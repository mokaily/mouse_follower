import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mouse_follower/mouse_follower.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mouse Follower Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MouseFollower(
          isVisible: kIsWeb,
          onHoverMouseStylesStack: [
            MouseStyle(
              size: const Size(7, 7),
              latency: const Duration(milliseconds: 25),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            ),
            MouseStyle(
              size: const Size(26, 26),
              latency: const Duration(milliseconds: 75),
              visibleOnHover: false,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor)),
            ),
          ],
          child: const MouseFollowerDemoPage()),
    );
  }
}

class MouseFollowerDemoPage extends StatelessWidget {
  const MouseFollowerDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ContainerWithMouseStyle(title: "Default Style:", color: Colors.grey.shade50),
          const Divider(height: 1),
          MouseOnHoverEvent(
              child: ContainerWithMouseStyle(title: "OnHover Main Style:", color: Colors.red.shade50)),
          const Divider(height: 1),
          MouseOnHoverEvent(
              onHoverMouseCursor: SystemMouseCursors.none,
              customOnHoverMouseStylesStack: [
                const MouseStyle(
                  alignment: Alignment.topCenter,
                  size: Size(15, 15),
                  latency: Duration(milliseconds: 75),
                  opacity: 0.5,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),
                MouseStyle(
                  size: const Size(15, 15),
                  latency: const Duration(milliseconds: 0),
                  child: kIsWeb ? Image.network("images/cursor.png") : Image.asset("images/cursor.png"),
                ),
              ],
              child: ContainerWithMouseStyle(title: "Custom Cursor:", color: Colors.purple.shade50)),
          const Divider(height: 1),
          MouseOnHoverEvent(customOnHoverMouseStylesStack: [
            MouseStyle(
              animationDuration: const Duration(milliseconds: 0),
              opacity: 0.4,
              size: const Size(200, 120),
              alignment: Alignment.centerRight,
              child: Container(
                height: 100,
                width: 250,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: kIsWeb
                    ? Image.network("images/mouse_follower.jpg", fit: BoxFit.fill)
                    : Image.asset("images/mouse_follower.jpg", fit: BoxFit.fill),
              ),
            ),
          ], child: ContainerWithMouseStyle(title: "With Background:", color: Colors.green.shade50)),
          const Divider(height: 1),
          MouseOnHoverEvent(
              onHoverMouseCursor: SystemMouseCursors.none,
              customOnHoverMouseStylesStack: [
                const MouseStyle(
                  size: Size(50, 50),
                  latency: Duration(milliseconds: 0),
                  child: RawMagnifier(
                    size: Size(80, 80),
                    magnificationScale: 1.5,
                    decoration: MagnifierDecoration(shape: CircleBorder()),
                  ),
                ),
                MouseStyle(
                  size: const Size(15, 15),
                  latency: const Duration(milliseconds: 0),
                  child: kIsWeb ? Image.network("images/magnifier.png") : Image.asset("images/magnifier.png"),
                ),
              ],
              child: ContainerWithMouseStyle(title: "Magnifier Function:", color: Colors.blue.shade50)),
          const Divider(height: 1),
          MouseOnHoverEvent(
              onHoverMouseCursor: SystemMouseCursors.none,
              customOnHoverMouseStylesStack: [
                MouseStyle(
                  alignment: Alignment.bottomRight,
                  size: const Size(15, 15),
                  latency: const Duration(milliseconds: 0),
                  // decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: CustomPaint(
                    size: const Size(15, 15),
                    painter: CurvedLinePainter(),
                  ),
                ),
                const MouseStyle(
                  alignment: Alignment.topLeft,
                  size: Size(15, 15),
                  latency: Duration(milliseconds: 0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),
                const MouseStyle(
                  alignment: Alignment.topRight,
                  size: Size(15, 15),
                  latency: Duration(milliseconds: 0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),
                const MouseStyle(
                  size: Size(20, 20),
                  latency: Duration(milliseconds: 0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                ),
                const MouseStyle(
                  size: Size(5, 5),
                  latency: Duration(milliseconds: 0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),

              ],
              child: ContainerWithMouseStyle(title: "Custom Draw:", color: Colors.brown.shade50)),
        ],
      ),
    );
  }
}

class ContainerWithMouseStyle extends StatelessWidget {
  final String title;
  final Color color;
  const ContainerWithMouseStyle({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: 150,
      color: color,
      child: Text(title, style: const TextStyle(fontSize: 20)),
    );
  }
}

class CurvedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path()
      ..moveTo(0, 0) // Starting point
      ..quadraticBezierTo(40, -10, 30, 10); // Define a quadratic Bezier curve

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}