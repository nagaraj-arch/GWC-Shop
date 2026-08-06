import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderClr;
  final Color shadowClr;
  final double borderWidth;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CommonCard({
    super.key,
    required this.child,
    this.backgroundColor = gWhiteColor,
    this.borderClr = borderColor,this.shadowClr = borderColor,
    this.borderWidth = 1,
    this.borderRadius = 16,
    this.elevation = 4,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final pad =
        padding ?? EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h);
    final mar =
        margin ?? EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.5.h);

    return Card(
      elevation: elevation,
      color: backgroundColor,
      margin: mar,
      shadowColor: shadowClr.withAlpha(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderClr, width: borderWidth),
      ),
      child: Padding(padding: pad, child: child),
    );
  }
}
