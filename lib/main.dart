// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors, prefer_final_locals, use_build_context_synchronously, always_specify_types, sort_constructors_first, use_key_in_widget_constructors, unused_field, inference_failure_on_instance_creation, unused_import

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: directives_ordering, depend_on_referenced_packages
import 'package:path/path.dart';
import 'HomePage.dart'; // นำเข้าไฟล์ HomePage.dart
import 'database_helper.dart';
import 'Login.dart'; // นำเข้าไฟล์ HomePage.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 176, 20, 137)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}
