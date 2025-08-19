import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = 'dot_driver_files.db';
  static const _databaseVersion = 1;

  // Table names
  static const String driversTable = 'drivers';
  static const String documentsTable = 'documents';
  static const String companiesTable = 'companies';
  static const String settingsTable = 'settings';
  static const String syncLogTable = 'sync_log';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createDriversTable(db);
    await _createDocumentsTable(db);
    await _createCompaniesTable(db);
    await _createSettingsTable(db);
    await _createSyncLogTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic for future versions
    }
  }

  Future<void> _createDriversTable(Database db) async {
    await db.execute('''
      CREATE TABLE $driversTable (
        id TEXT PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT,
        cdl_number TEXT,
        date_of_birth INTEGER,
        address TEXT,
        city TEXT,
        state TEXT,
        zip_code TEXT,
        emergency_contact_name TEXT,
        emergency_contact_phone TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_verified INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        driver_type TEXT NOT NULL DEFAULT 'independent',
        company_id TEXT,
        company_name TEXT,
        company_dot_number TEXT,
        position TEXT,
        hire_date INTEGER,
        employment_status TEXT,
        supervisor_name TEXT,
        supervisor_email TEXT,
        supervisor_phone TEXT,
        documents_shared_with_company INTEGER DEFAULT 0,
        shared_document_types TEXT,
        allow_company_sharing INTEGER DEFAULT 1,
        auto_share_new_documents INTEGER DEFAULT 0,
        receive_expiry_notifications INTEGER DEFAULT 1,
        receive_company_updates INTEGER DEFAULT 0,
        allow_location_tracking INTEGER DEFAULT 0,
        enable_biometric_login INTEGER DEFAULT 1,
        sync_status TEXT DEFAULT 'pending',
        last_sync INTEGER
      )
    ''');
  }

  Future<void> _createDocumentsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $documentsTable (
        id TEXT PRIMARY KEY,
        driver_id TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        file_path TEXT,
        file_name TEXT,
        file_size INTEGER,
        mime_type TEXT,
        issue_date INTEGER,
        expiry_date INTEGER,
        status TEXT DEFAULT 'active',
        is_shared_with_company INTEGER DEFAULT 0,
        shared_companies TEXT,
        tags TEXT,
        metadata TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        last_sync INTEGER,
        FOREIGN KEY (driver_id) REFERENCES $driversTable (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createCompaniesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $companiesTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        dot_number TEXT NOT NULL UNIQUE,
        address TEXT,
        phone TEXT,
        email TEXT,
        website TEXT,
        logo_url TEXT,
        is_verified INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        last_sync INTEGER
      )
    ''');
  }

  Future<void> _createSettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $settingsTable (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        data_type TEXT NOT NULL DEFAULT 'string',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _createSyncLogTable(Database db) async {
    await db.execute('''
      CREATE TABLE $syncLogTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        action TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        error_message TEXT,
        retry_count INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        synced_at INTEGER
      )
    ''');
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final Database db = await database;
    row['created_at'] = DateTime.now().millisecondsSinceEpoch;
    row['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    
    final result = await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
    
    // Log sync action
    await _logSyncAction(table, row['id']?.toString() ?? '', 'insert');
    
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAll(String table, {String? orderBy}) async {
    final Database db = await database;
    return await db.query(table, orderBy: orderBy);
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final Database db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(String table, String id, Map<String, dynamic> row) async {
    final Database db = await database;
    row['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    
    final result = await db.update(
      table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    // Log sync action
    await _logSyncAction(table, id, 'update');
    
    return result;
  }

  Future<int> delete(String table, String id) async {
    final Database db = await database;
    
    final result = await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    // Log sync action
    await _logSyncAction(table, id, 'delete');
    
    return result;
  }

  Future<void> _logSyncAction(String tableName, String recordId, String action) async {
    final Database db = await database;
    await db.insert(syncLogTable, {
      'table_name': tableName,
      'record_id': recordId,
      'action': action,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Settings operations
  Future<void> setSetting(String key, dynamic value) async {
    final Database db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    String dataType;
    String stringValue;
    
    if (value is bool) {
      dataType = 'bool';
      stringValue = value.toString();
    } else if (value is int) {
      dataType = 'int';
      stringValue = value.toString();
    } else if (value is double) {
      dataType = 'double';
      stringValue = value.toString();
    } else {
      dataType = 'string';
      stringValue = value.toString();
    }

    await db.insert(
      settingsTable,
      {
        'key': key,
        'value': stringValue,
        'data_type': dataType,
        'created_at': now,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<T?> getSetting<T>(String key, {T? defaultValue}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      settingsTable,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isEmpty) {
      return defaultValue;
    }

    final row = result.first;
    final String value = row['value'];
    final String dataType = row['data_type'];

    switch (dataType) {
      case 'bool':
        return (value.toLowerCase() == 'true') as T?;
      case 'int':
        return int.tryParse(value) as T?;
      case 'double':
        return double.tryParse(value) as T?;
      default:
        return value as T?;
    }
  }

  // Sync operations
  Future<List<Map<String, dynamic>>> getPendingSyncActions() async {
    final Database db = await database;
    return await db.query(
      syncLogTable,
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> markSyncComplete(int syncLogId) async {
    final Database db = await database;
    await db.update(
      syncLogTable,
      {
        'status': 'completed',
        'synced_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [syncLogId],
    );
  }

  Future<void> markSyncFailed(int syncLogId, String errorMessage) async {
    final Database db = await database;
    await db.update(
      syncLogTable,
      {
        'status': 'failed',
        'error_message': errorMessage,
        'retry_count': 'retry_count + 1',
      },
      where: 'id = ?',
      whereArgs: [syncLogId],
    );
  }

  // Database maintenance
  Future<void> clearCache() async {
    final Database db = await database;
    await db.delete(syncLogTable, where: 'status = ?', whereArgs: ['completed']);
  }

  Future<int> getDatabaseSize() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    final File dbFile = File(path);
    
    if (await dbFile.exists()) {
      return await dbFile.length();
    }
    
    return 0;
  }

  Future<void> backup() async {
    // TODO: Implement database backup functionality
  }

  Future<void> close() async {
    final Database? db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}