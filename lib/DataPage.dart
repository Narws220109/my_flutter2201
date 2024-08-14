// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  int _sensorValue = 0;
  bool _loading = true;
  String _errorMessage = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer =
        Timer.periodic(const Duration(seconds: 2), (Timer t) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final http.Response response = await http.get(Uri.parse(
          'http://192.168.137.101')); // Replace with your ESP32 IP address

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        setState(() {
          _sensorValue = data['sensor_value'] is int
              ? data['sensor_value'] as int
              : int.tryParse(data['sensor_value'].toString()) ?? 0;
          _loading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sensor Value: $_sensorValue',
                        style: const TextStyle(fontSize: 24),
                      ),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
