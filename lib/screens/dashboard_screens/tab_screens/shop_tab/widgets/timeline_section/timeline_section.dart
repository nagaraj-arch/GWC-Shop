import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../../controllers/providers/products_providers.dart';
import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import 'clock_vertical_slider.dart';

class TimelineSection extends StatefulWidget {
  const TimelineSection({super.key});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  final List<String> meals = [
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  EARLY MORNING
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  MORNING
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  MID MORNING
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  NOON
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  EVENING
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  NIGHT
</p>
""",
  ];

  final List<String> foods = [
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  AMBALI
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  NUTRIMEAL
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  INFUSION
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  KHICHDI
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  HEALTHY INDULGENCE
</p>
""",
    """
<p style="font-family:'Arimo'; font-weight:700; line-height:1.1;">
  SOUP
</p>
""",
  ];

  final icons = [
    "assets/images/early_morning.png",
    "assets/images/morning.png",
    "assets/images/mid_morning.png",
    "assets/images/noon.png",
    "assets/images/evening.png",
    "assets/images/night.png",
    // Icons.sunny,
    // Icons.wb_sunny_outlined,
    // Icons.sunny_snowing,
    // Icons.light_mode,
    // Icons.wb_twilight,
    // Icons.nightlight_round,
  ];

  late int selected;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    selected = _getCurrentMealIndex();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ShopProvider>().selectTimelineCategory(foods[selected]);
    });

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final current = _getCurrentMealIndex();
      if (current != selected) {
        setState(() {
          selected = current;
        });
        context.read<ShopProvider>().selectTimelineCategory(foods[current]);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _getCurrentMealIndex() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 8) return 0;
    if (hour >= 8 && hour < 11) return 1;
    if (hour >= 11 && hour < 13) return 2;
    if (hour >= 13 && hour < 17) return 3;
    if (hour >= 17 && hour < 20) return 4;
    return 5;
  }

  String _normalizeMealTiming(dynamic value) {
    if (value == null) return "";

    String text = value.toString();

    // 🔥 Remove HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');

    // 🔥 Remove HTML entities if any
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // 🔥 Normalize spaces / new lines
    return text
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toUpperCase();
  }

  List<Products> _getProductsByMealTiming(
      String mealName,
      List<Products> allProducts,
      ) {
    // 🔥 HTML meal name becomes plain text here
    final targetMeal = _normalizeMealTiming(mealName);

    if (targetMeal.isEmpty) {
      return [];
    }

    return allProducts.where((product) {
      final mealTimings = product.mealTimings;

      if (mealTimings == null || mealTimings.isEmpty) {
        return false;
      }

      return mealTimings.any((timing) {
        // 🔥 API value is normalized to the same format
        final apiMealTiming = _normalizeMealTiming(timing);

        // 🔥 EXACT MATCH
        return apiMealTiming == targetMeal;
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final helper = ScreenSizeHelper(context);

    // IMPORTANT:
    // watch() makes TimelineSection rebuild when
    // ProductsProvider.additionalProducts gets updated.
    final productsProvider = context.watch<ProductsProvider>();

    final filteredProducts = _getProductsByMealTiming(
      meals[selected],
      productsProvider.additionalProducts,
    );

    return Column(
      children: [
        (helper.isMobile || helper.isTablet) ? mobileTabBar() : _timeline(),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: filteredProducts.isNotEmpty
              ? (selected < 3
                    ? Row(
                        key: const ValueKey("leftLayout"),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Expanded(
                            flex: helper.isMobile ? 1 : 3,
                            child: _story(selected),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: GutClockVerticalSlider(
                              products: filteredProducts,
                              categoryName: foods[selected],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        key: const ValueKey("rightLayout"),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Expanded(
                            flex: 1,
                            child: GutClockVerticalSlider(
                              products: filteredProducts,
                              categoryName: foods[selected],
                            ),
                          ),const SizedBox(width: 10),
                          Expanded(
                            flex: helper.isMobile ? 1 : 3,
                            child: _story(selected),
                          ),
                        ],
                      ))
              : const SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      "Launching Soon",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  final ScrollController _timelineController = ScrollController();

  Widget mobileTabBar() {
    final helper = ScreenSizeHelper(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // ============================================================
    // RESPONSIVE ITEM WIDTH
    // ============================================================

    final double itemWidth = helper.isMobile
        ? (screenWidth * 0.24).clamp(82.0, 105.0)
        : helper.isTablet
        ? (screenWidth * 0.16).clamp(90.0, 120.0)
        : helper.isLaptop
        ? 110.0
        : 125.0;

    // ============================================================
    // RESPONSIVE FONT
    // ============================================================

    final double titleFont = helper.isMobile
        ? 8.5
        : helper.isTablet
        ? 10.0
        : helper.isLaptop
        ? 11.0
        : 12.0;

    final double mealFont = helper.isMobile
        ? 8.0
        : helper.isTablet
        ? 9.0
        : 10.0;

    // ============================================================
    // RESPONSIVE HEIGHTS
    // ============================================================

    final double totalHeight = helper.isMobile
        ? 175.0
        : helper.isTablet
        ? 200.0
        : 225.0;

    final double thumbnailHeight = helper.isMobile
        ? 58.0
        : helper.isTablet
        ? 65.0
        : 70.0;

    final double arrowAreaHeight = helper.isMobile
        ? 55.0
        : helper.isTablet
        ? 65.0
        : 75.0;

    // ============================================================
    // RESPONSIVE ICON SIZE
    // ============================================================

    final double iconSize = helper.isMobile
        ? 34.0
        : helper.isTablet
        ? 42.0
        : helper.isLaptop
        ? 48.0
        : 52.0;

    final selectedFontSize = helper.isMobile
        ? 08.0
        : helper.isTablet
        ? 12.0
        : helper.isLaptop
        ? 13.0
        : 14.0; // desktop & above

    final unselectedFontSize = helper.isMobile
        ? 07.0
        : helper.isTablet
        ? 11.0
        : helper.isLaptop
        ? 12.0
        : 13.0;

    return SizedBox(
      height: totalHeight,
      child: SingleChildScrollView(
        controller: _timelineController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: SizedBox(
          width: itemWidth * meals.length,
          child: Column(
            children: [
              // ========================================================
              // THUMBNAILS
              // ========================================================
              SizedBox(
                height: thumbnailHeight,
                child: Row(
                  children: List.generate(meals.length, (index) {
                    final active = selected == index;

                    return SizedBox(
                      width: itemWidth,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          setState(() {
                            selected = index;
                          });

                          await context
                              .read<ShopProvider>()
                              .selectTimelineCategory(foods[index]);

                          final target =
                              (index * itemWidth) -
                              (screenWidth / 2) +
                              (itemWidth / 2);

                          if (_timelineController.hasClients) {
                            _timelineController.animateTo(
                              target.clamp(
                                0.0,
                                _timelineController.position.maxScrollExtent,
                              ),
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.all(helper.isMobile ? 2 : 4),
                          decoration: active
                              ? BoxDecoration(
                                  color: gPrimaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(
                                    helper.isMobile ? 6 : 8,
                                  ),
                                )
                              : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: active ? 1.08 : 1,
                                child: Image(
                                  image: AssetImage(icons[index]),
                                  width: iconSize,
                                  height: iconSize,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              SizedBox(height: helper.isMobile ? 2 : 4),

                              HtmlWidget(
                                meals[index],
                                textStyle: TextStyle(
                                  fontSize: titleFont,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: active
                                      ? gPrimaryColor
                                      : gHintTextColor,
                                  height: 1.0,
                                ),
                                customStylesBuilder: (_) => {
                                  'text-align': 'center',
                                  'margin': '0',
                                  'padding': '0',
                                  'line-height': '1',
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // ========================================================
              // TIMELINE
              // ========================================================
              SizedBox(
                height: helper.isMobile ? 18 : 20,
                child: Stack(
                  children: [
                    Positioned(
                      left: itemWidth / 2,
                      right: itemWidth / 2,
                      top: helper.isMobile ? 8 : 9,
                      child: Container(
                        height: helper.isMobile ? 1.5 : 2,
                        color: Colors.grey.shade300,
                      ),
                    ),

                    Row(
                      children: List.generate(meals.length, (index) {
                        return SizedBox(
                          width: itemWidth,
                          child: Center(
                            child: Container(
                              width: helper.isMobile ? 7 : 9,
                              height: helper.isMobile ? 7 : 9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      left:
                          (selected * itemWidth) +
                          (itemWidth / 2) -
                          (helper.isMobile ? 4 : 5),
                      top: helper.isMobile ? 4 : 4,
                      child: Container(
                        width: helper.isMobile ? 8 : 10,
                        height: helper.isMobile ? 8 : 10,
                        decoration: BoxDecoration(
                          color: gMainColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: helper.isMobile ? 1.5 : 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // TITLES
              // ========================================================
              SizedBox(
                height: helper.isMobile ? 35 : 45,
                child: Row(
                  children: List.generate(foods.length, (index) {
                    final active = selected == index;

                    final baseStyle = TextStyle(
                      fontFamily: active ? fontBold : fontMedium,
                      fontSize: active ? selectedFontSize : unselectedFontSize,
                      color: active ? gPrimaryColor : gHintTextColor,
                      height: 1.2,
                    );

                    return SizedBox(
                      width: itemWidth,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: helper.isMobile ? 2 : 4,
                          ),
                          child: HtmlWidget(
                            foods[index],
                            textStyle: baseStyle,
                            customStylesBuilder: (_) => {
                              'text-align': 'center',
                              'margin': '0',
                              'padding': '0',
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 2),

              // ========================================================
              // ARROW
              // ========================================================
              SizedBox(
                height: arrowAreaHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      left:
                          (selected * itemWidth) +
                          (itemWidth / 2) -
                          (itemWidth / 2),
                      top: 0,
                      child: SizedBox(
                        width: itemWidth,
                        child: Center(
                          child: Image.asset(
                            "assets/images/tab_arrow.png",
                            width: helper.isMobile ? 14 : 18,
                            height: helper.isMobile ? 34 : 42,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeline() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // --------------------------------------------------
        // RESPONSIVE SCALE
        // Mobile design is the base design for ALL devices.
        // --------------------------------------------------
        final scale = (width / 390.0).clamp(0.82, 1.45);

        final itemWidth = width / meals.length;

        final iconSize = (52.0 * scale).clamp(44.0, 70.0);
        final timeFontSize = (9.0 * scale).clamp(8.0, 12.0);

        final foodFontSize = (9.0 * scale).clamp(8.0, 13.0);

        final timelineHeight = (20.0 * scale).clamp(18.0, 24.0);

        final dotSize = (9.0 * scale).clamp(8.0, 11.0);

        final activeDotSize = (10.0 * scale).clamp(9.0, 12.0);

        final arrowHeight = (65.0 * scale).clamp(55.0, 75.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // ICON + TIME
            // ==================================================
            SizedBox(
              height: (iconSize + timeFontSize + 12).clamp(
                72.0,
                100.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  meals.length,
                      (index) {
                    final active = selected == index;

                    return Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () async {
                          setState(() {
                            selected = index;
                          });

                          await context
                              .read<ShopProvider>()
                              .selectTimelineCategory(
                            foods[index],
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 250,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * scale,
                            vertical: 2,
                          ),
                          decoration: active
                              ? BoxDecoration(
                            color:
                            gPrimaryColor.withAlpha(10),
                            borderRadius:
                            BorderRadius.circular(6),
                          )
                              : null,
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // -----------------------------
                              // ICON
                              // -----------------------------
                              AnimatedScale(
                                duration: const Duration(
                                  milliseconds: 250,
                                ),
                                scale: active ? 1.06 : 1.0,
                                child: Image.asset(
                                  icons[index],
                                  width: iconSize,
                                  height: iconSize,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              SizedBox(
                                height: 2 * scale,
                              ),

                              // -----------------------------
                              // TIME HTML
                              // -----------------------------
                              Flexible(
                                child: HtmlWidget(
                                  meals[index],
                                  textStyle: TextStyle(
                                    fontSize: timeFontSize,
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: active
                                        ? gPrimaryColor
                                        : gHintTextColor,
                                    height: 1.0,
                                  ),
                                  customStylesBuilder: (_) => {
                                    'text-align': 'center',
                                    'margin': '0',
                                    'padding': '0',
                                    'line-height': '1',
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ==================================================
            // TIMELINE
            // ==================================================
            SizedBox(
              height: timelineHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Horizontal line
                  Positioned(
                    left: itemWidth / 2,
                    right: itemWidth / 2,
                    top: timelineHeight / 2 - 1,
                    child: Container(
                      height: 2,
                      color: gHintTextColor,
                    ),
                  ),

                  // Normal dots
                  Row(
                    children: List.generate(
                      meals.length,
                          (index) {
                        return Expanded(
                          child: Center(
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: gHintTextColor,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Active dot
                  AnimatedPositioned(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    curve: Curves.easeOut,
                    left: (itemWidth * selected) +
                        (itemWidth / 2) -
                        (activeDotSize / 2),
                    top: timelineHeight / 2 -
                        (activeDotSize / 2),
                    child: Container(
                      width: activeDotSize,
                      height: activeDotSize,
                      decoration: BoxDecoration(
                        color: gPrimaryColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // FOOD NAMES
            // ==================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                foods.length,
                    (index) {
                  final active = selected == index;

                  return Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      style: TextStyle(
                        fontFamily:
                        active ? fontBold : fontMedium,
                        fontSize: foodFontSize,
                        fontWeight: active
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: active
                            ? gPrimaryColor
                            : gHintTextColor,
                        height: 1.15,
                      ),
                      child: HtmlWidget(
                        foods[index],
                        textStyle: TextStyle(
                          fontFamily:
                          active ? fontBold : fontMedium,
                          fontSize: foodFontSize,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: active
                              ? gPrimaryColor
                              : gHintTextColor,
                          height: 1.15,
                        ),
                        customStylesBuilder: (_) => {
                          'text-align': 'center',
                          'margin': '0',
                          'padding': '0',
                          'line-height': '1.15',
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 5 * scale,
            ),

            // ==================================================
            // MOVING ARROW
            // ==================================================
            SizedBox(
              height: arrowHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(
                      milliseconds: 350,
                    ),
                    curve: Curves.easeOut,
                    left: (itemWidth * selected) +
                        (itemWidth / 2) -
                        (arrowHeight * 0.26),
                    child: Image.asset(
                      "assets/images/tab_arrow.png",
                      height: arrowHeight,
                      width: arrowHeight * 0.52,
                      fit: BoxFit.contain,
                      color: gPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  final List<Map<String, String>> storyData = [
    // EARLY MORNING - AMBALI
    {
      "body":
          "As you wake up, so do the <red>trillion micro biome</red> in your gut!\n"
          "This is the best time to get their meal ready & build more of them.\n\n"
          "<gold>Our Ambali</gold>\n"
          "<b>Is an excellent naturally fermented, probiotic drink!</b>\n"
          "<b>Just what your Gut & biome need.</b>\n\n"
          "<red>Give them your love!</red>\n"
          "As they control majority of what happens within you.",
    },

    // MORNING - NUTRIMEAL
    {
      "body":
          "“Eat breakfast like a king”\n"
          "Means more <red>Quality over Quantity!</red> "
          "A healthy day should begin with nutritionally dense breakfast, not just quantity.\n\n"
          "<gold>Our NutriMeal</gold>\n"
          "<b>A complete nutritionally balanced porridge,</b>\n"
          "<b>will set you for the day & control your cravings.</b>\n\n"
          "<red>Start complete.</red>\n"
          "Arrive at lunch steadily, curb your cravings.",
    },

    // MID MORNING - INFUSIONS
    {
      "body":
          "<red>Not every pause needs another snack.</red>\n"
          "A warm infusion brings flavour, hydration and a lighter\n"
          "ritual to the space between meals.\n\n"
          "<gold>Our Infusions</gold>\n"
          "<b>Not only fill these gaps but also strengthen your</b>\n"
          "<b>metabolism and lower the chances of gut disturbances.</b>\n\n"
          "<red>Have a warm spiced pause,</red>\n"
          "Pep up for real nourishment.",
    },

    // NOON - KHICHDI
    {
      "body":
          "Struggling with <red>Cravings post 4pm?</red>\n"
          "Focus on what you eat at lunch! This is when your Gut is\n"
          "ready for most of its daily fuel.\n\n"
          "<gold>Our Khichadi's</gold>\n"
          "<b>Are borrowed wisdom from our tradition. They give your gut</b>\n"
          "<b>the satiety that it needs at this time.</b>\n\n"
          "<red>Eat right at noon &</red>\n"
          "Meet the evening with ease.",
    },

    // EVENING - HEALTHY INDULGENCE
    {
      "body":
          "<red>Sometimes your gut asks for some pampering</red>\n"
          "A bowl of naturally creamy kheer on those days, is just\n"
          "what fits in perfectly.\n\n"
          "<gold>Our Healthy Indulgence's</gold>\n"
          "<b>Not only pampers your Gut, but also helps calm down your</b>\n"
          "<b>Gut-brain activities.</b>\n\n"
          "<red>Indulge occasionally in a warm soulful treat,</red>\n"
          "Free up from any guilt.",
    },

    // NIGHT - SOUP
    {
      "body":
          "Struggling with <red>Satisfactory Evacuation?</red>\n"
          "Its probably insufficient Fruits & vegetable fiber in your diet.\n\n"
          "<gold>Our Soups</gold>\n"
          "<b>Do the magic for you!</b>\n"
          "<b>Tasty, tempting AND fulfilling the bulk forming fiber need of your gut.</b>\n\n"
          "<red>Best had at dinner</red>\n"
          "Satiating and helps lower the load on your gut post sunset.",
    },
  ];

  Widget _story(int index) {
    final responsive = ScreenSizeHelper(context);

    final bodySize = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 23.0
        : responsive.isLaptop
        ? 25.0
        : 27.0;

    final html = storyData[index]["body"]!
        .replaceAll("<red>", "<span style='color:#B32929;'>")
        .replaceAll("</red>", "</span>")
        .replaceAll("<gold>", "<span style='color:#C18A12;'>")
        .replaceAll("</gold>", "</span>")
        .replaceAll("<b>", "<strong>")
        .replaceAll("</b>", "</strong>")
        .replaceAll("\n", "<br>");

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Center(
        key: ValueKey(index),
        child: SizedBox(
          width: responsive.isMobile
              ? double.infinity
              : responsive.isTablet
              ? 500
              : 650,
          child: HtmlWidget(
            html,
            textStyle: GoogleFonts.caveat(
              fontSize: bodySize,
              height: 1.6,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
