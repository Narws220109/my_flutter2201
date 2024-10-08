// ignore_for_file: file_names, directives_ordering, unused_import, duplicate_ignore, duplicate_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'DataPage.dart';
import 'QRScanScreen.dart';
import 'ScannQr_code.dart'; // นำเข้าไฟล์ QRScanScreen
import 'Manage_employees.dart'; // เพิ่มการนำเข้าหน้า EmployeeManagementPage
import 'DataPage.dart'; // เพิ่มการนำเข้าหน้า DataPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูหลัก'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // การทำงานเมื่อกดปุ่มค้นหา
              // ในที่นี้ยังไม่ได้ระบุการทำงาน
            },
          ),
        ],
      ),
      body: Column(
        // ignore: avoid_redundant_argument_values
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20.0),
          _buildUserInfo(
            name: 'John Doe',
            employeeId: '12345',
            phoneNumber: '081-234-5678',
            imageUrl:
                'https://example.com/avatar.jpg', // URL ของรูปภาพที่ต้องการแสดง
          ),
          const SizedBox(height: 20.0),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 0.0),
                const Text(
                  '   เมนู',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.local_activity,
                  title: 'เมนูวัดน้ำหนัก',
                  onTap: () {
                    Navigator.push(
                      context,
                      // ignore: inference_failure_on_instance_creation, always_specify_types
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const QRScanScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'เมนูจัดการพนักงาน',
                  onTap: () {
                    Navigator.push(
                      context,
                      // ignore: inference_failure_on_instance_creation, always_specify_types
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const EmployeeManagementPage(
                          loggedInUserId: '',
                        ),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'แสดงน้ำหนัก',
                  onTap: () {
                    Navigator.push(
                      context,
                      // ignore: inference_failure_on_instance_creation, always_specify_types
                      MaterialPageRoute(
                          builder: (BuildContext context) => const DataPage()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'เมนูตั้งค่า',
                  onTap: () {
                    // เมนูตั้งค่า
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo({
    required String name,
    required String employeeId,
    required String phoneNumber,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // ignore: avoid_redundant_argument_values
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        // ignore: avoid_redundant_argument_values
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ชื่อผู้ใช้: $name',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'รหัสพนักงาน: $employeeId',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'เบอร์โทร: $phoneNumber',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 243, 145, 33)),
      title: Text(title,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      onTap: onTap,
    );
  }
}
