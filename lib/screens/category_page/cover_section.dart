import 'package:flutter/material.dart';

import '../../utils/responsive_helper.dart';
import '../../widgets/iamge_picker_widget/thumbnail_view.dart';

class CoverSection extends StatelessWidget {
  final String? coverImage;
  final String? coverImageMobile;
  final String? coverImageLaptop;
  final String? coverImageTab;
  final String? coverImageDesktop;
  final String? coverTitle;
  final String? coverDesc;
  const CoverSection({
    super.key,
    this.coverImage,
    this.coverImageMobile,
    this.coverImageLaptop,
    this.coverImageTab,
    this.coverImageDesktop,
    this.coverTitle,
    this.coverDesc,
  });

  // flutter_widget_from_html's HtmlWidget caches its rendered output
  // keyed off the HTML content string — it has no way to know that
  // customStylesBuilder's *output* (font-size here) depends on screen
  // width too. So resizing the window rebuilds this widget with a new
  // titleSize/descSize, but since the HTML content itself hasn't
  // changed, the package reuses its stale cached render — the new size
  // only shows up after something forces a full rebuild (e.g. a page
  // refresh). Keying each HtmlWidget to the breakpoint tier forces
  // Flutter to dispose and recreate it whenever the tier actually
  // changes, so it picks up the new size immediately.
  // String _tierLabel(ScreenSizeHelper responsive) {
  //   if (responsive.isMobile) return 'mobile';
  //   if (responsive.isTablet) return 'tablet';
  //   if (responsive.isLaptop) return 'laptop';
  //   if (responsive.isDesktop) return 'desktop';
  //   return 'largeDesktop';
  // }

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;
    // late final String imageUrl;
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

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: ThumbnailView(
        context: context,
        imageUrl: coverImage ?? '',
        enablePreview: false,
        borderRadius: 0,
        width: double.infinity,
        height: bannerHeight,
        fit: BoxFit.fill,
        lazyLoad: true,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final responsive = ScreenSizeHelper(context);
  //   final screenWidth = MediaQuery.of(context).size.width;
  //
  //   // Helper to check if image URL is valid
  //   bool isValidImage(String? url) =>
  //       url != null && url.trim().isNotEmpty && url != 'null';
  //
  //   final showCoverSection = isValidImage(coverImage);
  //
  //   String? selectedCoverImage;
  //
  //   if (responsive.isMobile) {
  //     selectedCoverImage =
  //         (coverImageMobile?.isNotEmpty ?? false) && coverImageMobile != "null"
  //         ? coverImageMobile
  //         : coverImage;
  //   } else if (responsive.isTablet) {
  //     selectedCoverImage =
  //         (coverImageTab?.isNotEmpty ?? false) && coverImageTab != "null"
  //         ? coverImageTab
  //         : coverImage;
  //   } else if (responsive.isLaptop) {
  //     selectedCoverImage =
  //         (coverImageLaptop?.isNotEmpty ?? false) && coverImageLaptop != "null"
  //         ? coverImageLaptop
  //         : coverImage;
  //   } else {
  //     selectedCoverImage =
  //         (coverImageDesktop?.isNotEmpty ?? false) &&
  //             coverImageDesktop != "null"
  //         ? coverImageDesktop
  //         : coverImage;
  //   }
  //
  //   if (!showCoverSection) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   final titleSize = responsive.isMobile
  //       ? 34.0
  //       : responsive.isTablet
  //       ? 46.0
  //       : responsive.isLaptop
  //       ? 100.0
  //       : responsive.isDesktop
  //       ? 110.0
  //       : responsive.isLargeDesktop
  //       ? 120.0
  //       : 130.0;
  //
  //   final descSize = responsive.isMobile
  //       ? 14.0
  //       : responsive.isTablet
  //       ? 16.0
  //       : responsive.isLaptop
  //       ? 20.0
  //       : responsive.isDesktop
  //       ? 22.0
  //       : 24.0;
  //
  //   final bannerHeight = responsive.isMobile
  //       ? 300.0
  //       : responsive.isTablet
  //       ? 400.0
  //       : responsive.isLaptop
  //       ? 600.0
  //       : responsive.isDesktop
  //       ? 700.0
  //       : 800.0;
  //
  //   final leftOffset = responsive.isMobile
  //       ? 20.0
  //       : responsive.isTablet
  //       ? 40.0
  //       : responsive.isLaptop
  //       ? 50.0
  //       : 60.0;
  //
  //   final topOffset = responsive.isMobile
  //       ? 20.0
  //       : responsive.isTablet
  //       ? 28.0
  //       : responsive.isLaptop
  //       ? 34.0
  //       : 40.0;
  //
  //   // The fixed left offsets above assume a screen wide enough to leave
  //   // room for the text next to them. On a small enough phone that
  //   // breaks and the title/description could overflow to the right —
  //   // this is the hard ceiling the text zone can never exceed.
  //   final maxTextWidth = (screenWidth - leftOffset - 16).clamp(
  //     160.0,
  //     double.infinity,
  //   );
  //
  //   final contentHorizontalPadding = responsive.isMobile
  //       ? 20.0
  //       : responsive.isTablet
  //       ? 40.0
  //       : responsive.isLaptop
  //       ? 80.0
  //       : responsive.isDesktop
  //       ? 120.0
  //       : 150.0;
  //
  //   return SizedBox(
  //     height: bannerHeight,
  //     width: double.infinity,
  //     // color: const Color(0xffF8F5F0),
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         /// Background image — StackFit.expand already forces this to
  //         /// fill the Stack, so no explicit width/height is needed here.
  //         ThumbnailView(
  //           context: context,
  //           imageUrl: selectedCoverImage,
  //           enablePreview: false,
  //           borderRadius: 0,
  //           fit: BoxFit.fill,
  //           width: double.maxFinite,
  //           height: bannerHeight,
  //         ),
  //
  //         // Scrim: BoxFit.cover crops differently at every aspect
  //         // ratio, so there's no guarantee the photo's own plain
  //         // background area stays aligned with the text zone at every
  //         // screen size. This keeps the text legible regardless of what
  //         // the crop lands on underneath it.
  //         // const IgnorePointer(
  //         //   child: DecoratedBox(
  //         //     decoration: BoxDecoration(
  //         //       gradient: LinearGradient(
  //         //         begin: Alignment.centerLeft,
  //         //         end: Alignment.centerRight,
  //         //         colors: [Color(0xE6F8F5F0), Color(0x00F8F5F0)],
  //         //         stops: [0.0, 0.55],
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //
  //         /// Left text
  //         Positioned(
  //           left: contentHorizontalPadding,
  //           top: topOffset,
  //           child: SizedBox(
  //             width: maxTextWidth,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Title - Responsive font size, rest from HTML
  //                 HtmlWidget(
  //                   key: ValueKey('coverTitle-${_tierLabel(responsive)}'),
  //                   coverTitle ?? '',
  //                   customStylesBuilder: (element) {
  //                     if (element.localName == 'h1' ||
  //                         element.localName == 'h2' ||
  //                         element.localName == 'p' ||
  //                         element.localName == 'span' ||
  //                         element.localName == 'div') {
  //                       return {
  //                         'font-size': '${titleSize}px',
  //                         'line-height': '0.9',
  //                       };
  //                     }
  //                     return null;
  //                   },
  //                   textStyle: const TextStyle(),
  //                 ),
  //
  //                 SizedBox(
  //                   height: responsive.isMobile
  //                       ? 8
  //                       : responsive.isTablet
  //                       ? 12
  //                       : 20,
  //                 ),
  //                 DefaultTextStyle(
  //                   style: const TextStyle(),
  //                   textAlign: TextAlign.justify,
  //                   child: HtmlWidget(
  //                     key: ValueKey(
  //                       'coverDescription-${_tierLabel(responsive)}',
  //                     ),
  //                     coverDesc ?? "",
  //                     customStylesBuilder: (element) {
  //                       if (element.localName == 'p' ||
  //                           element.localName == 'span' ||
  //                           element.localName == 'div') {
  //                         return {'font-size': '${descSize}px'};
  //                       }
  //                       return null;
  //                     },
  //                     textStyle: TextStyle(
  //                       height: 1.31, // Line spacing
  //                       letterSpacing: 1.5, // Letter spacing
  //                     ),
  //                   ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
