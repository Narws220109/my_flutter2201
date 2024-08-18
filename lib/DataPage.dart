// ignore_for_file: unused_import, file_names, avoid_print, prefer_final_locals

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_server/http_server.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late HttpServer _server;
  double _angle = 0.0;

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    _server = await HttpServer.bind('0.0.0.0', 8080);
    print('Server started on port 8080');

    _server.listen((HttpRequest request) async {
      if (request.uri.path == '/update-angle' && request.method == 'POST') {
        String content = await utf8.decoder.bind(request).join();
        Map<String, String> data = Uri.splitQueryString(content);

        if (data.containsKey('angle')) {
          setState(() {
            _angle = double.parse(data['angle']!);
            print('Received angle: $_angle');
          });
        }

        request.response
          ..statusCode = 200
          ..write('Angle updated successfully')
          ..close();
      } else {
        request.response
          ..statusCode = 404
          ..write('Not Found')
          ..close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Angle Sensor Monitor'),
        ),
        body: Center(
          child: Text(
            'Current Angle: $_angle°',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _server.close();
    super.dispose();
  }
}
