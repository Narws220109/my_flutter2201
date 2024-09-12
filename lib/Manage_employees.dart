// ignore_for_file: inference_failure_on_function_invocation, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import สำหรับ QR Code
import 'database_helper.dart';

class EmployeeManagementPage extends StatefulWidget {
  final String loggedInUserId;
  const EmployeeManagementPage({super.key, required this.loggedInUserId});

  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  late Database _database;
  List<Map<String, dynamic>> _employees = <Map<String, dynamic>>[];
  Map<String, dynamic>? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await DatabaseHelper.instance.database;
    _fetchEmployees();
    _fetchLoggedInUser();
  }

  Future<void> _fetchEmployees() async {
    final List<Map<String, dynamic>> employees =
        await _database.query('employees');
    setState(() {
      _employees = employees;
    });
  }

  Future<void> _fetchLoggedInUser() async {
    final List<Map<String, dynamic>> user = await _database.query(
      'employees',
      where: 'id = ?',
      whereArgs: <Object?>[widget.loggedInUserId],
    );
    setState(() {
      _loggedInUser = user.isNotEmpty ? user.first : null;
    });
  }

  Future<void> _insertEmployee(
      String id, String name, String phone, String password) async {
    await _database.insert(
      'employees',
      <String, Object?>{
        'id': id,
        'name': name,
        'phone': phone,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchEmployees();
  }

  Future<void> _updateEmployee(
      String id, String name, String phone, String password) async {
    await _database.update(
      'employees',
      <String, Object?>{'name': name, 'phone': phone, 'password': password},
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
    _fetchEmployees();
  }

  // เพิ่มฟังก์ชันยืนยันการลบพนักงาน
  Future<void> _confirmDeleteEmployee(String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const Text('คุณแน่ใจหรือว่าต้องการลบพนักงานคนนี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog และไม่ลบข้อมูล
              },
            ),
            ElevatedButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                _deleteEmployee(id); // ลบข้อมูลพนักงาน
                Navigator.of(context).pop(); // ปิด Dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEmployee(String id) async {
    await _database.delete(
      'employees',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
    _fetchEmployees();
  }

  void _showAddEmployeeDialog() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เพิ่มพนักงาน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: idController,
                decoration:
                    const InputDecoration(labelText: 'รหัสประจำตัวพนักงาน'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อพนักงาน'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'เบอร์โทร'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('เพิ่ม'),
              onPressed: () {
                final String id = idController.text;
                final String name = nameController.text;
                final String phone = phoneController.text;
                final String password = passwordController.text;

                if (id.isNotEmpty &&
                    name.isNotEmpty &&
                    phone.isNotEmpty &&
                    password.isNotEmpty) {
                  _insertEmployee(id, name, phone, password);
                  Navigator.of(context).pop(); // ปิด Dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditEmployeeDialog(Map<String, dynamic> employee) {
    final TextEditingController idController =
        TextEditingController(text: employee['id']?.toString() ?? '');
    final TextEditingController nameController =
        TextEditingController(text: employee['name']?.toString() ?? '');
    final TextEditingController phoneController =
        TextEditingController(text: employee['phone']?.toString() ?? '');
    final TextEditingController passwordController =
        TextEditingController(text: employee['password']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('แก้ไขพนักงาน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: idController,
                decoration:
                    const InputDecoration(labelText: 'รหัสประจำตัวพนักงาน'),
                enabled: false,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อพนักงาน'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'เบอร์โทร'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('แก้ไข'),
              onPressed: () {
                final String id = idController.text;
                final String name = nameController.text;
                final String phone = phoneController.text;
                final String password = passwordController.text;

                if (id.isNotEmpty &&
                    name.isNotEmpty &&
                    phone.isNotEmpty &&
                    password.isNotEmpty) {
                  _updateEmployee(id, name, phone, password);
                  Navigator.of(context)
                      .pop(); // ปิด Dialog และกลับไปที่หน้าหลัก
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันสร้าง QR Code สำหรับพนักงาน
  void _generateQRCode(Map<String, dynamic> employee) {
    final String qrData =
        'ID: ${employee['id']}\nName: ${employee['name']}\nPhone: ${employee['phone']}';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code พนักงาน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ใช้ Row สำหรับจัดตำแหน่ง QR Code ให้อยู่ตรงกลาง
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // ทำให้ QR Code อยู่ตรงกลาง
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      data: qrData,
                      size: 200.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // จัดข้อมูลให้อยู่ชิดซ้าย
              Align(
                alignment: Alignment.centerLeft, // จัดข้อมูลให้อยู่ชิดซ้าย
                child: Text('ข้อมูล\n$qrData'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การจัดการพนักงาน'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEmployeeDialog,
          ),
        ],
      ),
      body: Container(
        // เพิ่ม background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _employees.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> employee = _employees[index];
            return Card(
              // เปลี่ยนสีกรอบของ Card
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 0.0,
                ), // กำหนดสีและความหนาของกรอบ
                borderRadius:
                    BorderRadius.circular(10.0), // กำหนดขอบมุมของการ์ด
              ),
              color: const Color.fromARGB(228, 255, 255, 255)
                  .withOpacity(0.7), // เปลี่ยนสีพื้นหลังภายในกรอบ
              child: ListTile(
                // ใช้ Column เพื่อจัดชื่อและ ID ให้อยู่คนละบรรทัด
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      employee['name']?.toString() ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'รหัส: ${employee['id']?.toString() ?? ''}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                subtitle: Text('เบอร์โทร: ${employee['phone']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.qr_code, color: Colors.green),
                      onPressed: () {
                        _generateQRCode(employee);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showEditEmployeeDialog(employee);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeleteEmployee(
                            employee['id']?.toString() ?? '');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
