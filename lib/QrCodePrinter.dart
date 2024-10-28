// ignore_for_file: prefer_final_locals, unnecessary_string_interpolations, use_super_parameters, inference_failure_on_function_return_type, prefer_single_quotes, prefer_final_in_for_each

import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key, required this.dailyResults}) : super(key: key);

  final List<Map<String, String>> dailyResults;

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  int selectedIndex = 0;
  List<Map<String, String>> get dailyResults => widget.dailyResults;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get pages {
    return [
      EarningsPage(dailyResults: dailyResults),
      ReportsPage(dailyResults: dailyResults),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการชั่งน้ำหนัก'),
        bottom: TabBarSection(
          selectedIndex: selectedIndex,
          onTabSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}

class TabBarSection extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const TabBarSection({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: selectedIndex == 0 ? Colors.pink[200] : Colors.white,
              child: Center(
                child: Text(
                  'รายวัน',
                  style: TextStyle(
                    color: selectedIndex == 0 ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: selectedIndex == 1 ? Colors.pink[200] : Colors.white,
              child: Center(
                child: Text(
                  'คำนวณเงินรายวัน',
                  style: TextStyle(
                    color: selectedIndex == 1 ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class EarningsPage extends StatelessWidget {
  final List<Map<String, String>> dailyResults;

  const EarningsPage({Key? key, required this.dailyResults}) : super(key: key);

  Future<void> _selectAndPrint(BuildContext context, String text) async {
    try {
      final printer = BlueThermalPrinter.instance;
      final devices = await printer.getBondedDevices();
      final selectedDevice = await _selectBluetoothDevice(context, devices);

      if (selectedDevice != null) {
        await printer.connect(selectedDevice);
        await printer.printNewLine();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กำลังพิมพ์...')),
        );
        await printer.disconnect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่ได้เลือกอุปกรณ์')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('พิมพ์ล้มเหลว: $e')),
      );
    }
  }

  Future<BluetoothDevice?> _selectBluetoothDevice(
      BuildContext context, List<BluetoothDevice> devices) async {
    return showDialog<BluetoothDevice>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกอุปกรณ์ Bluetooth'),
          content: SingleChildScrollView(
            child: ListBody(
              children: devices.map((device) {
                return ListTile(
                  title: Text(device.name ?? "ไม่ทราบชื่อ"),
                  onTap: () {
                    Navigator.of(context).pop(device);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dailyResults.isEmpty) {
      return const Center(
        child: Text('ไม่มีข้อมูล', style: TextStyle(fontSize: 20)),
      );
    }

    return ListView.builder(
      itemCount: dailyResults.length,
      itemBuilder: (context, index) {
        final dailyResult = dailyResults[index];
        return Card(
          child: ListTile(
            title: Text(dailyResult['fullName'] ?? 'ชื่อไม่ทราบ'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('รหัส: ${dailyResult['employeeId'] ?? 'รหัสไม่ทราบ'}'),
                Text(
                    'เบอร์โทร: ${dailyResult['phoneNumber'] ?? 'เบอร์โทรไม่ทราบ'}'),
                Text('น้ำหนัก: ${dailyResult['weight'] ?? '0'} กก.'),
                Text(
                    'วันที่: ${dailyResult['formattedDate'] ?? 'วันที่ไม่ทราบ'}'),
                Text('เวลา: ${dailyResult['formattedTime'] ?? 'เวลาไม่ทราบ'}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                final text = """
รหัสประจำตัวพนักงาน: ${dailyResult['employeeId'] ?? 'รหัสไม่ทราบ'}
ชื่อพนักงาน: ${dailyResult['fullName'] ?? 'ชื่อไม่ทราบ'}
เบอร์โทร: ${dailyResult['phoneNumber'] ?? 'เบอร์โทรไม่ทราบ'}
น้ำหนัก: ${dailyResult['weight'] ?? '0'} กก.
วันที่: ${dailyResult['formattedDate'] ?? 'วันที่ไม่ทราบ'}
เวลา: ${dailyResult['formattedTime'] ?? 'เวลาไม่ทราบ'}
                """;
                _selectAndPrint(context, text);
              },
            ),
          ),
        );
      },
    );
  }
}

class ReportsPage extends StatefulWidget {
  final List<Map<String, String>> dailyResults;

  const ReportsPage({Key? key, required this.dailyResults}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  double globalRate = 0.0;
  final Map<String, double> totalWeights = {};

  @override
  void initState() {
    super.initState();
    _calculateTotalWeights();
  }

  void _calculateTotalWeights() {
    for (Map<String, String> entry in widget.dailyResults) {
      final key =
          '${entry['fullName']}_${entry['employeeId']}_${entry['formattedDate']}';
      final weight = double.tryParse(entry['weight'] ?? '0') ?? 0;

      if (totalWeights.containsKey(key)) {
        totalWeights[key] = totalWeights[key]! + weight;
      } else {
        totalWeights[key] = weight;
      }
    }
  }

  Future<void> _selectAndPrintAll(BuildContext context) async {
    try {
      final printer = BlueThermalPrinter.instance;
      final devices = await printer.getBondedDevices();
      final selectedDevice = await _selectBluetoothDevice(context, devices);

      if (selectedDevice != null) {
        await printer.connect(selectedDevice);
        final buffer = StringBuffer();
        totalWeights.forEach((key, totalWeight) {
          final totalAmount = (totalWeight * globalRate).toStringAsFixed(2);

          final nameAndDate = key.split('_');
          final fullName = nameAndDate[0];
          final employeeId = nameAndDate[1];
          final formattedDate = nameAndDate[2];

          buffer.writeln('''
ชื่อพนักงาน: $fullName
รหัส: $employeeId
วันที่: $formattedDate
น้ำหนักรวม: $totalWeight กก.
รวมเป็นเงิน: $totalAmount บาท
          ''');
        });

        await printer.printNewLine();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กำลังพิมพ์ทั้งหมด...')),
        );
        await printer.disconnect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่ได้เลือกอุปกรณ์')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('พิมพ์ล้มเหลว: $e')),
      );
    }
  }

  Future<BluetoothDevice?> _selectBluetoothDevice(
      BuildContext context, List<BluetoothDevice> devices) async {
    return showDialog<BluetoothDevice>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกอุปกรณ์ Bluetooth'),
          content: SingleChildScrollView(
            child: ListBody(
              children: devices.map((device) {
                return ListTile(
                  title: Text(device.name ?? "ไม่ทราบชื่อ"),
                  onTap: () {
                    Navigator.of(context).pop(device);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text('จำนวนเงินรายวัน: '),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'กรอกจำนวนเงิน',
                  ),
                  onChanged: (value) {
                    setState(() {
                      globalRate = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _selectAndPrintAll(context);
          },
          child: const Text('พิมพ์ทั้งหมด'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: totalWeights.length,
            itemBuilder: (context, index) {
              final key = totalWeights.keys.elementAt(index);
              final totalWeight = totalWeights[key] ?? 0;
              final totalAmount = (totalWeight * globalRate).toStringAsFixed(2);

              final nameAndDate = key.split('_');
              final fullName = nameAndDate[0];
              final employeeId = nameAndDate[1];
              final formattedDate = nameAndDate[2];

              return Card(
                child: ListTile(
                  title: Text('$fullName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รหัส: $employeeId'),
                      Text('วันที่: $formattedDate'),
                      Text('น้ำหนักรวม: $totalWeight กก.'),
                      Text('รวมเป็นเงิน: $totalAmount บาท'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
