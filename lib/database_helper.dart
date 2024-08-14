// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'employee_database.db');
    return openDatabase(
      path,
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE employees(id TEXT PRIMARY KEY, name TEXT, phone TEXT, position TEXT)',
        );
      },
      version: 2, // อัปเดตเวอร์ชันฐานข้อมูล
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // เพิ่มคอลัมน์ใหม่
          await db.execute(
            'ALTER TABLE employees ADD COLUMN position TEXT',
          );
        }
      },
    );
  }

  Future<void> insertEmployee(
      String id, String name, String phone, String position) async {
    final Database db = await database;
    await db.insert(
      'employees',
      <String, Object?>{
        'id': id,
        'name': name,
        'phone': phone,
        'position': position,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEmployee(
      String id, String name, String phone, String position) async {
    final Database db = await database;
    await db.update(
      'employees',
      <String, Object?>{
        'name': name,
        'phone': phone,
        'position': position,
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
}
