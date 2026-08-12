import 'package:flutter/material.dart';

import '../../controllers/models/shop_models/category_model.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/iamge_picker_widget/thumbnail_view.dart';

class CategoryBanner extends StatelessWidget {
  final CategoryList? category;
  final bool showCoverSection;
  final VoidCallback? onChooseProducts;
  final VoidCallback? onLearnMore;
  final VoidCallback? isFoodFarmacy;

  const CategoryBanner({
    super.key,
    required this.category,
    this.showCoverSection = false,
    this.onChooseProducts,
    this.onLearnMore,
    this.isFoodFarmacy,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;
    late final String imageUrl;
    late final double bannerHeight;

    if (responsive.isMobile) {
      imageUrl = category?.bannerSmall ?? '';
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isTablet) {
      imageUrl = category?.bannerTab ?? '';
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isLaptop) {
      imageUrl = category?.bannerLaptop ?? '';
      bannerHeight = screenWidth * 0.45;
    } else if (responsive.isDesktop) {
      imageUrl = category?.bannerDesktop ?? '';
      bannerHeight = screenWidth * 0.45;
    } else {
      imageUrl = category?.bannerBig ?? '';
      bannerHeight = screenWidth * 0.45;
    }

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: ThumbnailView(
        context: context,
        imageUrl: category?.bannerLaptop ?? '',
        enablePreview: true,
        onTap: isFoodFarmacy ?? onChooseProducts ?? () {},
        borderRadius: 0,
        width: double.infinity,
        height: bannerHeight,
        fit: BoxFit.fill,
      ),
    );
  }
}

