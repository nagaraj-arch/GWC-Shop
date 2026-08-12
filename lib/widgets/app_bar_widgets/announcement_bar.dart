import 'package:flutter/material.dart';
import 'package:gwc_shop/utils/common_utils.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/utils/responsive_helper.dart';
import 'package:marquee/marquee.dart';

class AnnouncementBar extends StatelessWidget {
  const AnnouncementBar({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final isDesktop = responsive.isDesktop;

    double getResponsiveFontSize(BuildContext context) {
      final r = ScreenSizeHelper(context);

      if (r.isUltraWide) return 22;
      if (r.isLargeDesktop) return 20;
      if (r.isDesktop) return 16;
      if (r.isLaptop) return 14;
      if (r.isTablet) return 12;
      return 12;
    }

    TextStyle announcementTextStyle() {
      return TextStyle(
        fontFamily: "Avenir",
        color: gWhiteColor,
        fontSize: getResponsiveFontSize(context),
        fontWeight: FontWeight.w700,
      );
    }

    return Container(
      height: isDesktop ? 40 : 34,
      color: Color(0xffC41a0f),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 12,
      ),
      child: isDesktop
          ? Row(
        children: [
          Expanded(
            child: Text(
              "Free shipping on orders above ₹799",
              style: announcementTextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Your gut asks for care every day. Start with what you eat.",
                textAlign: TextAlign.center,
                style: announcementTextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Food-Only Formulations",
                textAlign: TextAlign.end,
                style: announcementTextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      )
          : Marquee(
        text:
        "🚚 Free shipping on orders above ₹799     •     🌿 Your gut asks for care every day. Start with what you eat.     •     🥗 Food-Only Formulations",
        style: announcementTextStyle(),
        blankSpace: 60,
        velocity: 40,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 10,
        accelerationDuration: const Duration(milliseconds: 800),
        decelerationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}