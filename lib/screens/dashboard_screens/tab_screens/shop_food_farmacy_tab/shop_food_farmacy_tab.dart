import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gwc_shop/screens/category_page/cover_section.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_food_farmacy_tab/widgets/cluster_benefits_grid.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/category_model.dart';
import '../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../controllers/providers/cart_provider.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../../widgets/loading_widgets/loading_indicator.dart';
import '../../../category_page/category_product_card.dart';
import '../../../category_page/footer_section.dart';
import '../../widgets/banner_section.dart';
import '../../widgets/horizontal_tab_heading.dart';
import '../food_farmacy_tab/food_farmacy_tab.dart';
import '../food_farmacy_tab/widgets/add_as_combo_banner.dart';

class ShopFoodFarmacyTab extends StatefulWidget {
  const ShopFoodFarmacyTab({super.key});

  @override
  State<ShopFoodFarmacyTab> createState() => _ShopFoodFarmacyTabState();
}

class _ShopFoodFarmacyTabState extends State<ShopFoodFarmacyTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final CarouselSliderController _productCarouselController =
      CarouselSliderController();

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
      final provider = context.read<ShopProvider>();

      provider.fetchClusterList().then((_) {
        if (!mounted) return;

        _setupTabController(provider.clusterList.length);
      });
    });
  }

  void _setupTabController(int length) {
    if (length == 0) return;

    _tabController?.dispose();

    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: selectedIndex,
    );

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) return;

      final index = _tabController!.index;

      if (index != selectedIndex) {
        setState(() {
          selectedIndex = index;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToProducts();
        });
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    // Clear cached images when leaving this image-heavy page.
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    _tabController?.dispose();
    super.dispose();
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
    final mobileDesign = responsive.isMobile || responsive.isTablet;

    final provider = context.watch<ShopProvider>();

    final foodFarmacyCategory = provider.allCategories.firstWhere(
      (e) => (e.name ?? "").toLowerCase().trim().contains("food farmacy"),
      orElse: () => provider.allCategories.first,
    );

    bool isValidImage(String? url) =>
        url != null && url.trim().isNotEmpty && url != 'null';

    final showCoverSection = isValidImage(selectedCluster?.comboThumbnailUrl);
    final showFooterSection = isValidImage(foodFarmacyCategory.footerThumnail);
    if (mobileDesign) {
      return provider.isLoading(ShopLoadingType.getClusterList)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: LoadingIndicator(),
            )
          : Column(
              children: [
                BannerSection(
                  category: foodFarmacyCategory,
                  isFoodFarmacy: _scrollToFormulation,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      buildIntroSection(
                        text: "CHOOSE WHAT FEELS FAMILIAR",
                        title: foodFarmacyCategory.subTextHeading ?? "",
                        desc: mobileDesign ? "" :foodFarmacyCategory.subTextDescription ?? "",
                      ),
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
                SizedBox(height: 20),
                if (showCoverSection) ...[
                  Builder(
                    key: _coverImageKey,
                    builder: (context) {
                      return CoverSection(
                        coverImage: selectedCluster?.comboThumbnailUrl,
                        coverImageMobile:
                            selectedCluster?.comboThumbnailMobileUrl,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                // ✅ Only show FeatureGrid if points exist
                if ((selectedCluster?.clusterBenefitsUrls ?? [])
                    .isNotEmpty) ...[
                  ClusterBenefitsGrid(
                    items: selectedCluster!.clusterBenefitsUrls ?? [],
                  ),
                ],
                if (showFooterSection) ...[
                  SizedBox(height: 40),
                  FooterSection(
                    footerThumbnail: foodFarmacyCategory.footerThumnail,
                    footerThumbnailMobile:
                        foodFarmacyCategory.footerThumnailMobile,
                    footerThumbnailTab: foodFarmacyCategory.footerThumnailTab,
                    footerThumbnailLaptop:
                        foodFarmacyCategory.footerThumnailLaptop,
                    footerThumbnailDesktop:
                        foodFarmacyCategory.footerThumnailDesktop,
                    footerTitle: foodFarmacyCategory.footerTitle,
                    footerDescription: foodFarmacyCategory.footerDescription,
                    footerHighlightText:
                        foodFarmacyCategory.footerHighlightText,
                  ),
                  SizedBox(
                    height: responsive.isMobile || responsive.isTablet ? 40 : 0,
                  ),
                ],
              ],
            );
    }
    return FoodFarmacyTab();
  }

  Widget buildIntroSection({String? text, String? title, String? desc}) {
    final hasText = text?.trim().isNotEmpty ?? false;
    final hasTitle = title?.trim().isNotEmpty ?? false;
    final hasDesc = desc?.trim().isNotEmpty ?? false;

    if (!hasText && !hasTitle && !hasDesc) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: gWhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          if (hasText)
            Text(
              text!.trim(),
              style: TextStyle(
                color: gMainColor,
                fontSize: fontSize12,
                fontFamily: "Avenir",
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          if (hasText && hasTitle) const SizedBox(height: 8),
          if (hasTitle)
            HtmlWidget(
              title!.trim(),
              customStylesBuilder: (element) {
                if (element.localName == 'h1' ||
                    element.localName == 'h2' ||
                    element.localName == 'p' ||
                    element.localName == 'span' ||
                    element.localName == 'div') {
                  return {'line-height': '0.9', 'letter-spacing': '-2px'};
                }
                return null;
              },
              textStyle: TextStyle(height: 1, fontSize: fontSize30),
            ),
          if (hasTitle && hasDesc) const SizedBox(height: 8),
          if (hasDesc)
            DefaultTextStyle(
              style: const TextStyle(),
              textAlign: TextAlign.justify,
              child: HtmlWidget(
                desc!.trim(),
                customStylesBuilder: (element) {
                  if (element.localName == 'p' ||
                      element.localName == 'span' ||
                      element.localName == 'div') {
                    return null;
                  }
                  return null;
                },
                textStyle: TextStyle(
                  height: 1.31,
                  letterSpacing: 1.5,
                  fontSize: fontSize14,
                ),
              ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String toTitleCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Widget formulation(
    ScreenSizeHelper responsive,
    ShopProvider provider,
    CategoryList category,
  ) {
    final cluster = provider.clusterList;
    final currentCluster = selectedCluster;
    final clusterProducts = currentCluster?.productsData ?? [];

    if (cluster.isEmpty) {
      return const SizedBox.shrink();
    }

    final clusterName = (currentCluster?.clusterName ?? "")
        // Remove <br>, <br/>, <br />
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
        // Remove all HTML tags
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        // Remove new lines / tabs
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        // Remove multiple spaces
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // First letter capital, remaining letters small
    final formattedClusterName = toTitleCase(clusterName);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalTabHeading(title: "SWIPE THROUGH CONCERNS"),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final double tabWidth;
              final double tabHeight;

              if (width < 500) {
                // 📱 Mobile
                tabWidth = 125;
                tabHeight = 155;
              } else if (width < 800) {
                // 📱 Tablet
                tabWidth = 140;
                tabHeight = 165;
              } else if (width < 1200) {
                // 💻 Small laptop
                tabWidth = 150;
                tabHeight = 175;
              } else if (width < 1600) {
                // 💻 Laptop / desktop
                tabWidth = 165;
                tabHeight = 185;
              } else {
                // 🖥️ Large desktop
                tabWidth = 175;
                tabHeight = 195;
              }

              if (_tabController == null ||
                  _tabController!.length != cluster.length) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: tabHeight + 8,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,

                  padding: EdgeInsets.zero,

                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),

                  indicator: const BoxDecoration(),
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,

                  overlayColor: WidgetStateProperty.all(Colors.transparent),

                  tabs: List.generate(cluster.length, (index) {
                    return SizedBox(
                      width: tabWidth,
                      height: tabHeight,
                      child: buildConcernCard(
                        cluster[index],
                        index,
                        category,
                        compact: true,
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            "Food Farmacy Recommendation\nfor $formattedClusterName",
            style: TextStyle(
              height: 1.2,
              fontSize: fontSize20,
              fontFamily: "Roboto Condensed",
              fontWeight: FontWeight.w700,
              color: gBlackColor,
            ),
          ),
          SizedBox(height: 15),

          // ============================================================
          // PRODUCTS
          // ============================================================
          KeyedSubtree(
            key: _productsKey,
            child: _buildProducts(
              selectedCluster?.productsData ?? [],
              category.color,
            ),
          ),
          const SizedBox(height: 30),

          // ============================================================
          // COMBO BANNER
          // ============================================================
          if (clusterProducts.length > 1) ...[
            AddAsComboBanner(
              key: ValueKey(currentCluster?.id ?? selectedIndex),
              products: clusterProducts,
              category: category,
              cluster: currentCluster,
              originalPrice: clusterProducts.fold<double>(
                0,
                (sum, product) =>
                    sum + (double.tryParse(product.actualPrice ?? "0") ?? 0),
              ),
              comboPrice: clusterProducts.fold<double>(
                0,
                (sum, product) =>
                    sum + (double.tryParse(product.discountPrice ?? "0") ?? 0),
              ),
              onBuyCombo: () {
                _addClusterAsCombo(context, clusterProducts, comboPrice: 0);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildConcernCard(
    ClusterList item,
    int index,
    CategoryList category, {
    bool compact = false,
  }) {
    final isHovered = hoveredIndex == index;
    final isSelected = selectedIndex == index;
    final active = isHovered || isSelected;

    const selectedColor = gPrimaryColor;

    // ============================================================
    // RESPONSIVE CARD SIZES
    // ============================================================
    final double imageSize;
    final double titleSize;
    final double descriptionSize;
    final double exploreSize;

    if (compact) {
      imageSize = 58;
      titleSize = 11;
      descriptionSize = 7.5;
      exploreSize = 7.5;
    } else {
      imageSize = 100;
      titleSize = 18;
      descriptionSize = 14;
      exploreSize = 14;
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1, end: active ? 1.03 : 1),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,

            onEnter: (_) {
              if (!mounted) return;

              setState(() {
                hoveredIndex = index;
              });
            },

            onExit: (_) {
              if (!mounted) return;

              setState(() {
                hoveredIndex = -1;
              });
            },

            child: InkWell(
              borderRadius: BorderRadius.circular(compact ? 12 : 18),

              onTap: () {
                _tabController?.animateTo(index);
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,

                decoration: BoxDecoration(
                  color: active ? selectedColor : gWhiteColor,

                  borderRadius: BorderRadius.circular(compact ? 12 : 18),

                  border: Border.all(
                    color: gMainColor,
                    width: compact ? 1 : 1.5,
                  ),

                  boxShadow: [
                    if (active)
                      BoxShadow(
                        color: gBlackColor.withAlpha(18),
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),

                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 7 : 18,
                  vertical: compact ? 7 : 18,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==================================================
                    // IMAGE
                    // ==================================================
                    AnimatedScale(
                      scale: active ? 1.06 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: ThumbnailView(
                        imageUrl: item.clusterThumbnailUrl ?? '',
                        context: context,
                        enablePreview: false,
                        height: imageSize,
                        width: imageSize,
                      ),
                    ),

                    SizedBox(height: compact ? 5 : 12),

                    // ==================================================
                    // TITLE
                    // ==================================================
                    HtmlWidget(
                      item.clusterName ?? '',
                      textStyle: TextStyle(
                        color: active ? gWhiteColor : category.color,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                      ),
                      customStylesBuilder: (element) {
                        if (element.localName == 'p' ||
                            element.localName == 'span' ||
                            element.localName == 'h1' ||
                            element.localName == 'h2' ||
                            element.localName == 'div') {
                          return {
                            'font-size': '${titleSize}px',
                            'font-weight': '700',
                            'text-align': 'center',
                            'color': active ? '#FFFFFF' : '#355C4A',
                            'margin': '0',
                            'padding': '0',
                            'line-height': '1.0',
                          };
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: compact ? 5 : 8),

                    // ==================================================
                    // DESCRIPTION
                    // ==================================================
                    Text(
                      item.clusterDescription ?? '',
                      textAlign: TextAlign.center,
                      maxLines: compact ? 3 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: fontBook,
                        fontSize: descriptionSize,
                        height: compact ? 1.1 : 1.3,
                        color: active ? gWhiteColor : category.color,
                      ),
                    ),

                    SizedBox(height: compact ? 6 : 10),

                    // ==================================================
                    // EXPLORE
                    // ==================================================
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Explore",
                          style: TextStyle(
                            fontFamily: fontBook,
                            fontSize: exploreSize,
                            color: gMainColor,
                          ),
                        ),

                        SizedBox(width: compact ? 2 : 4),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: compact ? exploreSize + 1 : 14,
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

  Widget _buildProducts(List<Products> products, Color category) {
    if (products.isEmpty) {
      return _buildLaunchingSoon();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ScreenSizeHelper(context);

        // ============================================================
        // RESPONSIVE SIZES
        // ============================================================
        final double titleSize;
        final double priceSize;
        final double infoSize;
        final double buttonHeight;
        final double contentPadding;
        final double imageHeightMultiplier;
        final bool titleTwoLines;
        final double rowGap1;
        final double rowGap2;
        final double gapBeforeButton;

        if (responsive.isMobile) {
          titleSize = 10.5;
          priceSize = 10.5;
          infoSize = 8.5;
          buttonHeight = 30;
          contentPadding = 6;
          imageHeightMultiplier = 0.78;
          titleTwoLines = true;
          rowGap1 = 4;
          rowGap2 = 5;
          gapBeforeButton = 8;
        } else if (responsive.isTablet) {
          titleSize = 12.5;
          priceSize = 12;
          infoSize = 10;
          buttonHeight = 34;
          contentPadding = 8;
          imageHeightMultiplier = 0.80;
          titleTwoLines = false;
          rowGap1 = 6;
          rowGap2 = 8;
          gapBeforeButton = 10;
        } else if (responsive.isLaptop) {
          titleSize = 15;
          priceSize = 14;
          infoSize = 12;
          buttonHeight = 36;
          contentPadding = 10;
          imageHeightMultiplier = 0.80;
          titleTwoLines = false;
          rowGap1 = 6;
          rowGap2 = 8;
          gapBeforeButton = 12;
        } else {
          titleSize = 16;
          priceSize = 15;
          infoSize = 13;
          buttonHeight = 38;
          contentPadding = 10;
          imageHeightMultiplier = 0.88;
          titleTwoLines = false;
          rowGap1 = 6;
          rowGap2 = 8;
          gapBeforeButton = 14;
        }

        // ============================================================
        // ARROW + CARD SPACING
        // ============================================================
        const double arrowWidth = 22;

        // 👇 Space between product cards
        const double cardSpacing = 8;

        // ============================================================
        // VISIBLE CARDS
        // ============================================================
        final int visibleCards;

        if (constraints.maxWidth < 500) {
          visibleCards = 2;
        } else if (constraints.maxWidth < 800) {
          visibleCards = 2;
        } else if (constraints.maxWidth < 1200) {
          visibleCards = 3;
        } else {
          visibleCards = 4;
        }

        // ============================================================
        // FULL WIDTH
        // ============================================================
        final double carouselWidth = constraints.maxWidth - (arrowWidth * 2);

        // Width available for each carousel slot.
        final double slotWidth = carouselWidth / visibleCards;

        // Actual product card width after spacing.
        final double cardWidth = slotWidth - cardSpacing;

        // ============================================================
        // CARD HEIGHT
        // ============================================================
        final double imageHeight = cardWidth * imageHeightMultiplier;

        final double textBlockHeight =
            contentPadding +
            (titleSize * 1.3 * (titleTwoLines ? 2 : 1)) +
            rowGap1 +
            (priceSize * 1.3) +
            rowGap2 +
            (infoSize * 1.3);

        final double buttonSectionHeight = buttonHeight + contentPadding * 2;

        final double cardHeight =
            imageHeight +
            textBlockHeight +
            gapBeforeButton +
            buttonSectionHeight;

        // ============================================================
        // FINAL
        // ============================================================
        return SizedBox(
          width: double.infinity,
          height: cardHeight,
          child: Row(
            children: [
              // ========================================================
              // LEFT ARROW
              // ========================================================
              SizedBox(
                width: arrowWidth,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 18,
                    onPressed: products.length > visibleCards
                        ? () {
                            _productCarouselController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      size: 25,
                      color: products.length > visibleCards
                          ? gPrimaryColor
                          : gPrimaryColor.withValues(alpha: .25),
                    ),
                  ),
                ),
              ),

              // ========================================================
              // PRODUCT CAROUSEL
              // ========================================================
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _productCarouselController,

                  itemCount: products.length,

                  itemBuilder: (context, index, realIndex) {
                    final product = products[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: cardSpacing / 2,
                      ),
                      child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: ProductCard(
                          key: ValueKey('${product.productTitle}_$index'),
                          item: product,
                          category: category,
                          cardWidth: cardWidth,
                        ),
                      ),
                    );
                  },

                  options: CarouselOptions(
                    height: cardHeight,

                    // 2 / 3 / 4 cards depending on screen
                    viewportFraction: 1 / visibleCards,

                    scrollDirection: Axis.horizontal,

                    autoPlay: false,

                    pageSnapping: true,

                    enlargeCenterPage: false,

                    // Important for full-width layout
                    padEnds: false,

                    enableInfiniteScroll: false,

                    scrollPhysics: const ClampingScrollPhysics(),
                  ),
                ),
              ),

              // ========================================================
              // RIGHT ARROW
              // ========================================================
              SizedBox(
                width: arrowWidth,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 18,
                    onPressed: products.length > visibleCards
                        ? () {
                            _productCarouselController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      size: 25,
                      color: products.length > visibleCards
                          ? gPrimaryColor
                          : gPrimaryColor.withValues(alpha: .25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLaunchingSoon() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          'Launching Soon',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _addClusterAsCombo(
    BuildContext context,
    List<Products> products, {
    required double comboPrice,
  }) {
    if (products.length <= 1) return;

    final cartManager = context.read<CartProvider>();

    for (final product in products) {
      cartManager.addItem(
        context,
        Item(
          id: product.productId ?? 0,
          name: product.productTitle ?? '',
          price: double.parse(product.discountPrice ?? "0"),
          description: product.productDescription,
          category: product.category?.name ?? '',
          specialTag: product.productSpecialTag,
          weight: product.itemQty,
          unitId: product.weightType?.id.toString(),
          unitName: product.weightType?.unit,
          servings: product.servings,
          thumbnail: product.productThumbnailsUrls?.first,
        ),
      );
    }
  }
}
