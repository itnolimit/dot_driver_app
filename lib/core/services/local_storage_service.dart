import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../../features/auth/domain/entities/driver.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  final DatabaseHelper _db = DatabaseHelper.instance;

  // Driver operations
  Future<void> saveDriver(Driver driver) async {
    final Map<String, dynamic> driverMap = _driverToMap(driver);
    await _db.insert(DatabaseHelper.driversTable, driverMap);
  }

  Future<Driver?> getDriver(String id) async {
    final result = await _db.queryById(DatabaseHelper.driversTable, id);
    return result != null ? _mapToDriver(result) : null;
  }

  Future<Driver?> getCurrentDriver() async {
    // Get the most recently active driver
    final results = await _db.queryWhere(
      DatabaseHelper.driversTable,
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    
    return results.isNotEmpty ? _mapToDriver(results.first) : null;
  }

  Future<void> updateDriver(String id, Driver driver) async {
    final Map<String, dynamic> driverMap = _driverToMap(driver);
    await _db.update(DatabaseHelper.driversTable, id, driverMap);
  }

  Future<void> deleteDriver(String id) async {
    await _db.delete(DatabaseHelper.driversTable, id);
  }

  // Document operations
  Future<void> saveDocument(Map<String, dynamic> document) async {
    await _db.insert(DatabaseHelper.documentsTable, document);
  }

  Future<List<Map<String, dynamic>>> getDocuments(String driverId) async {
    return await _db.queryWhere(
      DatabaseHelper.documentsTable,
      where: 'driver_id = ?',
      whereArgs: [driverId],
      orderBy: 'created_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getDocument(String id) async {
    return await _db.queryById(DatabaseHelper.documentsTable, id);
  }

  Future<void> updateDocument(String id, Map<String, dynamic> document) async {
    await _db.update(DatabaseHelper.documentsTable, id, document);
  }

  Future<void> deleteDocument(String id) async {
    // Also delete the physical file
    final document = await getDocument(id);
    if (document != null && document['file_path'] != null) {
      final file = File(document['file_path']);
      if (await file.exists()) {
        await file.delete();
      }
    }
    
    await _db.delete(DatabaseHelper.documentsTable, id);
  }

  Future<List<Map<String, dynamic>>> getExpiringDocuments(String driverId, {int daysFromNow = 30}) async {
    final thirtyDaysFromNow = DateTime.now().add(Duration(days: daysFromNow)).millisecondsSinceEpoch;
    
    return await _db.queryWhere(
      DatabaseHelper.documentsTable,
      where: 'driver_id = ? AND expiry_date <= ? AND expiry_date > ?',
      whereArgs: [driverId, thirtyDaysFromNow, DateTime.now().millisecondsSinceEpoch],
      orderBy: 'expiry_date ASC',
    );
  }

  // File storage operations
  Future<String> saveDocumentFile(List<int> fileBytes, String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory documentsDir = Directory('${appDir.path}/documents');
    
    if (!await documentsDir.exists()) {
      await documentsDir.create(recursive: true);
    }
    
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String newFileName = '${timestamp}_$fileName';
    final String filePath = '${documentsDir.path}/$newFileName';
    
    final File file = File(filePath);
    await file.writeAsBytes(fileBytes);
    
    return filePath;
  }

  Future<File?> getDocumentFile(String filePath) async {
    final file = File(filePath);
    return await file.exists() ? file : null;
  }

  Future<void> deleteDocumentFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Company operations
  Future<void> saveCompany(Map<String, dynamic> company) async {
    await _db.insert(DatabaseHelper.companiesTable, company);
  }

  Future<Map<String, dynamic>?> getCompany(String id) async {
    return await _db.queryById(DatabaseHelper.companiesTable, id);
  }

  Future<List<Map<String, dynamic>>> getCompanies() async {
    return await _db.queryAll(DatabaseHelper.companiesTable, orderBy: 'name ASC');
  }

  Future<void> updateCompany(String id, Map<String, dynamic> company) async {
    await _db.update(DatabaseHelper.companiesTable, id, company);
  }

  // Settings operations
  Future<void> saveSetting(String key, dynamic value) async {
    await _db.setSetting(key, value);
  }

  Future<T?> getSetting<T>(String key, {T? defaultValue}) async {
    return await _db.getSetting<T>(key, defaultValue: defaultValue);
  }

  // App settings
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    for (final entry in settings.entries) {
      await saveSetting('app_${entry.key}', entry.value);
    }
  }

  Future<Map<String, dynamic>> getAppSettings() async {
    return {
      'notifications_enabled': await getSetting<bool>('app_notifications_enabled', defaultValue: true),
      'biometric_enabled': await getSetting<bool>('app_biometric_enabled', defaultValue: false),
      'dark_mode_enabled': await getSetting<bool>('app_dark_mode_enabled', defaultValue: false),
      'auto_backup_enabled': await getSetting<bool>('app_auto_backup_enabled', defaultValue: true),
      'sync_wifi_only': await getSetting<bool>('app_sync_wifi_only', defaultValue: true),
      'cache_size_limit': await getSetting<int>('app_cache_size_limit', defaultValue: 100), // MB
      'last_backup': await getSetting<int>('app_last_backup'),
      'last_sync': await getSetting<int>('app_last_sync'),
    };
  }

  // Sync operations
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPendingSyncData() async {
    return await _db.getPendingSyncActions();
  }

  Future<void> markSyncComplete(int syncLogId) async {
    await _db.markSyncComplete(syncLogId);
  }

  Future<void> markSyncFailed(int syncLogId, String error) async {
    await _db.markSyncFailed(syncLogId, error);
  }

  // Cache management
  Future<void> clearCache() async {
    await _db.clearCache();
    
    // Clear temporary files
    final Directory tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      await for (final file in tempDir.list()) {
        if (file is File) {
          await file.delete();
        }
      }
    }
  }

  Future<int> getCacheSize() async {
    int totalSize = 0;
    
    // Database size
    totalSize += await _db.getDatabaseSize();
    
    // Documents folder size
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory documentsDir = Directory('${appDir.path}/documents');
    
    if (await documentsDir.exists()) {
      await for (final file in documentsDir.list(recursive: true)) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
    }
    
    return totalSize;
  }

  Future<String> getCacheSizeFormatted() async {
    final int bytes = await getCacheSize();
    
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Backup and restore
  Future<String> createBackup() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory backupDir = Directory('${appDir.path}/backups');
    
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final String backupFileName = 'backup_$timestamp.json';
    final String backupPath = '${backupDir.path}/$backupFileName';
    
    // Export all data
    final Map<String, dynamic> backupData = {
      'version': 1,
      'created_at': DateTime.now().toIso8601String(),
      'drivers': await _db.queryAll(DatabaseHelper.driversTable),
      'documents': await _db.queryAll(DatabaseHelper.documentsTable),
      'companies': await _db.queryAll(DatabaseHelper.companiesTable),
      'settings': await _db.queryAll(DatabaseHelper.settingsTable),
    };
    
    final File backupFile = File(backupPath);
    await backupFile.writeAsString(jsonEncode(backupData));
    
    await saveSetting('app_last_backup', DateTime.now().millisecondsSinceEpoch);
    
    return backupPath;
  }

  Future<void> restoreFromBackup(String backupPath) async {
    final File backupFile = File(backupPath);
    if (!await backupFile.exists()) {
      throw Exception('Backup file not found');
    }
    
    final String backupContent = await backupFile.readAsString();
    final Map<String, dynamic> backupData = jsonDecode(backupContent);
    
    // Clear existing data
    final Database db = await _db.database;
    await db.delete(DatabaseHelper.driversTable);
    await db.delete(DatabaseHelper.documentsTable);
    await db.delete(DatabaseHelper.companiesTable);
    await db.delete(DatabaseHelper.settingsTable);
    
    // Restore data
    for (final driver in backupData['drivers']) {
      await _db.insert(DatabaseHelper.driversTable, driver);
    }
    
    for (final document in backupData['documents']) {
      await _db.insert(DatabaseHelper.documentsTable, document);
    }
    
    for (final company in backupData['companies']) {
      await _db.insert(DatabaseHelper.companiesTable, company);
    }
    
    for (final setting in backupData['settings']) {
      await _db.insert(DatabaseHelper.settingsTable, setting);
    }
  }

  // Utility methods
  Map<String, dynamic> _driverToMap(Driver driver) {
    return {
      'id': driver.id,
      'first_name': driver.firstName,
      'last_name': driver.lastName,
      'email': driver.email,
      'phone': driver.phone,
      'cdl_number': driver.cdlNumber,
      'date_of_birth': driver.dateOfBirth?.millisecondsSinceEpoch,
      'address': driver.address,
      'city': driver.city,
      'state': driver.state,
      'zip_code': driver.zipCode,
      'emergency_contact_name': driver.emergencyContactName,
      'emergency_contact_phone': driver.emergencyContactPhone,
      'created_at': driver.createdAt.millisecondsSinceEpoch,
      'is_verified': driver.isVerified ? 1 : 0,
      'is_active': driver.isActive ? 1 : 0,
      'driver_type': driver.driverType.name,
      'company_id': driver.companyAssociation?.companyId,
      'company_name': driver.companyAssociation?.companyName,
      'company_dot_number': driver.companyAssociation?.companyDotNumber,
      'position': driver.companyAssociation?.position,
      'hire_date': driver.companyAssociation?.hireDate.millisecondsSinceEpoch,
      'employment_status': driver.companyAssociation?.status.name,
      'supervisor_name': driver.companyAssociation?.supervisorName,
      'supervisor_email': driver.companyAssociation?.supervisorEmail,
      'supervisor_phone': driver.companyAssociation?.supervisorPhone,
      'documents_shared_with_company': driver.companyAssociation?.documentsSharedWithCompany == true ? 1 : 0,
      'shared_document_types': driver.companyAssociation?.sharedDocumentTypes.join(','),
      'allow_company_sharing': driver.preferences.allowCompanySharing ? 1 : 0,
      'auto_share_new_documents': driver.preferences.autoShareNewDocuments ? 1 : 0,
      'receive_expiry_notifications': driver.preferences.receiveExpiryNotifications ? 1 : 0,
      'receive_company_updates': driver.preferences.receiveCompanyUpdates ? 1 : 0,
      'allow_location_tracking': driver.preferences.allowLocationTracking ? 1 : 0,
      'enable_biometric_login': driver.preferences.enableBiometricLogin ? 1 : 0,
    };
  }

  Driver _mapToDriver(Map<String, dynamic> map) {
    CompanyAssociation? companyAssociation;
    
    if (map['company_id'] != null) {
      companyAssociation = CompanyAssociation(
        companyId: map['company_id'],
        companyName: map['company_name'],
        companyDotNumber: map['company_dot_number'],
        position: map['position'],
        hireDate: DateTime.fromMillisecondsSinceEpoch(map['hire_date']),
        status: EmploymentStatus.values.firstWhere(
          (e) => e.name == map['employment_status'],
          orElse: () => EmploymentStatus.active,
        ),
        supervisorName: map['supervisor_name'],
        supervisorEmail: map['supervisor_email'],
        supervisorPhone: map['supervisor_phone'],
        documentsSharedWithCompany: map['documents_shared_with_company'] == 1,
        sharedDocumentTypes: map['shared_document_types']?.split(',') ?? [],
      );
    }

    return Driver(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      cdlNumber: map['cdl_number'],
      dateOfBirth: map['date_of_birth'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['date_of_birth'])
          : null,
      address: map['address'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zip_code'],
      emergencyContactName: map['emergency_contact_name'],
      emergencyContactPhone: map['emergency_contact_phone'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      isVerified: map['is_verified'] == 1,
      isActive: map['is_active'] == 1,
      driverType: DriverType.values.firstWhere(
        (e) => e.name == map['driver_type'],
        orElse: () => DriverType.independent,
      ),
      companyAssociation: companyAssociation,
      sharedWithCompanies: [], // TODO: Implement proper parsing
      preferences: DriverPreferences(
        allowCompanySharing: map['allow_company_sharing'] == 1,
        autoShareNewDocuments: map['auto_share_new_documents'] == 1,
        receiveExpiryNotifications: map['receive_expiry_notifications'] == 1,
        receiveCompanyUpdates: map['receive_company_updates'] == 1,
        allowLocationTracking: map['allow_location_tracking'] == 1,
        enableBiometricLogin: map['enable_biometric_login'] == 1,
      ),
    );
  }

  Future<void> close() async {
    await _db.close();
  }
}