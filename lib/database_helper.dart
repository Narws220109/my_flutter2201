// ignore_for_file: prefer_final_locals

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<void> deleteDatabaseFile() async {
    final String path = join(await getDatabasesPath(), 'employee_database.db');
    await deleteDatabase(path); // ลบไฟล์ฐานข้อมูล
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'employee_database.db');
    return openDatabase(
      path,
      onCreate: (Database db, int version) async {
        // สร้างตารางใหม่เมื่อตารางยังไม่มี
        await db.execute(
          'CREATE TABLE employees(id TEXT PRIMARY KEY, name TEXT, phone TEXT, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE scan_data(employeeId TEXT PRIMARY KEY, fullName TEXT, weight TEXT, scanDateTime TEXT)',
        );
      },
      version: 3, // ระบุเวอร์ชันของฐานข้อมูล
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // ตรวจสอบว่าตาราง `employees` มีคอลัมน์ `password` หรือไม่
          final List<Map<String, dynamic>> columns = await db.rawQuery(
            'PRAGMA table_info(employees)',
          );

          bool columnExists = columns.any(
              (Map<String, dynamic> column) => column['name'] == 'password');

          if (!columnExists) {
            // เพิ่มคอลัมน์ `password` หากยังไม่มี
            await db.execute(
              'ALTER TABLE employees ADD COLUMN password TEXT',
            );
          }
        }

        if (oldVersion < 3) {
          // ตรวจสอบและสร้างตาราง `scan_data` ถ้ายังไม่มี
          final List<Map<String, dynamic>> tables = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='scan_data'",
          );

          if (tables.isEmpty) {
            // สร้างตาราง `scan_data` ถ้ายังไม่มี
            await db.execute(
              'CREATE TABLE scan_data(employeeId TEXT PRIMARY KEY, fullName TEXT, weight TEXT, scanDateTime TEXT)',
            );
          }
        }
      },
    );
  }

  // Methods for managing employees and scan data
  Future<void> insertEmployee(
      String id, String name, String phone, String password) async {
    final Database db = await database;
    await db.insert(
      'employees',
      <String, Object?>{
        'id': id,
        'name': name,
        'phone': phone,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEmployee(
      String id, String name, String phone, String password) async {
    final Database db = await database;
    await db.update(
      'employees',
      <String, Object?>{
        'name': name,
        'phone': phone,
        'password': password,
      },
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<void> deleteEmployee(String id) async {
    final Database db = await database;
    await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<Map<String, dynamic>?> getEmployee(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // New methods for managing scan data
  Future<void> insertScanData(String employeeId, String fullName, String weight,
      DateTime scanDateTime) async {
    final Database db = await database;
    await db.insert(
      'scan_data',
      <String, Object?>{
        'employeeId': employeeId,
        'fullName': fullName,
        'weight': weight,
        'scanDateTime': scanDateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getScanData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('scan_data');
    return maps;
  }

  Future<Map<String, dynamic>?> getScanDataById(String employeeId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_data',
      where: 'employeeId = ?',
      whereArgs: <Object?>[employeeId],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }
}
