// ignore_for_file: sort_constructors_first, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QRResultScreen extends StatelessWidget {
  final String employeeId;
  final String fullName;
  final String weight;
  final DateTime scanDateTime;
  final String phoneNumber;
  final String stableWeight;
  final String barcodeValue;

  const QRResultScreen({
    super.key,
    required this.employeeId,
    required this.fullName,
    required this.weight,
    required this.scanDateTime,
    required this.phoneNumber,
    required this.stableWeight,
    required this.barcodeValue,
  });

  @override
  Widget build(BuildContext context) {
    // แปลงวันและเวลาตามฟอร์แมตที่กำหนด
    String formattedDate = DateFormat('dd/MM/yyyy').format(scanDateTime);
    String formattedTime = DateFormat('HH:mm:ss').format(scanDateTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลลัพธ์จาก QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('รหัสประจำตัวพนักงาน: $employeeId'),
            const SizedBox(height: 10),
            Text('ชื่อ-นามสกุล: $fullName'),
            const SizedBox(height: 10),
            Text('เบอร์โทรศัพท์: $phoneNumber'),
            const SizedBox(height: 10),
            Text('น้ำหนักที่ชั่ง: $weight kg'),
            const SizedBox(height: 10),
            Text('วัน/เดือน/ปี: $formattedDate'),
            Text('เวลา: $formattedTime'),
            const SizedBox(height: 10),
            Text('ข้อมูล QR Code: $barcodeValue'),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // จัดการกับการบันทึกน้ำหนัก
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกน้ำหนักเรียบร้อย')),
                      );
                    },
                    child: const Text('บันทึกน้ำหนัก'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // จัดการกับการตั้งค่าคาริเบต
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ตั้งค่าคาริเบต')),
                      );
                    },
                    child: const Text('ตั้งค่าคาริเบต'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
