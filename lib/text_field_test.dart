import 'package:flutter/material.dart';

class TextFieldTest extends StatelessWidget {
  const TextFieldTest({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("TextField 예시")),
      body: Center(
        child: SizedBox(
          width: 300.0,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "이름을 입력하세요",
            ),
          ),
        ),
      ),
    );
  }
}