// class CategoryBanner extends StatelessWidget {
//   final CategoryList? category;
//   final bool showCoverSection;
//   final VoidCallback? onChooseProducts;
//   final VoidCallback? onLearnMore;
//   final VoidCallback? isFoodFarmacy;
//
//   const CategoryBanner({
//     super.key,
//     required this.category,
//     this.showCoverSection = false,
//     this.onChooseProducts,
//     this.onLearnMore,
//     this.isFoodFarmacy,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final responsive = ScreenSizeHelper(context);
//     final screenWidth = responsive.screenWidth;
//
//     debugPrint('SCREEN WIDTH: ${MediaQuery.of(context).size.width}');
//
//     // late final String imageUrl;
//     // late final double bannerHeight;
//     //
//     // if (responsive.isMobile) {
//     //   imageUrl = category?.bannerSmall ?? '';
//     //   bannerHeight = screenWidth * 0.55;
//     // } else if (responsive.isTablet) {
//     //   imageUrl = category?.bannerTab ?? '';
//     //   bannerHeight = screenWidth * 0.50;
//     // } else if (responsive.isLaptop) {
//     //   imageUrl = category?.bannerLaptop ?? '';
//     //   bannerHeight = screenWidth * 0.45;
//     // } else if (responsive.isDesktop) {
//     //   imageUrl = category?.bannerDesktop ?? '';
//     //   bannerHeight = screenWidth * 0.35;
//     // } else {
//     //   imageUrl = category?.bannerBig ?? '';
//     //   bannerHeight = screenWidth * 0.30;
//     // }
//
//     // final leftOffset = responsive.isMobile
//     //     ? 16.0
//     //     : responsive.isTablet
//     //     ? 24.0
//     //     : 60.0;
//
//     // The fixed content widths below (300/420/560/650 etc.) assume a
//     // screen wide enough to fit them next to leftOffset. On a small
//     // enough phone that assumption breaks and text/rows overflow to the
//     // right (the classic yellow/black RenderFlex warning). This is the
//     // hard ceiling any content width is allowed to hit, regardless of
//     // breakpoint.
//     // final maxContentWidth = (screenWidth - leftOffset - 16).clamp(
//     //   160.0,
//     //   double.infinity,
//     // );
//
//     late final String imageUrl;
//
//     if (responsive.isMobile) {
//       imageUrl = category?.bannerSmall ?? '';
//     } else if (responsive.isTablet) {
//       imageUrl = category?.bannerTab ?? '';
//     } else if (responsive.isLaptop) {
//       imageUrl = category?.bannerLaptop ?? '';
//     } else if (responsive.isDesktop) {
//       imageUrl = category?.bannerDesktop ?? '';
//     } else {
//       imageUrl = category?.bannerBig ?? '';
//     }
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final bannerWidth = constraints.maxWidth;
//         const bannerAspectRatio = 2.8;
//
//         final bannerHeight = bannerWidth / bannerAspectRatio;
//
//         return SizedBox(
//           height: bannerHeight,
//           width: double.infinity,
//           child: ThumbnailView(
//             context: context,
//             imageUrl: category?.bannerLaptop ?? '',
//             enablePreview: true,
//             onTap: onChooseProducts ?? () {},
//             borderRadius: 0,
//             width: double.infinity,
//             height: bannerHeight,
//             fit: BoxFit.fill,
//           ),
//         );
//       },
//     );
//     // return SizedBox(
//     //   height: bannerHeight,
//     //   width: double.infinity,
//     //   child: Stack(
//     //     children: [
//     //       /// Banner Image
//     //       ThumbnailView(
//     //         context: context,
//     //         imageUrl: category?.bannerLaptop ?? '',
//     //         enablePreview: false,
//     //         borderRadius: 0,
//     //         width: double.infinity,
//     //         height: bannerHeight,
//     //         fit: BoxFit.fill,
//     //       ),
//     //
//     //       // Soft scrim behind the left-side text/thumbnails so they stay
//     //       // legible regardless of where the product photography happens
//     //       // to fall at this breakpoint's crop — without this, text and
//     //       // icons can land directly on top of busy parts of the photo
//     //       // (e.g. a product pouch) and become unreadable.
//     //       //
//     //       // Each breakpoint loads a genuinely different image asset
//     //       // (bannerSmall/bannerTab/bannerLaptop/bannerDesktop/bannerBig),
//     //       // not a scaled copy of one shared photo — so a single fade-out
//     //       // stop tuned for one crop doesn't necessarily hold for another.
//     //       // The mobile asset's product photography apparently starts
//     //       // further left (as a % of its own width) than the others, so
//     //       // it needs more coverage. Retune these per-tier if a specific
//     //       // asset's product photography still creeps into the text zone.
//     //       // Positioned.fill(
//     //       //   child: IgnorePointer(
//     //       //     child: DecoratedBox(
//     //       //       decoration: BoxDecoration(
//     //       //         gradient: LinearGradient(
//     //       //           begin: Alignment.centerLeft,
//     //       //           end: Alignment.centerRight,
//     //       //           colors: [
//     //       //             const Color(0xffF8F4EA).withAlpha(55),
//     //       //             const Color(0xffF8F4EA).withAlpha(0),
//     //       //           ],
//     //       //           stops: [
//     //       //             0.0,
//     //       //             responsive.isMobile ? 0.80 : 0.62,
//     //       //           ],
//     //       //         ),
//     //       //       ),
//     //       //     ),
//     //       //   ),
//     //       // ),
//     //       // Positioned(
//     //       //   right: 0,
//     //       //   top: 0,
//     //       //   child: Container(
//     //       //     color: gPrimaryColor,
//     //       //     padding: EdgeInsets.all(6),
//     //       //     child: Text("${MediaQuery.of(context).size.width}",
//     //       //       style: TextStyle(color: gWhiteColor),),
//     //       //
//     //       //   ),
//     //       // ),
//     //
//     //       /// Buttons
//     //       // Positioned(
//     //       //   left: responsive.isMobile
//     //       //       ? 20.0
//     //       //       : responsive.isTablet
//     //       //       ? 40.0
//     //       //       : responsive.isLaptop
//     //       //       ? 80.0
//     //       //       : responsive.isDesktop
//     //       //       ? 120.0
//     //       //       : 150.0,
//     //       //   bottom: responsive.isMobile
//     //       //       ? 25
//     //       //       : responsive.isTablet
//     //       //       ? 40
//     //       //       : responsive.isLaptop
//     //       //       ? 55
//     //       //       : 65,
//     //       //   child: (isFoodFarmacy == null)
//     //       //       ? Column(
//     //       //     crossAxisAlignment: CrossAxisAlignment.start,
//     //       //     children: [
//     //       //       _bannerButton(
//     //       //         context,
//     //       //         "CHOOSE YOUR ${SafeString().toTitleCase(category?.name ?? '').toUpperCase()}",
//     //       //         category?.color,
//     //       //         onChooseProducts ?? () {},
//     //       //       ),
//     //       //
//     //       //       if (showCoverSection) ...[
//     //       //         const SizedBox(height: 10),
//     //       //
//     //       //         _bannerButton(
//     //       //           context,
//     //       //           "LEARN HOW IT WORKS",
//     //       //           category?.color,
//     //       //           onLearnMore ?? () {},
//     //       //         ),
//     //       //       ],
//     //       //     ],
//     //       //   )
//     //       //       : _bannerButton(
//     //       //     context,
//     //       //     "FIND WHAT YOUR GUT NEEDS",
//     //       //     gsecondaryColor,
//     //       //     isFoodFarmacy ?? (){},
//     //       //   ),
//     //       // ),
//     //       // Positioned(
//     //       //   left: responsive.isMobile
//     //       //       ? 20.0
//     //       //       : responsive.isTablet
//     //       //       ? 40.0
//     //       //       : responsive.isLaptop
//     //       //       ? 80.0
//     //       //       : responsive.isDesktop
//     //       //       ? 120.0
//     //       //       : 150.0,
//     //       //   top: responsive.isMobile
//     //       //       ? 40
//     //       //       : responsive.isTablet
//     //       //       ? 40
//     //       //       : responsive.isLaptop
//     //       //       ? 40
//     //       //       : responsive.isDesktop
//     //       //       ? 90
//     //       //       : 110,
//     //       //   child: Builder(
//     //       //     builder: (context) {
//     //       //       final desiredTextWidth = responsive.isMobile
//     //       //           ? 300.0
//     //       //           : responsive.isTablet
//     //       //           ? 420.0
//     //       //           : responsive.isLaptop
//     //       //           ? 700.0
//     //       //           : 800.0;
//     //       //
//     //       //       final textWidth = desiredTextWidth < maxContentWidth
//     //       //           ? desiredTextWidth
//     //       //           : maxContentWidth;
//     //       //
//     //       //       final subTextSize = responsive.isMobile
//     //       //           ? 24.0
//     //       //           : responsive.isTablet
//     //       //           ? 30.0
//     //       //           : responsive.isLaptop
//     //       //           ? 60.0
//     //       //           : responsive.isDesktop
//     //       //           ? 68.0
//     //       //           : responsive.isLargeDesktop
//     //       //           ? 76.0
//     //       //           : 84.0;
//     //       //
//     //       //       final descSize = responsive.isMobile
//     //       //           ? 16.0
//     //       //           : responsive.isTablet
//     //       //           ? 20.0
//     //       //           : responsive.isLaptop
//     //       //           ? 35.0
//     //       //           : responsive.isDesktop
//     //       //           ? 41.0
//     //       //           : responsive.isLargeDesktop
//     //       //           ? 47.0
//     //       //           : 53.0;
//     //       //
//     //       //       return Column(
//     //       //         crossAxisAlignment: CrossAxisAlignment.start,
//     //       //         children: [
//     //       //           SizedBox(
//     //       //             width: textWidth,
//     //       //             child: Center(
//     //       //               child: HtmlWidget(
//     //       //                 key: ValueKey('subText-${_tierLabel(responsive)}'),
//     //       //                 category?.subText ?? "",
//     //       //                 textStyle: TextStyle(letterSpacing: -.035),
//     //       //                 customStylesBuilder: (element) {
//     //       //                   if (element.localName == 'p' ||
//     //       //                       element.localName == 'span' ||
//     //       //                       element.localName == 'h1' ||
//     //       //                       element.localName == 'div') {
//     //       //                     return {
//     //       //                       'font-size': '${subTextSize}px',
//     //       //                       // ✅ font-weight, line-height, color, font-family from HTML
//     //       //                     };
//     //       //                   }
//     //       //                   return null;
//     //       //                 },
//     //       //               ),
//     //       //             ),
//     //       //           ),
//     //       //           SizedBox(height: responsive.isMobile ? 10 : 0),
//     //       //           SizedBox(
//     //       //             width: textWidth,
//     //       //             child: Center(
//     //       //               child: Padding(
//     //       //                 padding: EdgeInsets.only(
//     //       //                   left: responsive.isMobile
//     //       //                       ? 40
//     //       //                       : responsive.isTablet
//     //       //                       ? 60
//     //       //                       : 180,
//     //       //                 ),
//     //       //                 child: Transform.rotate(
//     //       //                   angle: -0.1,
//     //       //                   // HtmlWidget with responsive font size, rest from HTML
//     //       //                   child: HtmlWidget(
//     //       //                     key: ValueKey(
//     //       //                       'description-${_tierLabel(responsive)}',
//     //       //                     ),
//     //       //                     category?.description ?? "",
//     //       //                     customStylesBuilder: (element) {
//     //       //                       if (element.localName == 'p' ||
//     //       //                           element.localName == 'span' ||
//     //       //                           element.localName == 'h1' ||
//     //       //                           element.localName == 'div') {
//     //       //                         return {
//     //       //                           'font-size': '${descSize}px',
//     //       //                           // ✅ font-weight, line-height, color, font-family from HTML
//     //       //                         };
//     //       //                       }
//     //       //                       return null;
//     //       //                     },
//     //       //                   ),
//     //       //                 ),
//     //       //               ),
//     //       //             ),
//     //       //           ),
//     //       //           if ((category?.bannerThumbnails?.isNotEmpty ?? false)) ...[
//     //       //             SizedBox(height: responsive.isMobile ? 30 : 50),
//     //       //             Padding(
//     //       //               padding: const EdgeInsets.only(left: 20),
//     //       //               child: SizedBox(
//     //       //                 width: textWidth,
//     //       //                 height: 200,
//     //       //                 child: ListView.builder(
//     //       //                   scrollDirection: Axis.horizontal,
//     //       //                   itemCount: category?.bannerThumbnails?.length,
//     //       //                   padding: EdgeInsets.zero,
//     //       //                   shrinkWrap: true,
//     //       //                   itemBuilder: (_, index) {
//     //       //                     final item = category!.bannerThumbnails![index];
//     //       //
//     //       //                     return BannerThumbnailItem(
//     //       //                       item: item,
//     //       //                       responsive: responsive,
//     //       //                       textWidth: textWidth,
//     //       //                       itemCount: category!.bannerThumbnails!.length,
//     //       //                       category: category,
//     //       //                     );
//     //       //                   },
//     //       //                 ),
//     //       //               ),
//     //       //             ),
//     //       //           ],
//     //       //         ],
//     //       //       );
//     //       //     },
//     //       //   ),
//     //       // ),
//     //     ],
//     //   ),
//     // );
//   }
//
//   // Widget _bannerButton(
//   //     BuildContext context,
//   //     String title,
//   //     Color? color,
//   //     VoidCallback onTap,
//   //     ) {
//   //   final r = ScreenSizeHelper(context);
//   //
//   //   final buttonHeight = r.isMobile
//   //       ? 30.0
//   //       : r.isTablet
//   //       ? 36.0
//   //       : r.isLaptop
//   //       ? 44.0
//   //       : r.isDesktop
//   //       ? 46.0
//   //       : 48.0;
//   //
//   //   final buttonWidth = r.isMobile
//   //       ? 160.0
//   //       : r.isTablet
//   //       ? 200.0
//   //       : r.isLaptop
//   //       ? 250.0
//   //       : r.isDesktop
//   //       ? 290.0
//   //       : 310.0;
//   //
//   //   final horizontalPadding = r.isMobile
//   //       ? 14.0
//   //       : r.isTablet
//   //       ? 16.0
//   //       : r.isLaptop
//   //       ? 18.0
//   //       : r.isDesktop
//   //       ? 22.0
//   //       : 26.0;
//   //
//   //   final fontSize = r.isMobile
//   //       ? 8.5
//   //       : r.isTablet
//   //       ? 10.5
//   //       : r.isLaptop
//   //       ? 12.0
//   //       : r.isDesktop
//   //       ? 13.5
//   //       : 15.0;
//   //
//   //   final iconSize = r.isMobile
//   //       ? 13.0
//   //       : r.isTablet
//   //       ? 15.0
//   //       : r.isLaptop
//   //       ? 16.0
//   //       : r.isDesktop
//   //       ? 18.0
//   //       : 20.0;
//   //
//   //   final lineWidth = r.isMobile
//   //       ? 18.0
//   //       : r.isTablet
//   //       ? 20.0
//   //       : r.isLaptop
//   //       ? 22.0
//   //       : r.isDesktop
//   //       ? 24.0
//   //       : 28.0;
//   //
//   //   return InkWell(
//   //     onTap: onTap,
//   //     borderRadius: BorderRadius.circular(buttonHeight / 3),
//   //     child: Container(
//   //       width: buttonWidth,
//   //       height: buttonHeight,
//   //       padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//   //       decoration: BoxDecoration(
//   //         color: color,
//   //         borderRadius: BorderRadius.circular(buttonHeight / 3),
//   //         border: Border.all(color: gMainColor),
//   //       ),
//   //       child: Row(
//   //         children: [
//   //           Expanded(
//   //             child: Text(
//   //               title,
//   //               maxLines: 1,
//   //               overflow: TextOverflow.ellipsis,
//   //               style: TextStyle(
//   //                 fontFamily: "Avenir",
//   //                 fontSize: fontSize,
//   //                 fontWeight: FontWeight.w600,
//   //                 color: Colors.white,
//   //               ),
//   //             ),
//   //           ),
//   //
//   //           SizedBox(width: 8),
//   //
//   //           Stack(
//   //             alignment: Alignment.centerRight,
//   //             children: [
//   //               Container(
//   //                 width: lineWidth,
//   //                 height: 2,
//   //                 color: Colors.white,
//   //               ),
//   //               Icon(
//   //                 Icons.arrow_forward,
//   //                 color: Colors.white,
//   //                 size: iconSize,
//   //               ),
//   //             ],
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }

