import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/category_model.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../../widgets/loading_widgets/loading_indicator.dart';
import '../../../category_page/category_banner.dart';
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

    final showCoverSection = isValidImage(category.coverImage);
    final showFooterSection = isValidImage(category.footerThumnail);

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

        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              mobileDesign
                  ? bannerSection()
                  : CategoryBanner(
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
                  vertical: mobileDesign ? 0 : 30,
                ),
                child: Column(
                  children: [
                    mobileDesign
                        ? mobileHeader(
                      category,
                      showAllProducts: _showAllProducts,
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    mobileDesign ? mobileRightSection(category) : SizedBox(),
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
                      coverImageDesktop: widget.category.coverImageDesktop,
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
                  footerThumbnailMobile: widget.category.footerThumnailMobile,
                  footerThumbnailTab: widget.category.footerThumnailTab,
                  footerThumbnailLaptop: widget.category.footerThumnailLaptop,
                  footerThumbnailDesktop: widget.category.footerThumnailDesktop,
                  footerTitle: widget.category.footerTitle,
                  footerDescription: widget.category.footerDescription,
                  footerHighlightText: widget.category.footerHighlightText,
                ),
              ],
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

    return Container(
      width: double.infinity,
      height: bannerHeight,
      padding: EdgeInsets.all(8),
      child: ThumbnailView(
        context: context,
        imageUrl: widget.category.bannerLaptop ?? '',
        enablePreview: true,
        onTap: () {
          debugPrint("Choose Products Clicked");
          _scrollToKey(_productsGridKey);
        },
        borderRadius: 10,
        width: double.infinity,
        height: bannerHeight,
        fit: BoxFit.fill,
      ),
    );
  }

  bool _showAllProducts = false;

  Widget mobileHeader(
      CategoryList category, {
        required VoidCallback onViewAll,
        required bool showAllProducts,
      }) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Smaller scaling for desktop and ultra-wide screens
    final scale = (screenWidth / 1440.0).clamp(0.82, 1.08);

    final titleSize = (40.0 * scale).clamp(22.0, 50.0);

    final titleLetterSpacing =
    (-1.8 * scale).clamp(-2.2, -0.7);

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

        const SizedBox(width: 6),

        InkWell(
          onTap: onViewAll,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey(showAllProducts),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gPrimaryColor.withValues(alpha: 0.10),
                    ),
                    child: Icon(
                      showAllProducts
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.arrow_forward_rounded,
                      size: 14,
                      color: gPrimaryColor,
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Text(
                    showAllProducts ? "Less" : "View All",
                    key: ValueKey(showAllProducts),
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: gPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget mobileRightSection(CategoryList category) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / 1440.0).clamp(0.82, 1.08);
    final titleSize = (40.0 * scale).clamp(20.0, 60.0);

    final thumbnailHeight = screenWidth < 600
        ? screenWidth * 0.28
        : screenWidth < 1024
        ? screenWidth * 0.20
        : screenWidth * 0.12;

    return Column(
      children: [
        Text(
          category.subTextHighlight ?? '',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: "Archivo Narrow",
            fontSize: titleSize,
            color: gBlackColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        ThumbnailView(
          context: context,
          imageUrl: category.subTextThubnail,
          enablePreview: false,
          fit: BoxFit.contain,
          width: double.maxFinite,
          height: thumbnailHeight,
        ),
      ],
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

    final imageHeight = responsive.isMobile
        ? 150.0
        : responsive.isTablet
        ? 150.0
        : responsive.isLaptop
        ? 140.0
        : responsive.isDesktop
        ? 240.0
        : 280.0;

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
            fit: BoxFit.contain,
            width: double.maxFinite,
            height: imageHeight,
          ),
        ),
      ],
    );
  }
}
