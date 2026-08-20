import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:gwc_shop/widgets/button_widgets/button_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../../../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../timeline_section/clock_vertical_slider.dart';

class FoodFarmacyTimeline extends StatefulWidget {
  const FoodFarmacyTimeline({super.key});

  @override
  State<FoodFarmacyTimeline> createState() => _FoodFarmacyTimelineState();
}

class _FoodFarmacyTimelineState extends State<FoodFarmacyTimeline> {
  int selected = 0;

  ClusterList? get selectedCluster {
    final provider = context.read<ShopProvider>();
    if (provider.clusterList.isEmpty) return null;
    if (selected < 0 || selected >= provider.clusterList.length) return null;
    return provider.clusterList[selected];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchClusterList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final helper = ScreenSizeHelper(context);
    final provider = context.watch<ShopProvider>();
    final clusters = provider.clusterList;
    // final allCategories = provider.allCategories;
    //
    // final height =
    //     MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight -
    //     60;

    // Ensure selected is valid when data loads/changes
    if (clusters.isNotEmpty && selected >= clusters.length) {
      selected = clusters.length - 1;
    }

    return Column(
      children: [
        SizedBox(height: 40),
        leftSection().animate().fade().slideY(begin: .2),
        SizedBox(height: 20),
        _presentingFoodFarmacy(),
        // ConstrainedBox(
        //   constraints: BoxConstraints(minHeight: height > 0 ? height : 0),
        //   child: helper.isMobile || helper.isTablet
        //       ? Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             leftSection().animate().fade().slideY(begin: .2),
        //
        //             const SizedBox(height: 20),
        //
        //             _rightSectionWithSlider(
        //               allCategories,
        //             ).animate().fade(delay: 300.ms).scale(),
        //           ],
        //         )
        //       : LayoutBuilder(
        //           builder: (context, constraints) {
        //             return Row(
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 /// LEFT CONTENT
        //                 Expanded(flex: 58, child: leftSection()),
        //
        //                 const SizedBox(width: 20),
        //
        //                 /// RIGHT IMAGE
        //                 Expanded(
        //                   flex: 42,
        //                   child: _rightSectionWithSlider(
        //                     allCategories,
        //                   ).animate().fade(delay: 300.ms).scale(),
        //                 ),
        //               ],
        //             );
        //           },
        //         ),
        // ),
        if (clusters.isNotEmpty)
          (helper.isMobile || helper.isTablet)
              ? clusterTabBar(clusters)
              : _clusterTimeline(clusters),

        const SizedBox(height: 10),
        // Cluster details + products
        if (selectedCluster != null) _clusterDetailsWithProducts(),
        SizedBox(height: 40),
      ],
    );
  }

  // ------------------- Top sections (unchanged) -------------------

