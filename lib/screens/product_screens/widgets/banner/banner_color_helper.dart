import 'package:flutter/material.dart';

class DominantGradient {
  final LinearGradient gradient;
  final Color primary;

  const DominantGradient({
    required this.gradient,
    required this.primary,
  });
}

class DominantColorHelper {
  DominantColorHelper._();

  static final List<DominantGradient> _gradients = [

    /// Sky Blue
    DominantGradient(
      primary: const Color(0xff38BDF8),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff38BDF8),
          Color(0xff0EA5E9),
        ],
      ),
    ),

    /// Emerald Green
    DominantGradient(
      primary: const Color(0xff34D399),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff34D399),
          Color(0xff10B981),
        ],
      ),
    ),

    /// Golden Orange
    DominantGradient(
      primary: const Color(0xffFBBF24),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffFBBF24),
          Color(0xffF59E0B),
        ],
      ),
    ),

    /// Royal Purple
    DominantGradient(
      primary: const Color(0xff8B5CF6),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff8B5CF6),
          Color(0xff7C3AED),
        ],
      ),
    ),
  ];

  static Future<DominantGradient> getGradient(String imageUrl) async {
    return _gradients[
    imageUrl.hashCode.abs() % _gradients.length];
  }
}