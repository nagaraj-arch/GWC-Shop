import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/widgets/loading_widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../controllers/providers/shop_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../footer_widget/footer_wrapper.dart';
import 'category_banner.dart';
import 'category_product_card.dart';
import 'cover_section.dart';
import 'feature_grid.dart';
import 'footer_section.dart';

class CategoryPage extends StatefulWidget {
  final String? categoryId;
  final CategoryList? category;

  const CategoryPage({super.key, this.categoryId, this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productsGridKey = GlobalKey();
  final GlobalKey _coverImageKey = GlobalKey();

  CategoryList? category;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCategory(widget.categoryId);
    });
  }

  Future<void> _loadCategory(String? id) async {
    if (id == null) return;

    final provider = context.read<ShopProvider>();

    if (provider.categories.isEmpty) {
      await provider.fetchCategory();
    }

    category = provider.categories.firstWhere((e) => e.id.toString() == id);

    await provider.fetchProductsByCategory(id);

    if (!mounted) return;

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FooterWrapper.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categoryId != widget.categoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCategory(widget.categoryId);
      });
    }
  }

  String? _currentCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final categoryId = GoRouterState.of(context).pathParameters['id'];

    if (categoryId != null && _currentCategory != categoryId) {
      _currentCategory = categoryId;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        final provider = context.read<ShopProvider>();

        category = provider.categories.firstWhere(
          (e) => e.id.toString() == categoryId,
        );

        await provider.fetchProductsByCategory(categoryId);

        if (mounted) {
          setState(() {});
        }
      });
    }
  }

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
    final isDesktop = ResponsiveHelper(context).isDesktop;
    final responsive = ScreenSizeHelper(context);
    final shopProvider = context.watch<ShopProvider>();

    // Show loading or error if category is null
    if (category == null) {
      return const Scaffold(body: Center(child: LoadingIndicator()));
    }

    // Helper to check if image URL is valid
    bool isValidImage(String? url) =>
        url != null && url.trim().isNotEmpty && url != 'null';

    final showCoverSection = isValidImage(category?.coverImage);
    final showFooterSection = isValidImage(category?.footerThumnail);

    final contentHorizontalPadding = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 40.0
        : responsive.isLaptop
        ? 80.0
        : responsive.isDesktop
        ? 120.0
        : 150.0;

    return FooterWrapper(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            CategoryBanner(
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
                vertical: 30,
              ),
              child: Column(
                children: [
                  isDesktop
                      ? Row(
                          children: [
                            Expanded(flex: 5, child: leftSection()),
                            Expanded(flex: 6, child: rightSection()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            leftSection(),
                            // rightSection() returns a Row with the default
                            // MainAxisSize.max, so it always fills full width
                            // regardless of an Align wrapper — the previous
                            // Align(alignment: centerRight, ...) here had no
                            // visual effect and has been removed.
                            rightSection(),
                          ],
                        ),

                  const SizedBox(height: 40),

                  Builder(
                    key: _productsGridKey,
                    builder: (context) =>
                        shopProvider.isLoading(
                          ShopLoadingType.getProductsByCategory,
                        )
                        ? const LoadingIndicator()
                        : AdditionalProductsGrid(
                            products: shopProvider.products,
                            category: category?.color,
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
                    coverImage: category?.coverImage,
                    coverImageMobile: category?.coverImageMobile,
                    coverImageLaptop: category?.coverImageLaptop,
                    coverImageTab: category?.coverImageTab,
                    coverImageDesktop: category?.coverImageDesktop,
                    coverTitle: category?.coverTitle,
                    coverDesc: category?.coverDescription,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
            FeatureGrid(
              category: category?.importantPoints,
              color: category?.color,
            ),
            if (showFooterSection) ...[
              SizedBox(height: 40),
              FooterSection(
                footerThumbnail: category?.footerThumnail,
                footerThumbnailMobile: category?.footerThumnailMobile,
                footerThumbnailTab: category?.footerThumnailTab,
                footerThumbnailLaptop: category?.footerThumnailLaptop,
                footerThumbnailDesktop: category?.footerThumnailDesktop,
                footerTitle: category?.footerTitle,
                footerDescription: category?.footerDescription,
                footerHighlightText: category?.footerHighlightText,
              ),
              const SizedBox(height: 40),
            ],

            LayoutBuilder(
              builder: (context, ctaConstraints) {
                // Fixed width: 350 previously — on a narrow phone,
                // combined with the page's own horizontal margins, this
                // could exceed the viewport and overflow. Cap it to
                // whatever's actually available instead.
                final ctaWidth = 350.0 < ctaConstraints.maxWidth - 40
                    ? 350.0
                    : ctaConstraints.maxWidth - 40;

                return SizedBox(
                  width: ctaWidth,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          category?.color ?? const Color(0xff3B2415),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      final shopProvider = context.read<ShopProvider>();

                      // Change to tab 1
                      shopProvider.changeTab(0);

                      // Navigate to home first
                      context.go("/");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Flexible + ellipsis: on a shrunk button the
                        // text alone can exceed the available width and
                        // overflow (the classic RenderFlex warning)
                        // without this.
                        Flexible(
                          child: Text(
                            "Explore other categories",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifDisplay(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: gWhiteColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        SizedBox(
                          width: 52,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                height: 2,
                                width: 44,
                                color: Colors.white,
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget leftSection() {
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
              category?.subTextHeading ?? "",
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
              category?.subTextDescription ?? "",
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

  Widget rightSection() {
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

    // final imageHeight = responsive.isMobile
    //     ? 150.0
    //     : responsive.isTablet
    //     ? 150.0
    //     : responsive.isLaptop
    //     ? 140.0
    //     : responsive.isDesktop
    //     ? 240.0
    //     : 280.0;

    return Row(
      children: [
        // Highlight + Arrow (fixed width column on the right)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Transform.rotate(
                  angle: -0.1,
                  child: Text(
                    category?.subTextHighlight ?? '',
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
            imageUrl: category?.subTextThubnail,
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
