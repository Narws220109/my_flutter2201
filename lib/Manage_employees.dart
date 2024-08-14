// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: library_private_types_in_public_api, file_names, inference_failure_on_function_invocation, sized_box_for_whitespace, always_specify_types

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class EmployeeManagementPage extends StatefulWidget {
  final String loggedInUserId;
  // ignore: sort_constructors_first
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
      String id, String name, String phone, String position) async {
    await _database.insert(
      'employees',
      <String, Object?>{
        'id': id,
        'name': name,
        'phone': phone,
        'position': position
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchEmployees();
  }

  Future<void> _updateEmployee(
      String id, String name, String phone, String position) async {
    await _database.update(
      'employees',
      <String, Object?>{'name': name, 'phone': phone, 'position': position},
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
    _fetchEmployees();
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
    final TextEditingController positionController = TextEditingController();

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
                controller: positionController,
                decoration: const InputDecoration(labelText: 'ตำแหน่งงาน'),
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
                final String position = positionController.text;

                if (id.isNotEmpty &&
                    name.isNotEmpty &&
                    phone.isNotEmpty &&
                    position.isNotEmpty) {
                  _insertEmployee(id, name, phone, position);
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
    final TextEditingController positionController =
        TextEditingController(text: employee['position']?.toString() ?? '');

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
                controller: positionController,
                decoration: const InputDecoration(labelText: 'ตำแหน่งงาน'),
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
                final String position = positionController.text;

                if (id.isNotEmpty &&
                    name.isNotEmpty &&
                    phone.isNotEmpty &&
                    position.isNotEmpty) {
                  _updateEmployee(id, name, phone, position);
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            if (_loggedInUser != null) ...<Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.person, size: 40),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ข้อมูลของคุณ: ${_loggedInUser!['name'] ?? 'ไม่มีชื่อ'}, เบอร์โทร: ${_loggedInUser!['phone'] ?? 'ไม่มีเบอร์โทร'}, ตำแหน่งงาน: ${_loggedInUser!['position'] ?? 'ไม่มีตำแหน่ง'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            Expanded(
              child: _employees.isEmpty
                  ? const Center(
                      child: Text('ไม่มีพนักงาน'),
                    )
                  : ListView.builder(
                      itemCount: _employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> employee = _employees[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                            ),
                            title: Text(
                              (employee['name'] as String?) ?? 'ไม่มีชื่อ',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ตำแหน่งงาน: ${employee['position'] ?? 'ไม่มี'}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'เบอร์โทร: ${employee['phone'] ?? 'ไม่มีเบอร์โทร'}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    iconSize: 21,
                                    onPressed: () =>
                                        _showEditEmployeeDialog(employee),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    iconSize: 21,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('ลบพนักงาน'),
                                            content: const Text(
                                                'คุณแน่ใจหรือไม่ว่าต้องการลบพนักงานนี้?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('ยกเลิก'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text('ลบ'),
                                                onPressed: () {
                                                  _deleteEmployee(employee['id']
                                                      .toString());

                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
