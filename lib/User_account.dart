// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'Login.dart';

class Setting extends StatefulWidget {
  final String loggedInUserId;
  final String name;
  final String phoneNumber;

  const Setting({
    super.key,
    required this.loggedInUserId,
    required this.name,
    required this.phoneNumber,
  });

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late Database _database;
  Map<String, dynamic>? _loggedInUser;
  bool _isDarkTheme = false; // สถานะของธีม

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await DatabaseHelper.instance.database;
    _fetchLoggedInUser();
  }

  Future<void> _fetchLoggedInUser() async {
    setState(() {
      _loggedInUser = {
        'name': widget.name,
        'phone': widget.phoneNumber,
        'id': widget.loggedInUserId,
      };
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แสดงข้อมูลพนักงาน'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Login'),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loggedInUser == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildInfoCard(Icons.badge, 'รหัสประจำตัว',
                      _loggedInUser!['id'].toString()),
                  _buildInfoCard(Icons.person, 'ชื่อ-นามสกุล',
                      _loggedInUser!['name'].toString()),
                  _buildInfoCard(Icons.phone, 'เบอร์โทร',
                      _loggedInUser!['phone'].toString()),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
