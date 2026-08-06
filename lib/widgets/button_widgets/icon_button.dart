import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class IconButtonWidget extends StatefulWidget {
  final String msg;
  final IconData icon;
  final VoidCallback onTap;
  final String? image;

  final Color? iconColor;
  final Color? hoverIconColor;

  final Color? bgColor;
  final Color? hoverBgColor;

  final Color? borderClr;
  final Color? hoverBorderClr;

  final double? size;
  final EdgeInsets? padding;
  final double radius;

  const IconButtonWidget({
    super.key,
    required this.msg,
    required this.icon,
    required this.onTap,
    this.image,
    this.iconColor,
    this.hoverIconColor,
    this.bgColor,
    this.hoverBgColor,
    this.borderClr,
    this.hoverBorderClr,
    this.size,
    this.padding,
    this.radius = 6,
  });

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: Tooltip(
        message: widget.msg,
        textStyle: TextStyle(
          color: gWhiteColor,
          fontSize: fontSize10,
          fontFamily: fontMedium,
        ),
        decoration: BoxDecoration(
          color: gPrimaryColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        waitDuration: const Duration(milliseconds: 300),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.radius),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isHover ? gPrimaryColor : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: isHover ? gPrimaryColor : borderColor),
              boxShadow: [
                BoxShadow(
                  color: gBlackColor.withAlpha(5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: (widget.image != null && widget.image!.isNotEmpty)
                  ? Image(
                      image: AssetImage(widget.image ?? ''),
                      height: isDesktop ? 2.5.h : 2.h,
                      color: isHover ? gWhiteColor : gPrimaryColor,
                      key: ValueKey(isHover),
                    )
                  : Icon(
                      widget.icon,
                      size: isDesktop ? 2.5.h : 2.h,
                      color: isHover ? gWhiteColor : gPrimaryColor,
                      key: ValueKey(isHover),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
