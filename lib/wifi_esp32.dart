// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ESP32 Communication'),
        ),
        body: const Center(
          child: CommunicationWidget(),
        ),
      ),
    );
  }
}

class CommunicationWidget extends StatefulWidget {
  const CommunicationWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CommunicationWidgetState createState() => _CommunicationWidgetState();
}

class _CommunicationWidgetState extends State<CommunicationWidget> {
  final String esp32IpAddress =
      'http://192.168.137.249'; // ใส่ IP Address ของ ESP32 ที่เชื่อมต่อกับเครือข่าย Wi-Fi
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendData() async {
    final String message = _messageController.text;
    final http.Response response = await http.post(
      Uri.parse('$esp32IpAddress/sendData'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: <String, String>{'message': message},
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print('Failed to send data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _messageController,
          decoration: const InputDecoration(
            labelText: 'Enter message',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _sendData,
          child: const Text('Send Data'),
        ),
      ],
    );
  }
}
