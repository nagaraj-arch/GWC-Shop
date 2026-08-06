import 'package:flutter/material.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/clock_section/gut_clock_section.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/difference_section/difference_section.dart';
import 'package:gwc_shop/screens/dashboard_screens/tab_screens/shop_tab/widgets/rhythm_widget/rhythm_widget.dart';

import '../../../../utils/responsive_helper.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 25,
        // vertical: isDesktop ? 40 : 30,
      ),
      child: Column(
        children: [
          RhythmWidget(),
          SizedBox(height: 40),
          GutClockSection(),
          SizedBox(height: 40),
          DifferenceSection(),
          SizedBox(height: 40),
        ],
      ),
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