import 'package:flutter/material.dart';

class AppLogo3D extends StatelessWidget {
  final double size;
  final IconData icon;

  const AppLogo3D({
    super.key,
    this.size = 56,
    this.icon = Icons.note_alt_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFEAF2FF),
            Color(0xFFD7E7FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.75),
            blurRadius: 12,
            offset: const Offset(-6, -6),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
      ),
      child: Center(
        child: Container(
          width: size * 0.68,
          height: size * 0.68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.40),
        ),
      ),
    );
  }
}
