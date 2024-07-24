import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class WeightComparisonScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Weight Comparison'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildDatabaseSection(),
            const Divider(),
            _buildConnectionSection(),
            const Divider(),
            _buildBasketWeightSection(),
            const Divider(),
            _buildCalibrationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('ฐานข้อมูล', style: TextStyle(fontSize: 18)),
        Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการเชื่อมต่อฐานข้อมูล
              },
              child: const Text('เชื่อมต่อ'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการบันทึกค่าการเชื่อมต่อ
              },
              child: const Text('บันทึกค่า'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('การเชื่อมต่อ', style: TextStyle(fontSize: 18)),
        Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการเลือกบลูทูธ
              },
              child: const Text('เลือกบลูทูธ'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // ใส่โค้ดสำหรับการบันทึกการเชื่อมต่อบลูทูธ
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasketWeightSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _basketWeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'น้ำหนักตะกร้า (กก.)',
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // ใส่โค้ดสำหรับบันทึกน้ำหนักตะกร้า
          },
          child: const Text('บันทึก'),
        ),
      ],
    );
  }

  Widget _buildCalibrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'น้ำหนัก (กก.)',
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _measuredWeight =
                      double.tryParse(_weightController.text) ?? 0.0;
                });
              },
              child: const Text('อ่านค่า'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('น้ำหนักก่อนอ่านค่า: $_calibratedWeight กก.'),
        Text('น้ำหนักหลังอ่านค่า: $_measuredWeight กก.'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _calibratedWeight = _measuredWeight;
            });
            // ใส่โค้ดสำหรับบันทึกค่าการกำหนดน้ำหนัก
          },
          child: const Text('บันทึกค่า'),
        ),
      ],
    );
  }
}
