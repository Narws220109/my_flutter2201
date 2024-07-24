// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors, prefer_final_locals, use_build_context_synchronously, always_specify_types, sort_constructors_first, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: directives_ordering, depend_on_referenced_packages
import 'package:path/path.dart';
import 'HomePage.dart'; // นำเข้าไฟล์ HomePage.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 176, 20, 137)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database database;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'employee_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id TEXT PRIMARY KEY, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertEmployee(String id, String password) async {
    await database.insert(
      'employees',
      {'id': id, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getEmployee(String id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/welcome.jpg',
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
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
                children: [
                  const Icon(Icons.badge, color: Colors.black),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _idController,
                      decoration: InputDecoration(
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
                children: [
                  const Icon(Icons.lock, color: Colors.black),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String id = _idController.text;
                    String password = _passwordController.text;

                    if (id.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กรอกข้อมูลเพื่อลงชื่อเข้าใช้')),
                      );
                      return;
                    }

                    Map<String, dynamic>? employee = await getEmployee(id);

                    if (employee == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ไม่พบผู้ใช้งาน')),
                      );
                      // ลบข้อมูลที่กรอก
                      _idController.clear();
                      _passwordController.clear();
                      // นำไปยังหน้าสมัครสมาชิก
                      Navigator.push(
                        context,
                        // ignore: inference_failure_on_instance_creation
                        MaterialPageRoute(
                            builder: (context) =>
                                RegistrationPage(database: database)),
                      );
                    } else {
                      if (employee['password'] == password) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
                        );
                        Navigator.push(
                          context,
                          // ignore: inference_failure_on_instance_creation
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
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
                      // ignore: inference_failure_on_instance_creation
                      MaterialPageRoute(
                          builder: (context) =>
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
    );
  }
}

class RegistrationPage extends StatelessWidget {
  final Database database;

  RegistrationPage({required this.database});

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> insertEmployee(String id, String password) async {
    await database.insert(
      'employees',
      {'id': id, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'รหัสประจำตัวพนักงาน',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String id = _idController.text;
                String password = _passwordController.text;

                if (id.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                  );
                  return;
                }

                await insertEmployee(id, password);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ลงทะเบียนสำเร็จ')),
                );
                Navigator.pop(context);
              },
              child: const Text('ลงทะเบียน'),
            ),
          ],
        ),
      ),
    );
  }
}
