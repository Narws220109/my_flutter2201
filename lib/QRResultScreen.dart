// ignore_for_file: inference_failure_on_function_invocation, use_super_parameters

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'storage_service.dart'; // ใช้ StorageService แทน QRDataStore
import 'package:blue_thermal_printer/blue_thermal_printer.dart'; // นำเข้าแพ็กเกจ Bluetooth Printer

class QRResultScreen extends StatefulWidget {
  final String employeeId;
  final String fullName;
  final String weight;
  final DateTime scanDateTime;
  final String phoneNumber;
  final String barcodeValue;

  const QRResultScreen({
    Key? key,
    required this.employeeId,
    required this.fullName,
    required this.weight,
    required this.scanDateTime,
    required this.phoneNumber,
    required this.barcodeValue,
  }) : super(key: key);

  @override
  _QRResultScreenState createState() => _QRResultScreenState();
}

class _QRResultScreenState extends State<QRResultScreen> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
  }

  Future<void> _getBluetoothDevices() async {
    final List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _printQRData() async {
    if (_selectedDevice != null) {
      try {
        await bluetooth.connect(_selectedDevice!);
        final String qrData =
            'รหัสประจำตัวพนักงาน: ${widget.employeeId},\nชื่อพนักงาน: ${widget.fullName},\nเบอร์โทร: ${widget.phoneNumber},\nน้ำหนักที่ชั่ง: ${widget.weight} กก.,\nวันที่: ${DateFormat('dd-MM-yyyy').format(widget.scanDateTime.toLocal())},\nเวลา: ${DateFormat('HH:mm:ss').format(widget.scanDateTime.toLocal())}';
        bluetooth.printCustom(qrData, 0, 1);
        bluetooth.printNewLine();
        bluetooth.disconnect();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการพิมพ์: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกเครื่องพิมพ์ก่อนพิมพ์')),
      );
    }
  }

  void _showDeviceSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกเครื่องพิมพ์'),
          content: DropdownButton<BluetoothDevice>(
            items: _devices
                .map((BluetoothDevice device) =>
                    DropdownMenuItem<BluetoothDevice>(
                      value: device,
                      child: Text(device.name!),
                    ))
                .toList(),
            onChanged: (BluetoothDevice? value) {
              setState(() {
                _selectedDevice = value;
              });
              Navigator.of(context).pop();
            },
            hint: const Text('เลือกเครื่องพิมพ์'),
            value: _selectedDevice,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm:ss');

    final formattedDate = dateFormat.format(widget.scanDateTime.toLocal());
    final formattedTime = timeFormat.format(widget.scanDateTime.toLocal());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ผลลัพธ์ QR Code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _showDeviceSelectionDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildInfoCard(context, Icons.badge, 'รหัสประจำตัวพนักงาน',
                widget.employeeId, ''),
            _buildInfoCard(
                context, Icons.person, 'ชื่อพนักงาน', widget.fullName, ''),
            _buildInfoCard(
                context, Icons.phone, 'เบอร์โทร', widget.phoneNumber, ''),
            _buildInfoCard(
                context, Icons.scale, 'น้ำหนักที่ชั่ง', widget.weight, 'กก.'),
            _buildInfoCard(
                context, Icons.calendar_today, 'วันที่', formattedDate, ''),
            _buildInfoCard(
                context, Icons.access_time, 'เวลา', formattedTime, ''),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final storageService = StorageService();
                    final qrData = await storageService.getQrData();
                    qrData.insert(0, {
                      'employeeId': widget.employeeId,
                      'fullName': widget.fullName,
                      'weight': widget.weight,
                      'formattedDate': formattedDate,
                      'formattedTime': formattedTime,
                      'phoneNumber': widget.phoneNumber,
                    });
                    await storageService.saveQrData(qrData);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('บันทึกสำเร็จ')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                    );
                  }
                },
                child: const Text('บันทึก'),
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: _printQRData,
                child: const Text('พิมพ์ QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title,
      String content, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Card(
        color: Colors.white,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 24.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '$content $unit',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
