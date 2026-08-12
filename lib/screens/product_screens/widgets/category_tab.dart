import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';

class CategoryTabs extends StatefulWidget {
  final TabController controller;
  final List<String> categories;
  final int Function(String) getCount;

  const CategoryTabs({
    super.key,
    required this.controller,
    required this.categories,
    required this.getCount,
  });

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  int hoverIndex = -1;

  IconData getCategoryIcon(String name) {
    switch (name.toLowerCase().trim()) {
      case "food farmacy":
        return Icons.eco_rounded;

      case "amla shots":
        return Icons.spa_rounded;

      case "infusion":
        return Icons.local_cafe_rounded;

      case "juice":
        return Icons.local_drink_rounded;

      case "khichdi":
        return Icons.rice_bowl_rounded;

      case "soup":
        return Icons.soup_kitchen_rounded;

      case "chutney & podi":
        return Icons.grass_rounded;

      case "dessert":
        return Icons.icecream_rounded;

      case "ambalis":
        return Icons.breakfast_dining_rounded;

      case "nutri meal":
        return Icons.restaurant_rounded;

      case "flavours":
        return Icons.grain_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenSizeHelper(context).isMobile;

    return Container(
      height: isMobile ? 60 : 70,
      margin: EdgeInsets.symmetric(vertical: 0.h),
      decoration: const BoxDecoration(
        color: gWhiteColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Center(
        child: TabBar(
          controller: widget.controller,
          isScrollable: true,
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.center,
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          labelPadding: EdgeInsets.only(right: isMobile ? 8 : 14),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 2.w : 2.w,
            vertical: isMobile ? .6.h : 1.h,
          ),
          tabs: List.generate(widget.categories.length, (index) {
            final tab = widget.categories[index];
            final isSelected = widget.controller.index == index;
            final hovered = hoverIndex == index;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                if (!isMobile) setState(() => hoverIndex = index);
              },
              onExit: (_) {
                if (!isMobile) setState(() => hoverIndex = -1);
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: hovered || isSelected ? 1.08 : 1,
                child: SizedBox(
                  width: isMobile ? 70 : 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 1.5 : 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gWhiteColor,
                          border: Border.all(
                            color: isSelected ? gPrimaryColor : borderColor,
                            width: isSelected ? 1.5 : 0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: gBlackColor.withAlpha(20),
                                    blurRadius: 5,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.all(isMobile ? 3 : 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? gPrimaryColor : gWhiteColor,
                          ),
                          child: Icon(
                            getCategoryIcon(tab),
                            color: isSelected ? gWhiteColor : gPrimaryColor,
                            size: isMobile ? 12 : 14,
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 3 : 4),
                      Text(
                        tab,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Arimo",
                          fontWeight: FontWeight.w800,
                          color: isSelected ? gPrimaryColor : gHintTextColor,
                          fontSize: fontSize10,
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
//
// import '../../../utils/constants.dart';
// import '../../../utils/opacity_to_alpha.dart';
// import '../../../utils/responsive_helper.dart';
// import '../../../widgets/common_card.dart';
//
// class CategoryTabs extends StatefulWidget {
//   final TabController controller;
//   final List<String> categories;
//   final int Function(String) getCount;
//
//   const CategoryTabs({
//     super.key,
//     required this.controller,
//     required this.categories,
//     required this.getCount,
//   });
//
//   @override
//   State<CategoryTabs> createState() => _CategoryTabsState();
// }
//
// class _CategoryTabsState extends State<CategoryTabs> {
//   int hoverIndex = -1;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = ResponsiveHelper(context).isDesktop;
//
//     return Container(
//       height: 7.h,
//       decoration: const BoxDecoration(
//         color: gWhiteColor,
//         border: Border(
//           bottom: BorderSide(color: borderColor),
//         ),
//       ),
//       child: TabBar(
//         controller: widget.controller,
//         isScrollable: true,
//         dividerColor: Colors.transparent,
//         tabAlignment: TabAlignment.start,
//         indicatorColor: Colors.transparent,
//         overlayColor: WidgetStateProperty.all(Colors.transparent),
//         splashFactory: NoSplash.splashFactory,
//         labelPadding: EdgeInsets.only(right: 10),
//         padding: EdgeInsets.symmetric(
//             horizontal: isDesktop ? 2.w : 3.w, vertical: 1.h),
//         tabs: List.generate(
//           widget.categories.length,
//           (index) {
//             // final selected = widget.controller.index == index;
//             final hovered = hoverIndex == index;
//
//             return MouseRegion(
//               cursor: SystemMouseCursors.click,
//               onEnter: (_) {
//                 if (isDesktop) {
//                   setState(() => hoverIndex = index);
//                 }
//               },
//               onExit: (_) {
//                 if (isDesktop) {
//                   setState(() => hoverIndex = -1);
//                 }
//               },
//               child: AnimatedBuilder(
//                 animation: widget.controller.animation!,
//                 builder: (context, child) {
//                   final isSelected = widget.controller.index == index;
//
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     curve: Curves.easeInOut,
//                     child: CommonCard(
//                       elevation: isSelected || hovered ? 3 : 0,
//                       borderRadius: 10,
//                       borderClr: isSelected || hovered
//                           ? gPrimaryColor
//                           : Colors.transparent,
//                       backgroundColor: isSelected
//                           ? gPrimaryColor
//                           : hovered
//                               ? gPrimaryColor.withAlpha(20)
//                               : Colors.transparent,
//                       margin: EdgeInsets.zero,
//                       padding: EdgeInsets.symmetric(
//                         vertical: isDesktop ? 1.h : .5.h,
//                         horizontal: 1.5.w,
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             widget.categories[index].toUpperCase(),
//                             style: TextStyle(
//                               fontSize: fontSize10,
//                               fontFamily: fontMedium,
//                               color: isSelected
//                                   ? Colors.white
//                                   : hovered
//                                       ? gPrimaryColor
//                                       : gBlackColor.withAlpha(90),
//                             ),
//                           ),
//                           SizedBox(width: .8.w),
//                           Container(
//                             constraints: const BoxConstraints(
//                               minWidth: 20,
//                               minHeight: 20,
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 5,
//                               vertical: 2,
//                             ),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? Colors.white.withAlpha(60)
//                                   : gPrimaryColor.withAlpha(
//                                       AlphaHelper.fromOpacity(.7),
//                                     ),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               "${widget.getCount(widget.categories[index])}",
//                               style: TextStyle(
//                                 fontSize: fontSize08,
//                                 color: Colors.white,
//                                 fontFamily: fontBold,
//                                 height: 1,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
//
// import '../../../utils/constants.dart';
// import '../../../utils/responsive_helper.dart';
//
// class CategoryTabs extends StatefulWidget {
//   final TabController controller;
//   final List<String> categories;
//   final int Function(String) getCount;
//
//   const CategoryTabs({
//     super.key,
//     required this.controller,
//     required this.categories,
//     required this.getCount,
//   });
//
//   @override
//   State<CategoryTabs> createState() => _CategoryTabsState();
// }
//
// class _CategoryTabsState extends State<CategoryTabs> {
//   int hoverIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//
//     widget.controller.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final responsive = ResponsiveHelper(context);
//     final isDesktop = responsive.isDesktop;
//
//     return Container(
//       height: 7.h,
//       decoration: const BoxDecoration(
//         color: Colors.transparent,
//         border: Border(
//           bottom: BorderSide(color: borderColor),
//         ),
//       ),
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(
//             horizontal: isDesktop ? 2.w : 2.w, vertical: .8.h),
//         itemCount: widget.categories.length,
//         separatorBuilder: (_, __) => SizedBox(width: 1.w),
//         itemBuilder: (context, index) {
//           final selected = widget.controller.index == index;
//
//           return MouseRegion(
//             cursor: SystemMouseCursors.click,
//             onEnter: (_) {
//               if (isDesktop) {
//                 setState(() => hoverIndex = index);
//               }
//             },
//             onExit: (_) {
//               if (isDesktop) {
//                 setState(() => hoverIndex = -1);
//               }
//             },
//             child: InkWell(
//               borderRadius: BorderRadius.circular(50),
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               onTap: () {
//                 widget.controller.animateTo(index);
//               },
//               child: _buildTab(index, selected, hoverIndex == index),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTab(int index, bool selected, bool hovered) {
//     final bgColor = selected
//         ? Colors.white.withAlpha(46) // .18
//         : hovered
//         ? Colors.white.withAlpha(25) // .10
//         : Colors.transparent;
//
//     final borderColor = selected
//         ? Colors.white.withAlpha(102) // .40
//         : hovered
//         ? Colors.white.withAlpha(46) // .18
//         : Colors.transparent;
//
//     final textColor = selected
//         ? Colors.white
//         : hovered
//         ? Colors.white
//         : Colors.white.withAlpha(191); // .75
//
//     return AnimatedScale(
//       scale: selected
//           ? 1
//           : hovered
//           ? 1.03
//           : 1,
//       duration: const Duration(milliseconds: 180),
//       curve: Curves.easeOut,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 220),
//         curve: Curves.easeOut,
//         padding: EdgeInsets.symmetric(
//           horizontal: 1.2.w,
//           vertical: .6.h,
//         ),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(50),
//           border: Border.all(
//             color: borderColor,
//             width: 1,
//           ),
//           boxShadow: selected
//               ? [
//             BoxShadow(
//               color: Colors.white.withAlpha(30), // .12
//               blurRadius: 18,
//               spreadRadius: 1,
//             ),
//           ]
//               : [],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedDefaultTextStyle(
//               duration: const Duration(milliseconds: 200),
//               style: TextStyle(
//                 color: textColor,
//                 fontFamily: selected ? fontBold : fontMedium,
//                 fontSize: selected ? fontSize11 : fontSize10,
//                 letterSpacing: .3,
//               ),
//               child: Text(
//                 widget.categories[index].toUpperCase(),
//               ),
//             ),
//             SizedBox(width: .8.w),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 24,
//               height: 24,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: selected
//                     ? Colors.white
//                     : hovered
//                     ? Colors.white.withAlpha(46) // .18
//                     : Colors.white.withAlpha(25), // .10
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 "${widget.getCount(widget.categories[index])}",
//                 style: TextStyle(
//                   color: selected ? gPrimaryColor : Colors.white,
//                   fontSize: fontSize08,
//                   fontFamily: fontBold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_sizer/flutter_sizer.dart';
// // import 'package:gwc_masalas/utils/opacity_to_alpha.dart';
// //
// // import '../../../utils/constants.dart';
// // import '../../../utils/responsive_helper.dart';
// //
// // class CategoryTabs extends StatefulWidget {
// //   final TabController controller;
// //   final List<String> categories;
// //   final int Function(String) getCount;
// //
// //   const CategoryTabs({
// //     super.key,
// //     required this.controller,
// //     required this.categories,
// //     required this.getCount,
// //   });
// //
// //   @override
// //   State<CategoryTabs> createState() => _CategoryTabsState();
// // }
// //
// // class _CategoryTabsState extends State<CategoryTabs> {
// //   int hoverIndex = -1;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final isDesktop = ResponsiveHelper(context).isDesktop;
// //
// //     return Container(
// //       height: 6.h,
// //       decoration: const BoxDecoration(
// //         color: Colors.transparent,
// //         border: Border(
// //           bottom: BorderSide(color: borderColor),
// //         ),
// //       ),
// //       child: TabBar(
// //         controller: widget.controller,
// //         isScrollable: true,
// //         tabAlignment: TabAlignment.start,
// //         indicatorColor: Colors.transparent,
// //         dividerColor: Colors.transparent,
// //         overlayColor: WidgetStateProperty.all(Colors.transparent),
// //         splashFactory: NoSplash.splashFactory,
// //         labelPadding: EdgeInsets.only(right: 18),
// //         padding: EdgeInsets.symmetric(
// //           horizontal: isDesktop ? 2.w : 3.w,
// //           vertical: .8.h,
// //         ),
// //         tabs: List.generate(widget.categories.length, (index) {
// //           return MouseRegion(
// //             cursor: SystemMouseCursors.click,
// //             onEnter: (_) {
// //               if (isDesktop) {
// //                 setState(() => hoverIndex = index);
// //               }
// //             },
// //             onExit: (_) {
// //               if (isDesktop) {
// //                 setState(() => hoverIndex = -1);
// //               }
// //             },
// //             child: AnimatedBuilder(
// //               animation: widget.controller.animation!,
// //               builder: (context, child) {
// //                 final isSelected = widget.controller.index == index;
// //                 final isHover = hoverIndex == index;
// //
// //                 final textColor = isSelected
// //                     ? gPrimaryColor
// //                     : isHover
// //                         ? gWhiteColor
// //                         : gWhiteColor.withAlpha(AlphaHelper.fromOpacity(0.7));
// //
// //                 return AnimatedContainer(
// //                   duration: const Duration(milliseconds: 220),
// //                   padding: EdgeInsets.symmetric(horizontal: 4, vertical: .4.h),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       AnimatedDefaultTextStyle(
// //                         duration: const Duration(milliseconds: 200),
// //                         style: TextStyle(
// //                           color: textColor,
// //                           fontSize: isSelected ? fontSize11 : fontSize09,
// //                           fontFamily: isSelected ? fontBold : fontMedium,
// //                         ),
// //                         child: Text(
// //                           "${widget.categories[index].toUpperCase()} ",
// //                         ),
// //                       ),
// //                       AnimatedContainer(
// //                         duration: const Duration(milliseconds: 200),
// //                         padding: const EdgeInsets.all(5),
// //                         decoration: BoxDecoration(
// //                           color: isSelected
// //                               ? Colors.white
// //                               : Colors.white
// //                                   .withAlpha(AlphaHelper.fromOpacity(0.2)),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Text(
// //                           "${widget.getCount(widget.categories[index])}",
// //                           style: TextStyle(
// //                             color: isSelected ? gPrimaryColor : gWhiteColor,
// //                             fontFamily: isSelected ? fontBold : fontMedium,
// //                             fontSize: fontSize08,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               },
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }
// //
// //   // @override
// //   // Widget build(BuildContext context) {
// //   //   final isDesktop = ResponsiveHelper(context).isDesktop;
// //   //
// //   //   return Container(
// // //     height: 7.h,
// // //     decoration: const BoxDecoration(
// // //       border: Border(
// // //         bottom: BorderSide(color: borderColor),
// // //       ),
// // //     ),
// //   //     child: TabBar(
// //   //       controller: widget.controller,
// //   //       isScrollable: true,
// //   //       dividerColor: Colors.transparent,
// //   //       tabAlignment: TabAlignment.start,
// //   //       indicatorColor: Colors.transparent,
// //   //       overlayColor: WidgetStateProperty.all(Colors.transparent),
// //   //       splashFactory: NoSplash.splashFactory,
// //   //       labelPadding: EdgeInsets.only(right: 10),
// //   //       padding: EdgeInsets.symmetric(
// //   //           horizontal: isDesktop ? 2.w : 3.w, vertical: 1.h),
// //   //       tabs: List.generate(
// //   //         widget.categories.length,
// //   //         (index) {
// //   //           final selected = widget.controller.index == index;
// //   //           final hovered = hoverIndex == index;
// //   //
// //   //           return MouseRegion(
// //   //             cursor: SystemMouseCursors.click,
// //   //             onEnter: (_) {
// //   //               if (isDesktop) {
// //   //                 setState(() => hoverIndex = index);
// //   //               }
// //   //             },
// //   //             onExit: (_) {
// //   //               if (isDesktop) {
// //   //                 setState(() => hoverIndex = -1);
// //   //               }
// //   //             },
// //   //             child: AnimatedBuilder(
// //   //               animation: widget.controller.animation!,
// //   //               builder: (context, child) {
// //   //                 final isSelected = widget.controller.index == index;
// //   //
// //   //                 return AnimatedContainer(
// //   //                   duration: const Duration(milliseconds: 180),
// //   //                   curve: Curves.easeInOut,
// //   //                   child: CommonCard(
// //   //                     elevation: isSelected || hovered ? 3 : 0,
// //   //                     borderRadius: 10,
// //   //                     borderClr: isSelected || hovered
// //   //                         ? gPrimaryColor
// //   //                         : Colors.transparent,
// //   //                     backgroundColor: isSelected
// //   //                         ? gPrimaryColor
// //   //                         : hovered
// //   //                             ? gPrimaryColor.withAlpha(20)
// //   //                             : Colors.transparent,
// //   //                     margin: EdgeInsets.zero,
// //   //                     padding: EdgeInsets.symmetric(
// //   //                       vertical: isDesktop ? 1.h : .5.h,
// //   //                       horizontal: 1.5.w,
// //   //                     ),
// //   //                     child: Row(
// //   //                       mainAxisSize: MainAxisSize.min,
// //   //                       children: [
// //   //                         Text(
// //   //                           widget.categories[index].toUpperCase(),
// //   //                           style: TextStyle(
// //   //                             fontSize: fontSize10,
// //   //                             fontFamily: fontMedium,
// //   //                             color: isSelected
// //   //                                 ? Colors.white
// //   //                                 : hovered
// //   //                                     ? gPrimaryColor
// //   //                                     : gBlackColor.withAlpha(90),
// //   //                           ),
// //   //                         ),
// //   //                         SizedBox(width: .8.w),
// //   //                         Container(
// //   //                           constraints: const BoxConstraints(
// //   //                             minWidth: 20,
// //   //                             minHeight: 20,
// //   //                           ),
// //   //                           padding: const EdgeInsets.symmetric(
// //   //                             horizontal: 5,
// //   //                             vertical: 2,
// //   //                           ),
// //   //                           alignment: Alignment.center,
// //   //                           decoration: BoxDecoration(
// //   //                             color: isSelected
// //   //                                 ? Colors.white.withAlpha(60)
// //   //                                 : gPrimaryColor.withAlpha(
// //   //                                     AlphaHelper.fromOpacity(.7),
// //   //                                   ),
// //   //                             shape: BoxShape.circle,
// //   //                           ),
// //   //                           child: Text(
// //   //                             "${widget.getCount(widget.categories[index])}",
// //   //                             style: TextStyle(
// //   //                               fontSize: fontSize08,
// //   //                               color: Colors.white,
// //   //                               fontFamily: fontBold,
// //   //                               height: 1,
// //   //                             ),
// //   //                           ),
// //   //                         ),
// //   //                       ],
// //   //                     ),
// //   //                   ),
// //   //                 );
// //   //               },
// //   //             ),
// //   //           );
// //   //         },
// //   //       ),
// //   //     ),
// //   //   );
// //   // }
// // }
// //
// // // class CategoryTabs extends StatefulWidget {
// // //   final List<String> categories;
// // //   final int selectedIndex;
// // //   final Function(int) onTap;
// // //   final int Function(String) getCount;
// // //
// // //   const CategoryTabs({
// // //     super.key,
// // //     required this.categories,
// // //     required this.selectedIndex,
// // //     required this.onTap,
// // //     required this.getCount,
// // //   });
// // //
// // //   @override
// // //   State<CategoryTabs> createState() => _CategoryTabsState();
// // // }
// // //
// // // class _CategoryTabsState extends State<CategoryTabs> {
// // //   int hoverIndex = -1;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isDesktop = ResponsiveHelper(context).isDesktop;
// // //
// // //     return Container(
// // //       height: 7.h,
// // //       decoration: const BoxDecoration(
// // //           color: gWhiteColor,
// // //           border: Border(bottom: BorderSide(color: borderColor))),
// // //       child: ListView.builder(
// // //         scrollDirection: Axis.horizontal,
// // //         itemCount: widget.categories.length,
// // //         padding: EdgeInsets.symmetric(
// // //             horizontal: isDesktop ? 5.w : 3.w, vertical: 1.h),
// // //         itemBuilder: (context, index) {
// // //           final selected = widget.selectedIndex == index;
// // //           final hovered = hoverIndex == index;
// // //
// // //           return MouseRegion(
// // //             cursor: SystemMouseCursors.click,
// // //             onEnter: (_) => setState(() => hoverIndex = index),
// // //             onExit: (_) => setState(() => hoverIndex = -1),
// // //             child: Container(
// // //               margin: const EdgeInsets.only(right: 10),
// // //               child: InkWell(
// // //                 borderRadius: BorderRadius.circular(10),
// // //                 onTap: () => widget.onTap(index),
// // //                 child: AnimatedContainer(
// // //                   duration: const Duration(milliseconds: 180),
// // //                   curve: Curves.easeInOut,
// // //                   child: CommonCard(
// // //                     elevation: selected || hovered ? 3 : 0,
// // //                     borderRadius: 10,
// // //                     borderClr: selected || hovered
// // //                         ? gPrimaryColor
// // //                         : Colors.transparent,
// // //                     backgroundColor: selected
// // //                         ? gPrimaryColor
// // //                         : hovered
// // //                         ? gPrimaryColor.withAlpha(20)
// // //                         : Colors.transparent,
// // //                     margin: EdgeInsets.zero,
// // //                     padding: EdgeInsets.symmetric(
// // //                       vertical: isDesktop ? 1.h : .5.h,
// // //                       horizontal: 1.5.w,
// // //                     ),
// // //                     child: Center(
// // //                       child: Row(
// // //                         mainAxisSize: MainAxisSize.min,
// // //                         children: [
// // //                           Text(
// // //                             widget.categories[index].toUpperCase(),
// // //                             style: TextStyle(
// // //                               fontSize: fontSize10,
// // //                               fontFamily: fontMedium,
// // //                               color: selected
// // //                                   ? Colors.white
// // //                                   : hovered
// // //                                   ? gPrimaryColor
// // //                                   : gBlackColor.withAlpha(90),
// // //                             ),
// // //                           ),
// // //
// // //                           SizedBox(width: .8.w),
// // //
// // //                           Container(
// // //                             constraints: const BoxConstraints(
// // //                               minWidth: 20,
// // //                               minHeight: 20,
// // //                             ),
// // //                             padding: const EdgeInsets.symmetric(
// // //                               horizontal: 5,
// // //                               vertical: 2,
// // //                             ),
// // //                             alignment: Alignment.center,
// // //                             decoration: BoxDecoration(
// // //                               color: selected
// // //                                   ? Colors.white.withAlpha(60)
// // //                                   : gPrimaryColor.withAlpha(
// // //                                 AlphaHelper.fromOpacity(.7),
// // //                               ),
// // //                               shape: BoxShape.circle,
// // //                             ),
// // //                             child: Text(
// // //                               "${widget.getCount(widget.categories[index])}",
// // //                               style: TextStyle(
// // //                                 fontSize: fontSize08,
// // //                                 color: Colors.white,
// // //                                 fontFamily: fontBold,
// // //                                 height: 1,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
