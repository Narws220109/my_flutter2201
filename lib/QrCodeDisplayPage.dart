// ignore_for_file: avoid_redundant_argument_values, sort_constructors_first, file_names

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  final String qrData;

  const QrCodeDisplayPage({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: qrData.isNotEmpty
            ? QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0, // ขนาดของ QR Code
                backgroundColor: Colors.white, // สีพื้นหลังของ QR Code
              )
            : const Text('No QR Code Data'),
      ),
    );
  }
}
