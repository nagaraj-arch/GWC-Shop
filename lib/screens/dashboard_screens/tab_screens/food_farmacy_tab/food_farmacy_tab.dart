import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gwc_shop/controllers/models/shop_models/category_model.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/widgets/loading_widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../category_page/category_banner.dart';
import '../../../category_page/category_product_card.dart';
import '../../../category_page/feature_grid.dart';
import '../../../category_page/footer_section.dart';

class FoodFarmacyTab extends StatefulWidget {
  const FoodFarmacyTab({super.key});

  @override
  State<FoodFarmacyTab> createState() => _FoodFarmacyTabState();
}

// All per-breakpoint sizing for a concern card, in one place — used both
// to compute the grid's mainAxisExtent and to actually render the card,
// so the two can never drift out of sync (the same pattern used for the
// product cards in category_product_card.dart).
class _ConcernCardSizing {
  final double thumbSize;
  final double titleSize;
  final double descSize;
  final double exploreSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double gapAfterThumb;
  final double gapAfterTitle;
  final double gapAfterDesc;

  const _ConcernCardSizing({
    required this.thumbSize,
    required this.titleSize,
    required this.descSize,
    required this.exploreSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.gapAfterThumb,
    required this.gapAfterTitle,
    required this.gapAfterDesc,
  });

  static _ConcernCardSizing forBreakpoint(ScreenSizeHelper responsive) {
    if (responsive.isMobile) {
      return const _ConcernCardSizing(
        thumbSize: 44,
        titleSize: 11,
        descSize: 9,
        exploreSize: 9,
        horizontalPadding: 14,
        verticalPadding: 18,
        gapAfterThumb: 12,
        gapAfterTitle: 10,
        gapAfterDesc: 15,
      );
    } else if (responsive.isTablet) {
      return const _ConcernCardSizing(
        thumbSize: 50,
        titleSize: 12,
        descSize: 10,
        exploreSize: 9.5,
        horizontalPadding: 18,
        verticalPadding: 20,
        gapAfterThumb: 14,
        gapAfterTitle: 12,
        gapAfterDesc: 16,
      );
    } else if (responsive.isLaptop) {
      return const _ConcernCardSizing(
        thumbSize: 56,
        titleSize: 13,
        descSize: 10.5,
        exploreSize: 10,
        horizontalPadding: 20,
        verticalPadding: 22,
        gapAfterThumb: 15,
        gapAfterTitle: 13,
        gapAfterDesc: 17,
      );
    } else if (responsive.isDesktop) {
      return const _ConcernCardSizing(
        thumbSize: 60,
        titleSize: 14,
        descSize: 11,
        exploreSize: 10.5,
        horizontalPadding: 20,
        verticalPadding: 24,
        gapAfterThumb: 16,
        gapAfterTitle: 14,
        gapAfterDesc: 18,
      );
    } else {
      return const _ConcernCardSizing(
        thumbSize: 64,
        titleSize: 15,
        descSize: 11.5,
        exploreSize: 11,
        horizontalPadding: 22,
        verticalPadding: 26,
        gapAfterThumb: 17,
        gapAfterTitle: 15,
        gapAfterDesc: 19,
      );
    }
  }

  // 2-line title, 3-line description, both estimated with a ~1.3–1.5x
  // line-height factor, plus the "Explore >" row.
  double get mainAxisExtent =>
      verticalPadding +
          thumbSize +
          gapAfterThumb +
          (titleSize * 1.25 * 2) +
          gapAfterTitle +
          (descSize * 1.5 * 3) +
          gapAfterDesc +
          (exploreSize * 1.3) +
          verticalPadding;
}

class _FoodFarmacyTabState extends State<FoodFarmacyTab> {
  final GlobalKey _formulationKey = GlobalKey();
  final GlobalKey _coverImageKey = GlobalKey();
  final GlobalKey _productsKey = GlobalKey();

  int selectedIndex = 0;
  int hoveredIndex = -1;

