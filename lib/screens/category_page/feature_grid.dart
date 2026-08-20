import 'package:flutter/material.dart';
import 'package:gwc_shop/utils/constants.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class FeatureGrid extends StatelessWidget {
  final List<ImportantPoints>? category;
  final Color? color;

  const FeatureGrid({super.key, this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    final itemCount = category?.length ?? 0;

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Always 2 columns.
        const crossAxisCount = 2;

        // Responsive horizontal padding.
        final horizontalPadding = screenWidth < 400
            ? 8.0
            : screenWidth < 600
            ? 12.0
            : screenWidth < 900
            ? 20.0
            : 28.0;

        // Responsive gap.
        final spacing = screenWidth < 400
            ? 8.0
            : screenWidth < 600
            ? 10.0
            : screenWidth < 900
            ? 16.0
            : 20.0;

        // Don't allow cards to become unnecessarily huge
        // on large desktop screens.
        final gridWidth = screenWidth > 1000 ? 850.0 : screenWidth;

        final availableWidth = gridWidth - (horizontalPadding * 2);

        final cardWidth = (availableWidth - spacing) / 2;

        /*
         * IMPORTANT:
         *
         * Old:
         * cardWidth * 1.08
         *
         * That made the cards almost square.
         *
         * New:
         * approximately 0.76 × card width.
         *
         * This gives the compact design shown in your screenshot.
         */
        final cardHeight = (cardWidth * 0.76).clamp(115.0, 185.0);

        return Center(
          child: SizedBox(
            width: gridWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing * 1.35,
                  mainAxisExtent: cardHeight,
                ),
                itemBuilder: (context, index) {
                  return _FeatureCard(
                    item: category![index],
                    index: index,
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    color: color,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final ImportantPoints? item;
  final int index;
  final double cardWidth;
  final double cardHeight;
  final Color? color;

  const _FeatureCard({
    required this.item,
    required this.index,
    required this.cardWidth,
    required this.cardHeight,
    required this.color,
  });

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = _clamp(cardWidth * 0.26, 42, 72);

    final titleSize = _clamp(cardWidth * 0.043, 8.5, 14);

    final descriptionSize = _clamp(cardWidth * 0.043, 8.5, 12);

    final indexSize = _clamp(cardWidth * 0.040, 8, 13);

    final cardRadius = _clamp(cardWidth * 0.065, 8, 18);

    final cardColor = color ?? const Color(0xff3B2415);

    return SizedBox(
      width: double.infinity,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: cardHeight,
            margin: EdgeInsets.only(top: avatarSize * 0.42),
            padding: EdgeInsets.fromLTRB(
              cardWidth * 0.075,
              cardWidth * 0.035,
              cardWidth * 0.075,
              cardWidth * 0.04,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // -------------------------
                // NUMBER
                // -------------------------
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${index + 1}'.padLeft(2, '0'),
                        style: TextStyle(
                          color: gMainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: indexSize,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: _clamp(cardWidth * 0.055, 8, 16),
                        height: 1.5,
                        color: gMainColor,
                      ),
                    ],
                  ),
                ),

                // Space for overlapping image.
                SizedBox(height: cardWidth * 0.075),

                // -------------------------
                // TITLE
                // -------------------------
                Text(
                  item?.title?.toUpperCase() ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w700,
                    fontSize: titleSize,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),

                SizedBox(height: cardWidth * 0.018),

                // -------------------------
                // UNDERLINE
                // -------------------------
                Center(
                  child: Container(
                    width: _clamp(cardWidth * 0.15, 12, 32),
                    height: 1.5,
                    color: gMainColor,
                  ),
                ),

                SizedBox(height: cardWidth * 0.025),

                // -------------------------
                // DESCRIPTION
                // -------------------------
                Expanded(
                  child: Text(
                    item?.description ?? '',
                    textAlign: TextAlign.left,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w500,
                      fontSize: descriptionSize,
                      color: const Color(0xffF5EDE6),
                      letterSpacing: 0,
                      height: 1.18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -------------------------
          // AVATAR
          // -------------------------
          Positioned(
            top: 0,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: const Color(0xffD7A100), width: 1.5),
              ),
              padding: EdgeInsets.all(_clamp(cardWidth * 0.012, 2, 4)),
              child: ClipOval(
                child: ThumbnailView(
                  context: context,
                  imageUrl: item?.thumbnail,
                  width: avatarSize,
                  height: avatarSize,
                  enablePreview: false,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
