// ignore_for_file: sort_constructors_first, avoid_print, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:math';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'QRResultScreen.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  String? _scannedData;
  late AnimationController _animationController;

  BluetoothConnection? connection;
  String realTimeWeight = ''; // ค่าน้ำหนักแบบเรียลทาม
  String stableWeight = ''; // ค่าน้ำหนักที่คงที่
  bool isConnecting = true;
  bool isConnected = false;
  bool isDisconnected = false;
  String errorMessage = '';
  Timer? _updateTimer;
  List<double> weightReadings = <double>[];
  final int maxStableReadings = 10;
  final double stableThreshold = 5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
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
          final double voltage = double.tryParse(newData) ?? 0;
          final double weight = _calculateWeight(voltage);

          setState(() {
            realTimeWeight = weight.toStringAsFixed(3);
          });

          _addWeightReading(weight);

          if (_updateTimer == null || !_updateTimer!.isActive) {
            _updateTimer = Timer(const Duration(seconds: 3), () {
              final double? averageWeight = _calculateStableWeight();
              if (averageWeight != null) {
                setState(() {
                  stableWeight = averageWeight.toStringAsFixed(3);
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
    return (voltage / 4095) * 60;
  }

  void _addWeightReading(double weight) {
    if (weightReadings.length >= maxStableReadings) {
      weightReadings.removeAt(0);
    }
    weightReadings.add(weight);
  }

  double? _calculateStableWeight() {
    if (weightReadings.length < maxStableReadings) {
      return null;
    }

    final double maxWeight = weightReadings.reduce(max);
    final double minWeight = weightReadings.reduce(min);
    if ((maxWeight - minWeight) <= stableThreshold) {
      return weightReadings.reduce((a, b) => a + b) / weightReadings.length;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _updateTimer?.cancel();
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สแกน QR Code'),
        actions: <Widget>[
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller.torchState,
              builder: (BuildContext context, Object? value, Widget? child) {
                return Icon(
                  value == TorchState.off ? Icons.flash_off : Icons.flash_on,
                  color: value == TorchState.off ? Colors.grey : Colors.yellow,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller.cameraFacingState,
              builder: (BuildContext context, Object? value, Widget? child) {
                return Icon(
                  value == CameraFacing.front
                      ? Icons.camera_front
                      : Icons.camera_rear,
                );
              },
            ),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) async {
              try {
                final List<Barcode> barcodes = capture.barcodes;

                for (final Barcode barcode in barcodes) {
                  final String barcodeValue = barcode.rawValue ?? 'Unknown';
                  if (_scannedData != barcodeValue) {
                    setState(() {
                      _scannedData = barcodeValue;
                    });

                    final List<String> dataParts = barcodeValue.split(',');
                    final String employeeId = dataParts.isNotEmpty
                        ? dataParts[0].split(':')[1].trim()
                        : 'Unknown';
                    final String fullName = dataParts.length > 1
                        ? dataParts[1].split(':')[1].trim()
                        : 'Unknown';
                    final String phoneNumber = dataParts.length > 2
                        ? dataParts[2].split(':')[1].trim()
                        : 'Unknown';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRResultScreen(
                          employeeId: employeeId,
                          fullName: fullName,
                          weight: stableWeight,
                          scanDateTime: DateTime.now(),
                          phoneNumber: phoneNumber,
                          barcodeValue: barcodeValue,
                        ),
                      ),
                    );
                    break;
                  }
                }
              } catch (e) {
                debugPrint('Error: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('An error occurred: $e')),
                );
              }
            },
          ),
          _buildScannerOverlay(context),
          // Add the stable weight display in the top-right corner
          Positioned(
            top: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'น้ำหนัก: $stableWeight กก.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isConnected
                      ? 'Connected'
                      : isDisconnected
                          ? 'Disconnected'
                          : 'Connecting...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          // Optionally, display the last scanned data at the bottom
          if (_scannedData != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Last Scanned: $_scannedData, น้ำหนัก: $stableWeight กก.',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    return Stack(
      children: <Widget>[
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 230,
            height: 230,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ScannerOverlayPainter(_animationController.value),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double progress;

  ScannerOverlayPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 6.0;
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const double cornerLength = 50.0;

    final Path path = Path();
    final Rect rect = Offset.zero & size;

    // Top left corner
    path.moveTo(rect.left + cornerLength, rect.top);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left, rect.top + cornerLength);

    // Top right corner
    path.moveTo(rect.right - cornerLength, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + cornerLength);

    // Bottom left corner
    path.moveTo(rect.left, rect.bottom - cornerLength);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left + cornerLength, rect.bottom);

    // Bottom right corner
    path.moveTo(rect.right - cornerLength, rect.bottom);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right, rect.bottom - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
