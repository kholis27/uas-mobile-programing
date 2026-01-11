import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1D4ED8),
                Color(0xFF3B82F6),
                Color(0xFFEFF6FF),
              ],
            ),
          ),
        ),
        Positioned(
          top: -140,
          left: -90,
          child: _Blob(size: 320, color: Colors.white.withOpacity(0.18)),
        ),
        Positioned(
          top: 120,
          right: -110,
          child: _Blob(size: 260, color: Colors.white.withOpacity(0.12)),
        ),
        Positioned(
          bottom: -160,
          left: -120,
          child: _Blob(size: 360, color: Colors.white.withOpacity(0.16)),
        ),
        IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: _DotPainter(),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    const spacing = 26.0;
    const radius = 1.4;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
