// ignore_for_file: library_private_types_in_public_api, always_specify_types, inference_failure_on_instance_creation, file_names

import 'package:flutter/material.dart';
import 'QrCodeDisplayPage.dart'; // นำเข้าคลาสหน้าจอใหม่ที่สร้าง

class QrCodePrinterPage extends StatefulWidget {
  const QrCodePrinterPage({super.key});

  @override
  _QrCodePrinterPageState createState() => _QrCodePrinterPageState();
}

class _QrCodePrinterPageState extends State<QrCodePrinterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String _qrData = '';

  void _generateQrCode() {
    setState(() {
      _qrData = '${_nameController.text}\n${_idController.text}';
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrCodeDisplayPage(qrData: _qrData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล'),
            ),
            TextField(
              controller: _idController,
              decoration:
                  const InputDecoration(labelText: 'รหัสประจำตัวพนักงาน'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _generateQrCode,
              child: const Text('สร้าง QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
