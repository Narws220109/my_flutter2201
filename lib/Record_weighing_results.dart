// ignore_for_file: file_names, avoid_field_initializers_in_const_classes, sort_child_properties_last

import 'package:flutter/material.dart';

class WeightHistoryScreen extends StatelessWidget {
  const WeightHistoryScreen({super.key});

  final String employeeName = 'John Doe';
  final String employeeId = '12345';
  final double weight = 70.5;
  final String date = '01/01/2024';
  final String time = '12:00 PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:
            const Text('ประวัติผลการชั่งน้ำหนัก', textAlign: TextAlign.center),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // ใส่โค้ดสำหรับสั่งพิมพ์ผลการชั่งน้ำหนัก
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ประวัติผลการชั่งน้ำหนัก',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoBlock(Icons.person, 'ชื่อ-นามสกุล', employeeName),
              _buildInfoBlock(Icons.badge, 'รหัสประจำตัว', employeeId),
              _buildInfoBlock(
                  Icons.monitor_weight, 'น้ำหนักที่ชั่ง', '$weight กก.'),
              _buildInfoBlock(Icons.calendar_today, 'วัน/เดือน/ปี', date),
              _buildInfoBlock(Icons.access_time, 'เวลา', time),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // ใส่โค้ดสำหรับบันทึกผลการชั่งและกลับไปยังหน้าหลัก
                  },
                  child: const Text('บันทึกผลการชั่ง'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50), // ปรับขนาดของปุ่ม
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
