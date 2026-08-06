import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';

class CommonSectionHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;
  final double? iconSize;
  final double? titleSize;
  final double? subtitleSize;
  final FontWeight titleWeight;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final bool horizontalLayout;

  const CommonSectionHeader({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = gPrimaryColor,
    this.titleColor = gPrimaryColor,
    this.subtitleColor = Colors.grey,
    this.iconSize,
    this.titleSize,
    this.subtitleSize,
    this.titleWeight = FontWeight.w700,
    this.padding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.horizontalLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    if (horizontalLayout) {
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cormorantGaramond(
                fontSize: titleSize ?? fontSize18,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: .5,
                color: titleColor,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(width: 16),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: subtitleSize ?? fontSize09,
                fontFamily: fontBook,
                color: subtitleColor,
              ),
            ),
          ]
        ],
      );
    }
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? 2.2.h,
              color: iconColor,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: titleSize ?? fontSize18,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: .5,
                    color: titleColor,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: .3.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: subtitleSize ?? fontSize09,
                      fontFamily: fontBook,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
