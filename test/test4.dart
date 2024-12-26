import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: ExpandableCircularMenu(),
  ));
}

class ExpandableCircularMenu extends StatefulWidget {
  const ExpandableCircularMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableCircularMenuState createState() => _ExpandableCircularMenuState();
}

class _ExpandableCircularMenuState extends State<ExpandableCircularMenu>
    with SingleTickerProviderStateMixin {
  final int segmentCount = 6; // 分为6个扇形
  int? highlightedSegment; // 当前高亮的扇形
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isMenuVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // 动画持续时间
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleMenu() {
    if (isMenuVisible) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  void onSegmentHover(int? index) {
    setState(() {
      highlightedSegment = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expandable Circular Menu')),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 菜单区域
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _scaleAnimation.value,
                    child: MouseRegion(
                      onHover: (details) {
                        _handleHover(details.localPosition);
                      },
                      onExit: (_) {
                        onSegmentHover(null);
                      },
                      child: CustomPaint(
                        size: Size(300, 300), // 圆形菜单的大小
                        painter: HighlightCircularMenuPainter(
                          segmentCount,
                          highlightedSegment,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // 中心按钮
            GestureDetector(
              onTap: toggleMenu,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Icon(
                    isMenuVisible ? Icons.close : Icons.menu,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleHover(Offset localPosition) {
    final center = Offset(150, 150); // 圆心
    final offset = localPosition - center;
    final angle = atan2(offset.dy, offset.dx); // 计算点击点的角度
    final adjustedAngle = (angle >= 0 ? angle : (2 * pi + angle));
    final segmentSize = (2 * pi) / segmentCount; // 每个扇形的角度
    final hoveredSegment = (adjustedAngle ~/ segmentSize);

    onSegmentHover(hoveredSegment); // 设置高亮的扇形
  }
}

class HighlightCircularMenuPainter extends CustomPainter {
  final int segmentCount;
  final int? highlightedSegment;
  HighlightCircularMenuPainter(this.segmentCount, this.highlightedSegment);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final double baseRadius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < segmentCount; i++) {
      final isHighlighted = i == highlightedSegment;
      final startAngle = (2 * pi / segmentCount) * i;
      final sweepAngle = (2 * pi / segmentCount);

      // 高亮时增加半径并改变颜色
      final double radius = isHighlighted ? baseRadius * 1.1 : baseRadius;
      paint.color = isHighlighted
          ? Colors.primaries[i % Colors.primaries.length].withValues(alpha: 0.8)
          : Colors.primaries[i % Colors.primaries.length]
              .withValues(alpha: 0.6);

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
