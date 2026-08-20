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
  final double? buttonHeight;
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
    required this.isLoading,
    this.color,
    this.textColor,
    this.loadingColor,
    this.radius,
    this.padding,
    this.buttonHeight,
    this.font,
    this.borderClr = Colors.transparent,
    this.icon,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final buttonColor = color ?? gPrimaryColor;

    final buttonTextColor = textColor ?? gWhiteColor;

    final borderRadius = radius ?? 30.0;

    final buttonFont = font ?? fontMedium;

    return SizedBox(
      height: buttonHeight ?? (responsive.isDesktop ? 5.h : 4.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor,
          padding: padding ??
              EdgeInsets.symmetric(
                  horizontal: responsive.isDesktop ? 1.5.w : 2.w,
                  vertical: 1.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: borderClr)),
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
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: Icon(
                        icon,
                        size: iconSize ?? 18,
                      ),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: buttonFont,
                      fontSize: fontSize12,
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
                          padding: const EdgeInsets.only(
                            right: 8,
                          ),
                          child: Icon(
                            icon,
                            color: iconColor ?? buttonTextColor,
                            size: iconSize ?? 2.5.h,
                          ),
                        ),
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: buttonFont,
                          color: buttonTextColor,
                          fontSize:
                              responsive.isMobile ? fontSize10 : fontSize11,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