  ClusterList? get selectedCluster {
    final provider = context.read<ShopProvider>();

    if (provider.clusterList.isEmpty) return null;

    return provider.clusterList[selectedIndex];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchClusterList();
    });

    final provider = context.read<ShopProvider>();
    if (provider.clusterList.isNotEmpty) {
      selectedIndex = 0;
    }
  }

  void _scrollToFormulation() {
    if (!mounted) return;
    final contextKey = _formulationKey.currentContext;
    if (contextKey == null) return;

    Scrollable.ensureVisible(
      contextKey,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.1, // slightly from top
    );
  }

  void _scrollToProducts() {
    final context = _productsKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    final provider = context.watch<ShopProvider>();

    final foodFarmacyCategory = provider.allCategories.firstWhere(
      (e) => (e.name ?? "").toLowerCase().trim().contains("food farmacy"),
      orElse: () => provider.allCategories.first,
    );

    bool isValidImage(String? url) =>
        url != null && url.trim().isNotEmpty && url != 'null';

    final showCoverSection = isValidImage(foodFarmacyCategory.coverImage);

    return provider.isLoading(ShopLoadingType.getClusterList)
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: LoadingIndicator(),
          )
        : Column(
            children: [
              CategoryBanner(
                category: foodFarmacyCategory,
                isFoodFarmacy: _scrollToFormulation,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.isMobile ? 0 : 100),
                child: Column(
                  children: [

                    buildIntroSection(context,foodFarmacyCategory),
                    KeyedSubtree(
                      key: _formulationKey,
                      child: formulation(responsive,provider,foodFarmacyCategory),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),
              if (showCoverSection) ...[
                Builder(
                  key: _coverImageKey,
                  builder: (context) {
                    return FooterSection(
                      footerThumbnail: selectedCluster?.comboThumbnailUrl,
                      footerTitle: selectedCluster?.clusterComboName,
                      footerDescription: selectedCluster?.comboDescription,
                      isFoodFarmacy: true,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
              // ✅ Only show FeatureGrid if points exist
              if ((selectedCluster?.clusterBenefitsUrls ?? []).isNotEmpty) ...[
                SizedBox(height: 40),
                FeatureGrid(
                  category: selectedCluster!.clusterBenefitsUrls,
                  color: foodFarmacyCategory.color,
                ),
              ],
              SizedBox(height: 40),
              FooterSection(
                footerThumbnail: foodFarmacyCategory.footerThumnail,
                footerTitle: foodFarmacyCategory.footerTitle,
                footerDescription: foodFarmacyCategory.footerDescription,
                footerHighlightText: foodFarmacyCategory.footerHighlightText,
              ),
            ],
          );
  }

  Widget buildIntroSection(BuildContext context,CategoryList category) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final responsive = ScreenSizeHelper(context);

    // Font sizes - like FooterSection pattern
    final titleSize = responsive.isMobile
        ? 32.0
        : responsive.isTablet
        ? 44.0
        : responsive.isLaptop
        ? 56.0
        : 66.0;

    final descSize = responsive.isMobile
        ? 14.0
        : responsive.isTablet
        ? 16.0
        : 20;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            "CHOOSE WHAT FEELS FAMILIAR",
            style: TextStyle(
              color: gMainColor,
              fontSize: isDesktop ? 14 : 10,
              fontFamily: fontMedium,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          HtmlWidget(
            category.subTextHeading ?? '',
            customStylesBuilder: (element) {
              if (element.localName == 'h1' ||
                  element.localName == 'h2' ||
                  element.localName == 'p' ||
                  element.localName == 'span' ||
                  element.localName == 'div') {
                return {
                  'font-size': '${titleSize}px',
                };
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          HtmlWidget(
            category.subTextDescription ?? '',
            customStylesBuilder: (element) {
              if (element.localName == 'p' ||
                  element.localName == 'span' ||
                  element.localName == 'h1' ||
                  element.localName == 'div') {
                return {
                  'font-size': '${descSize}px',
                };
              }
              return null;
            },
          ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
          // /// Heading
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: "Is your gut ",
          //         style: TextStyle(
          //           color: const Color(0xff231F20),
          //           fontSize: isDesktop ? 50 : 20,
          //           fontFamily: fontBold,
          //           height: 1,
          //         ),
          //       ),
          //       TextSpan(
          //         text: "asking",
          //         style: TextStyle(
          //           color: const Color(0xff971B1E),
          //           fontSize: isDesktop ? 50 : 20,
          //           fontFamily: fontBold,
          //           height: 1,
          //         ),
          //       ),
          //       TextSpan(
          //         text: "—\n",
          //         style: TextStyle(
          //           color: const Color(0xff231F20),
          //           fontSize: isDesktop ? 50 : 20,
          //           fontFamily: fontBold,
          //           height: 1,
          //         ),
          //       ),
          //       TextSpan(
          //         text: "or warning you?",
          //         style: TextStyle(
          //           color: const Color(0xff231F20),
          //           fontSize: isDesktop ? 50 : 20,
          //           fontFamily: fontBold,
          //           height: 1,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //
          // SizedBox(height: isDesktop ? 10 : 10),
          //
          // /// Description
          // RichText(
          //   text: TextSpan(
          //     style: TextStyle(
          //       fontSize: isDesktop ? 18 : 12,
          //       fontFamily: fontBook,
          //       color: gBlackColor,
          //       height: 1.6,
          //     ),
          //     children: const [
          //       TextSpan(
          //         text: "Begin with the concern, not the product.\n",
          //         style: TextStyle(
          //           color: gPrimaryColor,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       TextSpan(
          //         text:
          //             "Each concern leads to the most relevant\nFood Farmacy formulation.",
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

 Widget formulation(ScreenSizeHelper responsive, ShopProvider provider,CategoryList category){
    final cluster = provider.clusterList;

    // Fixed 4 columns on tablet and up, 2 on mobile — was previously
    // 5/3/2 via the old binary ResponsiveHelper, which didn't match the
    // design's strict 4-column grid.
    final crossAxisCount = responsive.isMobile ? 2 : 4;

    final cardSizing = _ConcernCardSizing.forBreakpoint(responsive);

    final horizontalPadding = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 40.0
        : responsive.isLaptop
        ? 60.0
        : 60.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cluster.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              // Computed from the card's actual content instead of a
              // guessed childAspectRatio — keeps the card height
              // matched to its content at every breakpoint instead of
              // a fixed ratio that only fits at one specific width.
              mainAxisExtent: cardSizing.mainAxisExtent,
            ),
            itemBuilder: (context, index) {
              return buildConcernCard(cluster[index], index, cardSizing)
                  .animate()
                  .fade(
                delay: Duration(milliseconds: index * 80),
                duration: 500.ms,
              )
                  .slideY(
                begin: .15,
                delay: Duration(milliseconds: index * 80),
                duration: 500.ms,
                curve: Curves.easeOut,
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            "FOOD-FARMACY RECOMMENDATIONS",
            style: TextStyle(
              color: gMainColor,
              fontSize: responsive.isMobile ? 10 : 14,
              fontFamily: fontMedium,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Your purposeful\nfood response",
            style: TextStyle(
              color: gBlackColor,
              fontSize: responsive.isMobile
                  ? 30
                  : responsive.isTablet
                  ? 40
                  : responsive.isLaptop
                  ? 55
                  : 62,
              fontFamily: fontBold,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: responsive.isMobile
                ? double.infinity
                : responsive.isTablet
                ? 420
                : responsive.isLaptop
                ? 520
                : 580,
            child: Text(
              "Based on the concern you selected, these are the most relevant Food Farmacy formulations for what your gut is experiencing—purposefully made to support this moment and gently guide your gut back to rhythm.",
              style: TextStyle(
                color: const Color(0xff3B3B3B),
                fontSize: responsive.isMobile
                    ? 14
                    : responsive.isTablet
                    ? 16
                    : 18,
                fontFamily: "Courier Prime", // monospace like screenshot
                fontWeight: FontWeight.w500,
                height: 1.45,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(height: 20),
          KeyedSubtree(
            key: _productsKey,
            child: AdditionalProductsGrid(
              products: selectedCluster?.productsData ?? [],
              category: category,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget buildConcernCard(
      ClusterList item,
      int index,
      _ConcernCardSizing sizing,
      ) {
    final isHovered = hoveredIndex == index;
    final isSelected = selectedIndex == index;
    final active = isHovered || isSelected;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween(begin: 1, end: active ? 1.03 : 1),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() => hoveredIndex = index);
            },
            onExit: (_) {
              setState(() => hoveredIndex = -1);
            },
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToProducts();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,

                decoration: BoxDecoration(
                  color: active ? gsecondaryColor : gWhiteColor,

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(color: gMainColor, width: 1.5),

                  boxShadow: [
                    if (active)
                      BoxShadow(
                        color: gBlackColor.withAlpha(15),
                        blurRadius: 10,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),

                padding: EdgeInsets.symmetric(
                  horizontal: sizing.horizontalPadding),

                // Was MainAxisAlignment.center, which centered the whole
                // content block vertically — but the design shows the
                // icon anchored near the top and "Explore" anchored
                // near the bottom, not a centered stack. Column defaults
                // to MainAxisAlignment.start, which — combined with
                // mainAxisExtent now matching the content closely above
                // — keeps content top-anchored instead.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: active ? 1.12 : 1,
                      duration: const Duration(milliseconds: 250),
                      child: ThumbnailView(
                        imageUrl: item.clusterThumbnailUrl ?? '',
                        context: context,
                        enablePreview: false,
                        height: sizing.thumbSize,
                        width: sizing.thumbSize,
                      ),
                    ),

                    SizedBox(height: sizing.gapAfterThumb),
                    HtmlWidget(
                      item.clusterName ?? "",
                      customStylesBuilder: (element) {
                        if (element.localName == 'p' ||
                            element.localName == 'span' ||
                            element.localName == 'h1' ||
                            element.localName == 'div') {
                          return {
                            'font-size': '${sizing.titleSize}px',
                            'text-align': 'center',
                            'color': active ? '#FFFFFF' : '#355C4A', // or your hex color
                            'margin': '0',
                            'padding': '0',
                          };
                        }
                        return null;
                      },
                    ),
                    // Text(
                    //   (item.clusterName ?? '').toUpperCase(),
                    //   textAlign: TextAlign.center,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //     fontFamily: fontBold,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: sizing.titleSize,
                    //     height: 1.2,
                    //     color: active ? gWhiteColor : gsecondaryColor,
                    //   ),
                    // ),

                    SizedBox(height: sizing.gapAfterTitle),

                    Text(
                      item.clusterDescription ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: fontBook,
                        fontSize: sizing.descSize,
                        height: 1.4,
                        color: active ? gWhiteColor : gsecondaryColor,
                      ),
                    ),

                    SizedBox(height: sizing.gapAfterDesc),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Explore",
                          style: TextStyle(
                            fontFamily: fontBook,
                            fontSize: sizing.exploreSize,
                            color: gMainColor,
                          ),
                        ),

                        const SizedBox(width: 4),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: sizing.exploreSize + 2,
                          color: gMainColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../utils/constants.dart';
// import '../../../../utils/responsive_helper.dart';
// import '../shop_tab/widgets/clock_section/clock_top_slider.dart';
// import '../shop_tab/widgets/clock_section/clock_vertical_slider.dart';
//
// class FoodFarmacyTab extends StatefulWidget {
//   const FoodFarmacyTab({super.key});
//
//   @override
//   State<FoodFarmacyTab> createState() => _FoodFarmacyTabState();
// }
//
// class _FoodFarmacyTabState extends State<FoodFarmacyTab> {
//
//   int selected = 0;
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = ResponsiveHelper(context).isDesktop;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: isDesktop ? 150 : 20,
//         vertical: isDesktop ? 40 : 30,
//       ),
//       child: Column(
//         children: [
//           isDesktop
//               ? Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(flex: 4, child: leftSection()),
//                     SizedBox(width: 20),
//                     Expanded(flex: 6, child: GutClockTopSlider()),
//                   ],
//                 )
//               : Column(
//                   children: [
//                     leftSection(),
//                     SizedBox(height: 30),
//                     GutClockTopSlider(),
//                   ],
//                 ),
//           SizedBox(height: 20),
//           _timeline(),
//           const SizedBox(height: 10),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 500),
//             switchInCurve: Curves.easeOut,
//             switchOutCurve: Curves.easeIn,
//             child: selected < 3
//                 ? Row(
//               key: const ValueKey("leftLayout"),
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// LEFT CONTENT
//                 Expanded(
//                   flex: 7,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _story(selected),
//                       const SizedBox(height: 40),
//                       _button(),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//
//                 /// RIGHT PRODUCTS
//                 const Expanded(flex: 2, child: GutClockVerticalSlider()),
//               ],
//             )
//                 : Row(
//               key: const ValueKey("rightLayout"),
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// LEFT PRODUCTS
//                 const Expanded(flex: 2, child: GutClockVerticalSlider()),
//                 const SizedBox(width: 40),
//
//                 /// RIGHT CONTENT
//                 Expanded(
//                   flex: 7,
//                   child: Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _story(selected),
//                         const SizedBox(height: 40),
//                         _button(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget leftSection() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Gut out of\nRhythm?",
//                     style: GoogleFonts.inter(
//                       fontSize: 56,
//                       fontWeight: FontWeight.w700,
//                       height: .95,
//                       color: const Color(0xff231F20),
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//                   Transform.rotate(
//                     angle: -.08,
//                     child: Text(
//                       "Meet Food Farmacy",
//                       style: GoogleFonts.caveat(
//                         color: const Color(0xffB7861A),
//                         fontSize: 34,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ).animate(delay: 400.ms).fade().slideY(begin: .4),
//                 ],
//               ),
//             ),
//
//             Image.asset("assets/images/food_farmacy_arrow.png", width: 90)
//                 .animate(onPlay: (c) => c.repeat(reverse: true))
//                 .moveX(begin: 0, end: 6, duration: 1200.ms),
//           ],
//         ),
//         const SizedBox(height: 20),
//
//         Text(
//           "The everyday idea of food as medicine.\n"
//           "Food Farmacy brings targeted formulations "
//           "for gas, bloating, acidity, burping, "
//           "constipation and poor digestion using "
//           "familiar, time-tested ingredients in the "
//           "right form and dose for the moment your "
//           "gut needs support.\n"
//           "Right food. Right concern. "
//           "A gentler way back to rhythm.",
//           style: GoogleFonts.ibmPlexMono(
//             fontSize: 13,
//             height: 1.55,
//             color: Colors.grey.shade700,
//           ),
//         ).animate().fade(delay: 300.ms).slideY(begin: .15),
//       ],
//     );
//   }
//
//   Widget _timeline() {
//     final icons = [
//       Icons.no_meals_rounded,
//       Icons.local_fire_department_outlined,
//       Icons.sync_alt_rounded,
//       Icons.air_rounded,
//       Icons.bubble_chart_outlined,
//       Icons.record_voice_over_outlined,
//     ];
//
//     final foods = [
//       "POOR\nDIGESTION",
//       "ACIDITY",
//       "CONSTIPATION",
//       "GAS",
//       "BLOATING",
//       "BURPING",
//     ];
//
//     // final questions = [
//     //   "Food feels heavy after eating?",
//     //   "Burning sensation after meals?",
//     //   "Not passing stools regularly?",
//     //   "Gas after every meal?",
//     //   "Feeling bloated after eating?",
//     //   "Frequent burping throughout the day?",
//     // ];
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final itemWidth = constraints.maxWidth / icons.length;
//
//         return Column(
//           children: [
//             /// ICONS + TIME
//             SizedBox(
//               height: 40,
//               child: Row(
//                 children: List.generate(
//                   icons.length,
//                       (index) {
//                     final active = selected == index;
//
//                     return Expanded(
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           setState(() {
//                             selected = index;
//                           });
//                         },
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 250),
//                           padding: const EdgeInsets.symmetric(vertical: 4),
//                           decoration: BoxDecoration(
//                             color: active
//                                 ? Colors.grey.shade100
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               AnimatedScale(
//                                 duration: const Duration(milliseconds: 250),
//                                 scale: active ? 1.08 : 1,
//                                 child: Icon(
//                                   icons[index],
//                                   size: active ? 24 : 22,
//                                   color: const Color(0xffD89C00),
//                                 ),
//                               ),
//
//                               const SizedBox(height: 4),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//
//             /// TIMELINE
//             SizedBox(
//               height: 20,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: itemWidth / 2,
//                     right: itemWidth / 2,
//                     top: 9,
//                     child: Container(
//                       height: 2,
//                       color: Colors.grey.shade300,
//                     ),
//                   ),
//
//                   Row(
//                     children: List.generate(
//                       icons.length,
//                           (index) {
//                         return Expanded(
//                           child: Center(
//                             child: Container(
//                               width: 9,
//                               height: 9,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border.all(
//                                   color: Colors.grey.shade400,
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//
//                   AnimatedPositioned(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeOut,
//                     left: (itemWidth * selected) +
//                         itemWidth / 2 -
//                         5,
//                     top: 4,
//                     child: Container(
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                         color: const Color(0xffD89C00),
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 2,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//             /// FOOD NAMES
//             Row(
//               children: List.generate(
//                 foods.length,
//                     (index) {
//                   final active = selected == index;
//
//                   return Expanded(
//                     child: AnimatedDefaultTextStyle(
//                       duration: const Duration(milliseconds: 250),
//                       style: TextStyle(
//                         fontFamily: active ? fontBold : fontMedium,
//                         fontSize: 11,
//                         color: active
//                             ? const Color(0xffD89C00)
//                             : Colors.grey.shade700,
//                       ),
//                       child: Text(
//                         foods[index],
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             /// MOVING ARROW
//             SizedBox(
//               height: 70,
//               child: Stack(
//                 children: [
//                   AnimatedPositioned(
//                     duration: const Duration(milliseconds: 350),
//                     curve: Curves.easeOut,
//                     left: (itemWidth * selected) +
//                         (itemWidth / 2) -
//                         18,
//                     child: Image.asset(
//                       "assets/images/tab_arrow.png",
//                       height: 70,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   final titles = [
//     "Dear you,",
//     "Good Morning,",
//     "Stay Fresh,",
//     "Lunch Time,",
//     "Tea Time,",
//     "Relax,",
//   ];
//
//   final subtitles = [
//     "Begin gently. Let the rest of the day build better.",
//     "Fuel your morning with nourishment.",
//     "Keep your energy steady.",
//     "Give your gut something comforting.",
//     "A light pause makes a better evening.",
//     "End your day with warmth.",
//   ];
//
//   Widget _story(int index) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 400),
//
//       child: Column(
//         key: ValueKey(index),
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             titles[index],
//             style: GoogleFonts.caveat(
//               fontSize: 34,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           Text(
//             "A steadier day can begin with something gentle.\n"
//                 "Ambali brings fermented millet nourishment in a\n"
//                 "light, sippable form helping you begin well.\n\n"
//                 "Every moment has the right food.\n"
//                 "Give your gut what it needs.",
//             style: GoogleFonts.caveat(fontSize: 27, height: 1.6),
//           ),
//
//           const SizedBox(height: 24),
//
//           Text(
//             subtitles[index],
//             style: GoogleFonts.caveat(
//               color: const Color(0xffD89C00),
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _button() {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         width: 240,
//         height: 56,
//         decoration: BoxDecoration(
//           color: const Color(0xff9A1A1F),
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Begin My Morning",
//               style: GoogleFonts.inter(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             const SizedBox(width: 18),
//
//             const Icon(Icons.arrow_forward, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }
