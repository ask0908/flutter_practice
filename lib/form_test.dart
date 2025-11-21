import 'package:flutter/material.dart';

class FormTest extends StatelessWidget {
  const FormTest({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Form 예시")),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "이메일 입력",
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "텍스트를 입력하세요";
                    }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        debugPrint("유효한 값");
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}