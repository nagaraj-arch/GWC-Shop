import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../common_category_card.dart';

class RhythmWidget extends StatefulWidget {
  const RhythmWidget({super.key});

  @override
  State<RhythmWidget> createState() => _RhythmWidgetState();
}

class _RhythmWidgetState extends State<RhythmWidget> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final height =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        60; // Announcement bar height

    // ConstrainedBox + SingleChildScrollView instead of a hard SizedBox:
    // when content fits, it looks identical to before (fills the target
    // height). When content is taller than the available space — small
    // phones, short laptop windows, text growing from live API data — it
    // scrolls instead of throwing a RenderFlex overflow error.
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height > 0 ? height : 0),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center, // <-- Important
                children: [
                  Expanded(
                    flex: 5,
                    child: heroSection()
                        .animate()
                        .fade(duration: 800.ms)
                        .slideX(begin: -.2),
                  ),

                  const SizedBox(width: 60),

                  Expanded(
                    flex: 3,
                    child: CommonCategorySlider(
                      mode: SliderMode.single,
                    ).animate().fade().slideX(begin: .2),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center, // <-- Important
                mainAxisSize: MainAxisSize.min,
                children: [
                  heroSection().animate().fade().slideY(begin: .2),

                  const SizedBox(height: 40),

                  const CommonCategorySlider(
                    mode: SliderMode.single,
                  ).animate().fade(delay: 300.ms).scale(),
                ],
              ),
      ),
    );
  }

  Widget heroSection() {
    final responsive = ScreenSizeHelper(context);

    // Title sizes – increased
    final titleSize = responsive.isMobile
        ? 52.0
        : responsive.isTablet
        ? 68.0
        : responsive.isLaptop
        ? 88.0
        : responsive.isDesktop
        ? 106.0
        : responsive.isLargeDesktop
        ? 130.0
        : 140.0;

    // Subtitle (handwritten) sizes – slightly increased
    final subtitleSize = responsive.isMobile
        ? 34.0
        : responsive.isTablet
        ? 46.0
        : responsive.isLaptop
        ? 60.0
        : responsive.isDesktop
        ? 72.0
        : responsive.isLargeDesktop
        ? 78.0
        : 86.0;

    // Body text sizes – unchanged
    final bodySize = responsive.isMobile
        ? 14.0
        : responsive.isTablet
        ? 16.0
        : responsive.isLaptop
        ? 20.0
        : responsive.isDesktop
        ? 24.0
        : responsive.isLargeDesktop
        ? 26.0
        : 28.0;

    // Left padding for rotated subtitle
    final subtitleLeftPadding = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 30.0
        : responsive.isLaptop
        ? 80.0
        : responsive.isDesktop
        ? 120.0
        : 150.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --------------------
          /// Your gut follows
          /// --------------------
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              "Your gut follows",
              style: GoogleFonts.archivoNarrow(
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xff2C2423),
                height: 1.0,
                letterSpacing: -1,
              ),
            ),
          ).animate().fade(duration: 700.ms).slideX(begin: -.3),

          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  "a ",
                  style: GoogleFonts.archivoNarrow(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff2C2423),
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "rhythm.",
                  style: GoogleFonts.archivoNarrow(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: gPrimaryColor,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ).animate(delay: 150.ms).fade().slideX(begin: -.2),

          const SizedBox(height: 10),

          /// --------------------
          /// handwritten subtitle
          /// --------------------
          Padding(
            padding: EdgeInsets.only(left: subtitleLeftPadding),
            child: Transform.rotate(
              angle: -.09,
              child: Text(
                "Your food should too.",
                style: GoogleFonts.caveat(
                  color: const Color(0xffB7861A),
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ).animate(delay: 400.ms).fade().slideY(begin: .4),

          SizedBox(height: responsive.isMobile ? 20 : 30),

          Text(
            "Food-first products designed for the unique moments your gut needs care—from morning active nourishment to a warm, comforting bowl at night.",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoMono(
              fontSize: bodySize,
              height: 1.7,
              color: gHintTextColor,
              fontWeight: FontWeight.w500,
            ),
          ).animate(delay: 650.ms).fade(duration: 900.ms),

          // SizedBox(height: responsive.isMobile ? 35 : 50),
          //
          // /// CTA Button
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: gPrimaryColor,
          //     foregroundColor: Colors.white,
          //     elevation: 0,
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 34,
          //       vertical: 20,
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(40),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text(
          //         "Explore Products",
          //         style: GoogleFonts.inter(
          //           fontWeight: FontWeight.w700,
          //           fontSize: 16,
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       const Icon(Icons.arrow_forward_rounded),
          //     ],
          //   ),
          // ).animate(delay: 900.ms).fade().scale(begin: const Offset(.8, .8)),
        ],
      ),
    );
  }
}