  Widget leftSection() {
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSize = (screenWidth * 0.065).clamp(20.0, 60.0);

    final bodySize = (screenWidth * 0.014).clamp(14.0, 22.0);

    final title = """
<h1 style="font-family:'Archivo Narrow'; font-weight:600; ">
Is Your Gut out of Rhythm?
</h1>
""";

    final desc = """
<p style="font-family:'Courier Prime'; font-weight:400; font-size:inherit; font-style:italic;"
  "color:#786f68;">
   We curated Food Only Combination that can fix it!<br/>
   Your gut just wants
<span style="color:#C41A0F; font-family:'Courier Prime'; font-weight:400; font-style:italic;">
     Right support NOT Harsh chemicals.
  </span>
  </span>
</p>
""";
    //     final desc = """
    // <p style="font-family:'Courier Prime'; font-weight:400; font-size:inherit; font-style:italic;">
    //   <span style="color:#786f68;">
    //    The everyday idea of food as<br> medicine.
    // Food Farmacy brings targeted<br>
    //  formulations for gas, bloating,<br>
    //   acidity, burping, constipation and<br>
    //    poor digestion—using familiar, time-<br>
    //    tested ingredients in the right form <br>
    //    and dose for the moment your gut<br>
    //     needs support.<br>
    // Right food. Right concern. A gentler<br>
    //  way back to rhythm.
    //   </span>
    // </p>
    //
    // """;

    return Column(
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
          textStyle: TextStyle(height: 1),
        ),

        // SizedBox(height: 8),
        // const SizedBox(height: 8),
        // Transform.rotate(
        //   angle: -.08,
        //   child: Text(
        //     "Meet Food Farmacy",
        //     style: TextStyle(
        //       fontFamily: "Caveat",
        //       fontWeight: FontWeight.w700,
        //       color: const Color(0xffB7861A),
        //       fontSize: subtitleSize,
        //       height: 1.4, // line spacing
        //       letterSpacing: 0, // letter spacing
        //     ),
        //   ),
        // ).animate(delay: 400.ms).fade().slideY(begin: .4),
        const SizedBox(height: 20),
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
            textStyle: TextStyle(
              height: 1.31, // Line spacing
              letterSpacing: 1.5, // Letter spacing
            ),
          ).animate().fade(delay: 300.ms).slideY(begin: 0.15),
        ),
        // Text(
        //   "Gut out of\nRhythm?",
        //   style: TextStyle(
        //     fontFamily: "Archivo Narrow",
        //     fontWeight: FontWeight.w700,
        //     fontSize: titleSize,
        //     color: gBlackColor,
        //     height: 1.0,
        //     letterSpacing: -2.0,
        //   ),
        // ).animate().fade(duration: 500.ms).slideX(begin: -.2),
        //
        // const SizedBox(height: 8),
        // Transform.rotate(
        //   angle: -.08,
        //   child: Text(
        //     "Meet Food Farmacy",
        //     style: TextStyle(
        //       fontFamily: "Caveat",
        //       fontWeight: FontWeight.w700,
        //       color: const Color(0xffB7861A),
        //       fontSize: subtitleSize,
        //       height: 1.4, // line spacing
        //       letterSpacing: 0, // letter spacing
        //     ),
        //   ),
        // ).animate(delay: 400.ms).fade().slideY(begin: .4),
        //
        // const SizedBox(height: 20),
        // Text(
        //   "The everyday idea of food as medicine.\n"
        //   "Food Farmacy brings targeted formulations "
        //   "for gas, bloating, acidity, burping, "
        //   "constipation and poor digestion using "
        //   "familiar, time-tested ingredients in the "
        //   "right form and dose for the moment your "
        //   "gut needs support.\n"
        //   "Right food. Right concern. "
        //   "A gentler way back to rhythm.",
        //   style: TextStyle(
        //     fontFamily: "Courier Prime",
        //     fontWeight: FontWeight.w200,
        //     height: 1.31, // line spacing
        //     letterSpacing: 0, // letter spacing
        //     color: gHintTextColor,
        //     fontSize: bodySize,
        //   ),
        // ).animate().fade(duration: 500.ms).slideX(begin: -.2),
      ],
    );
  }

  Widget _presentingFoodFarmacy() {
    final screenWidth = MediaQuery.of(context).size.width;

    // -----------------------------
    // RESPONSIVE SIZES
    // -----------------------------
    final titleSize = (screenWidth * 0.022).clamp(22.0, 38.0);

    final arrowSize = (screenWidth * 0.065).clamp(65.0, 115.0);

    // final containerHeight = (screenWidth * 0.075).clamp(95.0, 125.0);
    //
    // // Arrow position
    // final arrowLeft = (screenWidth * 0.065).clamp(5.0, 100.0);
    //
    // // -----------------------------
    // // TITLE + BUTTON POSITION
    // // -----------------------------
    // final titleTop = (screenWidth * 0.014).clamp(12.0, 22.0);
    //
    // final titleButtonGap = (screenWidth * 0.008).clamp(5.0, 12.0);
    //
    // // Responsive horizontal padding
    // final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 60.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ARROW - bottom left
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Image.asset(
            "assets/images/food.png",
            width: arrowSize,
            fit: BoxFit.contain,
          ),
        ),

        // TITLE - immediately after arrow
        Transform.rotate(
          angle: -.1,
          child: Text(
            "Presenting Our Food Farmacy",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Caveat",
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xffB7861A),
              height: 1,
            ),
          ),
        ),
        SizedBox(width: 10),

        // BUTTON - immediately after title
        Transform.translate(
          offset: Offset(0, -(screenWidth * 0.004).clamp(2.0, 6.0)),
          child: ButtonWidget(
            text: "Explore Products",
            onPressed: () {
              final shopProvider = context.read<ShopProvider>();

              shopProvider.changeTab(2);
              context.go('/');
            },
            isLoading: false,
          ),
        ),
      ],
    );
  }

  // Widget _rightSectionWithSlider(List categories) {
  //   final category = categories.cast<CategoryList?>().firstWhere(
  //     (item) => item?.id == 32,
  //     orElse: () => null,
  //   );
  //
  //   if (category == null) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   final thumbnail = category.thumbnail ?? '';
  //
  //   if (thumbnail.isEmpty) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   return LayoutBuilder(
  //     builder: (context, outerConstraints) {
  //       final availableWidth = outerConstraints.maxWidth;
  //
  //       // ============================================================
  //       // RESPONSIVE VALUES
  //       // ============================================================
  //
  //       final isSmallMobile = availableWidth < 360;
  //       final isMobile = availableWidth < 600;
  //       final isTablet = availableWidth >= 600 && availableWidth < 1024;
  //       final isLaptop = availableWidth >= 1024 && availableWidth < 1440;
  //
  //       // Arrow
  //       final arrowHeight = isSmallMobile
  //           ? 24.0
  //           : isMobile
  //           ? 28.0
  //           : isTablet
  //           ? 38.0
  //           : isLaptop
  //           ? 46.0
  //           : 54.0;
  //
  //       // Card max width
  //       final maxCardWidth = isSmallMobile
  //           ? 260.0
  //           : isMobile
  //           ? 300.0
  //           : isTablet
  //           ? 360.0
  //           : 480.0;
  //
  //       return Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           // ============================================================
  //           // ARROW
  //           // ============================================================
  //           if (isMobile || isTablet || isLaptop || !isMobile) ...[
  //             Transform.scale(
  //                   scale: 1.8,
  //                   child: Image.asset(
  //                     "assets/images/food_farmacy_arrow.png",
  //                     height: arrowHeight,
  //                     fit: BoxFit.contain,
  //                   ),
  //                 )
  //                 .animate(onPlay: (c) => c.repeat(reverse: true))
  //                 .moveX(begin: 0, end: 6, duration: 1200.ms),
  //
  //             const SizedBox(width: 10),
  //           ],
  //           // ============================================================
  //           // CATEGORY CARD
  //           // ============================================================
  //           Expanded(
  //             child: Center(
  //               child: ConstrainedBox(
  //                 constraints: BoxConstraints(maxWidth: maxCardWidth),
  //                 child: LayoutBuilder(
  //                   builder: (context, constraints) {
  //                     final cardWidth = constraints.maxWidth;
  //
  //                     // Keep card compact on mobile
  //                     final cardHeight = isSmallMobile
  //                         ? cardWidth * 0.74
  //                         : isMobile
  //                         ? cardWidth * 0.72
  //                         : isTablet
  //                         ? cardWidth * 0.70
  //                         : cardWidth * 0.66;
  //
  //                     // Image / footer ratio
  //                     final imageHeight = cardHeight * 0.78;
  //                     final footerHeight = cardHeight * 0.22;
  //
  //                     // Responsive footer padding
  //                     final horizontalPadding = isSmallMobile
  //                         ? 8.0
  //                         : isMobile
  //                         ? 10.0
  //                         : isTablet
  //                         ? 14.0
  //                         : (cardWidth * 0.04).clamp(12.0, 22.0);
  //
  //                     // Responsive title
  //                     final titleSize = isSmallMobile
  //                         ? 9.0
  //                         : isMobile
  //                         ? 10.0
  //                         : isTablet
  //                         ? 12.0
  //                         : (cardWidth * 0.037).clamp(12.0, 18.0);
  //
  //                     // Responsive arrow icon
  //                     final arrowSize = isSmallMobile
  //                         ? 12.0
  //                         : isMobile
  //                         ? 14.0
  //                         : isTablet
  //                         ? 16.0
  //                         : (cardWidth * 0.05).clamp(16.0, 22.0);
  //
  //                     return MouseRegion(
  //                       cursor: SystemMouseCursors.click,
  //                       child: InkWell(
  //                         borderRadius: BorderRadius.circular(
  //                           isMobile ? 10 : 16,
  //                         ),
  //                         onTap: () {
  //                           final shopProvider = context.read<ShopProvider>();
  //
  //                           shopProvider.changeTab(1);
  //                           context.go('/');
  //                         },
  //                         child: AnimatedContainer(
  //                           duration: const Duration(milliseconds: 300),
  //                           width: cardWidth,
  //                           height: cardHeight,
  //                           decoration: BoxDecoration(
  //                             color: gPrimaryColor,
  //                             borderRadius: BorderRadius.circular(
  //                               isMobile ? 10 : 16,
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.black.withAlpha(25),
  //                                 blurRadius: isMobile ? 8 : 15,
  //                                 offset: Offset(0, isMobile ? 4 : 8),
  //                               ),
  //                             ],
  //                           ),
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(
  //                               isMobile ? 10 : 16,
  //                             ),
  //                             child: Column(
  //                               children: [
  //                                 // ==================================================
  //                                 // IMAGE
  //                                 // ==================================================
  //                                 SizedBox(
  //                                   width: double.infinity,
  //                                   height: imageHeight,
  //                                   child: ThumbnailView(
  //                                     context: context,
  //                                     height: imageHeight,
  //                                     width: double.infinity,
  //                                     imageUrl: thumbnail,
  //                                     enablePreview: false,
  //                                     borderRadius: 0,
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //
  //                                 // ==================================================
  //                                 // GREEN FOOTER
  //                                 // ==================================================
  //                                 SizedBox(
  //                                   width: double.infinity,
  //                                   height: footerHeight,
  //                                   child: Padding(
  //                                     padding: EdgeInsets.symmetric(
  //                                       horizontal: horizontalPadding,
  //                                     ),
  //                                     child: Row(
  //                                       children: [
  //                                         Expanded(
  //                                           child: Text(
  //                                             "Explore ${SafeString().toTitleCase(category.name ?? '')} Categories",
  //                                             maxLines: 2,
  //                                             overflow: TextOverflow.ellipsis,
  //                                             style:
  //                                                 GoogleFonts.cormorantGaramond(
  //                                                   fontWeight: FontWeight.w900,
  //                                                   color: Colors.white,
  //                                                   fontSize: titleSize,
  //                                                 ),
  //                                           ),
  //                                         ),
  //
  //                                         SizedBox(width: isMobile ? 4 : 8),
  //
  //                                         Icon(
  //                                           Icons.arrow_forward_ios,
  //                                           color: gWhiteColor,
  //                                           size: arrowSize,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // ------------------- Cluster-based timeline -------------------

  final ScrollController _timelineController = ScrollController();

  Widget clusterTabBar(List<ClusterList> clusters) {
    final helper = ScreenSizeHelper(context);

    final screenWidth = MediaQuery.of(context).size.width;

    final itemWidth = helper.isMobile
        ? screenWidth *
              .20 // 20% of screen
        : helper.isTablet
        ? screenWidth * .16
        : 95.0;

    final thumbSize = helper.isMobile
        ? 46.0
        : helper.isTablet
        ? 52.0
        : 60.0;

    final titleFont = helper.isMobile
        ? 9.0
        : helper.isTablet
        ? 10.5
        : 12.0;

    return SizedBox(
      height: 225,
      child: SingleChildScrollView(
        controller: _timelineController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: SizedBox(
          width: itemWidth * clusters.length,
          child: Column(
            children: [
              ///---------------- THUMBNAILS ----------------///
              SizedBox(
                height: 70,
                child: Row(
                  children: List.generate(clusters.length, (index) {
                    final active = selected == index;

                    return SizedBox(
                      width: itemWidth,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() => selected = index);

                          final target =
                              (index * itemWidth) -
                              (screenWidth / 2) +
                              (itemWidth / 2);

                          _timelineController.animateTo(
                            target.clamp(
                              0.0,
                              _timelineController.position.maxScrollExtent,
                            ),
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(4),
                          decoration: active
                              ? BoxDecoration(
                                  color: gPrimaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                )
                              : null,
                          child: SizedBox(
                            width: thumbSize,
                            height: thumbSize,
                            child: ThumbnailView(
                              context: context,fit: BoxFit.contain,
                              imageUrl: clusters[index].clusterThumbnailUrl,
                              onTap: () {
                                setState(() => selected = index);

                                final target =
                                    (index * itemWidth) -
                                    (screenWidth / 2) +
                                    (itemWidth / 2);

                                _timelineController.animateTo(
                                  target.clamp(
                                    0.0,
                                    _timelineController
                                        .position
                                        .maxScrollExtent,
                                  ),
                                  duration: const Duration(milliseconds: 450),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              ///---------------- TIMELINE ----------------///
              SizedBox(
                height: 20,
                child: Stack(
                  children: [
                    Positioned(
                      left: itemWidth / 2,
                      right: itemWidth / 2,
                      top: 9,
                      child: Container(height: 2, color: Colors.grey.shade300),
                    ),

                    Row(
                      children: List.generate(clusters.length, (index) {
                        return SizedBox(
                          width: itemWidth,
                          child: Center(
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400),
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
                      left: selected * itemWidth + itemWidth / 2 - 5,
                      top: 4,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: gMainColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///---------------- TITLES ----------------///
              SizedBox(
                height: 45,
                child: Row(
                  children: List.generate(clusters.length, (index) {
                    final active = selected == index;

                    return SizedBox(
                      width: itemWidth,
                      child: Center(
                        child: HtmlWidget(
                          clusters[index].clusterName ?? "",
                          textStyle: TextStyle(
                            fontSize: titleFont,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: active ? gPrimaryColor : gHintTextColor,
                          ),
                          customStylesBuilder: (_) => {
                            'text-align': 'center',
                            'margin': '0',
                            'padding': '0',
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 2),

              ///---------------- ARROW + ABOUT TITLE ----------------///
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = itemWidth * clusters.length;

                  final selectedCenter =
                      (selected * itemWidth) + (itemWidth / 2);

                  final titleWidth = helper.isMobile
                      ? itemWidth * 2.8
                      : itemWidth * 3.5;

                  double titleLeft = selectedCenter - (titleWidth / 2);

                  // First title → slightly left
                  if (selected == 0) {
                    titleLeft -= helper.isMobile ? 12.0 : 20.0;
                  }

                  return SizedBox(
                    height: 80,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,

                          // Arrow center = selected item center
                          left: selected * itemWidth,
                          top: 0,

                          child: SizedBox(
                            width: itemWidth,
                            child: Center(
                              child: Image.asset(
                                "assets/images/tab_arrow.png",
                                width: helper.isMobile ? 16 : 18,
                                height: helper.isMobile ? 38 : 42,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,

                          left: titleLeft.clamp(0.0, totalWidth - titleWidth),
                          top: 43,

                          child: SizedBox(
                            width: titleWidth,
                            child: Transform.translate(
                              offset: Offset(
                                selected == 0
                                    ? (helper.isMobile ? -8.0 : -15.0)
                                    : 0.0,
                                0,
                              ),
                              child: Text(
                                clusters[selected].clusterAboutTitle ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: helper.isMobile
                                      ? fontSize10
                                      : fontSize10,
                                  fontFamily: "Avenir",
                                  fontWeight: FontWeight.w600,
                                  color: gMainColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _clusterTimeline(List<ClusterList> clusters) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = clusters.length;
        if (count == 0) return const SizedBox.shrink();

        final itemWidth = constraints.maxWidth / count;
        final helper = ScreenSizeHelper(context);

        final titleWidth = helper.isMobile
            ? itemWidth * 1.4
            : helper.isTablet
            ? itemWidth * 1.8
            : itemWidth * 2.8;

        final arrowWidth = helper.isMobile
            ? 16.0
            : helper.isTablet
            ? 20.0
            : 24.0;

        final arrowHeight = helper.isMobile
            ? 42.0
            : helper.isTablet
            ? 52.0
            : 70.0;

        final titleFont = helper.isMobile
            ? 8.5
            : helper.isTablet
            ? 10.5
            : 14.0;

        // Responsive font sizes based on your breakpoints
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

        final leftOffset = titleWidth / 2;

        return Column(
          children: [
            /// THUMBNAIL ROW
            SizedBox(
              height: 70,
              child: Row(
                children: List.generate(count, (index) {
                  final cluster = clusters[index];
                  final active = selected == index;

                  return Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() => selected = index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        decoration: active
                            ? BoxDecoration(
                                color: gPrimaryColor.withAlpha(10),
                                borderRadius: BorderRadius.circular(6),
                              )
                            : const BoxDecoration(),
                        child: ThumbnailView(
                          context: context,
                          imageUrl: cluster.clusterThumbnailUrl,fit: BoxFit.contain,
                          onTap: () {
                            setState(() => selected = index);
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),

            /// TIMELINE LINE + DOTS
            SizedBox(
              height: 20,
              child: Stack(
                children: [
                  Positioned(
                    left: itemWidth / 2,
                    right: itemWidth / 2,
                    top: 9,
                    child: Container(height: 2, color: Colors.grey.shade300),
                  ),
                  Row(
                    children: List.generate(
                      count,
                      (index) => Expanded(
                        child: Center(
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        color: gMainColor,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// CLUSTER NAMES (responsive + selected/unselected)
            Row(
              children: List.generate(clusters.length, (index) {
                final cluster = clusters[index];
                final active = selected == index;

                final baseStyle = TextStyle(
                  fontFamily: active ? fontBold : fontMedium,
                  fontSize: active ? selectedFontSize : unselectedFontSize,
                  color: active ? gPrimaryColor : gHintTextColor,
                  height: 1.2,
                );

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Center(
                      // If you need HTML support:
                      child: HtmlWidget(
                        cluster.clusterName ?? '',
                        textStyle: baseStyle,
                        customStylesBuilder: (element) {
                          if (element.localName == 'body' ||
                              element.localName == 'div' ||
                              element.localName == 'p') {
                            return {
                              'text-align': 'center',
                              'margin': '0',
                              'padding': '0',
                            };
                          }
                          return null;
                        },
                      ),
                      // If plain text is enough, use this instead:
                      // child: Text(
                      //   cluster.clusterName ?? '',
                      //   textAlign: TextAlign.center,
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: baseStyle,
                      // ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            /// MOVING ARROW
            SizedBox(
              height: helper.isMobile
                  ? 90
                  : helper.isTablet
                  ? 110
                  : 140,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    left: (itemWidth * selected) + itemWidth / 2 - leftOffset,
                    top: helper.isMobile
                        ? -2
                        : helper.isTablet
                        ? -5
                        : -8,
                    child: SizedBox(
                      width: titleWidth,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/tab_arrow.png",
                            width: arrowWidth,
                            height: arrowHeight,
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: titleWidth,
                            child: Text(
                              clusters[selected].clusterAboutTitle ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleFont,
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.w600,
                                color: gMainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // ------------------- Cluster details + products (parallel) -------------------

  Widget _clusterDetailsWithProducts() {
    final cluster = selectedCluster!;
    final isMobile = ScreenSizeHelper(context).isMobile;

    final products = cluster.productsData ?? [];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: products.isNotEmpty
          ? (selected < 4
                ? Row(
                    key: const ValueKey("leftLayout"),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isMobile ? 1 : 3,
                        child: _clusterDescriptionSection(cluster),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: GutClockVerticalSlider(
                          products: products,
                          categoryName: cluster.clusterName ?? '',
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
                          products: products,
                          categoryName: cluster.clusterName ?? '',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: isMobile ? 1 : 3,
                        child: _clusterDescriptionSection(cluster),
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
    );
  }

  Widget _clusterDescriptionSection(ClusterList cluster) {
    final responsive = ScreenSizeHelper(context);

    final bodySize = responsive.isMobile
        ? 20.0
        : responsive.isTablet
        ? 23.0
        : responsive.isLaptop
        ? 25.0
        : 27.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Center(
        child: SizedBox(
          width: responsive.isMobile
              ? double.infinity
              : responsive.isTablet
              ? 500
              : 650,
          child: HtmlWidget(
            cluster.clusterAbout ?? '',
            customStylesBuilder: (element) {
              if (element.localName == 'body' ||
                  element.localName == 'div' ||
                  element.localName == 'p' ||
                  element.localName == 'span') {
                return {
                  'font-size': '${bodySize}px',
                  'line-height': '1.4',
                  'letter-spacing': '-0.07em',
                };
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
