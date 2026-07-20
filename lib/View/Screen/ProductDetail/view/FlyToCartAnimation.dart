import 'dart:math' as math;

import 'package:flutter/material.dart';

class FlyToCartAnimator {
  static Future<void> fly({
    required BuildContext context,
    required GlobalKey startKey,
    required GlobalKey cartKey,
    required String imageUrl,
    VoidCallback? onComplete,
    bool curvedPath = false,
    bool withRotation = false,
    Duration duration = const Duration(milliseconds: 800),
  }) async {
    final overlay = Overlay.of(context);
    final renderBox =
    startKey.currentContext?.findRenderObject() as RenderBox?;
    final cartBox =
    cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || cartBox == null) return;

    final startPos = renderBox.localToGlobal(Offset.zero);
    final startSize = renderBox.size;
    final cartPos = cartBox.localToGlobal(Offset.zero);
    final cartSize = cartBox.size;

    final endX = cartPos.dx + cartSize.width / 2 - startSize.width / 2;
    final endY = cartPos.dy + cartSize.height / 2 - startSize.height / 2;
    final endPos = Offset(endX, endY);

    final controlPoint = curvedPath
        ? Offset(
      (startPos.dx + endPos.dx) / 2,
      math.min(startPos.dy, endPos.dy) - 140,
    )
        : null;

    late OverlayEntry entry;
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: duration,
    );

    final progressAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    final scaleAnim = Tween<double>(begin: 1.0, end: 0.12).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    final opacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    final rotationAnim = Tween<double>(begin: 0.0, end: 0.35).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    entry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final t = progressAnim.value;
          final position = curvedPath && controlPoint != null
              ? _quadraticBezier(startPos, controlPoint, endPos, t)
              : Offset.lerp(startPos, endPos, t)!;

          Widget image = Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrl,
              width: startSize.width,
              height: startSize.height,
              fit: BoxFit.cover,
            ),
          );

          if (withRotation) {
            image = Transform.rotate(
              angle: rotationAnim.value,
              child: image,
            );
          }

          return Positioned(
            left: position.dx,
            top: position.dy,
            child: Opacity(
              opacity: opacityAnim.value,
              child: Transform.scale(
                scale: scaleAnim.value,
                child: image,
              ),
            ),
          );
        },
      ),
    );

    overlay.insert(entry);
    await controller.forward();
    entry.remove();
    controller.dispose();
    onComplete?.call();
  }

  static Offset _quadraticBezier(
      Offset start,
      Offset control,
      Offset end,
      double t,
      ) {
    final u = 1 - t;
    return Offset(
      u * u * start.dx + 2 * u * t * control.dx + t * t * end.dx,
      u * u * start.dy + 2 * u * t * control.dy + t * t * end.dy,
    );
  }
}
