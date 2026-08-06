import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gwc_shop/utils/constants.dart';

import '../../utils/responsive_helper.dart';
import '../../widgets/iamge_picker_widget/thumbnail_view.dart';

class FooterSection extends StatefulWidget {
  final String? footerThumbnail;
  final String? footerTitle;
  final String? footerDescription;
  final String? footerHighlightText;
  final bool isFoodFarmacy;
  const FooterSection({
    super.key,
    this.footerThumbnail,
    this.footerTitle,
    this.footerDescription,
    this.footerHighlightText,
    this.isFoodFarmacy = false,
  });

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    final responsive = ScreenSizeHelper(context);

    // Helper to check if image URL is valid
    bool isValidImage(String? url) =>
        url != null && url.trim().isNotEmpty && url != 'null';

    final showFooterSection = isValidImage(widget.footerThumbnail);

    if (!showFooterSection) {
      return const SizedBox.shrink();
    }

    // Previously reused the full-page cover section's 300–700px height
    // scale here, which is much taller than this footer's photo needs
    // to be relative to its text column (per the reference design).
    // Scaled down to more proportionate values.
    final footerImageHeight = responsive.isMobile
        ? 300.0
        : responsive.isTablet
        ? 400.0
        : responsive.isLaptop
        ? 600.0
        : responsive.isDesktop
        ? 700.0
        : 800.0;

    return Container(
      width: double.infinity,
      color: widget.isFoodFarmacy ? gWhiteColor : const Color(0xffF7F2EC),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80, bottom: 20),
                    child: _footerText(),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ThumbnailView(
                      context: context,
                      imageUrl: widget.footerThumbnail,
                      enablePreview: false,
                      borderRadius: 0,
                      // BoxFit.fill stretches non-uniformly;
                      // BoxFit.cover preserves the photo's real
                      // proportions and crops to fill instead.
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: footerImageHeight,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _footerText(),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ThumbnailView(
                    context: context,
                    imageUrl: widget.footerThumbnail,
                    enablePreview: false,
                    borderRadius: 20,
                    // .contain never distorts (letterboxes
                    // instead of stretching), so it's left as
                    // the intentional mobile treatment.
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _footerText() {
    final responsive = ScreenSizeHelper(context);

    final titleSize = responsive.isMobile
        ? 34.0
        : responsive.isTablet
        ? 46.0
        : responsive.isLaptop
        ? 100.0
        : responsive.isDesktop
        ? 110.0
        : responsive.isLargeDesktop
        ? 120.0
        : 130.0;

    final descSize = responsive.isMobile
        ? 14.0
        : responsive.isTablet
        ? 16.0
        : responsive.isLaptop
        ? 18.0
        : responsive.isDesktop
        ? 20.0
        : 22.0;

    final highlightSize = widget.isFoodFarmacy
        ? (responsive.isMobile
              ? 24.0
              : responsive.isTablet
              ? 26.0
              : responsive.isLaptop
              ? 30.0
              : 34.0)
        : (responsive.isMobile
              ? 16.0
              : responsive.isTablet
              ? 20.0
              : responsive.isLaptop
              ? 35.0
              : responsive.isDesktop
              ? 41.0
              : responsive.isLargeDesktop
              ? 47.0
              : 53.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        HtmlWidget(
          widget.footerTitle ?? "",
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
          textStyle: TextStyle(),
        ),

        SizedBox(
          height: responsive.isMobile
              ? 8
              : responsive.isTablet
              ? 12
              : 16,
        ),
        HtmlWidget(
          widget.footerDescription ?? "",
          customStylesBuilder: (element) {
            if (element.localName == 'p' ||
                element.localName == 'span' ||
                element.localName == 'div') {
              return {'font-size': '${descSize}px'};
            }
            return null;
          },
          textStyle: TextStyle(
            height: 1.31, // Line spacing
            letterSpacing: 1.5, // Letter spacing
          ),
        ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
        Padding(
          padding: EdgeInsets.only(left: 60,top: 40),
          child: SizedBox(
            width: double.infinity,
            child: Transform.rotate(
              angle: -0.1,
              child: Align(
                alignment: Alignment.centerRight,
                child: HtmlWidget(
                  widget.footerHighlightText ?? "",
                  customStylesBuilder: (element) {
                    if (element.localName == 'p' ||
                        element.localName == 'span' ||
                        element.localName == 'h1' ||
                        element.localName == 'div') {
                      return {
                        'font-size': '${highlightSize}px',
                        'text-align': 'right',
                      };
                    }
                    return null;
                  },
                  textStyle: const TextStyle(
                    height: 1.25,
                    letterSpacing: -0.030,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
