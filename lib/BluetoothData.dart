// ignore_for_file: prefer_final_locals, prefer_final_in_for_each

import 'dart:async';
import 'dart:math'; // ใช้สำหรับคำนวณทางคณิตศาสตร์
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
  String realTimeWeight = '00.00';
  String stableWeight = '00.00';
  bool isConnecting = true;
  bool isConnected = false;
  bool isDisconnected = false;
  String errorMessage = '';
  Timer? _updateTimer;
  List<double> weightReadings = <double>[];
  double slope = 0;
  double intercept = 0;

  Map<int, RangeValues> calibrationValues = {
    0: const RangeValues(0, 0),
    10: const RangeValues(0, 0),
    20: const RangeValues(0, 0),
    30: const RangeValues(0, 0),
    40: const RangeValues(0, 0),
    50: const RangeValues(0, 0),
    60: const RangeValues(0, 0),
  };

  final Map<int, TextEditingController> calibrationControllers = {};

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    calibrationControllers.addAll({
      0: TextEditingController(),
      10: TextEditingController(),
      20: TextEditingController(),
      30: TextEditingController(),
      40: TextEditingController(),
      50: TextEditingController(),
      60: TextEditingController(),
    });
  }

  Future<void> _requestPermissions() async {
    // ขอสิทธิ์ Bluetooth
    await Permission.bluetooth.request();
    if (await Permission.bluetooth.isGranted) {
      _connectToDevice();
    }
  }

  Future<void> _connectToDevice() async {
    // การเชื่อมต่อกับอุปกรณ์ Bluetooth
    try {
      // สมมติว่าเชื่อมต่อกับอุปกรณ์แล้ว
      setState(() {
        isConnected = true;
        isConnecting = false;
      });

      // เริ่มต้นการรับข้อมูลจากเซ็นเซอร์และคำนวณน้ำหนัก
      _startReceivingData();
    } catch (error) {
      setState(() {
        isConnected = false;
        errorMessage = 'ไม่สามารถเชื่อมต่อได้';
      });
    }
  }

  void _startReceivingData() {
    // เริ่มต้นการรับค่าแรงดันจากเซ็นเซอร์ (เชื่อมต่อผ่าน Bluetooth)
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      double voltage =
          _getRandomVoltage(); // แทนการรับค่าแรงดันจริงจากเซ็นเซอร์

      double weight = _calculateWeight(voltage);
      _addWeightReading(weight);

      double? averageWeight = _calculateAverageWeight();
      if (averageWeight != null) {
        setState(() {
          realTimeWeight = weight.toStringAsFixed(2);
          stableWeight = averageWeight.toStringAsFixed(2);
        });
      }
    });
  }

  double _getRandomVoltage() {
    // จำลองการรับค่าแรงดันจากเซ็นเซอร์
    return Random().nextDouble() * 5; // จำลองแรงดันในช่วง 0-5 โวลต์
  }

  double _calculateWeight(double voltage) {
    // ใช้สมการเชิงเส้นที่คำนวณจากค่าแรงดันและน้ำหนักที่เก็บไว้
    return intercept + slope * voltage;
  }

  void _addWeightReading(double weight) {
    weightReadings.add(weight);
    if (weightReadings.length > 10) {
      weightReadings.removeAt(0); // ลบค่าที่เก่าที่สุด
    }
  }

  double? _calculateAverageWeight() {
    if (weightReadings.isNotEmpty) {
      return weightReadings.reduce((a, b) => a + b) / weightReadings.length;
    }
    return null;
  }

  void _calibrate() {
    // คำนวณสมการเชิงเส้นจากค่าที่ผู้ใช้กรอกในแต่ละช่วงน้ำหนัก
    List<double> voltages = [];
    List<double> weights = [];

    calibrationValues.forEach((weight, range) {
      if (range.start != 0) {
        voltages.add(range.start);
        weights.add(weight.toDouble());
      }
    });

    if (voltages.isNotEmpty && weights.isNotEmpty) {
      // คำนวณค่าความชัน (slope) และ intercept
      double n = voltages.length.toDouble();
      double sumX = voltages.reduce((a, b) => a + b);
      double sumY = weights.reduce((a, b) => a + b);
      double sumXY = 0;
      double sumX2 = 0;

      for (int i = 0; i < voltages.length; i++) {
        sumXY += voltages[i] * weights[i];
        sumX2 += pow(voltages[i], 2);
      }

      slope = (n * sumXY - sumX * sumY) / (n * sumX2 - pow(sumX, 2));
      intercept = (sumY - slope * sumX) / n;

      setState(() {
        // อัปเดตสมการ
      });
    }
  }

  @override
  void dispose() {
    if (connection != null) {
      connection!.dispose();
    }
    _updateTimer?.cancel();
    for (TextEditingController controller in calibrationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Calculation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Real-time Weight:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${double.parse(realTimeWeight).toStringAsFixed(2).padLeft(5, '0')} kg',
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                'Stable Weight (Average):',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${double.parse(stableWeight).toStringAsFixed(2).padLeft(5, '0')} kg',
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 20),
              const Text('Calibration (0-60 kg):'),
              Column(
                children: calibrationValues.keys.map((weight) {
                  return Row(
                    children: [
                      Text('$weight kg: '),
                      Expanded(
                        child: TextField(
                          controller: calibrationControllers[weight],
                          decoration: const InputDecoration(
                            labelText: 'Voltage',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              calibrationValues[weight] =
                                  RangeValues(double.tryParse(value) ?? 0, 0);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calibrate,
                child: const Text('Calibrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
