import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

class AccountManagementPage extends StatefulWidget {
  @override
  _AccountManagementPageState createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Table(
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Icon(Icons.person, size: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ชื่อ-นามสกุล:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'การแก้ไขชื่อ-นามสกุล',
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Icon(Icons.work, size: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ตำแหน่งงาน:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'แสดงตำแหน่งงาน',
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Icon(Icons.badge, size: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'รหัสประจำตัวพนักงาน:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'แสดงรหัสประจำตัวพนักงาน',
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Icon(Icons.email, size: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'อีเมลล์:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'แก้ไขอีเมลล์',
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Icon(Icons.photo_camera, size: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'รูปภาพ:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : NetworkImage(
                                          'https://via.placeholder.com/150')
                                      as ImageProvider,
                            ),
                            SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(Icons.file_upload),
                              label: Text('เลือกไฟล์'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
