import 'dart:io';
import 'local_storage_service.dart';
import '../../features/auth/domain/entities/driver.dart';
import '../data/dummy_data.dart';

class OfflineService {
  static final OfflineService _instance = OfflineService._internal();
  factory OfflineService() => _instance;
  OfflineService._internal();

  final LocalStorageService _localStorage = LocalStorageService();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check if we have any existing data
      final currentDriver = await _localStorage.getCurrentDriver();
      
      if (currentDriver == null) {
        // First time setup - initialize with dummy data
        await _initializeDummyData();
      }
      
      _isInitialized = true;
    } catch (e) {
      print('Error initializing offline service: $e');
      // Even if there's an error, mark as initialized to prevent loops
      _isInitialized = true;
    }
  }

  Future<void> _initializeDummyData() async {
    try {
      // Save all dummy drivers
      await _localStorage.saveDriver(DummyData.independentDriver);
      await _localStorage.saveDriver(DummyData.companyDriver);
      await _localStorage.saveDriver(DummyData.anotherCompanyDriver);
      
      // Save dummy companies
      for (final company in DummyData.companyInfoMap.values) {
        await _localStorage.saveCompany({
          'id': company.id,
          'name': company.name,
          'dot_number': company.dotNumber,
          'address': company.address,
          'phone': company.phone,
          'website': company.website,
          'logo_url': company.logoUrl,
          'is_verified': 1,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
      }
      
      // Initialize default app settings
      await _localStorage.saveAppSettings({
        'notifications_enabled': true,
        'biometric_enabled': false,
        'dark_mode_enabled': false,
        'auto_backup_enabled': true,
        'sync_wifi_only': true,
        'cache_size_limit': 100, // MB
      });
      
      // Create sample documents for each driver
      await _createSampleDocuments();
      
      print('Dummy data initialized successfully');
    } catch (e) {
      print('Error initializing dummy data: $e');
    }
  }

  Future<void> _createSampleDocuments() async {
    final now = DateTime.now();
    
    // Documents for independent driver
    final independentDriverId = DummyData.independentDriver.id;
    final independentDocuments = [
      {
        'id': 'doc_001',
        'driver_id': independentDriverId,
        'title': 'Driver License',
        'type': 'license',
        'description': 'Class A Commercial Driver License',
        'issue_date': DateTime(2022, 3, 20).millisecondsSinceEpoch,
        'expiry_date': DateTime(2026, 3, 20).millisecondsSinceEpoch,
        'status': 'active',
        'file_path': '/documents/license_${independentDriverId}.pdf',
        'file_name': 'drivers_license.pdf',
        'file_size': 2400000, // 2.4 MB
        'mime_type': 'application/pdf',
        'created_at': now.millisecondsSinceEpoch,
        'updated_at': now.millisecondsSinceEpoch,
        'is_shared_with_company': 0,
        'tags': 'license,cdl,commercial',
      },
      {
        'id': 'doc_002',
        'driver_id': independentDriverId,
        'title': 'Medical Certificate',
        'type': 'medical',
        'description': 'DOT Physical Examination Report',
        'issue_date': DateTime(2023, 12, 15).millisecondsSinceEpoch,
        'expiry_date': DateTime(2024, 12, 15).millisecondsSinceEpoch,
        'status': 'expiring',
        'file_path': '/documents/medical_${independentDriverId}.pdf',
        'file_name': 'medical_certificate.pdf',
        'file_size': 1800000, // 1.8 MB
        'mime_type': 'application/pdf',
        'created_at': now.millisecondsSinceEpoch,
        'updated_at': now.millisecondsSinceEpoch,
        'is_shared_with_company': 0,
        'tags': 'medical,dot,physical',
      },
    ];
    
    // Documents for company driver
    final companyDriverId = DummyData.companyDriver.id;
    final companyDocuments = [
      {
        'id': 'doc_003',
        'driver_id': companyDriverId,
        'title': 'Driver License',
        'type': 'license',
        'description': 'Class A Commercial Driver License',
        'issue_date': DateTime(2021, 8, 10).millisecondsSinceEpoch,
        'expiry_date': DateTime(2025, 8, 10).millisecondsSinceEpoch,
        'status': 'active',
        'file_path': '/documents/license_${companyDriverId}.pdf',
        'file_name': 'drivers_license.pdf',
        'file_size': 2200000, // 2.2 MB
        'mime_type': 'application/pdf',
        'created_at': now.millisecondsSinceEpoch,
        'updated_at': now.millisecondsSinceEpoch,
        'is_shared_with_company': 1,
        'shared_companies': 'company_001',
        'tags': 'license,cdl,commercial',
      },
      {
        'id': 'doc_004',
        'driver_id': companyDriverId,
        'title': 'DOT Physical Report',
        'type': 'medical',
        'description': 'Complete DOT Physical Examination',
        'issue_date': DateTime(2024, 1, 12).millisecondsSinceEpoch,
        'expiry_date': DateTime(2025, 1, 12).millisecondsSinceEpoch,
        'status': 'active',
        'file_path': '/documents/physical_${companyDriverId}.pdf',
        'file_name': 'dot_physical.pdf',
        'file_size': 2100000, // 2.1 MB
        'mime_type': 'application/pdf',
        'created_at': now.millisecondsSinceEpoch,
        'updated_at': now.millisecondsSinceEpoch,
        'is_shared_with_company': 1,
        'shared_companies': 'company_001',
        'tags': 'medical,dot,physical,pdf',
      },
    ];
    
    // Save all documents
    for (final doc in [...independentDocuments, ...companyDocuments]) {
      await _localStorage.saveDocument(doc);
    }
  }

  // Convenience methods for app-wide access
  Future<Driver?> getCurrentDriver() async {
    await initialize();
    return await _localStorage.getCurrentDriver();
  }

  Future<void> switchToDriver(Driver driver) async {
    await initialize();
    
    // Deactivate current driver
    final currentDriver = await getCurrentDriver();
    if (currentDriver != null) {
      final deactivatedDriver = currentDriver.copyWith(isActive: false);
      await _localStorage.updateDriver(currentDriver.id, deactivatedDriver);
    }
    
    // Activate new driver
    final activatedDriver = driver.copyWith(isActive: true);
    await _localStorage.updateDriver(driver.id, activatedDriver);
    
    // Update dummy data current driver
    DummyData.currentDriver = activatedDriver;
  }

  Future<bool> isOnline() async {
    return await _localStorage.isOnline();
  }

  Future<Map<String, dynamic>> getAppSettings() async {
    await initialize();
    return await _localStorage.getAppSettings();
  }

  Future<void> saveAppSetting(String key, dynamic value) async {
    await initialize();
    await _localStorage.saveSetting('app_$key', value);
  }

  Future<String> getCacheSize() async {
    await initialize();
    return await _localStorage.getCacheSizeFormatted();
  }

  Future<void> clearCache() async {
    await initialize();
    await _localStorage.clearCache();
  }

  Future<String> createBackup() async {
    await initialize();
    return await _localStorage.createBackup();
  }

  Future<void> restoreFromBackup(String backupPath) async {
    await initialize();
    await _localStorage.restoreFromBackup(backupPath);
  }

  // Sync methods for future API integration
  Future<bool> needsSync() async {
    await initialize();
    final pendingActions = await _localStorage.getPendingSyncData();
    return pendingActions.isNotEmpty;
  }

  Future<int> getPendingSyncCount() async {
    await initialize();
    final pendingActions = await _localStorage.getPendingSyncData();
    return pendingActions.length;
  }

  Future<void> performSync() async {
    await initialize();
    
    if (!await isOnline()) {
      throw Exception('No internet connection available for sync');
    }
    
    final pendingActions = await _localStorage.getPendingSyncData();
    
    for (final action in pendingActions) {
      try {
        // TODO: Implement actual API sync calls
        // For now, just mark as completed
        await _localStorage.markSyncComplete(action['id']);
        
        // Simulate sync delay
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        await _localStorage.markSyncFailed(action['id'], e.toString());
      }
    }
    
    // Update last sync time
    await _localStorage.saveSetting('app_last_sync', DateTime.now().millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastSyncTime() async {
    await initialize();
    final lastSyncMs = await _localStorage.getSetting<int>('app_last_sync');
    return lastSyncMs != null ? DateTime.fromMillisecondsSinceEpoch(lastSyncMs) : null;
  }

  Future<void> close() async {
    await _localStorage.close();
    _isInitialized = false;
  }
}