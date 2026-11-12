import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/opacity_to_alpha.dart';

class CommonEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subText;

  const CommonEmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.subText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gPrimaryColor
                        .withAlpha(AlphaHelper.fromOpacity(0.18)),
                    gMainColor.withAlpha(AlphaHelper.fromOpacity(0.08)),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: gPrimaryColor
                        .withAlpha(AlphaHelper.fromOpacity(0.12)),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(icon, size: 48, color: gPrimaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize16,
                fontFamily: fontMedium,
                color: gBlackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize11,
                fontFamily: fontBook,
                color: gHintTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
