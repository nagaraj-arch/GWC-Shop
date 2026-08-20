import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../shop_tab/widgets/food_farmacy_timeline/food_farmacy_timeline.dart';
import '../shop_tab/widgets/rhythm_widget/gut_clock_widget.dart';
import '../shop_tab/widgets/rhythm_widget/rhythm_widget.dart';
import '../shop_tab/widgets/timeline_section/timeline_section.dart';
import 'widgets/follows_rhythm.dart';
import 'widgets/food_pharmacy_follows.dart';
import 'widgets/gut_clock_follows.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final helper = ScreenSizeHelper(context);
    final mobileDesign = helper.isMobile || helper.isTablet;

    if (mobileDesign) {
      return Column(
        children: [
          const FollowsRhythm(),
          GutClockFollows(),
          FoodFarmacyFollows(),
          SizedBox(height: 40),
        ],
      );
    }
    return Column(
      children: [
        RhythmWidget(),
        Container(
          color: gPrimaryColor.withValues(alpha: 0.03),
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
          color: gPrimaryColor.withValues(alpha: 0.1),
          padding: EdgeInsets.symmetric(
            horizontal: (helper.isMobile || helper.isTablet) ? 15 : 120,
          ),
          child: FoodFarmacyTimeline(),
        ),
        // DifferenceSection(),
        // SizedBox(height: 40),
      ],
    );
  }
}
