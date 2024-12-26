import 'dart:math';

import 'package:flutter/widgets.dart';

typedef OnItemSelected = void Function(int index);

abstract class Item {
  final int index;
  final OnItemSelected onItemSelected;
  const Item({required this.index, required this.onItemSelected});

  Widget build(BuildContext context);
}

class BoardState {
  final int? hovering;
  final List<Item> items;
  final bool isMenuVisible;

  BoardState({this.hovering, required this.items, this.isMenuVisible = false});

  BoardState copyWith({int? hovering, List<Item>? items, bool? isMenuVisible}) {
    return BoardState(
      hovering: hovering ?? this.hovering,
      items: items ?? this.items,
      isMenuVisible: isMenuVisible ?? this.isMenuVisible,
    );
  }
}

class BoardController<I extends Item> {
  late final ValueNotifier<BoardState> _state;
  final List<I> items;
  late AnimationController? _controller;
  late Animation<double>? _scaleAnimation;

  ValueNotifier<BoardState> get state => _state;

  setAnimationController(AnimationController? controller) {
    _controller = controller;
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );
  }

  Animation<double> get scaleAnimation => _scaleAnimation!;

  void dispose() {
    _state.dispose();
    _controller?.dispose();
  }

  void toggleMenu() {
    if (_state.value.isMenuVisible) {
      _controller?.reverse();
    } else {
      _controller?.forward();
    }
    _state.value = _state.value.copyWith(
      isMenuVisible: !_state.value.isMenuVisible,
    );
  }

  BoardController({
    required this.items,
  }) {
    assert(items.isNotEmpty);
    _state = ValueNotifier(BoardState(hovering: -1, items: items));
  }

  changeHovering(int index) {
    if (index == _state.value.hovering) return;
    _state.value = _state.value.copyWith(hovering: index);
  }

  void handleHover(Offset localPosition) {
    final center = Offset(150, 150); // 圆心
    final offset = localPosition - center;
    final angle = atan2(offset.dy, offset.dx); // 计算点击点的角度
    final adjustedAngle = (angle >= 0 ? angle : (2 * pi + angle));
    final segmentSize = (2 * pi) / items.length; // 每个扇形的角度
    final hoveredSegment = (adjustedAngle ~/ segmentSize);

    changeHovering(hoveredSegment); // 设置高亮的扇形
  }

  tapCurrent(OnItemSelected onItemSelected) {
    if (_state.value.hovering != -1) {
      onItemSelected(_state.value.hovering!);
    }
  }
}
