// ignore_for_file: file_names, inference_failure_on_function_invocation, always_specify_types, avoid_redundant_argument_values
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  String? _scannedData;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
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
            onDetect: (BarcodeCapture capture) {
              try {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;

                if (barcodes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No barcodes found')),
                  );
                } else {
                  for (final Barcode barcode in barcodes) {
                    final String barcodeValue = barcode.rawValue ?? 'Unknown';
                    if (_scannedData != barcodeValue) {
                      setState(() {
                        _scannedData = barcodeValue;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Barcode found: $barcodeValue')),
                      );
                      debugPrint('Barcode found! $barcodeValue');
                    }
                  }
                }

                if (image != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Image.memory(image),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
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
          if (_scannedData != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Last Scanned: $_scannedData',
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
            width: 250,
            height: 250,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white, width: 4),
                        left: BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white, width: 4),
                        right: BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 4),
                        left: BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 4),
                        right: BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
