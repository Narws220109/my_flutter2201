// ignore_for_file: file_names, avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';

class WeightMeasurementScreen extends StatelessWidget {
  const WeightMeasurementScreen({super.key});

  final String employeeId = '123456';
  final String employeeName = 'John Doe';
  final String weight = '70.5 kg';
  final String qrData = 'Employee ID: 123456\nName: John Doe';

  @override
  Widget build(BuildContext context) {
    // var qrImage2 = QrImage(
    //    data: qrData,
    //   size: 200,
    //);
//    var qrImage = qrImage2;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Weight Measurement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //         qrImage,
            const SizedBox(height: 20),
            Text(
              'น้ำหนัก: $weight',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'รหัสประจำตัวพนักงาน: $employeeId',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'ชื่อ-สกุล: $employeeName',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // ใส่โค้ดสำหรับการเก็บค่าไปยังหน้าบันทึก
                  },
                  child: const Text('บันทึก'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ใส่โค้ดสำหรับการเปรียบเทียบน้ำหนัก
                  },
                  child: const Text('เปรียบเทียบ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
