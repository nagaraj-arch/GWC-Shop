import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../loading_widgets/loading_indicator.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final Color? loadingColor;
  final double? radius;
  final EdgeInsets? padding;
  final String? font;
  final Color borderClr;

  /// OPTIONAL ICON
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.loadingColor,
    this.radius,
    this.padding,
    this.font,
    this.borderClr = Colors.transparent,
    this.icon,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    final buttonColor = color ?? gPrimaryColor;

    final buttonTextColor = textColor ?? gWhiteColor;

    final borderRadius = radius ?? 8.0;

    final String buttonFontFamily = font ?? fontMedium;

    final double buttonFontSize = responsive.isMobile ? fontSize11 : fontSize12;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: buttonColor,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: borderClr),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// WIDTH RESERVE
          Opacity(
            opacity: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(icon, size: iconSize ?? 18),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: buttonFontFamily,
                    color: buttonTextColor,
                    fontSize: buttonFontSize,
                  ),
                ),
              ],
            ),
          ),

          isLoading
              ? SizedBox(
                  height: 18,
                  width: 40,
                  child: LoadingIndicator(
                    color: loadingColor ?? gWhiteColor,
                    size: 15,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          icon,
                          color: iconColor ?? buttonTextColor,
                          size: iconSize ?? 2.5.h,
                        ),
                      ),
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: buttonFontFamily,
                        color: buttonTextColor,
                        fontSize: buttonFontSize,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
