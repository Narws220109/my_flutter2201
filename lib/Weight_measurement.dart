// import 'package:flutter/material.dart';
// // import 'package:qr_flutter/qr_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weight Measurement',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WeightMeasurementScreen(),
//     );
//   }
// }

// class WeightMeasurementScreen extends StatelessWidget {
//   final String employeeId = "123456";
//   final String employeeName = "John Doe";
//   final String weight = "70.5 kg";
//   final String qrData = "Employee ID: 123456\nName: John Doe";

//   @override
//   Widget build(BuildContext context) {
//     // var qrImage2 = QrImage(
//     //     //    data: qrData,
//     //     //   size: 200,
//     //     );
//     // var qrImage = qrImage2;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text('Weight Measurement'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //         qrImage,
//             SizedBox(height: 20),
//             Text(
//               'น้ำหนัก: $weight',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'รหัสประจำตัวพนักงาน: $employeeId',
//               style: TextStyle(fontSize: 18),
//             ),
//             Text(
//               'ชื่อ-สกุล: $employeeName',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // ใส่โค้ดสำหรับการเก็บค่าไปยังหน้าบันทึก
//                   },
//                   child: Text('บันทึก'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // ใส่โค้ดสำหรับการเปรียบเทียบน้ำหนัก
//                   },
//                   child: Text('เปรียบเทียบ'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
