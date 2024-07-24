// ignore_for_file: file_names

import 'package:flutter/material.dart';

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การจัดการพนักงาน'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add employee page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with the actual number of employees
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      title: Text(
                        'ชื่อพนักงาน $index',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ตำแหน่งงาน $index',
                          style: const TextStyle(fontSize: 14)),
                      // ignore: sized_box_for_whitespace
                      trailing: Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.zero,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                iconSize: 21,
                                onPressed: () {
                                  // Edit employee information
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 21,
                              onPressed: () {
                                // Delete employee
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Save changes
                  },
                  child: const Text('บันทึก'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
