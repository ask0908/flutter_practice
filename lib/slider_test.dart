import 'package:flutter/material.dart';

class SliderTest extends StatefulWidget {
  const SliderTest({super.key});

  @override
  State<SliderTest> createState() => _SliderTestState();
}

class _SliderTestState extends State<SliderTest> {
  double currentVolume = 0;
  double customSlider1 = 50;
  double customSlider2 = 30;
  double customSlider3 = 5;
  double customSlider4 = 70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slider 커스텀 예시")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. 기본 Slider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: currentVolume,
              max: 10,
              divisions: 10,
              label: currentVolume.toString(),
              onChanged: (double value) {
                setState(() {
                  currentVolume = value;
                });
              },
            ),
            const SizedBox(height: 30),

            const Text('2. 색상 커스텀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: customSlider1,
              max: 100,
              divisions: 20,
              label: customSlider1.round().toString(),
              activeColor: Colors.purple,
              inactiveColor: Colors.purple.withOpacity(0.3),
              thumbColor: Colors.deepPurple,
              onChanged: (double value) {
                setState(() {
                  customSlider1 = value;
                });
              },
            ),
            const SizedBox(height: 30),

            const Text('3. SliderTheme 커스텀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.orange,
                inactiveTrackColor: Colors.orange.withOpacity(0.3),
                trackHeight: 8.0,
                thumbColor: Colors.orangeAccent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
                overlayColor: Colors.orange.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.orange.withOpacity(0.5),
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.orangeAccent,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              child: Slider(
                value: customSlider2,
                max: 100,
                divisions: 10,
                label: '${customSlider2.round()}%',
                onChanged: (double value) {
                  setState(() {
                    customSlider2 = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            const Text('4. 커스텀 Thumb 모양', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.teal,
                inactiveTrackColor: Colors.teal.withOpacity(0.3),
                trackHeight: 6.0,
                thumbShape: const DiamondSliderThumbShape(),
                overlayColor: Colors.teal.withOpacity(0.2),
              ),
              child: Slider(
                value: customSlider3,
                max: 10,
                onChanged: (double value) {
                  setState(() {
                    customSlider3 = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            const Text('5. 그라데이션 트랙', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 10.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                trackShape: const GradientRectSliderTrackShape(),
              ),
              child: Slider(
                value: customSlider4,
                max: 100,
                onChanged: (double value) {
                  setState(() {
                    customSlider4 = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiamondSliderThumbShape extends SliderComponentShape {
  const DiamondSliderThumbShape({this.thumbRadius = 12.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - thumbRadius);
    path.lineTo(center.dx + thumbRadius, center.dy);
    path.lineTo(center.dx, center.dy + thumbRadius);
    path.lineTo(center.dx - thumbRadius, center.dy);
    path.close();

    canvas.drawPath(path, paint);
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const GradientRectSliderTrackShape();

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        bool isDiscrete = false,
        bool isEnabled = false,
        Offset? secondaryOffset,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final gradient = const LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ],
    );

    final paint = Paint()..shader = gradient.createShader(trackRect);

    final activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, const Radius.circular(5)),
      paint,
    );

    final inactivePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final inactiveRect = Rect.fromLTRB(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(inactiveRect, const Radius.circular(5)),
      inactivePaint,
    );
  }
}