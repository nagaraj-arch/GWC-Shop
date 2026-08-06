import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/controllers/providers/products_providers.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../common_category_card.dart';
import 'clock_vertical_slider.dart';

class GutClockSection extends StatefulWidget {
  const GutClockSection({super.key});

  @override
  State<GutClockSection> createState() => _GutClockSectionState();
}

class _GutClockSectionState extends State<GutClockSection> {
  final List<String> meals = [
    "EARLY MORNING",
    "MORNING",
    "MID MORNING",
    "NOON",
    "EVENING",
    "NIGHT",
  ];

  final List<String> foods = [
    "AMBALIS",
    "PORRIDGE",
    "INFUSION",
    "KHICHDI",
    "INFUSION",
    "SOUP",
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

  List<dynamic> _getProductsByMealTiming(String mealName) {
    final provider = context.read<ProductsProvider>();
    final allProducts = provider.additionalProducts;

    // ✅ Clean meal name for comparison (remove \n, trim, uppercase)
    final targetMeal = mealName.toUpperCase().replaceAll('\n', ' ').trim();

    // ✅ Filter products where meal_timings contains EXACT match
    return allProducts.where((product) {
      final mealTimings = product.mealTimings ?? [];

      // ✅ Check for exact match
      return mealTimings.any((timing) {
        final timingUpper = timing.toUpperCase().trim();

        // ✅ Exact match checks
        if (timingUpper == targetMeal) return true;

        // ✅ Handle special cases
        if (targetMeal == "EARLY MORNING" && timingUpper == "EARLY MORNING")
          return true;
        if (targetMeal == "MID MORNING" && timingUpper == "MID MORNING")
          return true;
        if (targetMeal == "NIGHT" &&
            (timingUpper == "NIGHT" || timingUpper == "NIGHT "))
          return true;

        return false;
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    // ✅ Get filtered products for current meal
    final filteredProducts = _getProductsByMealTiming(meals[selected]);

    return Column(
      children: [
        isDesktop
            ? Row(
                children: [
                  Expanded(flex: 3, child: _leftSection()),
                  Expanded(flex: 5, child: _rightSectionWithSlider()),
                ],
              )
            : Column(children: [_leftSection(), _rightSectionWithSlider()]),
        SizedBox(height: 20),
        _timeline(),
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
                            flex: 1,
                            child: GutClockVerticalSlider(
                              products: filteredProducts,
                              categoryName: foods[selected],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: isDesktop ? 3 : 1,
                            child: _story(selected),
                          ),
                        ],
                      )
                    : Row(
                        key: const ValueKey("rightLayout"),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isDesktop ? 3 : 1,
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
                      ))
              : const SizedBox(
                  height: 520,
                  child: Center(
                    child: Text(
                      "No products available for this timing",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // LEFT: Title + description only
  Widget _leftSection() {
    final responsive = ScreenSizeHelper(context);

    final titleSize = responsive.isMobile
        ? 52.0
        : responsive.isTablet
        ? 68.0
        : responsive.isLaptop
        ? 88.0
        : responsive.isDesktop
        ? 106.0
        : responsive.isLargeDesktop
        ? 130.0
        : 140.0;

    final bodySize = responsive.isMobile
        ? 14.0
        : responsive.isTablet
        ? 16.0
        : responsive.isLaptop
        ? 20.0
        : responsive.isDesktop
        ? 24.0
        : responsive.isLargeDesktop
        ? 26.0
        : 28.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Gut\nClock",
          style: GoogleFonts.inter(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xff2C2423),
            height: 1.0,
            letterSpacing: -1,
          ),
        ).animate().fade(duration: 500.ms).slideX(begin: -.2),

        const SizedBox(height: 16),

        Text(
          "Your gut changes with the day. Are you giving it the right food at the right time?",
          style: GoogleFonts.ibmPlexMono(
            fontSize: bodySize,
            height: 1.7,
            color: gHintTextColor,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fade(delay: 300.ms).slideX(begin: -.15),
      ],
    );
  }

  // RIGHT: Slider + "Explore categories" + arrow (desktop)
  Widget _rightSectionWithSlider() {
    final res = ResponsiveHelper(context);

    return Row(
      children: [
        res.isMobile
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: _exploreAndArrow(),
              ),
        const SizedBox(width: 20),
        Expanded(child: CommonCategorySlider(mode: SliderMode.multi)),
      ],
    );
  }

  // Shared widget: "Explore categories" + arrow
  Widget _exploreAndArrow() {
    final responsive = ScreenSizeHelper(context);

    final highlightSize = responsive.isMobile
        ? 16.0
        : responsive.isTablet
        ? 18.0
        : responsive.isLaptop
        ? 20.0
        : 22.0;

    final arrowHeight = responsive.isMobile
        ? 32.0
        : responsive.isTablet
        ? 40.0
        : responsive.isLaptop
        ? 50.0
        : 60.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
              alignment: Alignment.topRight,
              child: Transform.rotate(
                angle: -0.1,
                child: Text(
                  "Explore\ncategories",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.caveat(
                    fontSize: highlightSize,
                    color: gPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveX(begin: 0, end: 6, duration: 1200.ms),

        const SizedBox(height: 6),

        Image.asset("assets/images/clock_top_arrow.png", height: arrowHeight)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveX(begin: 0, end: 6, duration: 1200.ms),
      ],
    );
  }

  Widget _timeline() {
    final icons = [
      Icons.sunny,
      Icons.wb_sunny_outlined,
      Icons.sunny_snowing,
      Icons.light_mode,
      Icons.wb_twilight,
      Icons.nightlight_round,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / meals.length;
        final iconRowHeight = ResponsiveHelper(context).isDesktop ? 62.0 : 72.0;

        return Column(
          children: [
            /// ICONS + TIME
            SizedBox(
              height: iconRowHeight,
              child: Row(
                children: List.generate(meals.length, (index) {
                  final active = selected == index;

                  return Expanded(
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
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: active
                            ? BoxDecoration(
                                color: gPrimaryColor.withAlpha(10),
                                borderRadius: BorderRadius.circular(6),
                              )
                            : const BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              duration: const Duration(milliseconds: 250),
                              scale: active ? 1.08 : 1,
                              child: Icon(
                                icons[index],
                                size: active ? 22 : 20,
                                color: active
                                    ? gPrimaryColor
                                    : const Color(0xffD89C00),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meals[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: active ? fontBold : fontMedium,
                                fontSize: active ? fontSize09 : fontSize08,
                                color: active ? gPrimaryColor : gHintTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),

            /// TIMELINE
            SizedBox(
              height: 20,
              child: Stack(
                children: [
                  Positioned(
                    left: itemWidth / 2,
                    right: itemWidth / 2,
                    top: 9,
                    child: Container(height: 2, color: gHintTextColor),
                  ),
                  Row(
                    children: List.generate(meals.length, (index) {
                      return Expanded(
                        child: Center(
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: gHintTextColor),
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
                    left: (itemWidth * selected) + itemWidth / 2 - 5,
                    top: 4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: gPrimaryColor,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// FOOD NAMES
            Row(
              children: List.generate(foods.length, (index) {
                final active = selected == index;

                return Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      fontFamily: active ? fontBold : fontMedium,
                      fontSize: active ? fontSize09 : fontSize08,
                      color: active ? gPrimaryColor : gHintTextColor,
                    ),
                    child: Text(foods[index], textAlign: TextAlign.center),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),

            /// MOVING ARROW
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    left: (itemWidth * selected) + (itemWidth / 2) - 18,
                    child: Image.asset(
                      "assets/images/tab_arrow.png",
                      height: 70,
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
