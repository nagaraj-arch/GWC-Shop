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
    if (count <= 1) {
      return const SizedBox.shrink();
    }

    return AnimatedSmoothIndicator(
      activeIndex: controller.hasClients
          ? (controller.page?.round() ?? controller.initialPage)
          : 0,
      count: count,
      effect: ExpandingDotsEffect(
        expansionFactor: 3.2,
        spacing: 8,
        radius: 20,
        dotWidth: 9,
        dotHeight: 9,
        strokeWidth: 0,
        dotColor: Colors.white.withOpacity(.45),
        activeDotColor: Colors.white,
      ),
    );
  }
}