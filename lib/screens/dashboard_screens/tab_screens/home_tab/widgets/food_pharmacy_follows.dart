import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../../../../../utils/app_config.dart';
import '../../../../category_page/category_product_card.dart';
import '../../../../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class FoodFarmacyFollows extends StatefulWidget {
  const FoodFarmacyFollows({super.key});

  @override
  State<FoodFarmacyFollows> createState() => _FoodFarmacyFollowsState();
}

class _FoodFarmacyFollowsState extends State<FoodFarmacyFollows>
    with TickerProviderStateMixin {
  // ===============================================================
  // CONSTANT COLOR
  // ===============================================================

  static const Color tabColor = Color(0xff08716D);

  // ===============================================================
  // STATE
  // ===============================================================

  int selected = 0;

  TabController? _tabController;

  late AnimationController _contentAnimationController;

  final CarouselSliderController _productCarouselController =
      CarouselSliderController();

  // ===============================================================
  // INIT
  // ===============================================================

  @override
  void initState() {
    super.initState();

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ShopProvider>().fetchClusterList();
    });
  }

  // ===============================================================
  // DISPOSE
  // ===============================================================

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);

    _tabController?.dispose();

    _contentAnimationController.dispose();

    super.dispose();
  }

  // ===============================================================
  // TAB CHANGED
  // ===============================================================

  void _onTabChanged() {
    final controller = _tabController;

    if (controller == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final newIndex = controller.index;

    if (newIndex < 0) {
      return;
    }

    if (selected == newIndex) {
      return;
    }

    setState(() {
      selected = newIndex;
    });

    // Reset products to first position.
    _productCarouselController.jumpToPage(0);

    // Animate selected content.
    _contentAnimationController
      ..reset()
      ..forward();
  }

  // ===============================================================
  // CREATE TAB CONTROLLER
  // ===============================================================

  void _createTabController(int length) {
    if (length <= 0) {
      return;
    }

    // Already correct.
    if (_tabController != null && _tabController!.length == length) {
      return;
    }

    _tabController?.removeListener(_onTabChanged);

    _tabController?.dispose();

    final safeIndex = selected.clamp(0, length - 1);

    selected = safeIndex;

    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: safeIndex,
    );

    _tabController!.addListener(_onTabChanged);
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final res = ScreenSizeHelper(context);
    final mobileDesign = res.isMobile || res.isTablet;
    final provider = context.watch<ShopProvider>();
    final clusters = provider.clusterList;

    // ============================================================
    // LOADING
    // ============================================================
    if (clusters.isEmpty) {
      return const SizedBox(
        height: 350,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // ============================================================
    // TAB CONTROLLER
    // ============================================================
    _createTabController(clusters.length);
    // ============================================================
    // SAFETY
    // ============================================================
    if (selected >= clusters.length) {
      selected = clusters.length - 1;
    }
    final selectedCluster = clusters[selected];
    final products = selectedCluster.productsData ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(mobileDesign),
          SizedBox(height: mobileDesign ? 10 : 30),
          Center(
            child: Transform.rotate(
              angle: -.1,
              child: Text(
                "Presenting Our Food Farmacy",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Caveat",
                  fontSize: fontSize15,
                  fontWeight: FontWeight.w700,
                  color: gMainColor,
                  height: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: mobileDesign ? 20 : 30),
          _buildHorizontalTabs(clusters, mobileDesign),
          SizedBox(height: mobileDesign ? 18 : 28),
          _buildSelectedDetails(selectedCluster, products, mobileDesign),
        ],
      ),
    );
  }

  // ===============================================================
  // HEADER
  // ===============================================================
  Widget _buildHeader(bool mobileDesign) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final titleSize = (screenWidth * 0.065).clamp(20.0, 60.0);
    final bodySize = (screenWidth * 0.014).clamp(14.0, 22.0);

    const title = '''
<h1 style="font-family:'Archivo Narrow'; font-weight:600;">
Is Your Gut out of Rhythm?
</h1>
''';

    const description = '''
<p style="font-family:'Courier Prime'; font-style:italic; color:#786f68;">
We curated Food Only Combination that can fix it!<br/>
Your gut just wants
<span style="color:#C41A0F;">
Right support NOT Harsh chemicals.
</span>
</p>
''';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HtmlWidget(
                title,
                customStylesBuilder: (element) {
                  if (element.localName == 'h1' ||
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
                textStyle: const TextStyle(height: 1),
              ),
              SizedBox(height: mobileDesign ? 8 : 12),
              HtmlWidget(
                description,
                customStylesBuilder: (element) {
                  if (element.localName == 'p' ||
                      element.localName == 'span' ||
                      element.localName == 'div') {
                    return {'font-size': '${bodySize}px'};
                  }
                  return null;
                },
                textStyle: const TextStyle(height: 1.31, letterSpacing: 1.5),
              ).animate().fade(delay: 300.ms).slideY(begin: .15),
            ],
          ),
        ),
        SizedBox(width: mobileDesign ? 8 : 20),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: .7, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Image.asset(
              'assets/images/suitability.png',
              width: mobileDesign ? 80 : 125,
              height: mobileDesign ? 80 : 125,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // HORIZONTAL TABS
  // ===============================================================
  Widget _buildHorizontalTabs(List<ClusterList> clusters, bool mobileDesign) {
    final controller = _tabController;

    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WHAT FEELS OUT OF RHYTHM',
              style: TextStyle(
                fontFamily: "Courier Prime",
                fontSize: fontSize13,
                fontWeight: FontWeight.w700,
                letterSpacing: .4,
                color: gMainColor,
              ),
            ),
            const SizedBox(width: 6),
            Image.asset(
              'assets/images/slider_right_arrow.png',
              width: mobileDesign ? 18 : 25,
              height: mobileDesign ? 18 : 25,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: mobileDesign ? 82 : 92,
          child: TabBar(
            controller: controller,
            isScrollable: true,
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 3.5),
            tabAlignment: TabAlignment.start,
            indicator: const BoxDecoration(),
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            onTap: null,
            tabs: List.generate(clusters.length, (index) {
              return _buildTab(clusters[index], index, mobileDesign);
            }),
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // TAB
  // ===============================================================

  Widget _buildTab(ClusterList cluster, int index, bool mobileDesign) {
    final active = selected == index;
    const Color commonYellow = gTabBackGroundColor;
    final tabWidth = mobileDesign ? 177.0 : 205.0;
    final tabHeight = mobileDesign ? 72.0 : 82.0;
    final imageWidth = mobileDesign ? 62.0 : 72.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      width: tabWidth,
      height: tabHeight,
      decoration: BoxDecoration(
        color: active ? tabColor : commonYellow,
        borderRadius: BorderRadius.circular(mobileDesign ? 15 : 18),
        boxShadow: active
            ? [
                BoxShadow(
                  color: tabColor.withValues(alpha: .22),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            width: imageWidth,
            height: tabHeight,
            decoration: BoxDecoration(
              color: tabColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(mobileDesign ? 15 : 18),
                bottomLeft: Radius.circular(mobileDesign ? 15 : 18),
                topRight: Radius.circular(
                  active ? (mobileDesign ? 15 : 18) : 0,
                ),
                bottomRight: Radius.circular(
                  active ? (mobileDesign ? 15 : 18) : 0,
                ),
              ),
            ),
            child: Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                scale: active ? 1.08 : 1.0,
                child: ThumbnailView(
                  context: context,
                  imageUrl: cluster.clusterThumbnailUrl,
                  width: mobileDesign ? 48 : 58,
                  height: mobileDesign ? 48 : 58,
                  fit: BoxFit.contain,
                  enablePreview: false,
                  borderRadius: 0,
                ),
              ),
            ),
          ),

          // ======================================================
          // CLUSTER NAME
          // ======================================================
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              color: active ? tabColor : commonYellow,
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Center(
                child: Text(
                  _cleanTitle(cluster.clusterName ?? ''),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Avenir",
                    fontSize: fontSize09,
                    fontWeight: FontWeight.w700,
                    color: active ? gWhiteColor : tabColor,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // SELECTED DETAILS
  // ===============================================================

  Widget _buildSelectedDetails(
    ClusterList cluster,
    List<Products> products,
    bool mobileDesign,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),

      switchInCurve: Curves.easeOutCubic,

      switchOutCurve: Curves.easeInCubic,

      child: Container(
        key: ValueKey(cluster.clusterName ?? selected),

        child: Column(
          children: [
            _buildStory(cluster, mobileDesign),
            SizedBox(height: 10),
            if (products.isNotEmpty)
              _buildProducts(products, mobileDesign)
            else
              _buildLaunchingSoon(mobileDesign),
            SizedBox(height: 30),
            _buildExploreButton(cluster, mobileDesign),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // STORY
  // ===============================================================

  Widget _buildStory(ClusterList cluster, bool mobileDesign) {
    final title = _cleanTitle(cluster.clusterAboutTitle ?? '');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      margin: EdgeInsets.symmetric(vertical: mobileDesign ? 15 : 20),
      decoration: BoxDecoration(
        color: gPrimaryColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(mobileDesign ? 12 : 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: TextStyle(
                fontFamily: "Courier Prime",
                fontSize: fontSize13,
                fontWeight: FontWeight.w700,
                color: gPrimaryColor,height: 0
              ),
            ),
          HtmlWidget(
            cluster.clusterAbout ?? '',
            textStyle: TextStyle(fontSize: fontSize16),
            customStylesBuilder: (element) {
              if (element.localName == 'body' ||
                  element.localName == 'div' ||
                  element.localName == 'p' ||
                  element.localName == 'span') {
                return {'line-height': '1.4', 'letter-spacing': '-0.07em'};
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // PRODUCTS
  // ===============================================================

  Widget _buildProducts(List<Products> products, bool mobileDesign) {
    if (products.isEmpty) {
      return _buildLaunchingSoon(mobileDesign);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ScreenSizeHelper(context);

        // ========================================================
        // PRODUCT CARD SIZING
        // ========================================================

        late final double titleSize;
        late final double priceSize;
        late final double infoSize;
        late final double buttonHeight;
        late final double contentPadding;
        late final double imageHeightMultiplier;
        late final bool titleTwoLines;
        late final double rowGap1;
        late final double rowGap2;
        late final double gapBeforeButton;

        if (responsive.isMobile) {
          titleSize = 10.5;
          priceSize = 10.5;
          infoSize = 8.5;
          buttonHeight = 30;
          contentPadding = 6;
          imageHeightMultiplier = .78;
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
          imageHeightMultiplier = .80;
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
          imageHeightMultiplier = .80;
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
          imageHeightMultiplier = .88;
          titleTwoLines = false;
          rowGap1 = 6;
          rowGap2 = 8;
          gapBeforeButton = 14;
        }

        // ========================================================
        // ARROWS / SPACING
        // ========================================================

        const double arrowWidth = 22;
        const double arrowGap = 6;
        const double cardSpacing = 10;

        final double carouselWidth =
            constraints.maxWidth - (arrowWidth * 2) - (arrowGap * 2);

        // Exactly 2 cards.
        final double cardWidth = (carouselWidth - cardSpacing) / 2;

        // ========================================================
        // HEIGHT
        // ========================================================

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

        return SizedBox(
          height: cardHeight,

          child: Row(
            children: [
              // ==================================================
              // LEFT ARROW
              // ==================================================
              SizedBox(
                width: arrowWidth,

                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,

                    splashRadius: 18,

                    onPressed: products.length > 2
                        ? () {
                            _productCarouselController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        : null,

                    icon: Icon(
                      Icons.chevron_left_rounded,

                      color: products.length > 2
                          ? gPrimaryColor
                          : gPrimaryColor.withValues(alpha: .25),

                      size: mobileDesign ? 25 : 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: arrowGap),

              // ==================================================
              // CAROUSEL
              // ==================================================
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _productCarouselController,

                  itemCount: products.length,

                  itemBuilder: (context, index, realIndex) {
                    final product = products[index];

                    return SizedBox(
                      width: cardWidth,

                      height: cardHeight,

                      child: ProductCard(
                        key: ValueKey('${product.productTitle}_$index'),

                        item: product,

                        // Always same color.
                        category: tabColor,

                        cardWidth: cardWidth,
                      ),
                    );
                  },

                  options: CarouselOptions(
                    height: cardHeight,

                    // Exactly 2 full cards.
                    viewportFraction: .5,

                    scrollDirection: Axis.horizontal,

                    autoPlay: false,

                    // One product at a time.
                    pageSnapping: true,

                    enlargeCenterPage: false,

                    padEnds: false,

                    enableInfiniteScroll: false,

                    scrollPhysics: const ClampingScrollPhysics(),
                  ),
                ),
              ),

              const SizedBox(width: arrowGap),

              // ==================================================
              // RIGHT ARROW
              // ==================================================
              SizedBox(
                width: arrowWidth,

                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,

                    splashRadius: 18,

                    onPressed: products.length > 2
                        ? () {
                            _productCarouselController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        : null,

                    icon: Icon(
                      Icons.chevron_right_rounded,

                      color: products.length > 2
                          ? gPrimaryColor
                          : gPrimaryColor.withValues(alpha: .25),

                      size: mobileDesign ? 25 : 30,
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

  // ===============================================================
  // EXPLORE BUTTON
  // ===============================================================

  Widget _buildExploreButton(ClusterList cluster, bool mobileDesign) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),

      duration: const Duration(milliseconds: 700),

      curve: Curves.easeOutBack,

      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },

      child: ElevatedButton(
        onPressed: () async {
          final prefs = AppConfig().preferences;

          await prefs?.setString("selectedCategory", "32");

          final shopProvider = context.read<ShopProvider>();

          shopProvider.changeTab(2);

          context.go('/');
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: gPrimaryColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),

        child: Text(
          'Explore The Combo',
          // 'Explore ${_cleanTitle(cluster.clusterName ?? 'Products')}',
          style: TextStyle(
            fontFamily: "Caveat",
            fontSize: fontSize14,
            fontWeight: FontWeight.w700,
            color: gMainColor,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // LAUNCHING SOON
  // ===============================================================

  Widget _buildLaunchingSoon(bool mobileDesign) {
    return Container(
      width: double.infinity,

      height: mobileDesign ? 180 : 220,

      alignment: Alignment.center,

      child: Text(
        'Launching Soon',

        style: TextStyle(
          fontFamily: "Caveat",

          fontSize: mobileDesign ? 24 : 30,

          fontWeight: FontWeight.w700,

          color: gHintTextColor,
        ),
      ),
    );
  }

  // ===============================================================
  // CLEAN HTML TEXT
  // ===============================================================

  String _cleanTitle(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
