import 'package:flutter/material.dart';

class DismissibleTest extends StatefulWidget {
  const DismissibleTest({super.key});

  @override
  State<DismissibleTest> createState() => _DismissibleTestState();
}

class _DismissibleTestState extends State<DismissibleTest> {

  List<int> items = List<int>.generate(100, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DatePickerDialog 테스트")),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              background: Container(
                color: Colors.green,
              ),
              key: ValueKey<int>(items[index]),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  items.removeAt(index);
                });
              },
              child: ListTile(
                title: Text(
                  'Item ${items[index]}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}