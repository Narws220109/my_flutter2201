// ignore_for_file: unnecessary_cast

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _key = 'qrData';

  Future<void> saveQrData(List<Map<String, String>> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(data);
    await prefs.setString(_key, jsonString);
  }

  Future<List<Map<String, String>>> getQrData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;

      // ตรวจสอบและแปลง List<dynamic> เป็น List<Map<String, String>>
      return jsonData.map((item) {
        if (item is Map) {
          return Map<String, String>.from(item as Map<dynamic, dynamic>);
        }
        return <String, String>{}; // ส่งค่าผิดพลาด ถ้าข้อมูลไม่เป็น Map
      }).toList();
    } else {
      return <Map<String, String>>[];
    }
  }
}
