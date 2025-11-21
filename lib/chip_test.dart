import 'package:flutter/material.dart';

class ChipTest extends StatefulWidget {
  const ChipTest({super.key});

  @override
  State<ChipTest> createState() => _ChipTestState();
}

enum FilterExample {
  walking,
  running,
  cycling,
  hiking,
}

class _ChipTestState extends State<ChipTest> {

  Set<FilterExample> filters = <FilterExample>{};
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SelectableText 테스트")),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              InputChip(
                avatar: CircleAvatar(
                  backgroundImage: AssetImage("assets/image/map_point.png"),
                ),
                label: Text("First"),
                onPressed: () {
                  debugPrint("First");
                },
              ),
              ChoiceChip(
                selected: false,
                avatar: CircleAvatar(
                  backgroundImage: AssetImage("assets/image/plus.png"),
                ),
                label: Text("Second"),
              ),
              FilterChip(
                label: Text("Third"),
                selected: true,
                onSelected: (bool isClicked) {
                  debugPrint("Third : $isClicked");
                },
              ),
              ActionChip(
                avatar: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text("Fourth"),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  debugPrint("Fourth");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}