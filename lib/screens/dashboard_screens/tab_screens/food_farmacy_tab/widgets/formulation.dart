import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gwc_shop/widgets/iamge_picker_widget/thumbnail_view.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/models/shop_models/category_model.dart';
import '../../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../controllers/providers/shop_provider.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/responsive_helper.dart';
import '../../../../product_screens/widgets/product_details_dialog.dart';
import '../../../widgets/common_cart_button.dart';

class Formulation extends StatefulWidget {
  final CategoryList category;
  const Formulation({super.key, required this.category});

  @override
  State<Formulation> createState() => _FormulationState();
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

class _FormulationState extends State<Formulation> {
  int selectedIndex = 0;
  int hoveredIndex = -1;

  List<Products> get products {
    final provider = context.read<ShopProvider>();

    if (provider.clusterList.isEmpty) return [];

    return provider.clusterList[selectedIndex].productsData ?? [];
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ShopProvider>();
    if (provider.clusterList.isNotEmpty) {
      selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final provider = context.watch<ShopProvider>();
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
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 5),
          Text(
            "Your next step\nback to rhythm",
            style: TextStyle(
              color: const Color(0xff231F20),
              fontSize: responsive.isMobile
                  ? 20
                  : responsive.isTablet
                  ? 30
                  : responsive.isLaptop
                  ? 40
                  : 50,
              fontFamily: fontBold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          productGrid(),
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
                  horizontal: sizing.horizontalPadding,
                  vertical: sizing.verticalPadding,
                ),

                // Was MainAxisAlignment.center, which centered the whole
                // content block vertically — but the design shows the
                // icon anchored near the top and "Explore" anchored
                // near the bottom, not a centered stack. Column defaults
                // to MainAxisAlignment.start, which — combined with
                // mainAxisExtent now matching the content closely above
                // — keeps content top-anchored instead.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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

                    Text(
                      (item.clusterName ?? '').toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: fontBold,
                        fontWeight: FontWeight.bold,
                        fontSize: sizing.titleSize,
                        height: 1.2,
                        color: active ? gWhiteColor : gsecondaryColor,
                      ),
                    ),

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

  Widget productGrid() {
    final screen = ScreenSizeHelper(context);

    int crossAxisCount;
    // Every tier kept in a consistent landscape range (previously swung
    // from 1.8 down to 1.1 and even 0.95 — near-square/portrait — at
    // some breakpoints, but the card's internal layout is always a
    // landscape Row[image, text] and gets awkwardly squeezed at those
    // ratios instead of scaling gracefully).
    double childAspectRatio;

    if (screen.isUltraWide) {
      crossAxisCount = 3;
      childAspectRatio = 1.8;
    } else if (screen.isLargeDesktop) {
      crossAxisCount = 3;
      childAspectRatio = 1.75;
    } else if (screen.isDesktop) {
      crossAxisCount = 2;
      childAspectRatio = 1.65;
    } else if (screen.isLaptop) {
      crossAxisCount = 2;
      childAspectRatio = 1.6;
    } else if (screen.isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 1.45;
    } else {
      // Mobile — still landscape, just a bit more compact.
      crossAxisCount = 1;
      childAspectRatio = 1.35;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: screen.isDesktop ? 24.0 : 16.0,
        mainAxisSpacing: screen.isDesktop ? 24.0 : 16.0,
      ),
      itemBuilder: (_, index) {
        return _productCard(products[index]);
      },
    );
  }

