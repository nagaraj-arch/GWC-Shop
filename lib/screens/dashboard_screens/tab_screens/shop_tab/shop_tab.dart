import 'package:flutter/material.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/food_farmacy_timeline/food_farmacy_timeline.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/rhythm_widget/gut_clock_widget.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/rhythm_widget/rhythm_widget.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/timeline_section/timeline_section.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/utils/responsive_helper.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  @override
  Widget build(BuildContext context) {
    final helper = ScreenSizeHelper(context);
    final screenWidth = helper.screenWidth;
    late final double bannerHeight;
    if (helper.isMobile) {
      bannerHeight = screenWidth * 0.50;
    } else if (helper.isTablet) {
      bannerHeight = screenWidth * 0.50;
    } else if (helper.isLaptop) {
      bannerHeight = screenWidth * 0.50;
    } else if (helper.isDesktop) {
      bannerHeight = screenWidth * 0.45;
    } else {
      bannerHeight = screenWidth * 0.45;
    }

    return Column(
      children: [
        // SizedBox(
        //   width: double.infinity,
        //   height: bannerHeight,
        //   child: ThumbnailView(
        //     context: context,
        //     imageUrl: 'https://gutandhealth.com/storage/uploads/ingredient_category_images/home_banner_top.webp',
        //     enablePreview: false,
        //     borderRadius: 0,
        //     width: double.infinity,
        //     height: bannerHeight,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        RhythmWidget(),
        Container(
          color: gPrimaryColor.withOpacity(0.03),
          padding: EdgeInsets.symmetric(
            horizontal: (helper.isMobile || helper.isTablet) ? 15 : 120,
          ),
          child: Column(
            children: [

              SizedBox(height: 60),
              GutClockWidget(),
              TimelineSection(),
              SizedBox(height: 40),

            ],
          ),
        ),
        Container(
          color: gPrimaryColor.withOpacity(0.1),
          padding: EdgeInsets.symmetric(
            horizontal: (helper.isMobile || helper.isTablet) ? 15 : 120,
          ),
          child: FoodFarmacyTimeline(),
        ),
        // DifferenceSection(),
        // SizedBox(height: 40),
      ],
    );

    // return SizedBox(
    //   height: MediaQuery.of(context).size.height,
    //   child: PageView.builder(
    //     controller: shopProvider.shopPageController,
    //     itemCount: 3,
    //     itemBuilder: (context, index) {
    //
    //       if (index == 0) {
    //         return FooterWrapper(
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(
    //               horizontal: isDesktop ? 150 : 20,
    //               vertical: isDesktop ? 40 : 30,
    //             ),
    //             child: Column(
    //               children: [
    //                 RhythmWidget(),
    //                 SizedBox(height: 40),
    //                 GutClockSection(),
    //                 SizedBox(height: 40),
    //                 isDesktop
    //                     ? const Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Expanded(child: DifferenceIntro()),
    //                     SizedBox(width: 10),
    //                     Expanded(
    //                       child: Center(
    //                         child: Image(
    //                           image: AssetImage("assets/images/real_difference.png"),
    //                           height: 430,
    //                           fit: BoxFit.contain,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //                     : const Column(
    //                   children: [
    //                     DifferenceIntro(),
    //                     SizedBox(height: 30),
    //                     Image(
    //                       image: AssetImage("assets/images/real_difference.png"),
    //                       height: 300,
    //                       fit: BoxFit.contain,
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(height: 45),
    //                 const DifferenceTimeline(),
    //               ],
    //             ),
    //           ),
    //         );
    //       }
    //
    //       if (index == 1) {
    //         return FooterWrapper(
    //           child: CategoryPage(
    //             category: shopProvider.selectedCategory,
    //           ),
    //         );
    //       }
    //
    //       if (index == 2) {
    //         return const FooterWrapper(
    //           child: ProductScreen(),
    //         );
    //       }
    //
    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );
  }
}
