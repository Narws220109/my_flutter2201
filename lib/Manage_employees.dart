// ignore_for_file: inference_failure_on_function_invocation, sort_constructors_first, avoid_void_async

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import สำหรับ QR Code
import 'package:blue_thermal_printer/blue_thermal_printer.dart'; // Import สำหรับ Bluetooth Printer
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
  BlueThermalPrinter bluetooth =
      BlueThermalPrinter.instance; // Bluetooth Printer Instance
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _getBluetoothDevices(); // เพิ่มการเชื่อมต่อ Bluetooth Printer
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

  // ฟังก์ชันสร้าง QR Code และพิมพ์ด้วย Bluetooth Printer
  void _generateQRCode(Map<String, dynamic> employee) {
    final String qrData =
        'รหัสประจำตัวพนักงาน: ${employee['id']},\nชื่อพนักงาน: ${employee['name']},\nเบอร์โทร: ${employee['phone']}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code พนักงาน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text('ข้อมูล\n$qrData'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('พิมพ์ QR Code'),
              onPressed: () {
                _printQRCode(qrData); // เรียกฟังก์ชันพิมพ์ QR Code
                Navigator.of(context).pop();
              },
            ),
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

  // ฟังก์ชันพิมพ์ QR Code ด้วยเครื่องพิมพ์ Bluetooth
  void _printQRCode(String qrData) async {
    if (_selectedDevice != null) {
      await bluetooth.connect(_selectedDevice!);
      bluetooth.printCustom(qrData, 0, 1); // พิมพ์ข้อมูล QR Code
      bluetooth.printNewLine();
      bluetooth.disconnect();
    } else {
      // แสดงข้อความหากไม่มีการเลือกเครื่องพิมพ์
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('ข้อผิดพลาด'),
            content: Text('กรุณาเลือกเครื่องพิมพ์ก่อนพิมพ์ QR Code'),
          );
        },
      );
    }
  }

  // ฟังก์ชันสำหรับเชื่อมต่อ Bluetooth Printer
  void _getBluetoothDevices() async {
    final List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  void _showDeviceSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกเครื่องพิมพ์'),
          content: DropdownButton<BluetoothDevice>(
            items: _devices
                .map((BluetoothDevice device) =>
                    DropdownMenuItem<BluetoothDevice>(
                      value: device,
                      child: Text(device.name!),
                    ))
                .toList(),
            onChanged: (BluetoothDevice? value) {
              setState(() {
                _selectedDevice = value;
              });
              Navigator.of(context).pop();
            },
            hint: const Text('เลือกเครื่องพิมพ์'),
            value: _selectedDevice,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการพนักงาน'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _showDeviceSelectionDialog, // เลือกเครื่องพิมพ์
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _employees.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> employee = _employees[index];
          return ListTile(
            title: Text(employee['name']?.toString() ?? ''),
            subtitle:
                Text('รหัส: ${employee['id']}\nเบอร์โทร: ${employee['phone']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.qr_code, color: Colors.green),
                  onPressed: () {
                    _generateQRCode(employee);
                    // แสดง QR Code
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showEditEmployeeDialog(employee);
                    // แก้ไขข้อมูลพนักงาน
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDeleteEmployee(employee['id'].toString());
                    // ลบพนักงาน
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEmployeeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
