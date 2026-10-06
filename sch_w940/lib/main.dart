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

// 설정
class cfg {
  static const bool showGuide = true; // 향후에 제거 예정
  static const double designW = 400; // 가로 길이
  static const double designH = 680; // 세로 길이
  static const double topBarH = 50; // 상단바 높이
  static const double bottomBarH = 90; // 하단바 높이
  static const String clock = 'clock'; // system 정보 받아와서 표기
  static const String? wallaperAssert = null; // 'assets/images/wallpaper.jpg'; pubspec에 등록
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final s = c.maxWidth / cfg.designW; // 스케일 팩터
      return ClipRect(
        child: Stack(
          children: [
            // 배경화면
            Positioned.fill(child: _Wallpaper()),
            // 우측 바로가기 아이콘
            Positioned(
              right: 8 * s,
              top: 285 * s,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _NateTodayIcon(s: s),
                  SizedBox(height: 14 * s),
                  _WebSurfingIcon(s: s),
                  SizedBox(height: 14 * s),
                  _MailIcon(s: s),
                ],
              ),
            ),
            // 좌측 슬라이드 탭
            Positioned(
              left: 0,
              top: 405 * s,
              child: _SideTab(s: s),
            ),
            // 상단 상태바
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: cfg.topBarH * s,
              child: _TopBar(s: s),
            ),
            // 하단 메뉴바
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: cfg.bottomBarH * s,
              child: _BottomBar(s: s),
            ),
          ],
        ),
      );
    });
  }
}

// 배경화면 위젯
class _Wallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (cfg.wallaperAssert != null) {
      return Image.asset(cfg.wallaperAssert!, fit: BoxFit.cover);
    } else {
      return CustomPaint(painter: _SkyPainter());
    }
  }
}

class _SkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rect = Offset.zero & size;

    // 하늘 그라디언트
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B3E8C),
            Color(0xFF1F5FB0),
            Color(0xFF5E93CF),
            Color(0xFF9CBDE3),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ).createShader(rect),
    );
 
    // 얇은 띠구름
    final streak = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    for (final y in [0.28, 0.31, 0.34, 0.38]) {
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(w * 0.5, h * y), width: w * 1.1, height: h * 0.012),
          streak);
    }
 
    // 뭉게구름
    final puff = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final blobs = <List<double>>[
      // [cx, cy, r] (비율)
      [0.20, 0.62, 0.11],
      [0.34, 0.58, 0.13],
      [0.50, 0.63, 0.12],
      [0.63, 0.70, 0.12],
      [0.12, 0.72, 0.13],
      [0.30, 0.74, 0.15],
      [0.48, 0.78, 0.14],
      [0.72, 0.80, 0.13],
      [0.20, 0.86, 0.16],
      [0.55, 0.88, 0.16],
      [0.90, 0.88, 0.14],
    ];
    for (final b in blobs) {
      canvas.drawCircle(Offset(w * b[0], h * b[1]), w * b[2], puff);
    }
    // 구름 그림자
    final shade = Paint()
      ..color = const Color(0xFF8FA6C4).withOpacity(0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawCircle(Offset(w * 0.38, h * 0.82), w * 0.10, shade);
    canvas.drawCircle(Offset(w * 0.68, h * 0.86), w * 0.09, shade);
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NateTodayIcon extends StatelessWidget {
  const _NateTodayIcon({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) => _HomeIcon(s: s, icon: Icons.today, label: 'Today');
}

class _WebSurfingIcon extends StatelessWidget {
  const _WebSurfingIcon({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) => _HomeIcon(s: s, icon: Icons.language, label: 'Web');
}

class _MailIcon extends StatelessWidget {
  const _MailIcon({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) => _HomeIcon(s: s, icon: Icons.mail, label: 'Mail');
}

class _HomeIcon extends StatelessWidget {
  const _HomeIcon({required this.s, required this.icon, required this.label});
  final double s;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, size: 32 * s, color: Colors.white),
          Text(label, style: TextStyle(fontSize: 12 * s, color: Colors.white)),
        ],
      );
}

class _SlideMenu extends StatelessWidget {
  const _SlideMenu({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) => Container(
        width: 12 * s,
        color: Colors.black.withOpacity(0.15),
      );
}

// 상단 상태바
class _TopBar extends StatelessWidget {
  const _TopBar({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return Container (
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF16213A), Color(0xFF0A1226)],
        ),
        border: Cfg.showGuide
            ? Border.all(color: Colors.red, width: 2)
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10 * s),
      child: Row(
        children: [
          _SignalIcon(s: s),
          SizedBox(width: 34 * s),
          Icon(Icons.music_note, color: const Color(0xFFBFD3F2), size: 30 * s),
          const Spacer(),
          _BatteryIcon(s: s),
          SizedBox(width: 12 * s),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 2 * s),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(3 * s),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Text(
              Cfg.clock,
              style: TextStyle(
                color: const Color(0xFFFFE600),
                fontSize: 26 * s,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}