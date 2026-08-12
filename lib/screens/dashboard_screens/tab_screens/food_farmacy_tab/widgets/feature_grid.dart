import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../../../controllers/models/shop_models/category_model.dart';
import '../../../../../../utils/responsive_helper.dart';
import '../../../../../utils/constants.dart';

class FeatureGrid extends StatelessWidget {
  final List<ImportantPoints>? category;
  final Color? color;

  const FeatureGrid({super.key, this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = MediaQuery.of(context).size.width;

    late final double maxCardWidth;
    late final double horizontalPadding;

    if (responsive.isMobile) {
      maxCardWidth = double.infinity;
      horizontalPadding = 16;
    } else if (responsive.isTablet) {
      maxCardWidth = 380;  // increased
      horizontalPadding = 24;
    } else if (responsive.isLaptop) {
      maxCardWidth = 480;  // increased
      horizontalPadding = 40;
    } else if (responsive.isDesktop) {
      maxCardWidth = 540;  // increased
      horizontalPadding = 50;
    } else {
      // largeDesktop / ultra-wide
      maxCardWidth = 600;  // increased
      horizontalPadding = 60;
    }

    final crossAxisCount = responsive.isMobile ? 1 : 2;
    final gridSpacing = responsive.isMobile ? 16.0 : 24.0;

    final maxGridWidth = responsive.isMobile
        ? double.infinity
        : (maxCardWidth * crossAxisCount) +
        (gridSpacing * (crossAxisCount - 1));

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: responsive.isMobile
              ? screenWidth
              : maxGridWidth + (horizontalPadding * 2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalSpacing = gridSpacing * (crossAxisCount - 1);
            final cardWidth =
                (constraints.maxWidth -
                    totalSpacing -
                    (horizontalPadding * 2)) /
                    crossAxisCount;

            final spacing = responsive.isMobile
                ? 16.0
                : responsive.isTablet
                ? 18.0
                : 20.0;

            final childAspectRatio = responsive.isMobile
                ? 2.5
                : responsive.isTablet
                ? 2.2
                : responsive.isLaptop
                ? 2.5
                : responsive.isDesktop
                ? 2.6
                : 2.8;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: category?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemBuilder: (_, index) {
                return _FeatureCard(
                  item: category?[index],
                  index: index,
                  responsive: responsive,
                  cardWidth: cardWidth,
                  color: color,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final ImportantPoints? item;
  final int index;
  final ScreenSizeHelper responsive;
  final double cardWidth;
  final Color? color;

  const _FeatureCard({
    required this.item,
    required this.index,
    required this.responsive,
    required this.cardWidth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = cardWidth * 0.26;

    final titleSize =
    (cardWidth * 0.034) < 10.5 ? 10.5 : cardWidth * 0.034;

    final descSize =
    (cardWidth * 0.038) < 10.0 ? 10.0 : cardWidth * 0.038;

    final clr = const Color(0xff941d22);

    return Container(
      padding: EdgeInsets.only(
        left: cardWidth * 0.07,
        right: cardWidth * 0.07,
        top: cardWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: clr,
        borderRadius: BorderRadius.circular(cardWidth * 0.08),
      ),
      child: Column(
        children: [
          // Slightly less top space
          SizedBox(height: cardWidth * 0.03),

          // Title
          Row(
            children: [
              Image(
                image: const AssetImage("assets/images/slider_right_arrow.png"),
                color: gMainColor,
                height: 4.h,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item?.title?.toUpperCase() ?? "",
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w700,
                    fontSize: titleSize,
                    color: gMainColor,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: cardWidth * 0.06),

          // Description
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(),
              textAlign: TextAlign.justify,
              child: Text(
                item?.description ?? "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w500,
                  fontSize: descSize,
                  color: const Color(0xffF5EDE6),
                  letterSpacing: 0.0,
                  height: 1.28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}