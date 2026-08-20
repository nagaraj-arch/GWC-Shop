import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../../utils/constants.dart';
import '../../../../../utils/responsive_helper.dart';
import '../../shop_tab/widgets/common_category_card.dart';

class FollowsRhythm extends StatefulWidget {
  const FollowsRhythm({super.key});

  @override
  State<FollowsRhythm> createState() => _FollowsRhythmState();
}

class _FollowsRhythmState extends State<FollowsRhythm> {
  @override
  Widget build(BuildContext context) {
    final res = ScreenSizeHelper(context);

    final mobileDesign = res.isMobile || res.isTablet;
    final height =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        60;
    return mobileDesign
        ? Container(
            color: gPrimaryColor.withValues(alpha: 0.1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: heroSection(mobileDesign),
          )
        : Container(
            width: double.maxFinite,
            color: gPrimaryColor.withValues(alpha: 0.1),
            padding: EdgeInsets.symmetric(
              horizontal: (res.isMobile || res.isTablet) ? 15 : 80,
              vertical: 40,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height > 0 ? height : 0),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 58, child: heroSection(mobileDesign)),

                          const SizedBox(width: 20),

                          Expanded(
                            flex: 50,
                            child: CommonCategorySlider(
                              mode: SliderMode.single,
                            ).animate().fade(delay: 300.ms).scale(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }

  Widget heroSection(bool mobileDesign) {
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSize = (screenWidth * 0.075).clamp(46.0, 104.0);

    final subtitleSize = (screenWidth * 0.040).clamp(28.0, 68.0);

    final bodySize = (screenWidth * 0.014).clamp(14.0, 22.0);

    final headline = RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: "Archivo Narrow",
          fontWeight: FontWeight.w700,
          height: 1.0, // line spacing
          letterSpacing: (-screenWidth * 0.0014).clamp(-2.2, -0.8),
          color: gBlackColor,
          fontSize: titleSize,
        ),
        children: const [
          TextSpan(text: 'Your gut follows\na '),
          TextSpan(
            text: 'rhythm.',
            style: TextStyle(color: gPrimaryColor),
          ),
        ],
      ),
    );

    final script = Padding(
      padding: EdgeInsets.only(left: mobileDesign ? 60 : 170),
      child: Transform.rotate(
        angle: -.12,
        child: Text(
          'Your food should too.',
          style: TextStyle(
            fontFamily: "Caveat",
            fontWeight: FontWeight.w700,
            color: const Color(0xffB7861A),
            fontSize: subtitleSize,
            height: 1.4, // line spacing
            letterSpacing: 0, // letter spacing
          ),
        ),
      ),
    );

    final desc = """
<p style="font-family:'Courier Prime'; font-weight:400; font-size:inherit;font-style:italic;text-align: justify;"">
  <span style="color:#786f68;">
   Food-only products designed for the unique intervals<br/>
    your gut needs care— from morning active nourishment<br/>
     to a warm, comforting bowl at night.
  </span>
</p>
""";

    final body = DefaultTextStyle(
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
          letterSpacing: 0, // Letter spacing
        ),
      ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --------------------
          /// Your gut follows
          /// --------------------
          headline,
          script,
          SizedBox(height: mobileDesign ? 20 : 70),
          SizedBox(
            width: (screenWidth * 0.82).clamp(300.0, 760.0),
            child: body,
          ),
          // FittedBox(
          //   alignment: Alignment.centerLeft,
          //   fit: BoxFit.scaleDown,
          //   child: Text(
          //     "Your gut follows",
          //     style: GoogleFonts.archivoNarrow(
          //       fontSize: titleSize,
          //       fontWeight: FontWeight.w700,
          //       color: const Color(0xff2C2423),
          //       height: 1.0,
          //       letterSpacing: -1,
          //     ),
          //   ),
          // ).animate().fade(duration: 700.ms).slideX(begin: -.3),
          //
          // FittedBox(
          //   alignment: Alignment.centerLeft,
          //   fit: BoxFit.scaleDown,
          //   child: Wrap(
          //     crossAxisAlignment: WrapCrossAlignment.end,
          //     children: [
          //       Text(
          //         "a ",
          //         style: GoogleFonts.archivoNarrow(
          //           fontSize: titleSize,
          //           fontWeight: FontWeight.w700,
          //           color: const Color(0xff2C2423),
          //           height: 1.1,
          //           letterSpacing: -0.5,
          //         ),
          //       ),
          //       Text(
          //         "rhythm.",
          //         style: GoogleFonts.archivoNarrow(
          //           fontSize: titleSize,
          //           fontWeight: FontWeight.w700,
          //           color: gPrimaryColor,
          //           height: 1.1,
          //           letterSpacing: -0.5,
          //         ),
          //       ),
          //     ],
          //   ),
          // ).animate(delay: 150.ms).fade().slideX(begin: -.2),
          //
          // const SizedBox(height: 10),
          //
          // /// --------------------
          // /// handwritten subtitle
          // /// --------------------
          // Padding(
          //   padding: EdgeInsets.only(left: subtitleLeftPadding),
          //   child: Transform.rotate(
          //     angle: -.09,
          //     child: Text(
          //       "Your food should too.",
          //       style: GoogleFonts.caveat(
          //         color: const Color(0xffB7861A),
          //         fontSize: subtitleSize,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ),
          // ).animate(delay: 400.ms).fade().slideY(begin: .4),
          //
          // SizedBox(height: responsive.isMobile ? 20 : 30),
          //
          // Text(
          //   "Food-first products designed for the unique moments your gut needs care—from morning active nourishment to a warm, comforting bowl at night.",
          //   maxLines: 3,
          //   overflow: TextOverflow.ellipsis,
          //   style: GoogleFonts.robotoMono(
          //     fontSize: bodySize,
          //     height: 1.7,
          //     color: gHintTextColor,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ).animate(delay: 650.ms).fade(duration: 900.ms),

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
