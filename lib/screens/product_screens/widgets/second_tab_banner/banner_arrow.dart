import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';

class BannerArrow extends StatefulWidget {
  final bool isLeft;
  final VoidCallback onTap;

  const BannerArrow({
    super.key,
    required this.isLeft,
    required this.onTap,
  });

  @override
  State<BannerArrow> createState() => _BannerArrowState();
}

class _BannerArrowState extends State<BannerArrow> {

  bool hover = false;

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: hover ? 1.08 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
           // padding: EdgeInsets.all(8),
           //  decoration: BoxDecoration(
           //    color: hover
           //        ? Colors.white
           //        : Colors.white.withAlpha(235),
           //    shape: BoxShape.circle,
           //    boxShadow: [
           //      BoxShadow(
           //        color: Colors.black.withAlpha(40),
           //        blurRadius: hover ? 20 : 14,
           //        spreadRadius: 2,
           //      )
           //    ],
           //  ),
            child: Icon(
              widget.isLeft
                  ? Icons.arrow_back_ios
                  : Icons.arrow_forward_ios,
              size: 22,
              color: gHintTextColor,
            ),
          ),
        ),
      ),
    );
  }
}