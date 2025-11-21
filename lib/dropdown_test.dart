import 'package:flutter/material.dart';

class DropdownTest extends StatefulWidget {
  const DropdownTest({super.key});

  @override
  State<DropdownTest> createState() => _DropdownTestState();
}

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  orange('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  final String label;
  final Color color;

  const ColorLabel(this.label, this.color);
}

class _DropdownTestState extends State<DropdownTest> {

  ColorLabel? selectedColor = ColorLabel.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DropdownMenu 예시")),
      body: Center(
        child: DropdownButton<ColorLabel>(
          value: selectedColor,
          hint: Text("Color"),
          items: ColorLabel.values.map((ColorLabel color) {
            return DropdownMenuItem<ColorLabel>(
              value: color,
              child: Text(
                color.label,
                style: TextStyle(color: color.color),
              ),
            );
          }).toList(),
          onChanged: (ColorLabel? newValue) {
            setState(() {
              selectedColor = newValue;
            });
          },
        ),
      ),
    );
  }
}