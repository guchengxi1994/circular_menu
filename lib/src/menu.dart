import 'dart:math';

import 'package:flutter/material.dart';

import 'controller.dart';

class CircularMenu extends StatefulWidget {
  const CircularMenu(
      {super.key, this.face, this.size = 300, required this.controller});
  // center widget when menu is closed
  final Widget? face;
  // size of the menu
  final double? size;
  final BoardController controller;

  @override
  State<CircularMenu> createState() => _CircularMenuState();
}

class _CircularMenuState extends State<CircularMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final int segmentCount = widget.controller.items.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // 动画持续时间
    );
    widget.controller.setAnimationController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ValueListenableBuilder(
          valueListenable: widget.controller.state,
          builder: (c, s, ch) {
            Widget face = widget.face ??
                Container(
                  width: 40,
                  height: 40,
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
                      s.isMenuVisible ? Icons.close : Icons.menu,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: widget.controller.scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: widget.controller.scaleAnimation.value,
                      child: Opacity(
                        opacity: widget.controller.scaleAnimation.value,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onHover: (details) {
                            // _handleHover(details.localPosition);
                            widget.controller
                                .handleHover(details.localPosition);
                          },
                          onExit: (_) {
                            widget.controller.changeHovering(-1);
                          },
                          child: GestureDetector(
                            onTap: () {
                              widget.controller.tapCurrent((index) {
                                // ignore: avoid_print
                                print("Tapped on item $index");
                              });
                            },
                            child: CustomPaint(
                              size: Size(300, 300), // 圆形菜单的大小
                              painter: HighlightCircularMenuPainter(
                                segmentCount,
                                widget.controller.state.value.hovering ?? -1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: widget.controller.toggleMenu,
                  child: Center(
                    child: face,
                  ),
                )
              ],
            );
          }),
    );
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
