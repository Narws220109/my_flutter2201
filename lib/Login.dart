// ignore_for_file: prefer_final_locals, no_leading_underscores_for_local_identifiers, dead_code

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'HomePage.dart'; // นำเข้าไฟล์ HomePage.dart
import 'database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database database;
  bool _obscureText = true; // ตัวแปรสำหรับควบคุมการแสดงรหัสผ่าน

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'employee_database.db');
    database = await openDatabase(
      path,
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE employees(id TEXT PRIMARY KEY, name TEXT, phone TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertEmployee(
      String id, String name, String phone, String password) async {
    await database.insert(
      'employees',
      <String, Object?>{
        'id': id,
        'name': name,
        'phone': phone,
        'password': password
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getEmployee(String id) async {
    final List<Map<String, dynamic>> maps = await database.query(
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

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เพื่อแก้ปัญหา Overflow
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/welcome.jpg',
              ),
              const SizedBox(height: 20.0),
              const Text(
                'กรุณาลงชื่อเข้าใช้',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.badge, color: Colors.black),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: 'รหัสประจำตัวพนักงาน',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.lock, color: Colors.black),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      String id = _idController.text;
                      String password = _passwordController.text;

                      if (id.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('กรอกข้อมูลเพื่อลงชื่อเข้าใช้')),
                        );
                        return;
                      }

                      Map<String, dynamic>? employee = await getEmployee(id);

                      if (employee == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ไม่พบผู้ใช้งาน')),
                        );
                        _idController.clear();
                        _passwordController.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegistrationPage(database: database)),
                        );
                      } else {
                        if (employee['password'] == password) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(
                                name: employee['name'] as String? ?? '',
                                employeeId: employee['id'] as String? ?? '',
                                phoneNumber: employee['phone'] as String? ?? '',
                                imageUrl: 'https://example.com/avatar.jpg', title: '',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
                          );
                        }
                      }
                    },
                    child: const Text('ลงชื่อเข้าใช้'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegistrationPage(database: database)),
                      );
                    },
                    child: const Text('สมัครสมาชิก'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  final Database database;

  RegistrationPage({super.key, required this.database});

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> insertEmployee(
      String id, String password, String name, String phone) async {
    await database.insert(
      'employees',
      <String, Object?>{
        'id': id,
        'password': password,
        'name': name,
        'phone': phone,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('สมัครสมาชิก'),
      ),
      body: SingleChildScrollView(
        // เพิ่ม SingleChildScrollView ที่นี่ด้วย
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'รหัสประจำตัวพนักงาน',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อผู้ใช้',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทร',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: const UnderlineInputBorder(),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _obscureText = !_obscureText;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String id = _idController.text;
                  String password = _passwordController.text;
                  String name = _nameController.text;
                  String phone = _phoneController.text;

                  await insertEmployee(id, password, name, phone);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')),
                  );
                  Navigator.pop(
                      context); // กลับไปหน้าลงชื่อเข้าใช้หลังสมัครเสร็จ
                },
                child: const Text('สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
