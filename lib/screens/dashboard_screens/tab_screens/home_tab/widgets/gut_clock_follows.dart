import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../../controllers/providers/products_providers.dart';
import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../../../../../utils/app_config.dart';
import '../../../../category_page/category_product_card.dart';

// ===============================================================
// GUT CLOCK MODEL
// ===============================================================

class GutClockItem {
  final String meal;
  final String food;
  final String icon;
  final Color tabColor;
  final String story;

  const GutClockItem({
    required this.meal,
    required this.food,
    required this.icon,
    required this.tabColor,
    required this.story,
  });
}

// ===============================================================
// GUT CLOCK
// ===============================================================

class GutClockFollows extends StatefulWidget {
  const GutClockFollows({super.key});

  @override
  State<GutClockFollows> createState() => _GutClockFollowsState();
}

class _GutClockFollowsState extends State<GutClockFollows>
    with TickerProviderStateMixin {
  // ===============================================================
  // DATA
  // ===============================================================

  final List<GutClockItem> gutClockItems = [
    GutClockItem(
      meal: 'EARLY MORNING',
      food: 'AMBALI',
      icon: 'assets/images/early_morning.png',
      tabColor: const Color(0xff08716D),
      story:
          'As you wake up, so do the <red>trillion micro biome</red> in your gut!\n'
          'This is the best time to get their meal ready & build more of them.\n\n'
          '<gold>Our Ambali</gold>\n'
          '<b>Is an excellent naturally fermented, probiotic drink!</b>\n'
          '<b>Just what your Gut & biome need.</b>\n\n'
          '<red>Give them your love!</red>\n'
          'As they control majority of what happens within you.',
    ),

    GutClockItem(
      meal: 'MORNING',
      food: 'NUTRIMEAL',
      icon: 'assets/images/morning.png',
      tabColor: const Color(0xff29466C),
      story:
          '“Eat breakfast like a king”\n'
          'Means more <red>Quality over Quantity!</red> '
          'A healthy day should begin with nutritionally dense breakfast, not just quantity.\n\n'
          '<gold>Our NutriMeal</gold>\n'
          '<b>A complete nutritionally balanced porridge,</b>\n'
          '<b>will set you for the day & control your cravings.</b>\n\n'
          '<red>Start complete.</red>\n'
          'Arrive at lunch steadily, curb your cravings.',
    ),

    GutClockItem(
      meal: 'MID MORNING',
      food: 'INFUSION',
      icon: 'assets/images/mid_morning.png',
      tabColor: const Color(0xff64516F),
      story:
          '<red>Not every pause needs another snack.</red>\n'
          'A warm infusion brings flavour, hydration and a lighter\n'
          'ritual to the space between meals.\n\n'
          '<gold>Our Infusions</gold>\n'
          '<b>Not only fill these gaps but also strengthen your</b>\n'
          '<b>metabolism and lower the chances of gut disturbances.</b>\n\n'
          '<red>Have a warm spiced pause,</red>\n'
          'Pep up for real nourishment.',
    ),

    GutClockItem(
      meal: 'NOON',
      food: 'KHICHDI',
      icon: 'assets/images/noon.png',
      tabColor: const Color(0xffA46B36),
      story:
          'Struggling with <red>Cravings post 4pm?</red>\n'
          'Focus on what you eat at lunch! This is when your Gut is\n'
          'ready for most of its daily fuel.\n\n'
          '<gold>Our Khichadi\'s</gold>\n'
          '<b>Are borrowed wisdom from our tradition. They give your gut</b>\n'
          '<b>the satiety that it needs at this time.</b>\n\n'
          '<red>Eat right at noon &</red>\n'
          'Meet the evening with ease.',
    ),

    GutClockItem(
      meal: 'EVENING',
      food: 'HEALTHY INDULGENCE',
      icon: 'assets/images/evening.png',
      tabColor: const Color(0xffA65A38),
      story:
          '<red>Sometimes your gut asks for some pampering</red>\n'
          'A bowl of naturally creamy kheer on those days, is just\n'
          'what fits in perfectly.\n\n'
          '<gold>Our Healthy Indulgence\'s</gold>\n'
          '<b>Not only pampers your Gut, but also helps calm down your</b>\n'
          '<b>Gut-brain activities.</b>\n\n'
          '<red>Indulge occasionally in a warm soulful treat,</red>\n'
          'Free up from any guilt.',
    ),

    GutClockItem(
      meal: 'NIGHT',
      food: 'SOUP',
      icon: 'assets/images/night.png',
      tabColor: const Color(0xff465D67),
      story:
          'Struggling with <red>Satisfactory Evacuation?</red>\n'
          'Its probably insufficient Fruits & vegetable fiber in your diet.\n\n'
          '<gold>Our Soups</gold>\n'
          '<b>Do the magic for you!</b>\n'
          '<b>Tasty, tempting AND fulfilling the bulk forming fiber need of your gut.</b>\n\n'
          '<red>Best had at dinner</red>\n'
          'Satiating and helps lower the load on your gut post sunset.',
    ),
  ];

  // ===============================================================
  // STATE
  // ===============================================================

  late int selected;

  Timer? _timer;

  late TabController _tabController;

  late AnimationController _contentAnimationController;

  final CarouselSliderController _productCarouselController =
      CarouselSliderController();

  // ===============================================================
  // INIT
  // ===============================================================

  @override
  void initState() {
    super.initState();

    selected = _getCurrentMealIndex();

    _tabController = TabController(
      length: gutClockItems.length,
      vsync: this,
      initialIndex: selected,
    );

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _contentAnimationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ShopProvider>().selectTimelineCategory(
        gutClockItems[selected].meal,
      );
    });

    // Automatically change meal according
    // to current time.
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final current = _getCurrentMealIndex();

      if (current != selected) {
        _selectTab(current, animatePage: true);
      }
    });
  }

  // ===============================================================
  // DISPOSE
  // ===============================================================

  @override
  void dispose() {
    _timer?.cancel();

    _tabController.dispose();

    _contentAnimationController.dispose();

    super.dispose();
  }

  // ===============================================================
  // CURRENT MEAL
  // ===============================================================

  int _getCurrentMealIndex() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 8) return 0;
    if (hour >= 8 && hour < 11) return 1;
    if (hour >= 11 && hour < 13) return 2;
    if (hour >= 13 && hour < 17) return 3;
    if (hour >= 17 && hour < 20) return 4;

    return 5;
  }

  // ===============================================================
  // NORMALIZE MEAL TIMING
  // ===============================================================

  String _normalizeMealTiming(dynamic value) {
    if (value == null) {
      return '';
    }

    String text = value.toString();

    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');

    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    return text
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toUpperCase();
  }

  // ===============================================================
  // PRODUCT FILTER
  // ===============================================================

  List<Products> _getProductsByMealTiming(
    String mealName,
    List<Products> allProducts,
  ) {
    final targetMeal = _normalizeMealTiming(mealName);

    final result = allProducts.where((product) {
      final mealTimings = product.mealTimings;

      if (mealTimings == null || mealTimings.isEmpty) {
        return false;
      }

      return mealTimings.any((timing) {
        final apiMealTiming = _normalizeMealTiming(timing);

        return apiMealTiming == targetMeal;
      });
    }).toList();

    debugPrint('');
    debugPrint('========================================');
    debugPrint('GUT CLOCK PRODUCT FILTER');
    debugPrint('Selected Meal : $mealName');
    debugPrint('Target Meal   : $targetMeal');
    debugPrint('Total Products: ${allProducts.length}');
    debugPrint('Matched       : ${result.length}');
    debugPrint('========================================');

    for (final product in result) {
      debugPrint(
        '${product.productTitle} '
        '-> ${product.mealTimings}',
      );
    }

    debugPrint('========================================');

    return result;
  }

  // ===============================================================
  // SELECT TAB
  // ===============================================================

  Future<void> _selectTab(int index, {bool animatePage = true}) async {
    if (index < 0 || index >= gutClockItems.length || index == selected) {
      return;
    }

    if (!mounted) return;

    setState(() {
      selected = index;
    });

    // Reset products to first slide
    _productCarouselController.jumpToPage(0);

    // Move TabBar
    if (_tabController.index != index) {
      if (animatePage) {
        _tabController.animateTo(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      } else {
        _tabController.index = index;
      }
    }

    // Content animation
    _contentAnimationController
      ..reset()
      ..forward();

    // Provider
    await context.read<ShopProvider>().selectTimelineCategory(
      gutClockItems[index].meal,
    );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final res = ScreenSizeHelper(context);

    final mobileDesign = res.isMobile || res.isTablet;

    final productsProvider = context.watch<ProductsProvider>();

    final selectedItem = gutClockItems[selected];

    final filteredProducts = _getProductsByMealTiming(
      selectedItem.meal,
      productsProvider.additionalProducts,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          _buildHeader(mobileDesign),

          SizedBox(height: mobileDesign ? 18 : 28),

          _buildHorizontalTabs(mobileDesign),

          _buildSelectedDetails(mobileDesign, filteredProducts),
        ],
      ),
    );
  }

  // ===============================================================
  // HEADER
  // ===============================================================

  Widget _buildHeader(bool mobileDesign) {
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSize = (screenWidth * 0.065).clamp(20.0, 60.0);

    final bodySize = (screenWidth * 0.014).clamp(14.0, 22.0);

    final title = """
<h1 style="font-family:'Archivo Narrow'; font-weight:600;">
Your Gut Has a Clock! Are You Aware Of It?<br>
</h1>
""";

    final desc = """
<p style="font-family:'Courier Prime'; font-weight:400; font-style:italic; color:#786f68;">
Your Digestive capacity changes through the day.<br/>
Are you giving it the
<span style="color:#C41A0F; font-family:'Courier Prime'; font-weight:400; font-style:italic;">
Right food at the Right time?
</span>
</p>
""";

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
                textStyle: const TextStyle(height: 1),
              ),

              SizedBox(height: mobileDesign ? 8 : 12),

              DefaultTextStyle(
                style: const TextStyle(),
                textAlign: TextAlign.justify,
                child: HtmlWidget(
                  desc,
                  customStylesBuilder: (element) {
                    if (element.localName == 'p' ||
                        element.localName == 'span' ||
                        element.localName == 'div') {
                      return {'font-size': '${bodySize}px'};
                    }

                    return null;
                  },
                  textStyle: const TextStyle(height: 1.31, letterSpacing: 1.5),
                ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
              ),
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
  // TAB BAR
  // ===============================================================

  Widget _buildHorizontalTabs(bool mobileDesign) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SLIDE THROUGH YOUR DAY',
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
          height: mobileDesign ? 72 : 82,
          child: TabBar(
            controller: _tabController,

            isScrollable: true,

            padding: EdgeInsets.zero,

            labelPadding: const EdgeInsets.symmetric(horizontal: 3.5),

            tabAlignment: TabAlignment.start,

            indicator: const BoxDecoration(),

            dividerColor: Colors.transparent,

            overlayColor: WidgetStateProperty.all(Colors.transparent),

            splashFactory: NoSplash.splashFactory,

            onTap: (index) {
              _selectTab(index, animatePage: false);
            },

            tabs: List.generate(gutClockItems.length, (index) {
              return _buildTab(index, mobileDesign);
            }),
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // CUSTOM TAB
  // ===============================================================

  Widget _buildTab(int index, bool mobileDesign) {
    final item = gutClockItems[index];

    final active = selected == index;

    final tabColor = item.tabColor;

    const Color commonYellow = gTabBackGroundColor;

    final double tabWidth = mobileDesign ? 177 : 205;

    final double tabHeight = mobileDesign ? 72 : 82;

    final double imageWidth = mobileDesign ? 62 : 72;

    return GestureDetector(
      onTap: () {
        _selectTab(index, animatePage: false);
      },

      child: AnimatedContainer(
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

                  child: Image.asset(
                    item.icon,
                    width: mobileDesign ? 48 : 58,
                    height: mobileDesign ? 48 : 58,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),

                color: active ? tabColor : commonYellow,

                padding: const EdgeInsets.only(left: 10, right: 5),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      capitalizeFirstLetter(item.meal),

                      style: TextStyle(
                        fontFamily: "Avenir",
                        fontSize: fontSize09,
                        fontWeight: FontWeight.w500,
                        color: active ? gWhiteColor : tabColor,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      capitalizeFirstLetter(item.food),

                      style: TextStyle(
                        fontFamily: "Caveat",
                        fontSize: fontSize12,
                        fontWeight: FontWeight.w700,
                        color: active ? gWhiteColor : tabColor,
                        height: .9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // SELECTED DETAILS
  // ===============================================================

  Widget _buildSelectedDetails(bool mobileDesign, List<Products> products) {
    final item = gutClockItems[selected];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,

      child: Container(
        key: ValueKey(selected),

        child: Column(
          children: [
            _buildStory(item, mobileDesign),

            if (products.isNotEmpty)
              _buildProducts(products, mobileDesign)
            else
              _buildLaunchingSoon(mobileDesign),

            SizedBox(height: 30),

            _buildExploreButton(item, mobileDesign),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // STORY
  // ===============================================================

  Widget _buildStory(GutClockItem item, bool mobileDesign) {
    final html = item.story
        .replaceAll('<red>', "<span style='color:#B32929;'>")
        .replaceAll('</red>', '</span>')
        .replaceAll('<gold>', "<span style='color:#C18A12;'>")
        .replaceAll('</gold>', '</span>')
        .replaceAll('<b>', '<strong>')
        .replaceAll('</b>', '</strong>')
        .replaceAll('\n', '<br>');

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

      margin: const EdgeInsets.symmetric(vertical: 40),

      decoration: BoxDecoration(
        color: gPrimaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(mobileDesign ? 12 : 20),
      ),

      child: HtmlWidget(
        html,

        textStyle: GoogleFonts.caveat(
          fontSize: fontSize18,
          height: 1.35,
          color: Colors.black,
        ),

        customStylesBuilder: (_) => {'margin': '0', 'padding': '0'},
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
        } else if (responsive.isDesktop) {
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
        } else {
          titleSize = 17;
          priceSize = 16;
          infoSize = 14;
          buttonHeight = 40;
          contentPadding = 12;
          imageHeightMultiplier = 0.94;
          titleTwoLines = false;
          rowGap1 = 6;
          rowGap2 = 8;
          gapBeforeButton = 16;
        }

        // ============================================================
        // ARROW / SPACING
        // ============================================================

        const double arrowWidth = 22;
        const double arrowGap = 6;
        const double cardSpacing = 10;

        // ============================================================
        // CAROUSEL WIDTH
        // ============================================================

        final double carouselWidth =
            constraints.maxWidth - (arrowWidth * 2) - (arrowGap * 2);

        // Two cards visible.
        final double cardWidth = (carouselWidth - cardSpacing) / 2;

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

        return SizedBox(
          height: cardHeight,

          child: Row(
            children: [
              // ======================================================
              // LEFT ARROW
              // ======================================================
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

              // ======================================================
              // CAROUSEL
              // ======================================================
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

                        category: gutClockItems[selected].tabColor,

                        cardWidth: cardWidth,
                      ),
                    );
                  },

                  options: CarouselOptions(
                    height: cardHeight,

                    // ==================================================
                    // EXACTLY 2 FULL PRODUCTS
                    // ==================================================
                    viewportFraction: 0.5,

                    // ==================================================
                    // CONTINUOUS HORIZONTAL SCROLL
                    // ==================================================
                    scrollDirection: Axis.horizontal,

                    autoPlay: false,

                    // Move ONE product at a time.
                    pageSnapping: true,

                    enlargeCenterPage: false,

                    padEnds: false,

                    enableInfiniteScroll: false,

                    // Allows manual continuous swipe.
                    scrollPhysics: const ClampingScrollPhysics(),
                  ),
                ),
              ),

              const SizedBox(width: arrowGap),

              // ======================================================
              // RIGHT ARROW
              // ======================================================
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
  // LAUNCHING SOON
  // ===============================================================

  Widget _buildLaunchingSoon(bool mobileDesign) {
    return SizedBox(
      height: mobileDesign ? 180 : 250,

      child: Center(
        child: Text(
          'Launching Soon',

          style: TextStyle(
            color: Colors.grey,
            fontSize: mobileDesign ? 14 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // EXPLORE BUTTON
  // ===============================================================

  Widget _buildExploreButton(GutClockItem item, bool mobileDesign) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),

      duration: const Duration(milliseconds: 700),

      curve: Curves.easeOutBack,

      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },

      child: ElevatedButton(
        onPressed: () async {
          // =========================================================
          // FIND CATEGORY FROM FOOD NAME
          // =========================================================

          final productsProvider = context.read<ProductsProvider>();

          final foodName = item.food.trim().toLowerCase();

          final matchingProduct = productsProvider.additionalProducts.where((
            product,
          ) {
            final categoryName = (product.category?.name ?? '')
                .trim()
                .toLowerCase();

            return categoryName == foodName;
          }).firstOrNull;

          final categoryId = matchingProduct?.category?.id;

          debugPrint('========================================');

          debugPrint('Gut Clock Explore');

          debugPrint('Selected Food : ${item.food}');

          debugPrint(
            'Category Name : '
            '${matchingProduct?.category?.name}',
          );

          debugPrint('Category ID   : $categoryId');

          debugPrint('========================================');

          // =========================================================
          // CATEGORY NOT FOUND
          // =========================================================

          if (categoryId == null) {
            debugPrint(
              'Category ID not found '
              'for ${item.food}',
            );

            return;
          }

          // =========================================================
          // SAVE CATEGORY
          // =========================================================

          final prefs = AppConfig().preferences;

          await prefs?.setString('selectedCategory', categoryId.toString());

          debugPrint(
            'Saved selectedCategory = '
            '${prefs?.getString("selectedCategory")}',
          );

          // =========================================================
          // ARCHIVED
          // =========================================================

          if (matchingProduct?.isArchived?.toString().trim() == '1') {
            context.go('/launching');

            return;
          }

          // =========================================================
          // FOOD FARMACY
          // =========================================================

          if (categoryId == 32) {
            final shopProvider = context.read<ShopProvider>();

            shopProvider.changeTab(1);

            context.go('/');

            return;
          }

          // =========================================================
          // OTHER CATEGORIES
          // =========================================================

          context.go('/category/$categoryId');
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: gPrimaryColor,

          elevation: 2,

          padding: EdgeInsets.symmetric(
            horizontal: mobileDesign ? 25 : 30,
            vertical: mobileDesign ? 8 : 10,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),

        child: Text(
          'Explore '
          '${capitalizeFirstLetter(item.food)}',

          style: TextStyle(
            fontFamily: 'Caveat',
            fontSize: fontSize14,
            fontWeight: FontWeight.w700,
            color: gMainColor,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // CAPITALIZE
  // ===============================================================
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }

    final value = text.toLowerCase();

    return value[0].toUpperCase() + value.substring(1);
  }
}
