// ignore_for_file: use_named_constants, avoid_print, avoid_redundant_argument_values, avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';

class WeightReportScreen extends StatelessWidget {
  const WeightReportScreen({super.key});

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
        title: const Text('พิมพ์รายงานผลการชั่งน้ำหนัก'),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: FloatingActionButton.extended(
              onPressed: () {
                // ใส่โค้ดสำหรับการพิมพ์รายงาน
                print('Printing report...');
              },
              label: const Text('พิมพ์รายงาน'),
              icon: const Icon(Icons.print),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 20),
            const Text(
              'พิมพ์รายงานผลการชั่งน้ำหนัก',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInfoBlock(Icons.person, 'ชื่อ-นามสกุล', employeeName),
            _buildInfoBlock(Icons.badge, 'รหัสประจำตัว', employeeId),
            _buildInfoBlock(
                Icons.monitor_weight, 'น้ำหนักที่ชั่ง', '$weight กก.'),
            _buildInfoBlock(Icons.calendar_today, 'วัน/เดือน/ปี', date),
            _buildInfoBlock(Icons.access_time, 'เวลา', time),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
