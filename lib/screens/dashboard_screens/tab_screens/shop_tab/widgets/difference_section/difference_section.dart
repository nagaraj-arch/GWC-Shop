import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../../../../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class DifferenceSection extends StatefulWidget {
  const DifferenceSection({super.key});

  @override
  State<DifferenceSection> createState() => _DifferenceSectionState();
}

class _DifferenceSectionState extends State<DifferenceSection> {

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;
    late final double bannerHeight;

    if (responsive.isMobile) {
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isTablet) {
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isLaptop) {
      bannerHeight = screenWidth * 0.45;
    } else if (responsive.isDesktop) {
      bannerHeight = screenWidth * 0.45;
    } else {
      bannerHeight = screenWidth * 0.45;
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: bannerHeight,
          child: ThumbnailView(
            context: context,
            imageUrl:
                "https://gutandhealth.com/storage/uploads/ingredient_category_images/home_footer.webp",
            enablePreview: false,
            borderRadius: 0,
            width: double.infinity,
            height: bannerHeight,
            fit: BoxFit.fill,
          ),
        ),
        // isDesktop
        //     ? Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Expanded(child: intro()),
        //     const SizedBox(width: 40),
        //     Expanded(
        //       child: Center(
        //         child: Image(
        //           image: const AssetImage(
        //             "assets/images/real_difference.png",
        //           ),
        //           height: 430,
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //     ),
        //   ],
        // )
        //     : Column(
        //   children: [
        //     intro(),
        //     const SizedBox(height: 30),
        //     Image(
        //       image: const AssetImage(
        //         "assets/images/real_difference.png",
        //       ),
        //       height: 300,
        //       fit: BoxFit.contain,
        //     ),
        //   ],
        // ),
        const SizedBox(height: 45),
        differenceTimeline(),
        const SizedBox(height: 30),
      ],
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

  Widget differenceTimeline() {
    final icons = [
      "assets/images/digestibility.png",
      "assets/images/timing.png",
      "assets/images/preparation.png",
      "assets/images/suitability.png",
    ];

    final List<String> foods = [
      "DIGESTIBILITY",
      "TIMING",
      "PREPARATION",
      "SUITABILITY",
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // ============================================================
        // RESPONSIVE VALUES
        // ============================================================

        // ICON
        final double iconSize = width < 400
            ? (width * 0.09).clamp(26.0, 36.0)
            : width < 600
            ? (width * 0.085).clamp(32.0, 42.0)
            : width < 1024
            ? (width * 0.07).clamp(38.0, 50.0)
            : (width * 0.06).clamp(42.0, 56.0);

        // ICON ROW HEIGHT
        final double iconRowHeight = width < 400
            ? 60.0
            : width < 600
            ? 68.0
            : width < 1024
            ? 75.0
            : 82.0;

        // SPACE BETWEEN ICON AND LINE
        final double iconToLineGap = width < 400
            ? 5.0
            : width < 600
            ? 7.0
            : 10.0;

        // DOT
        final double dotSize = width < 400
            ? 7.0
            : width < 600
            ? 8.0
            : 9.0;

        // TITLE
        final double titleSize = width < 400
            ? (width * 0.022).clamp(7.0, 8.5)
            : width < 600
            ? (width * 0.023).clamp(8.0, 9.5)
            : width < 1024
            ? (width * 0.021).clamp(9.0, 11.0)
            : (width * 0.019).clamp(10.0, 12.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============================================================
            // ICONS
            // ============================================================
            SizedBox(
              height: iconRowHeight,
              child: Row(
                children: List.generate(
                  icons.length,
                      (index) {
                    return Expanded(
                      child: Center(
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          scale: 1,
                          child: Image.asset(
                            icons[index],
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ============================================================
            // TIMELINE
            // ============================================================
            SizedBox(
              height: dotSize + 8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // LINE
                  Positioned(
                    left: width / icons.length / 2,
                    right: width / icons.length / 2,
                    top: (dotSize + 8) / 2,
                    child: Container(
                      height: 1.2,
                      color: gHintTextColor.withAlpha(70),
                    ),
                  ),

                  // DOTS
                  Row(
                    children: List.generate(
                      icons.length,
                          (index) {
                        return Expanded(
                          child: Center(
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: gHintTextColor.withAlpha(180),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: iconToLineGap),

            // ============================================================
            // FOOD NAMES
            // ============================================================
            Row(
              children: List.generate(
                foods.length,
                    (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontFamily: fontMedium,
                          fontSize: titleSize,
                          color: gHintTextColor,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            foods[index],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class DifferenceTimeline extends StatelessWidget {
  const DifferenceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Responsive scaling
        final isVerySmall = width < 360;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1024;
        final isDesktop = width >= 1024;

        final iconSize = isVerySmall
            ? 24.0
            : isMobile
            ? 28.0
            : isTablet
            ? 34.0
            : isDesktop
            ? 38.0
            : 30.0;

        final lineTop = isVerySmall
            ? 43.0
            : isMobile
            ? 47.0
            : isTablet
            ? 54.0
            : 60.0;

        final dotSize = isVerySmall
            ? 5.0
            : isMobile
            ? 5.0
            : isTablet
            ? 6.0
            : 6.0;

        final titleSize = isVerySmall
            ? 6.5
            : isMobile
            ? 7.5
            : isTablet
            ? 9.0
            : 10.0;

        final horizontalPadding = isVerySmall
            ? 4.0
            : isMobile
            ? 8.0
            : isTablet
            ? 20.0
            : 40.0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: lineTop + 30,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ==================================================
                      // TIMELINE LINE
                      // ==================================================
                      Positioned(
                        left: 0,
                        right: 0,
                        top: lineTop,
                        child: Container(
                          height: 1,
                          color: const Color(0xffA5A5A5),
                        ),
                      ),

                      // ==================================================
                      // ITEMS
                      // ==================================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimelineItem(
                            image: "assets/images/digestibility.png",
                            iconSize: iconSize,
                            dotSize: dotSize,
                            lineTop: lineTop,
                            titleSize: titleSize,
                          ),

                          _buildTimelineItem(
                            image: "assets/images/timing.png",
                            iconSize: iconSize,
                            dotSize: dotSize,
                            lineTop: lineTop,
                            titleSize: titleSize,
                          ),

                          _buildTimelineItem(
                            image: "assets/images/preparation.png",
                            iconSize: iconSize,
                            dotSize: dotSize,
                            lineTop: lineTop,
                            titleSize: titleSize,
                          ),

                          _buildTimelineItem(
                            image: "assets/images/suitability.png",
                            iconSize: iconSize,
                            dotSize: dotSize,
                            lineTop: lineTop,
                            titleSize: titleSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required String image,
    required double iconSize,
    required double dotSize,
    required double lineTop,
    required double titleSize,
  }) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ==============================================================
          // ICON
          // ==============================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: lineTop - 6,
              child: Center(
                child: Image.asset(
                  image,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ==============================================================
          // DOT
          // ==============================================================
          Positioned(
            top: lineTop - (dotSize / 2),
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xff999999),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // ==============================================================
          // TITLE
          // ==============================================================
          Positioned(
            top: lineTop + 10,
            left: 2,
            right: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _getTitle(image),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff444444),
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(String image) {
    if (image.contains("digestibility")) {
      return "DIGESTIBILITY";
    }

    if (image.contains("timing")) {
      return "TIMING";
    }

    if (image.contains("preparation")) {
      return "PREPARATION";
    }

    return "SUITABILITY";
  }
}