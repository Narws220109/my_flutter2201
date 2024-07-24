import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SendDataToESP32Screen extends StatelessWidget {
  SendDataToESP32Screen({super.key});

  final TextEditingController _controller = TextEditingController();

  Future<void> _sendData() async {
    final http.Response response = await http.post(
      Uri.parse('http://your_esp32_ip_address/sendData'),
      body: <String, String>{'message': _controller.text},
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Data to ESP32'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // ignore: always_specify_types
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendData,
              child: const Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}