  Widget _productCard(Products p, {bool pairWith = false}) {
    final screen = ScreenSizeHelper(context);

    final isDesktop =
        screen.isDesktop || screen.isLargeDesktop || screen.isUltraWide;

    final cardColor = widget.category.color;

    // Responsive font sizes
    final titleSize = screen.isUltraWide
        ? 32.0
        : screen.isLargeDesktop
        ? 28.0
        : screen.isDesktop
        ? 24.0
        : screen.isLaptop
        ? 18.0
        : screen.isTablet
        ? 16.0
        : 14.0;

    final priceSize = screen.isDesktop
        ? 24.0
        : screen.isLaptop
        ? 18.0
        : screen.isTablet
        ? 16.0
        : 14.0;

    final smallTextSize = isDesktop ? 11.0 : 10.0;
    final timingTextSize = isDesktop ? 12.0 : 11.0;

    final iconSizeMain = isDesktop ? 18.0 : 15.0;
    final arrowIconSize = isDesktop ? 18.0 : 15.0;
    final scheduleIconSize = 18.0;

    final orderQuantity = "${p.itemQty}${p.weightType?.unit}";
    final orderServings = p.servings;

    final List<String> values = [];

    if (orderQuantity.isNotEmpty && orderQuantity != "null") {
      values.add(orderQuantity);
    }

    if (orderServings != null &&
        orderServings.isNotEmpty &&
        orderServings != "null") {
      values.add("$orderServings Servings");
    }

    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    final String thumbnailUrl = p.productThumbnailsUrls?.isNotEmpty == true
        ? p.productThumbnailsUrls!.first
        : p.productThumbnails?.isNotEmpty == true
        ? p.productThumbnails!.first
        : "";

    // Padding & spacing
    final cardPadding = isDesktop ? 22.0 : 16.0;
    final innerSpacing = isDesktop ? 14.0 : 10.0;
    final imageRadius = isDesktop ? 12.0 : 10.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gBlackColor.withAlpha(08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ThumbnailView(
                      imageUrl: thumbnailUrl,
                      context: context,
                      width: double.maxFinite,
                      height: double.maxFinite,
                      // BoxFit.fill stretches the product photo non-
                      // uniformly; BoxFit.cover preserves its real
                      // proportions and crops to fill instead.
                      fit: BoxFit.cover,
                      borderRadius: imageRadius,
                    ),
                  ),
                  SizedBox(width: innerSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: innerSpacing),
                        Row(
                          children: [
                            Icon(
                              Icons.local_florist,
                              color: gMainColor,
                              size: iconSizeMain,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pairWith ? "PAIR WITH" : "BEST FOR",
                              style: TextStyle(
                                color: gMainColor,
                                fontFamily: fontMedium,
                                fontSize: smallTextSize,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.productTitle ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: gWhiteColor,
                            fontFamily: fontBold,
                            fontSize: titleSize,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹${double.parse(p.discountPrice ?? '').toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: priceSize,
                            fontFamily: fontBold,
                            color: gWhiteColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          values.join(" | "),
                          style: TextStyle(
                            fontSize: smallTextSize,
                            fontFamily: fontMedium,
                            color: gWhiteColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) {
                                return ProductDetailsDialog(item: p);
                              },
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "What's inside",
                                style: TextStyle(
                                  color: const Color(0xffE7D5C3),
                                  fontSize: smallTextSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.login_outlined,
                                size: arrowIconSize,
                                color: const Color(0xffE7D5C3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Direction for Use",
                                style: TextStyle(
                                  color: const Color(0xffE7D5C3),
                                  fontSize: smallTextSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.login_outlined,
                                size: arrowIconSize,
                                color: const Color(0xffE7D5C3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: innerSpacing),

            ///================ TIMING STRIP =================
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 16 : 12,
                vertical: isDesktop ? 10 : 8,
              ),
              decoration: BoxDecoration(
                color: gMainColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: scheduleIconSize,
                    color: gBlackColor,
                  ),
                  SizedBox(width: isDesktop ? 12 : 8),
                  Expanded(
                    child: Text(
                      "15 mins before heavy or slow-to-digest meals",
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: fontMedium,
                        fontSize: timingTextSize,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: innerSpacing),

            SizedBox(
              width: double.infinity,
              child: CommonCartButton(
                product: p,
                color: cardColor,
                height: isDesktop ? 34.0 : 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
