import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerDialogTest extends StatefulWidget {
  const DatePickerDialogTest({super.key});

  @override
  State<DatePickerDialogTest> createState() => _DatePickerDialogTestState();
}

class _DatePickerDialogTestState extends State<DatePickerDialogTest> {

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    var date = selectedDate;

    return Scaffold(
      appBar: AppBar(title: const Text("DatePickerDialog 테스트")),
      body: Center(
        child: Column(
          children: [
            Text(
              date == null
                  ? "날짜를 선택하세요"
                  : DateFormat("yyyy-MM-dd").format(date),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                var pickedDate = await showDatePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2050),
                );

                setState(() {
                  selectedDate = pickedDate;
                  debugPrint("선택한 날짜 : $selectedDate");
                });
              },
              label: const Text("날짜 선택"),
            )
          ],
        ),
      ),
    );
  }
}