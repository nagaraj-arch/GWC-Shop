import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';

class DifferenceSection extends StatefulWidget {
  const DifferenceSection({super.key});

  @override
  State<DifferenceSection> createState() => _DifferenceSectionState();
}

class _DifferenceSectionState extends State<DifferenceSection> {
  // Same max width DifferenceTimeline already uses below, so both rows
  // line up under one another instead of the top Row stretching
  // unbounded on wide desktop screens while the timeline stays capped.
  static const double _maxContentWidth = 1050.0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: Column(
          children: [
            isDesktop
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: intro()),
                const SizedBox(width: 40),
                Expanded(
                  child: Center(
                    child: Image(
                      image: const AssetImage(
                        "assets/images/real_difference.png",
                      ),
                      height: 430,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )
                : Column(
              children: [
                intro(),
                const SizedBox(height: 30),
                Image(
                  image: const AssetImage(
                    "assets/images/real_difference.png",
                  ),
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 45),
            const DifferenceTimeline(),
          ],
        ),
      ),
    );
  }

  Widget intro() {
    final responsive = ScreenSizeHelper(context);

    final titleSize = responsive.isMobile
        ? 36.0
        : responsive.isTablet
        ? 44.0
        : responsive.isLaptop
        ? 52.0
        : 62.0;

    final descSize = responsive.isMobile
        ? 12.0
        : responsive.isTablet
        ? 13.0
        : 14.0;

    final descWidth = responsive.isMobile || responsive.isTablet
        ? double.infinity
        : 340.0;

    final highlightSize = responsive.isMobile
        ? 22.0
        : responsive.isTablet
        ? 25.0
        : 28.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Text(
          "The Real\nDifference?",
          style: GoogleFonts.inter(
            fontSize: titleSize,
            height: 0.92,
            fontWeight: FontWeight.w800,
            color: const Color(0xff231F20),
          ),
        ).animate().fade(duration: 500.ms).slideX(begin: -0.15),

        const SizedBox(height: 28),

        /// DESCRIPTION
        SizedBox(
          width: descWidth,
          child: Text(
            "Your gut doesn’t need more products. "
                "It needs food that understands its rhythm. "
                "Your gut’s needs change throughout the day—"
                "and again when its natural rhythm is disturbed.\n\n"
                "Your Gut Clock helps build the rhythm. "
                "Food Farmacy supports you when it slips.",
            style: GoogleFonts.ibmPlexMono(
              fontSize: descSize,
              height: 1.65,
              color: gHintTextColor,
            ),
          ),
        ).animate().fade(delay: 150.ms).slideY(begin: 0.15),

        const SizedBox(height: 26),

        /// HAND WRITTEN TEXT
        Text(
          "Built for the way your gut actually lives—\n"
              "in rhythm, and sometimes out of it.",
          style: GoogleFonts.caveat(
            fontSize: highlightSize,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: gPrimaryColor,
          ),
        ).animate().fade(delay: 300.ms).slideX(begin: -0.1),
      ],
    );
  }
}

class DifferenceTimeline extends StatelessWidget {
  const DifferenceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final items = [
      (
      Icons.restaurant_menu_rounded,
      "Digestibility",
      "Easy on\nyour gut",
      const Color(0xffEAF7EE),
      ),
      (
      Icons.schedule_rounded,
      "Timing",
      "Eat with\nyour rhythm",
      const Color(0xffFFF5E8),
      ),
      (
      Icons.soup_kitchen_rounded,
      "Preparation",
      "Simple\n& Fresh",
      const Color(0xffEEF6FF),
      ),
      (
      Icons.favorite_rounded,
      "Suitability",
      "For every\ngut type",
      const Color(0xffFDEEEE),
      ),
    ];

    // Container max width on desktop, full width on mobile
    final maxWidth = isDesktop ? 1050.0 : double.infinity;

    final iconSize = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 24.0
        : responsive.isLaptop
        ? 28.0
        : 32.0;

    final circleSize = responsive.isMobile
        ? 46.0
        : responsive.isTablet
        ? 54.0
        : responsive.isLaptop
        ? 60.0
        : 68.0;

    final titleSize = responsive.isMobile
        ? 12.0
        : responsive.isTablet
        ? 13.0
        : responsive.isLaptop
        ? 15.0
        : 17.0;

    final lineHeight = isDesktop ? 2.0 : 1.5;
    final lineInset = responsive.isMobile ? 16.0 : (isDesktop ? 60.0 : 20.0);

    return SizedBox(
      width: maxWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / items.length;

          return Stack(
            alignment: Alignment.center,
            children: [
              /// Timeline Line
              Positioned(
                top: circleSize / 2 - lineHeight / 2,
                left: lineInset,
                right: lineInset,
                child: Container(
                  height: lineHeight,
                  color: Colors.grey.shade300,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((item) {
                  // On desktop, use a comfortable fixed width — but never
                  // wider than what's actually available, so narrower
                  // "isDesktop" windows (e.g. small laptops) can't overflow.
                  final desktopItemWidth = itemWidth < 180.0
                      ? itemWidth
                      : 180.0;

                  return SizedBox(
                    width: isDesktop ? desktopItemWidth : itemWidth,
                    child: Column(
                      children: [
                        /// Circle Icon
                        Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            color: item.$4,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gBlackColor.withAlpha(20),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Icon(
                            item.$1,
                            size: iconSize,
                            color: gPrimaryColor,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          item.$2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff222222),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}