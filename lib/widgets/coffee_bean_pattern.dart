import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Menggambar sebaran biji kopi (oval + garis tengah melengkung) sebagai
/// motif dekoratif. Posisi dibuat dari seed tetap sehingga hasilnya stabil
/// (tidak berubah-ubah setiap rebuild).
class CoffeeBeanPainter extends CustomPainter {
  final Color beanColor;
  final Color creaseColor;
  final int count;
  final int seed;
  final double minSize;
  final double maxSize;

  const CoffeeBeanPainter({
    this.beanColor = Colors.white,
    this.creaseColor = AppColors.armyGreen,
    this.count = 14,
    this.seed = 7,
    this.minSize = 14,
    this.maxSize = 34,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rnd = math.Random(seed);
    for (var i = 0; i < count; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final s = minSize + rnd.nextDouble() * (maxSize - minSize);
      final angle = rnd.nextDouble() * math.pi;
      _drawBean(canvas, Offset(dx, dy), s, angle);
    }
  }

  void _drawBean(Canvas canvas, Offset center, double s, double angle) {
    final w = s;
    final h = s * 1.35;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    // Badan biji
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      Paint()..color = beanColor,
    );

    // Garis tengah berbentuk huruf S
    final crease = Path()
      ..moveTo(0, -h / 2 + 2)
      ..quadraticBezierTo(w * 0.40, -h * 0.15, 0, 0)
      ..quadraticBezierTo(-w * 0.40, h * 0.15, 0, h / 2 - 2);
    canvas.drawPath(
      crease,
      Paint()
        ..color = creaseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, s * 0.08)
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CoffeeBeanPainter old) =>
      old.beanColor != beanColor ||
      old.creaseColor != creaseColor ||
      old.count != count ||
      old.seed != seed;
}

/// Membungkus [child] dengan latar motif biji kopi.
/// Cocok untuk header, banner, dan placeholder gambar menu.
class CoffeeBeanPattern extends StatelessWidget {
  final Widget? child;
  final Color beanColor;
  final Color creaseColor;
  final int count;
  final int seed;
  final double minSize;
  final double maxSize;

  const CoffeeBeanPattern({
    super.key,
    this.child,
    this.beanColor = Colors.white,
    this.creaseColor = AppColors.armyGreen,
    this.count = 14,
    this.seed = 7,
    this.minSize = 14,
    this.maxSize = 34,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CoffeeBeanPainter(
        beanColor: beanColor,
        creaseColor: creaseColor,
        count: count,
        seed: seed,
        minSize: minSize,
        maxSize: maxSize,
      ),
      child: child,
    );
  }
}

/// Ikon kecil satu biji kopi (untuk logo, empty state, dsb).
class CoffeeBeanIcon extends StatelessWidget {
  final double size;
  final Color color;
  final Color creaseColor;

  const CoffeeBeanIcon({
    super.key,
    this.size = 24,
    this.color = AppColors.gold,
    this.creaseColor = AppColors.armyGreen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.3,
      height: size * 1.3,
      child: CustomPaint(
        painter: _SingleBeanPainter(color, creaseColor, size),
      ),
    );
  }
}

class _SingleBeanPainter extends CustomPainter {
  final Color color;
  final Color creaseColor;
  final double s;

  _SingleBeanPainter(this.color, this.creaseColor, this.s);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final w = s * 0.8;
    final h = s * 1.1;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.pi / 6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      Paint()..color = color,
    );
    final crease = Path()
      ..moveTo(0, -h / 2 + 2)
      ..quadraticBezierTo(w * 0.40, -h * 0.15, 0, 0)
      ..quadraticBezierTo(-w * 0.40, h * 0.15, 0, h / 2 - 2);
    canvas.drawPath(
      crease,
      Paint()
        ..color = creaseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.4, s * 0.08)
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SingleBeanPainter old) =>
      old.color != color || old.creaseColor != creaseColor || old.s != s;
}
