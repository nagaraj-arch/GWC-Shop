import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class NewBadge extends StatefulWidget {
  const NewBadge({super.key});

  @override
  State<NewBadge> createState() => _NewBadgeState();
}

class _NewBadgeState extends State<NewBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
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
      builder: (_, child) {
        final t = Curves.easeInOut.transform(_controller.value);

        return Transform.scale(
          scale: 0.98 + (t * 0.04), // subtle breathing
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF8D25B),
                  Color(0xFFE2AE22),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF4C542).withOpacity(0.18),
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Opacity(
              opacity: 0.75 + (t * 0.25),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final t = Curves.easeInOut.transform(_controller.value);

                      return Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: gWhiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(.8),
                              blurRadius: 4 + (t * 8),
                              spreadRadius: t * 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "NEW",
                    style: TextStyle(
                      color: gWhiteColor,
                      fontFamily: fontBold,
                      fontSize: fontSize09,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
