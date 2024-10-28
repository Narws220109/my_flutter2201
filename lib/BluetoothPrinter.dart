// ignore_for_file: prefer_final_locals, use_if_null_to_convert_nulls_to_bools

import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class BluetoothPrinterService {
  final BlueThermalPrinter printer = BlueThermalPrinter.instance;

  Future<void> printText(String text) async {
    try {
      // ดึงข้อมูลอุปกรณ์ Bluetooth ที่จับคู่แล้ว

      List<BluetoothDevice> devices = await printer.getBondedDevices();

      // ตรวจสอบว่าเจออุปกรณ์ที่จับคู่แล้วหรือไม่
      if (devices.isNotEmpty) {
        // เลือกอุปกรณ์แรกที่เจออัตโนมัติ
        BluetoothDevice selectedDevice = devices.first;

        // เชื่อมต่อกับอุปกรณ์
        await printer.connect(selectedDevice);

        // ตรวจสอบว่าเชื่อมต่อสำเร็จหรือไม่
        bool? isConnected = await printer.isConnected;
        if (isConnected == true) {
          // พิมพ์ข้อความ (เปลี่ยนจาก printText เป็น printCustom ตามที่แพ็กเกจรองรับ)
          await printer.printCustom(text, 1, 1); // ระดับความหนาและขนาด

          // พิมพ์บรรทัดว่าง
          await printer.printNewLine();

          // ตัดการเชื่อมต่อหลังจากพิมพ์เสร็จ
          await printer.disconnect();
        } else {
          throw Exception('อุปกรณ์ไม่ได้เชื่อมต่อ');
        }
      } else {
        throw Exception('ไม่พบอุปกรณ์ Bluetooth');
      }
    } catch (e) {
      // การจัดการข้อผิดพลาด
      throw Exception('เกิดข้อผิดพลาดในการพิมพ์: $e');
    }
  }
}
