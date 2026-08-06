import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerIndicator extends StatelessWidget {

  final PageController controller;
  final int count;

  const BannerIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {

    return AnimatedSmoothIndicator(
      activeIndex: controller.hasClients
          ? controller.page?.round() ?? 0
          : 0,
      count: count,
      effect: ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        expansionFactor: 3,
        spacing: 6,
        activeDotColor: Colors.white,
        dotColor: Colors.white.withAlpha(120),
      ),
    );
  }
}