class BannerThumbnailItem extends StatelessWidget {
  final ImportantPoints item;
  final ScreenSizeHelper responsive;
  final double textWidth;
  final int itemCount;
  final CategoryList? category;

  const BannerThumbnailItem({
    super.key,
    required this.item,
    required this.responsive,
    required this.textWidth,
    required this.itemCount,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Small fixed spacing for mobile/tablet
    // ✅ Split evenly for laptop and desktop
    final itemSpacing = responsive.isMobile || responsive.isTablet
        ? 20.0 // Small fixed spacing
        : 60.0; // Large spacing for split layout

    // Responsive image sizes
    var imageSize = responsive.isMobile
        ? 24.0
        : responsive.isTablet
        ? 52.0
        : responsive.isLaptop
        ? 80.0
        : responsive.isDesktop
        ? 89.0
        : responsive.isLargeDesktop
        ? 98.0
        : 106.0;

    // Responsive text sizes
    var textSize = responsive.isMobile
        ? 11.0
        : responsive.isTablet
        ? 14.0
        : responsive.isLaptop
        ? 18.0
        : responsive.isDesktop
        ? 19.0
        : responsive.isLargeDesktop
        ? 21.0
        : 23.0;

    final title = item.title ?? "";

    final displayTitle = responsive.isMobile
        ? title.replaceAll(" ", "\n")
        : title;

    return Container(
      padding: EdgeInsets.only(right: itemSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThumbnailView(
            context: context,
            imageUrl: item.thumbnail,
            width: imageSize,
            height: imageSize,
            // ⚠️ Also keeps getting reverted back to .fill (same issue
            // as the main banner image above) — .contain preserves the
            // icon's real proportions instead of stretching it.
            fit: BoxFit.contain,
            enablePreview: false,
          ),
          SizedBox(height: 5),
          Text(
            displayTitle,
            textAlign: TextAlign.center,
            maxLines: responsive.isMobile ? null : 2,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: category?.color,
              fontFamily: "Roboto Condensed",
              fontSize: textSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
