import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/all_products_tab/widgets/mobile_catg_highlight.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/all_products_tab/widgets/recommented_products_Section.dart';
import 'package:gwc_shop/screens/dashboard_screens/widgets/banner_section.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/category_model.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../../widgets/loading_widgets/loading_indicator.dart';
import '../../../category_page/category_product_card.dart';
import '../../../category_page/cover_section.dart';
import '../../../category_page/feature_grid.dart';
import '../../../category_page/footer_section.dart';
import '../../../footer_widget/footer_section.dart';

class CategoryByProducts extends StatefulWidget {
  final CategoryList category;

  const CategoryByProducts({super.key, required this.category});

  @override
  State<CategoryByProducts> createState() => _CategoryByProductsState();
}

class _CategoryByProductsState extends State<CategoryByProducts> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productsGridKey = GlobalKey();
  final GlobalKey _coverImageKey = GlobalKey();

  @override
  void dispose() {
    // Clear cached images when leaving this image-heavy page.
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;

      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    final mobileDesign = responsive.isMobile || responsive.isTablet;

    final category = widget.category;

    bool isValidImage(String? url) =>
        url != null && url.trim().isNotEmpty && url != 'null';

    final showCoverSection =
        isValidImage(category.coverImage) ||
        isValidImage(category.coverImageDesktop) ||
        isValidImage(category.coverImageMobile);

    final showFooterSection =
        isValidImage(category.footerThumnail) ||
        isValidImage(category.footerThumnailDesktop) ||
        isValidImage(category.footerThumnailMobile);

    final contentHorizontalPadding = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 40.0
        : responsive.isLaptop
        ? 80.0
        : responsive.isDesktop
        ? 120.0
        : 150.0;

    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        final isLoading = shopProvider.isLoading(
          ShopLoadingType.getProductsByCategory,
        );

        if (isLoading) {
          return Center(child: LoadingIndicator());
        }

        return mobileDesign
            ? SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    BannerSection(
                      category: category,
                      showCoverSection: showCoverSection,
                      onChooseProducts: () {
                        debugPrint("Choose Products Clicked");
                        _scrollToKey(_productsGridKey);
                      },
                      onLearnMore: () => _scrollToKey(_coverImageKey),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: contentHorizontalPadding,
                        vertical: mobileDesign ? 10 : 30,
                      ),
                      child: Column(
                        children: [
                          mobileDesign
                              ? mobileHeader(
                                  category,
                                  showAllProducts: _showAllProducts,
                                  provider: shopProvider,
                                  onViewAll: () {
                                    setState(() {
                                      _showAllProducts = !_showAllProducts;
                                    });
                                  },
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: leftSection(category),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: rightSection(category),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          // Builder(
                          //   key: _productsGridKey,
                          //   builder: (context) =>
                          //       shopProvider.isLoading(
                          //         ShopLoadingType.getProductsByCategory,
                          //       )
                          //       ? const LoadingIndicator()
                          //       : RecommendedProductsSection(
                          //         products: shopProvider.products,
                          //         category: widget.category.color,
                          //       ),
                          // ),
                          Builder(
                            key: _productsGridKey,
                            builder: (context) =>
                                shopProvider.isLoading(
                                  ShopLoadingType.getProductsByCategory,
                                )
                                ? const LoadingIndicator()
                                : AdditionalProductsGrid(
                                    products: shopProvider.products,
                                    category: widget.category.color,
                                    mobileDesign: mobileDesign,
                                    showAllProducts: _showAllProducts,

                                    afterFirstRow: mobileDesign
                                        ? MobileCategoryHighlight(
                                            category: category,
                                          )
                                        : null,
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
                          return CoverSection(
                            coverImage: widget.category.coverImage,
                            coverImageMobile: widget.category.coverImageMobile,
                            coverImageLaptop: widget.category.coverImageLaptop,
                            coverImageTab: widget.category.coverImageTab,
                            coverImageDesktop:
                                widget.category.coverImageDesktop,
                            coverTitle: widget.category.coverTitle,
                            coverDesc: widget.category.coverDescription,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    FeatureGrid(
                      category: widget.category.importantPoints,
                      color: widget.category.color,
                    ),
                    if (showFooterSection) ...[
                      SizedBox(height: 40),
                      FooterSection(
                        footerThumbnail: widget.category.footerThumnail,
                        footerThumbnailMobile:
                            widget.category.footerThumnailMobile,
                        footerThumbnailTab: widget.category.footerThumnailTab,
                        footerThumbnailLaptop:
                            widget.category.footerThumnailLaptop,
                        footerThumbnailDesktop:
                            widget.category.footerThumnailDesktop,
                        footerTitle: widget.category.footerTitle,
                        footerDescription: widget.category.footerDescription,
                        footerHighlightText:
                            widget.category.footerHighlightText,
                      ),
                      SizedBox(
                        height: responsive.isMobile || responsive.isTablet
                            ? 40
                            : 0,
                      ),
                    ],
                    GwcFooter(),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: contentHorizontalPadding,
                        vertical: 30,
                      ),
                      child: AdditionalProductsGrid(
                        products: shopProvider.products,
                        category: widget.category.color,
                        mobileDesign: mobileDesign,
                        showAllProducts: _showAllProducts,

                        afterFirstRow: mobileDesign
                            ? MobileCategoryHighlight(category: category)
                            : null,
                      ),
                    ),
                    GwcFooter(),
                  ],
                ),
              );
      },
    );
  }

  Widget bannerSection() {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;
    late final double bannerHeight;

    if (responsive.isMobile) {
      bannerHeight = screenWidth * 0.55;
    } else if (responsive.isTablet) {
      bannerHeight = screenWidth * 0.55;
    } else if (responsive.isLaptop) {
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isDesktop) {
      bannerHeight = screenWidth * 0.50;
    } else {
      bannerHeight = screenWidth * 0.50;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: bannerHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: ThumbnailView(
                context: context,
                imageUrl: widget.category.bannerLaptop ?? '',
                enablePreview: true,
                onTap: () {
                  debugPrint("Choose Products Clicked");
                  _scrollToKey(_productsGridKey);
                },
                borderRadius: 0,
                width: double.infinity,
                height: bannerHeight,
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Container(
          //   height: 50,
          //   decoration: BoxDecoration(
          //     color: widget.category.color.withAlpha(50),
          //     // borderRadius: BorderRadius.only(
          //     //     bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)
          //     // ),
          //   ),
          // )
        ],
      ),
    );
  }

  bool _showAllProducts = false;

  Widget mobileHeader(
    CategoryList category, {
    required VoidCallback onViewAll,
    required bool showAllProducts,
    required ShopProvider provider,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Smaller title on small screens.
    final double titleSize;

    if (screenWidth <= 500) {
      titleSize = 22.0;
    } else if (screenWidth <= 600) {
      titleSize = 26.0;
    } else {
      final scale = (screenWidth / 1440.0).clamp(0.82, 1.08);
      titleSize = (40.0 * scale).clamp(22.0, 50.0);
    }

    final titleLetterSpacing = screenWidth <= 600
        ? -0.8
        : (-1.8 * (screenWidth / 1440.0).clamp(0.82, 1.08)).clamp(-2.2, -0.7);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: HtmlWidget(
            category.subTextHeading ?? "",
            customStylesBuilder: (element) {
              if (element.localName == 'h1' ||
                  element.localName == 'h2' ||
                  element.localName == 'p' ||
                  element.localName == 'span' ||
                  element.localName == 'div') {
                return {
                  'font-size': '${titleSize.toStringAsFixed(1)}px',
                  'line-height': '0.9',
                  'letter-spacing':
                      '${titleLetterSpacing.toStringAsFixed(2)}px',
                };
              }

              return null;
            },
            textStyle: const TextStyle(height: 1),
          ),
        ),

        // const SizedBox(width: 6),
        //
        // InkWell(
        //   onTap: onViewAll,
        //   borderRadius: BorderRadius.circular(6),
        //   child: AnimatedContainer(
        //     duration: const Duration(milliseconds: 250),
        //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        //     decoration: BoxDecoration(
        //       color: category.color,
        //       borderRadius: BorderRadius.circular(6),
        //       border: Border.all(color: gMainColor),
        //     ),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         AnimatedSwitcher(
        //           duration: const Duration(milliseconds: 250),
        //           child: Text(
        //             showAllProducts
        //                 ? "Show Less"
        //                 : "Explore all ${provider.products.length} ${category.name} ",
        //             key: ValueKey(showAllProducts),
        //             style: GoogleFonts.robotoCondensed(
        //               fontSize: fontSize10,
        //               fontWeight: FontWeight.w700,
        //               color: gWhiteColor,
        //             ),
        //           ),
        //         ),
        //
        //         const SizedBox(width: 3),
        //
        //         Icon(
        //           showAllProducts
        //               ? Icons.keyboard_arrow_up_rounded
        //               : Icons.arrow_forward_ios_rounded,
        //           size: 11,
        //           color: gWhiteColor,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget leftSection(CategoryList category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.sizeOf(context).width;

        // Smaller scaling for desktop and ultra-wide screens
        final scale = (screenWidth / 1440.0).clamp(0.82, 1.08);

        final titleSize = (90.0 * scale).clamp(35.0, 105.0);
        final descSize = (22.0 * scale).clamp(14.0, 24.0);

        final titleLetterSpacing = (-1.8 * scale).clamp(-2.2, -0.7);

        final descriptionLetterSpacing = (1.2 * scale).clamp(0.4, 1.6);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HtmlWidget(
              category.subTextHeading ?? "",
              customStylesBuilder: (element) {
                if (element.localName == 'h1' ||
                    element.localName == 'h2' ||
                    element.localName == 'p' ||
                    element.localName == 'span' ||
                    element.localName == 'div') {
                  return {
                    'font-size': '${titleSize.toStringAsFixed(1)}px',
                    'line-height': '0.9',
                    'letter-spacing':
                        '${titleLetterSpacing.toStringAsFixed(2)}px',
                  };
                }
                return null;
              },
              textStyle: const TextStyle(height: 1),
            ),

            SizedBox(height: (16.0 * scale).clamp(8.0, 18.0)),

            HtmlWidget(
              category.subTextDescription ?? "",
              customStylesBuilder: (element) {
                if (element.localName == 'p' ||
                    element.localName == 'span' ||
                    element.localName == 'div') {
                  return {'font-size': '${descSize.toStringAsFixed(1)}px'};
                }
                return null;
              },
              textStyle: TextStyle(
                height: 1.31,
                letterSpacing: descriptionLetterSpacing,
              ),
            ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
          ],
        );
      },
    );
  }

  Widget rightSection(CategoryList category) {
    final responsive = ScreenSizeHelper(context);

    // Responsive font & sizes
    final highlightSize = responsive.isMobile
        ? 14.0
        : responsive.isTablet
        ? 16.0
        : responsive.isLaptop
        ? 22.0
        : 25.0;

    final arrowWidth = responsive.isMobile
        ? 60.0
        : responsive.isTablet
        ? 70.0
        : responsive.isLaptop
        ? 80.0
        : 90.0;

    final spacing = responsive.isMobile
        ? 8.0
        : responsive.isTablet
        ? 12.0
        : 16.0;

    return Row(
      children: [
        // Highlight + Arrow (fixed width column on the right)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Transform.rotate(
                  angle: -0.1,
                  child: Text(
                    category.subTextHighlight ?? '',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.caveat(
                      fontSize: highlightSize,
                      color: gPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveX(begin: 0, end: 6, duration: 1200.ms),

            const SizedBox(height: 6),

            Image.asset("assets/images/clock_top_arrow.png", width: arrowWidth)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveX(begin: 0, end: 6, duration: 1200.ms),
          ],
        ),

        SizedBox(width: spacing),

        // Thumbnail: take remaining width in both mobile and desktop
        Expanded(
          child: ThumbnailView(
            context: context,
            imageUrl: category.subTextThubnail,
            enablePreview: false,
            fit: BoxFit.fill,
            width: double.maxFinite,
            // height: imageHeight,
          ),
        ),
      ],
    );
  }
}
