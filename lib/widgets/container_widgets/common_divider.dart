import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';
import '../../utils/opacity_to_alpha.dart';

class CommonDivider extends StatelessWidget {
  final double verticalMargin;
  final double horizontalMargin;
  final Color color;
  final double thickness;
  final double opacity; // 👈 NEW

  const CommonDivider({
    super.key,
    this.verticalMargin = 1,
    this.horizontalMargin = 0.0,
    this.color = kLineColor,
    this.thickness = 1.0,
    this.opacity = 0.8, // 👈 DEFAULT
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalMargin.h, horizontal: horizontalMargin.w),
      child: Divider(
        thickness: thickness,
        height: thickness,
        color: color.withAlpha(AlphaHelper.fromOpacity(opacity)),
      ),
    );
  }
}
