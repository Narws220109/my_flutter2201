// ignore_for_file: file_names, directives_ordering
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// ignore: use_key_in_widget_constructors
class AccountManagementPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AccountManagementPageState createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

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
        title: const Text('การจัดการบัญชีผู้ใช้'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Text(
                'การจัดการบัญชีผู้ใช้',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Table(
                // ignore: prefer_const_literals_to_create_immutables
                columnWidths: <int, TableColumnWidth>{
                  0: const IntrinsicColumnWidth(),
                  1: const FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  const TableRow(
                    children: <Widget>[
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
                  const TableRow(
                    children: <Widget>[
                      SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'การแก้ไขชื่อ-นามสกุล',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: <Widget>[
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
                  const TableRow(
                    children: <Widget>[
                      SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'แสดงตำแหน่งงาน',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: <Widget>[
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
                  const TableRow(
                    children: <Widget>[
                      SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'แสดงรหัสประจำตัวพนักงาน',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: <Widget>[
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
                  const TableRow(
                    children: <Widget>[
                      SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'แก้ไขอีเมลล์',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: <Widget>[
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
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Save changes
                },
                child: const Text('บันทึก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
