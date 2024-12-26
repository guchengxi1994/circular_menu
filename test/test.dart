import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: CircularMenu(),
  ));
}

// ignore: use_key_in_widget_constructors
class CircularMenu extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CircularMenuState createState() => _CircularMenuState();
}

class _CircularMenuState extends State<CircularMenu> {
  final int segmentCount = 6; // 分为6个扇形

  void onSegmentTap(int index) {
    // ignore: avoid_print
    print("Tapped on segment $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Circular Menu with Sectors')),
      body: Center(
        child: GestureDetector(
          onTapUp: (details) {
            _handleTap(details.localPosition);
          },
          child: CustomPaint(
            size: Size(300, 300), // 圆形菜单的大小
            painter: CircularMenuPainter(segmentCount),
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset localPosition) {
    final center = Offset(150, 150); // 圆心（根据CustomPaint的大小）
    final offset = localPosition - center;
    final angle = atan2(offset.dy, offset.dx); // 点击点的角度
    final adjustedAngle = (angle >= 0 ? angle : (2 * pi + angle));
    final segmentSize = (2 * pi) / segmentCount; // 每个扇形的角度
    final tappedSegment = (adjustedAngle ~/ segmentSize);

    onSegmentTap(tappedSegment); // 触发点击回调
  }
}

class CircularMenuPainter extends CustomPainter {
  final int segmentCount;
  CircularMenuPainter(this.segmentCount);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < segmentCount; i++) {
      final startAngle = (2 * pi / segmentCount) * i;
      final sweepAngle = (2 * pi / segmentCount);
      paint.color = Colors.primaries[i % Colors.primaries.length]; // 动态颜色
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
