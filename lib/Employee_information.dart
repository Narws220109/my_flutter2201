// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';

class EmployeeManagementPage extends StatefulWidget {
  const EmployeeManagementPage({super.key});

  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  // Sample employee data
  String employeeName = 'John Doe';
  String jobPosition = 'Developer';
  String employeeId = 'EMP001';
  String email = 'john.doe@example.com';
  File? _image;

  Future<void> _pickImage() async {
    // Implement image picking logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลพนักงาน'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Text(
                'ข้อมูลพนักงาน',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Table(
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                const TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.person, size: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'ชื่อ-นามสกุล:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          employeeName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.work, size: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'ตำแหน่งงาน:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          jobPosition,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.badge, size: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'รหัสประจำตัวพนักงาน:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          employeeId,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.email, size: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'อีเมลล์:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          email,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.photo_camera, size: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'รูปภาพ:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const NetworkImage(
                                        'https://via.placeholder.com/150')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.file_upload),
                            label: const Text('เลือกไฟล์'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle delete employee
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('ลบข้อมูล'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Save changes
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 158, 158, 158),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('บันทึก'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
