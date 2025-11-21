import 'package:flutter/material.dart';

enum Calendar {
  day,
  week,
  month,
  year,
}

class SegmentedButtonTest extends StatefulWidget {
  const SegmentedButtonTest({super.key});

  @override
  State<SegmentedButtonTest> createState() => _SegmentedButtonTestState();
}

class _SegmentedButtonTestState extends State<SegmentedButtonTest> {
  Calendar calendarView = Calendar.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RichText 예시")),
      body: Center(
        child: SegmentedButton<Calendar>(
          segments: [
            ButtonSegment(
              value: Calendar.day,
              label: Text("day"),
              icon: Icon(Icons.calendar_view_day)
            ),
            ButtonSegment(
                value: Calendar.week,
                label: Text("week"),
                icon: Icon(Icons.calendar_view_week)
            ),
            ButtonSegment(
                value: Calendar.month,
                label: Text("month"),
                icon: Icon(Icons.calendar_view_month)
            ),
            ButtonSegment(
                value: Calendar.year,
                label: Text("year"),
                icon: Icon(Icons.calendar_today)
            ),
          ],
          selected: <Calendar>{calendarView},
          onSelectionChanged: (Set<Calendar> newSelection) {
            setState(() {
              // 한 번에 선택 가능한 세그먼트는 하나 뿐이라 해당 값은 항상 첫 번째다
              calendarView = newSelection.first;
            });
          },
        ),
      ),
    );
  }
}