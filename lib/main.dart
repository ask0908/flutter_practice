import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shake 예시",
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const ShakeDemo(),
    );
  }
}

class ShakeDemo extends StatefulWidget {
  const ShakeDemo({super.key});

  @override
  State<ShakeDemo> createState() => _ShakeDemoState();
}

class _ShakeDemoState extends State<ShakeDemo> {
  ShakeDetector? _shakeDetector;
  String _lastShakeInfo = "아직 안 흔듦";
  double _shakeThreshold = 2.7;
  bool _useFilter = false;
  int _minShakeCount = 1;

  @override
  void initState() {
    super.initState();
    _startDetector();
  }

  void _startDetector() {
    _shakeDetector?.stopListening();
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        setState(() {
          _lastShakeInfo =
              "흔들기 감지!!!\n"
              "방향 : ${event.direction}\n"
              "힘 : ${event.force.toStringAsFixed(2)}\n"
              "시간 : ${event.timestamp.toString()}";
        });
      },
      minimumShakeCount: _minShakeCount,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3_000,
      shakeThresholdGravity: _shakeThreshold,
      useFilter: _useFilter,
    );
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shake 테스트")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "마지막 흔들기 정보 :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_lastShakeInfo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Settings : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text("민감도"),
              subtitle: Slider(
                value: _shakeThreshold,
                min: 1.0,
                max: 5.0,
                divisions: 20,
                label: _shakeThreshold.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _shakeThreshold = value;
                  });
                },
              ),
              trailing: Text('${_shakeThreshold.toStringAsFixed(1)} g'),
            ),
            SwitchListTile(
              title: const Text("노이즈 필터 사용하기"),
              subtitle: const Text("가속도 데이터를 부드럽게 처리"),
              value: _useFilter,
              onChanged: (value) {
                setState(() {
                  _useFilter = value;
                });
              },
            ),
            ListTile(
              title: const Text("최소 흔들기 카운트"),
              subtitle: Slider(
                value: _minShakeCount.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _minShakeCount.toString(),
                onChanged: (value) {
                  setState(() {
                    _minShakeCount = value.toInt();
                  });
                },
              ),
              trailing: Text('$_minShakeCount'),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _startDetector,
                child: const Text("설정 적용하기"),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}