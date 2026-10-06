import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// Flutter 앱의 진입점
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  // 앱이 세로 모드로만 실행되도록 설정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(const MainApp());
}

// 앱의 메인 위젯
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AspectRatio(
            aspectRatio: cfg.designW / cfg.designH,
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}

