import 'package:flutter/material.dart';

class ToggleWidgetTest extends StatelessWidget {
  const ToggleWidgetTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SelectableText 테스트")),
      body: Center(
        child: Column(
          children: [
            CheckboxTest(),
            SwitchTest(),
            RadioTest(),
          ],
        ),
      ),
    );
  }
}

class CheckboxTest extends StatefulWidget {
  const CheckboxTest({super.key});

  @override
  State<CheckboxTest> createState() => _CheckboxTestState();
}

class _CheckboxTestState extends State<CheckboxTest> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class SwitchTest extends StatefulWidget {
  const SwitchTest({super.key});

  @override
  State<SwitchTest> createState() => _SwitchTestState();
}

class _SwitchTestState extends State<SwitchTest> {

  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeThumbColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
      },
    );
  }
}

enum Character {
  musician,
  chef,
  firefighter,
  artist,
}

class RadioTest extends StatefulWidget {
  const RadioTest({super.key});

  @override
  State<RadioTest> createState() => _RadioTestState();
}

class _RadioTestState extends State<RadioTest> {

  Character? _character = Character.musician;

  void setCharacter(Character? value) {
    setState(() {
      _character = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup(
      groupValue: _character,
      onChanged: setCharacter,
      child: Column(
        children: [
          ListTile(
            title: const Text('Musician'),
            leading: Radio<Character>(value: Character.musician),
          ),
          ListTile(
            title: const Text('Chef'),
            leading: Radio<Character>(value: Character.chef),
          ),
          ListTile(
            title: const Text('Firefighter'),
            leading: Radio<Character>(value: Character.firefighter),
          ),
          ListTile(
            title: const Text('Artist'),
            leading: Radio<Character>(value: Character.artist),
          ),
        ],
      ),
    );
  }
}