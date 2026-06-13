import 'dart:math' as math;

import 'package:flutter/material.dart';

// ========== shakes its child whenever shakeToken changes ==========
class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.shakeToken,
    required this.child,
  });

  final int shakeToken;
  final Widget child;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  // ========== token changed, so play the shake once ==========
  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shakeToken != oldWidget.shakeToken) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      // ========== child built once and reused every frame ==========
      child: widget.child,
      builder: (context, child) {
        // ========== sine wave that wobbles then settles back ==========
        final t = _controller.value;
        final offset = math.sin(t * math.pi * 6) * 12 * (1 - t);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
    );
  }
}
