// ignore_for_file: prefer_single_quotes, avoid_print

import 'dart:typed_data';
import 'dart:async';
import 'dart:math'; // สำหรับการคำนวณทางคณิตศาสตร์
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothConnection? connection;
  String realTimeWeight = ''; // ค่าน้ำหนักแบบเรียลทาม
  String stableWeight = ''; // ค่าน้ำหนักที่คงที่
  bool isConnecting = true;
  bool isConnected = false;
  bool isDisconnected = false;
  String errorMessage = '';
  Timer? _updateTimer; // ตัวแปรสำหรับ Timer
  List<double> weightReadings = <double>[]; // เก็บค่าที่รับล่าสุด
  final int maxStableReadings = 10; // จำนวนค่าที่ใช้ในการคำนวณค่าเฉลี่ย
  final double stableThreshold = 5; // ความแตกต่างสูงสุดเพื่อให้ถือว่า "นิ่ง"

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.bluetooth.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted) {
      _connectToDevice();
    } else {
      await <Permission>[
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      if (await Permission.bluetooth.isGranted &&
          await Permission.bluetoothScan.isGranted &&
          await Permission.bluetoothConnect.isGranted) {
        _connectToDevice();
      } else {
        setState(() {
          isConnecting = false;
          errorMessage =
              "Please grant Bluetooth permissions in your device settings.";
        });
      }
    }
  }

  Future<void> _connectToDevice() async {
    final List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    BluetoothDevice? targetDevice;
    try {
      targetDevice = devices.firstWhere(
          (BluetoothDevice device) => device.name == "ESP32_Bluetooth");
    } catch (e) {
      targetDevice = null;
    }

    if (targetDevice != null) {
      try {
        connection = await BluetoothConnection.toAddress(targetDevice.address);
        setState(() {
          isConnecting = false;
          isConnected = true;
        });

        connection!.input!.listen((Uint8List data) {
          final String newData = String.fromCharCodes(data).trim();
          final double voltage =
              double.tryParse(newData) ?? 0; // รับค่าจาก ESP32
          final double weight = _calculateWeight(voltage); // คำนวณน้ำหนัก

          setState(() {
            realTimeWeight =
                weight.toStringAsFixed(3); // แสดงค่าน้ำหนักแบบเรียลทาม
          });

          _addWeightReading(weight); // เก็บค่าล่าสุดเพื่อคำนวณค่าเฉลี่ย

          if (_updateTimer == null || !_updateTimer!.isActive) {
            // เริ่มต้น Timer สำหรับการอัปเดตค่าทุก ๆ 3 วินาที
            // ignore: prefer_const_constructors
            _updateTimer = Timer(Duration(seconds: 3), () {
              final double? averageWeight = _calculateStableWeight();
              if (averageWeight != null) {
                setState(() {
                  stableWeight = averageWeight
                      .toStringAsFixed(3); // แสดงค่าน้ำหนักที่คงที่
                });
              }
            });
          }
        }).onDone(() {
          setState(() {
            isConnected = false;
            isDisconnected = true;
          });
          print("Disconnected");
        });
      } catch (e) {
        setState(() {
          isConnecting = false;
          isConnected = false;
          errorMessage = "Failed to connect: $e";
        });
        print("Failed to connect: $e");
      }
    } else {
      setState(() {
        isConnecting = false;
        isConnected = false;
        errorMessage = "Device not found!";
      });
      print("Device not found!");
    }
  }

  double _calculateWeight(double voltage) {
    // คำนวณน้ำหนักจากแรงดัน 0-4095 ให้กลายเป็น 0-60 กิโลกรัม
    return (voltage / 4095) * 60;
  }

  void _addWeightReading(double weight) {
    if (weightReadings.length >= maxStableReadings) {
      weightReadings.removeAt(0); // ลบค่าแรกออกเมื่อมีค่าครบ 10 ค่า
    }
    weightReadings.add(weight);
  }

  double? _calculateStableWeight() {
    if (weightReadings.length < maxStableReadings) {
      return null; // ถ้ายังมีค่าที่อ่านไม่ครบ 10 ค่า
    }

    // ตรวจสอบว่าความแตกต่างของค่าน้ำหนักแต่ละค่าน้อยกว่า threshold หรือไม่
    final double maxWeight = weightReadings.reduce(max);
    final double minWeight = weightReadings.reduce(min);
    if ((maxWeight - minWeight).abs() <= stableThreshold) {
      // ถ้าค่าคงที่แล้ว ให้คำนวณค่าเฉลี่ย
      final double totalWeight =
          weightReadings.reduce((double a, double b) => a + b);
      return totalWeight / weightReadings.length;
    }

    return null;
  }

  @override
  void dispose() {
    if (connection != null) {
      connection!.dispose();
    }
    _updateTimer?.cancel(); // ยกเลิก Timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusText;
    if (isConnecting) {
      statusText = 'Connecting...';
    } else if (isConnected) {
      statusText = 'Connected';
    } else if (isDisconnected) {
      statusText = 'Disconnected';
    } else {
      statusText = 'Not Connected';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              statusText,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              "Real-Time Weight: $realTimeWeight kg", // แสดงค่าน้ำหนักแบบเรียลทาม
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              "Stable Weight: $stableWeight kg", // แสดงค่าน้ำหนักที่คงที่
              style: const TextStyle(fontSize: 24),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
