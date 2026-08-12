import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/utils/responsive_helper.dart';

import '../../../../../../utils/constants.dart';
import '../common_category_card.dart';

class GutClockWidget extends StatefulWidget {
  const GutClockWidget({super.key});

  @override
  State<GutClockWidget> createState() => _GutClockWidgetState();
}

class _GutClockWidgetState extends State<GutClockWidget> {
  @override
  Widget build(BuildContext context) {
    final helper = ScreenSizeHelper(context);
    return Column(children: [
      _leftSection().animate().fade().slideY(begin: .2),
      SizedBox(height: 10),
      _letUnderstand(),
    ],);
    // return helper.isMobile || helper.isTablet
    //     ? Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           _leftSection().animate().fade().slideY(begin: .2),
    //
    //           // const SizedBox(height: 20),
    //           //
    //           // _rightSectionWithSlider().animate().fade(delay: 300.ms).scale(),
    //         ],
    //       )
    //     : LayoutBuilder(
    //         builder: (context, constraints) {
    //           return Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               /// LEFT CONTENT
    //               Expanded(flex: 42, child: _leftSection()),
    //
    //               // const SizedBox(width: 20),
    //               //
    //               // /// RIGHT IMAGE
    //               // Expanded(
    //               //   flex: 58,
    //               //   child: _rightSectionWithSlider().animate().fade(delay: 300.ms).scale(),
    //               // ),
    //             ],
    //           );
    //         },
    //       );
    // LayoutBuilder(
    //   builder: (context, constraints) {
    //     final width = constraints.maxWidth;
    //
    //     double heroWidth;
    //     double sliderWidth;
    //     double gap;
    //
    //     if (width >= 1700) {
    //       heroWidth = width * .54;
    //       sliderWidth = width * .40;
    //       gap = 40;
    //     } else if (width >= 1500) {
    //       heroWidth = width * .55;
    //       sliderWidth = width * .39;
    //       gap = 34;
    //     } else if (width >= 1300) {
    //       heroWidth = width * .56;
    //       sliderWidth = width * .38;
    //       gap = 28;
    //     } else if (width >= 1100) {
    //       heroWidth = width * .57;
    //       sliderWidth = width * .36;
    //       gap = 20;
    //     } else {
    //       heroWidth = width * .58;
    //       sliderWidth = width * .34;
    //       gap = 14;
    //     }
    //
    //     return Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(width: heroWidth, child: _leftSection()),
    //
    //         SizedBox(width: gap),
    //
    //         SizedBox(
    //           width: sliderWidth,
    //           child: _rightSectionWithSlider()
    //               .animate()
    //               .fade(delay: 300.ms)
    //               .scale(),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Widget _letUnderstand() {
    final screenWidth = MediaQuery.of(context).size.width;

    // Base design is calculated from screen width
    final containerWidth = (screenWidth * 0.18).clamp(
      160.0,
      300.0,
    );

    final containerHeight = (screenWidth * 0.09).clamp(
      90.0,
      145.0,
    );

    final arrowSize = (screenWidth * 0.075).clamp(
      70.0,
      130.0,
    );

    final textSize = (screenWidth * 0.020).clamp(
      20.0,
      30.0,
    );

    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 🖊️ Dashed arrow
          Positioned(
            left: 0,
            bottom:0,
            child: Image.asset(
              "assets/images/clock.png",
              width: arrowSize,
              fit: BoxFit.contain,
            ),
          ),

          /// ✍️ Let's Understand
          Positioned(
            right: 0,left: 70,top: 20,
            child: Transform.rotate(
              angle: -.2,
              child: Column(
                children: [
                  Text(
                    "Let's\nUnderstand",
                    style: TextStyle(
                      fontFamily: "Caveat",
                      fontSize: textSize,
                      fontWeight: FontWeight.w700,
                      color: gPrimaryColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // LEFT: Title + description only
  Widget _leftSection() {
    final responsive = ScreenSizeHelper(context);

    final screenWidth = MediaQuery.of(context).size.width;

    final titleSize = (screenWidth * 0.065).clamp(20.0, 60.0);
    final bodySize = (screenWidth * 0.014).clamp(14.0, 22.0);

    final title = """
<h1 style="font-family:'Archivo Narrow'; font-weight:600; ">
  Your Gut Has a Clock! Are You Aware Of It?<br>
</h1>
""";

    final desc = """
<p style="font-family:'Courier Prime'; font-weight:400; font-size:inherit; font-style:italic;"
  "color:#786f68;">
   Your Digestive capacity changes through the day.<br/>
   Are you giving it the
<span style="color:#C41A0F; font-family:'Courier Prime'; font-weight:400; font-style:italic;">
     Right food at the Right time?
</span>
</span>
</p>
""";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          title,
          customStylesBuilder: (element) {
            if (element.localName == 'h1' ||
                element.localName == 'h2' ||
                element.localName == 'p' ||
                element.localName == 'span' ||
                element.localName == 'div') {
              return {
                'font-size': '${titleSize}px',
                'line-height': '0.9',
                'letter-spacing': '-2px',
              };
            }
            return null;
          },
          textStyle: TextStyle(height: 1),
        ),

        SizedBox(
          height: responsive.isMobile
              ? 8
              : responsive.isTablet
              ? 12
              : 16,
        ),
        DefaultTextStyle(
          style: const TextStyle(),
          textAlign: TextAlign.justify,
          child: HtmlWidget(
            desc,
            customStylesBuilder: (element) {
              if (element.localName == 'p' ||
                  element.localName == 'span' ||
                  element.localName == 'div') {
                return {'font-size': '${bodySize}px'};
              }
              return null;
            },
            textStyle: TextStyle(
              height: 1.31, // Line spacing
              letterSpacing: 1.5, // Letter spacing
            ),
          ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
        ),
        // Text(
        //   title,
        //   style: TextStyle(
        //     fontFamily: "Archivo Narrow",
        //     fontWeight: FontWeight.w700,
        //     fontSize: titleSize,
        //     color: gBlackColor,
        //     height: 1.0,
        //     letterSpacing: -2.0,
        //   ),
        // ).animate().fade(duration: 500.ms).slideX(begin: -.2),
        //
        // const SizedBox(height: 40),
        //
        // Text(
        //   desc,
        //   style: TextStyle(
        //     fontFamily: "Courier Prime",
        //     fontWeight: FontWeight.w200,
        //     height: 1.31, // line spacing
        //     letterSpacing: 0, // letter spacing
        //     color: gHintTextColor,
        //     fontSize: bodySize,
        //   ),
        // ).animate().fade(duration: 500.ms).slideX(begin: -.2),
      ],
    );
  }

  // RIGHT: Slider + "Explore categories" + arrow (desktop)
  Widget _rightSectionWithSlider() {
    final res = ResponsiveHelper(context);

    return Row(
      children: [
        res.isMobile
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: _exploreAndArrow(),
              ),
        const SizedBox(width: 20),
        Expanded(child: CommonCategorySlider(mode: SliderMode.multi)),
      ],
    );
  }

  Widget _exploreAndArrow() {
    final responsive = ScreenSizeHelper(context);

    final highlightSize = responsive.isMobile
        ? 16.0
        : responsive.isTablet
        ? 18.0
        : responsive.isLaptop
        ? 20.0
        : 22.0;

    final arrowHeight = responsive.isMobile
        ? 32.0
        : responsive.isTablet
        ? 40.0
        : responsive.isLaptop
        ? 50.0
        : 60.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
              alignment: Alignment.topRight,
              child: Transform.rotate(
                angle: -0.1,
                child: Text(
                  "Explore\ncategories",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.caveat(
                    fontSize: highlightSize,
                    color: gPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveX(begin: 0, end: 6, duration: 1200.ms),

        const SizedBox(height: 6),

        Image.asset("assets/images/clock_top_arrow.png", height: arrowHeight)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveX(begin: 0, end: 6, duration: 1200.ms),
      ],
    );
  }
}
