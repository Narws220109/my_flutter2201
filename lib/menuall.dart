// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหลัก'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // การทำงานเมื่อกดปุ่มค้นหา
              // ในที่นี้ยังไม่ได้ระบุการทำงาน
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20.0),
          _buildUserInfo(
            name: 'John Doe',
            employeeId: '12345',
            phoneNumber: '081-234-5678',
            imageUrl:
                'https://example.com/avatar.jpg', // URL ของรูปภาพที่ต้องการแสดง
          ),
          SizedBox(height: 20.0),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 0.0),
                Text(
                  '   เมนู',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.local_activity,
                  title: 'เมนูวัดน้ำหนัก',
                  onTap: () {
                    // เมนูวัดน้ำหนัก
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'เมนูตั้งค่า',
                  onTap: () {
                    // เมนูตั้งค่า
                  },
                ),
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'เมนูจัดการพนักงาน',
                  onTap: () {
                    // เมนูจัดการพนักงาน
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
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ชื่อผู้ใช้: $name',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'รหัสพนักงาน: $employeeId',
                style: TextStyle(
                  fontSize: 18.0,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'เบอร์โทร: $phoneNumber',
                style: TextStyle(
                  fontSize: 20.0,
                  color: const Color.fromARGB(255, 0, 0, 0),
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
      leading: Icon(icon, color: Color.fromARGB(255, 243, 145, 33)),
      title: Text(title,
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainMenuScreen(),
    theme: ThemeData(
      primaryColor:
          Color.fromARGB(255, 0, 0, 0), // กำหนดสีหลักของแอปเป็นสีน้ำเงิน
      hintColor: const Color.fromARGB(
          255, 0, 0, 0), // กำหนดสีเสริมเป็นสีน้ำเงิน (ใช้เพื่อเน้นบางส่วน)
    ),
  ));
}
