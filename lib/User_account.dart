import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountManagementPage(),
    );
  }
}

class AccountManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การจัดการบัญชีผู้ใช้'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'การจัดการบัญชีผู้ใช้',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.person, size: 30),
                SizedBox(width: 10),
                Text(
                  'การแก้ไขชื่อ-นามสกุล:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อ-นามสกุล',
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.work, size: 30),
                SizedBox(width: 10),
                Text(
                  'แสดงตำแหน่งงาน:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ตำแหน่งงาน',
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.badge, size: 30),
                SizedBox(width: 10),
                Text(
                  'แสดงรหัสประจำตัวพนักงาน:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'รหัสประจำตัวพนักงาน',
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.email, size: 30),
                SizedBox(width: 10),
                Text(
                  'แก้ไขอีเมลล์:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'อีเมลล์',
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.photo_camera, size: 30),
                SizedBox(width: 10),
                Text(
                  'แก้ไขรูปภาพ:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Code to pick image
                  },
                  child: Text('เลือกไฟล์'),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Save changes
                },
                child: Text('บันทึก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
