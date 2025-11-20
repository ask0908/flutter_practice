import 'package:flutter/material.dart';

class SelectableTextTest extends StatelessWidget {
  const SelectableTextTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SelectableText 테스트")),
      body: Center(
        child: SelectableText(
          "Two households, both alike in dignity,\n"
              "In fair Verona, where we lay our scene,\n"
              "From ancient grudge break to new mutiny,\n"
              "Where civil blood makes civil hands unclean.\n"
              "From forth the fatal loins of these two foes",
          textAlign: .center,
        ),
      ),
    );
  }
}