import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Comparison',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeightComparisonScreen(),
    );
  }
}

class WeightComparisonScreen extends StatefulWidget {
  @override
  _WeightComparisonScreenState createState() => _WeightComparisonScreenState();
}

class _WeightComparisonScreenState extends State<WeightComparisonScreen> {
  final TextEditingController _basketWeightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _calibratedWeight = 0.0;
  double _measuredWeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Weight Comparison'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDatabaseSection(),
            Divider(),
            _buildConnectionSection(),
            Divider(),
            _buildBasketWeightSection(),
            Divider(),
            _buildCalibrationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('ฐานข้อมูล', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการเชื่อมต่อฐานข้อมูล
              },
              child: Text('เชื่อมต่อ'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการบันทึกค่าการเชื่อมต่อ
              },
              child: Text('บันทึกค่า'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('การเชื่อมต่อ', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการเลือกบลูทูธ
              },
              child: Text('เลือกบลูทูธ'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการบันทึกการเชื่อมต่อบลูทูธ
              },
              child: Text('บันทึก'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasketWeightSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: _basketWeightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'น้ำหนักตะกร้า (กก.)',
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // ใส่โค้ดสำหรับบันทึกน้ำหนักตะกร้า
          },
          child: Text('บันทึก'),
        ),
      ],
    );
  }

  Widget _buildCalibrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'น้ำหนัก (กก.)',
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _measuredWeight =
                      double.tryParse(_weightController.text) ?? 0.0;
                });
              },
              child: Text('อ่านค่า'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text('น้ำหนักก่อนอ่านค่า: $_calibratedWeight กก.'),
        Text('น้ำหนักหลังอ่านค่า: $_measuredWeight กก.'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _calibratedWeight = _measuredWeight;
            });
            // ใส่โค้ดสำหรับบันทึกค่าการกำหนดน้ำหนัก
          },
          child: Text('บันทึกค่า'),
        ),
      ],
    );
  }
}
