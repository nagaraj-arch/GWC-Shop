import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gwc_shop/controllers/models/shop_models/category_model.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/food_farmacy_tab/widgets/explore_other_products.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/food_farmacy_tab/widgets/feature_grid.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/widgets/loading_widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/button_widgets/button_widget.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../category_page/category_banner.dart';
import '../../../category_page/category_product_card.dart';
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
        thumbSize: 80,
        titleSize: 18,
        descSize: 13,
        exploreSize: 13,
        horizontalPadding: 20,
        verticalPadding: 22,
        gapAfterThumb: 15,
        gapAfterTitle: 13,
        gapAfterDesc: 17,
      );
    } else if (responsive.isDesktop) {
      return const _ConcernCardSizing(
        thumbSize: 90,
        titleSize: 20,
        descSize: 12,
        exploreSize: 10.5,
        horizontalPadding: 20,
        verticalPadding: 24,
        gapAfterThumb: 16,
        gapAfterTitle: 14,
        gapAfterDesc: 18,
      );
    } else {
      return const _ConcernCardSizing(
        thumbSize: 100,
        titleSize: 22,
        descSize: 13,
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
  final GlobalKey _exploreProductsKey = GlobalKey();

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

  void _scrollToExploreProducts() {
    final context = _exploreProductsKey.currentContext;
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

    final contentHorizontalPadding = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 40.0
        : responsive.isLaptop
        ? 80.0
        : responsive.isDesktop
        ? 120.0
        : 150.0;

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
                  horizontal: contentHorizontalPadding,
                ),
                child: Column(
                  children: [
                    buildIntroSection(
                      context,
                      "WHAT IS YOUR GUT POINTING TO?",
                      foodFarmacyCategory.subTextHeading ?? "",
                      foodFarmacyCategory.subTextDescription ?? "",
                    ),
                    // SizedBox(height: 60),
                    Align(alignment: Alignment.topLeft,
                      child: ButtonWidget(
                        text: "Explore Individual Products",
                        onPressed: _scrollToExploreProducts,
                        isLoading: false,
                      ),
                    ),
                    SizedBox(height: 40),
                    KeyedSubtree(
                      key: _formulationKey,
                      child: formulation(
                        responsive,
                        provider,
                        foodFarmacyCategory,
                      ),
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
              KeyedSubtree(
                key: _exploreProductsKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: contentHorizontalPadding,
                    vertical: 60,
                  ),
                  child: ExploreOtherProducts(clr: foodFarmacyCategory.color),
                ),
              ),
              FooterSection(
                footerThumbnail: foodFarmacyCategory.footerThumnail,
                footerThumbnailMobile: foodFarmacyCategory.footerThumnailMobile,
                footerThumbnailTab: foodFarmacyCategory.footerThumnailTab,
                footerThumbnailLaptop: foodFarmacyCategory.footerThumnailLaptop,
                footerThumbnailDesktop:
                    foodFarmacyCategory.footerThumnailDesktop,
                footerTitle: foodFarmacyCategory.footerTitle,
                footerDescription: foodFarmacyCategory.footerDescription,
                footerHighlightText: foodFarmacyCategory.footerHighlightText,
              ),
            ],
          );
  }

  Widget buildIntroSection(
    BuildContext context,
    String text,
    String title,
    String desc,
  ) {
    final responsive = ScreenSizeHelper(context);

    final titleSize = responsive.isMobile
        ? 34.0
        : responsive.isTablet
        ? 46.0
        : responsive.isLaptop
        ? 66.0
        : responsive.isDesktop
        ? 82.0
        : responsive.isLargeDesktop
        ? 95.0
        : 105.0;

    final descSize = responsive.isMobile
        ? 14.0
        : responsive.isTablet
        ? 16.0
        : responsive.isLaptop
        ? 18.0
        : responsive.isDesktop
        ? 20.0
        : 22.0;

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            text,
            style: TextStyle(
              color: gMainColor,
              fontSize: responsive.isMobile ? 10 : 14,
              fontFamily: fontMedium,
              letterSpacing: 1,
            ),
          ),
          SizedBox(
            height: responsive.isMobile
                ? 8
                : responsive.isTablet
                ? 12
                : 16,
          ),
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
                  return {'font-size': '${descSize}px'};
                }
                return null;
              },
              textStyle: TextStyle(
                height: 1.31, // Line spacing
                letterSpacing: 1.5, // Letter spacing
              ),
            ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget formulation(
    ScreenSizeHelper responsive,
    ShopProvider provider,
    CategoryList category,
  ) {
    final cluster = provider.clusterList;

    // Fixed 4 columns on tablet and up, 2 on mobile — was previously
    // 5/3/2 via the old binary ResponsiveHelper, which didn't match the
    // design's strict 4-column grid.
    final crossAxisCount = responsive.isMobile ? 2 : 4;

    final cardSizing = _ConcernCardSizing.forBreakpoint(responsive);

    final title = """
<h1 style="font-family:'Archivo Narrow'; font-weight:600;">
  Your purposeful<br>
  food response
</h1>
""";

    final desc = """
<p style="font-family:'Courier Prime'; font-weight:400; font-size:inherit;font-style:italic;text-align: justify;"">
  <span style="color:#786f68;">
   Based on the concern you selected,<br/>
    these are the most relevant Food Farmacy <br/>
    formulations for what your gut is <br/>
    experiencing—purposefully made to <br/>
    support this moment and gently guide <br/>
    your gut back to rhythm.
  </span>
</p>
""";
    return Container(
      width: double.infinity,
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
              return buildConcernCard(
                    cluster[index],
                    index,
                    cardSizing,
                    category,
                  )
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
          buildIntroSection(
            context,
            "FOOD-FARMACY RECOMMENDATIONS",
            title,
            desc,
          ),
          // Text(
          //   "FOOD-FARMACY RECOMMENDATIONS",
          //   style: TextStyle(
          //     color: gMainColor,
          //     fontSize: responsive.isMobile ? 10 : 14,
          //     fontFamily: fontMedium,
          //     letterSpacing: 0.8,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          //
          // const SizedBox(height: 6),
          //
          // Text(
          //   "Your purposeful\nfood response",
          //   style: TextStyle(
          //     color: gBlackColor,
          //     fontSize: responsive.isMobile
          //         ? 30
          //         : responsive.isTablet
          //         ? 40
          //         : responsive.isLaptop
          //         ? 55
          //         : 62,
          //     fontFamily: fontBold,
          //     fontWeight: FontWeight.w600,
          //     height: 1.2,
          //   ),
          // ),
          //
          // const SizedBox(height: 14),
          //
          // SizedBox(
          //   width: responsive.isMobile
          //       ? double.infinity
          //       : responsive.isTablet
          //       ? 420
          //       : responsive.isLaptop
          //       ? 520
          //       : 580,
          //   child: Text(
          //     "Based on the concern you selected, these are the most relevant Food Farmacy formulations for what your gut is experiencing—purposefully made to support this moment and gently guide your gut back to rhythm.",
          //     style: TextStyle(
          //       color: const Color(0xff3B3B3B),
          //       fontSize: responsive.isMobile
          //           ? 14
          //           : responsive.isTablet
          //           ? 16
          //           : 18,
          //       fontFamily: "Courier Prime", // monospace like screenshot
          //       fontWeight: FontWeight.w500,
          //       height: 1.45,
          //       letterSpacing: 0.15,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20),
          KeyedSubtree(
            key: _productsKey,
            child: AdditionalProductsGrid(
              products: selectedCluster?.productsData ?? [],
              category: category.color,
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
    CategoryList category,
  ) {
    final isHovered = hoveredIndex == index;
    final isSelected = selectedIndex == index;
    final active = isHovered || isSelected;

    final clr = Color(0xff941d22);

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
                  color: active ? clr : gWhiteColor,

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
                  horizontal: sizing.horizontalPadding,
                ),

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
                      textStyle: TextStyle(
                        color: active ? gWhiteColor : category.color,
                      ),
                      customStylesBuilder: (element) {
                        if (element.localName == 'p' ||
                            element.localName == 'span' ||
                            element.localName == 'h1' ||
                            element.localName == 'div') {
                          return {
                            'font-size': '${sizing.titleSize}px',
                            'text-align': 'center',
                            'color': active
                                ? '#FFFFFF'
                                : '#355C4A', // or your hex color
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
                        color: active ? gWhiteColor : category.color,
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
