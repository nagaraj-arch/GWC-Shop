import 'package:flutter/material.dart';

import '../../utils/responsive_helper.dart';
import '../../widgets/iamge_picker_widget/thumbnail_view.dart';

class FooterSection extends StatelessWidget {
  final String? footerThumbnail;
  final String? footerThumbnailMobile;
  final String? footerThumbnailLaptop;
  final String? footerThumbnailTab;
  final String? footerThumbnailDesktop;
  final String? footerTitle;
  final String? footerDescription;
  final String? footerHighlightText;
  final bool isFoodFarmacy;

  const FooterSection({
    super.key,
    this.footerThumbnail,
    this.footerThumbnailMobile,
    this.footerThumbnailLaptop,
    this.footerThumbnailTab,
    this.footerThumbnailDesktop,
    this.footerTitle,
    this.footerDescription,
    this.footerHighlightText,
    this.isFoodFarmacy = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;
    late final String imageUrl;
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

    // if (responsive.isMobile) {
    //   imageUrl = footerThumbnailMobile ?? '';
    //   bannerHeight = screenWidth * 0.55;
    // } else if (responsive.isTablet) {
    //   imageUrl = footerThumbnailTab ?? '';
    //   bannerHeight = screenWidth * 0.50;
    // } else if (responsive.isLaptop) {
    //   imageUrl = footerThumbnailLaptop ?? '';
    //   bannerHeight = screenWidth * 0.45;
    // } else {
    //   imageUrl = footerThumbnailDesktop ?? '';
    //   bannerHeight = screenWidth * 0.40;
    // }

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: ThumbnailView(
        context: context,
        imageUrl: footerThumbnail ?? '',
        enablePreview: false,
        borderRadius: 0,
        width: double.infinity,
        height: bannerHeight,
        fit: BoxFit.fill,
        lazyLoad: true,
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     bool isValidImage(String? url) =>
//         url != null && url.trim().isNotEmpty && url != 'null';
//
//     // Laptop image only for all screen sizes.
//     final footerImage = isValidImage(footerThumbnailLaptop)
//         ? footerThumbnailLaptop
//         : footerThumbnail;
//
//     if (!isValidImage(footerImage)) {
//       return const SizedBox.shrink();
//     }
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth.isFinite
//             ? constraints.maxWidth
//             : MediaQuery.sizeOf(context).width;
//
//         final isWide = width >= 800;
//
//         // Responsive image height.
//         final imageHeight = (width * 0.42).clamp(260.0, 680.0);
//
//         // Responsive horizontal padding.
//         final horizontalPadding = (width * 0.07).clamp(20.0, 120.0);
//
//         return Container(
//           width: double.infinity,
//           color: isFoodFarmacy
//               ? gWhiteColor
//               : const Color(0xffF7F2EC),
//           child: isWide
//               ? Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     left: horizontalPadding,
//                     right: width * 0.03,
//                     bottom: 20,
//                   ),
//                   child: _footerText(),
//                 ),
//               ),
//
//               Expanded(
//                 flex: 5,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                     (width * 0.015).clamp(12.0, 20.0),
//                   ),
//                   child: SizedBox(
//                     height: imageHeight,
//                     child: ThumbnailView(
//                       context: context,
//                       imageUrl: footerImage,
//                       enablePreview: false,
//                       borderRadius: 0,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       height: imageHeight,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//               : Column(
//             children: [
//               SizedBox(height: (width * 0.04).clamp(16.0, 24.0)),
//
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: horizontalPadding,
//                 ),
//                 child: _footerText(),
//               ),
//
//               SizedBox(height: (width * 0.04).clamp(16.0, 24.0)),
//
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(
//                   (width * 0.04).clamp(14.0, 20.0),
//                 ),
//                 child: AspectRatio(
//                   aspectRatio: 1.45,
//                   child: ThumbnailView(
//                     context: context,
//                     imageUrl: footerImage,
//                     enablePreview: false,
//                     borderRadius: 20,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _footerText() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final textWidth = constraints.maxWidth.isFinite
//             ? constraints.maxWidth
//             : MediaQuery.sizeOf(context).width;
//
//         final screenWidth = MediaQuery.sizeOf(context).width;
//         final isWide = screenWidth >= 800;
//
// // Smaller scaling for desktop and ultra-wide screens
//         final scale = (screenWidth / 1440.0).clamp(0.82, 1.08);
//
//         final titleSize = (96.0 * scale).clamp(36.0, 110.0);
//         final descSize = (22.0 * scale).clamp(14.0, 24.0);
//
//         final titleLetterSpacing =
//         (-1.8 * scale).clamp(-2.2, -0.7);
//
//         final descriptionLetterSpacing =
//         (1.2 * scale).clamp(0.4, 1.6);
//
//         final highlightScale = (screenWidth / 1200.0).clamp(0.9, 1.6);
//
//         final highlightSize = isFoodFarmacy
//             ? (36.0 * highlightScale).clamp(24.0, 56.0)
//             : (30.0 * highlightScale).clamp(20.0, 48.0);
//
//         final highlightLeftPadding = isWide
//             ? (textWidth * 0.07).clamp(24.0, 80.0)
//             : (textWidth * 0.04).clamp(12.0, 24.0);
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             HtmlWidget(
//               footerTitle ?? "",
//               customStylesBuilder: (element) {
//                 if (element.localName == 'h1' ||
//                     element.localName == 'h2' ||
//                     element.localName == 'p' ||
//                     element.localName == 'span' ||
//                     element.localName == 'div') {
//                   return {
//                     'font-size': '${titleSize.toStringAsFixed(1)}px',
//                     'line-height': '0.9',
//                     'letter-spacing':
//                     '${titleLetterSpacing.toStringAsFixed(2)}px',
//                   };
//                 }
//                 return null;
//               },
//               textStyle: const TextStyle(height: 1),
//             ),
//
//             SizedBox(
//               height: (16.0 * scale).clamp(8.0, 18.0),
//             ),
//
//             HtmlWidget(
//               footerDescription ?? "",
//               customStylesBuilder: (element) {
//                 if (element.localName == 'p' ||
//                     element.localName == 'span' ||
//                     element.localName == 'div') {
//                   return {
//                     'font-size': '${descSize.toStringAsFixed(1)}px',
//                   };
//                 }
//                 return null;
//               },
//               textStyle: TextStyle(
//                 height: 1.31,
//                 letterSpacing: descriptionLetterSpacing,
//               ),
//             ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
//
//             Padding(
//               padding: EdgeInsets.only(
//                 left: highlightLeftPadding,
//                 top: (20.0 * scale).clamp(16.0, 32.0),
//               ),
//               child: Transform.rotate(
//                 angle: -0.1,
//                 child: HtmlWidget(
//                   footerHighlightText ?? "",
//                   customStylesBuilder: (element) {
//                     if (element.localName == 'p' ||
//                         element.localName == 'span' ||
//                         element.localName == 'h1' ||
//                         element.localName == 'div') {
//                       return {
//                         'font-size': '${highlightSize.toStringAsFixed(1)}px',
//                         'line-height': '1.15',
//                         'letter-spacing':
//                         '${(-0.5 * (textWidth / 650).clamp(0.8, 1.4)).toStringAsFixed(2)}px',
//                       };
//                     }
//                     return null;
//                   },
//                   textStyle: TextStyle(
//                     fontSize: highlightSize,
//                     height: 1.15,
//                     letterSpacing:
//                     -0.5 * (textWidth / 650).clamp(0.8, 1.4),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
}
