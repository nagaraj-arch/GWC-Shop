import 'package:flutter/material.dart';

import '../../../../../controllers/models/shop_models/category_model.dart';
import '../../../../../utils/constants.dart';

class ClusterBenefitsGrid extends StatelessWidget {
  final List<ImportantPoints> items;

  const ClusterBenefitsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;

        // ==========================================================
        // RESPONSIVE SETTINGS
        // ==========================================================

        final bool isSmallMobile = screenWidth < 360;
        final bool isMobile = screenWidth < 600;
        final bool isTablet = screenWidth >= 600 && screenWidth < 1000;

        final double horizontalPadding = isMobile ? 12 : 20;
        final double spacing = isMobile ? 8 : 12;

        final double availableWidth = screenWidth - (horizontalPadding * 2);

        final double cardWidth = (availableWidth - spacing) / 2;

        // ==========================================================
        // CARD HEIGHT
        // ==========================================================
        //
        // We don't use childAspectRatio because it can make the
        // card too short on some devices and too tall on others.
        //
        // Instead, calculate a responsive fixed height.
        // ==========================================================

        final double cardHeight;

        if (isSmallMobile) {
          cardHeight = 105;
        } else if (isMobile) {
          cardHeight = 115;
        } else if (isTablet) {
          cardHeight = 120;
        } else {
          cardHeight = 130;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,

            // IMPORTANT:
            // Same height for every card.
            mainAxisExtent: cardHeight,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildCard(
              context,
              index,
              items[index],
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            );
          },
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    int index,
    ImportantPoints item, {
    required double cardWidth,
    required double cardHeight,
  }) {
    final List<String> thumbnails = [
      "assets/images/ff_cluster_benefits_1.png",
      "assets/images/ff_cluster_benefits_2.png",
      "assets/images/ff_cluster_benefits_3.png",
      "assets/images/ff_cluster_benefits_4.png",
    ];

    final String title = item.title?.trim() ?? '';
    final String description = item.description?.trim() ?? '';
    final String thumbnail = item.thumbnail?.trim() ?? '';

    if (title.isEmpty && description.isEmpty && thumbnail.isEmpty) {
      return const SizedBox.shrink();
    }

    // ============================================================
    // RESPONSIVE PADDING
    // ============================================================

    final double screenWidth = MediaQuery.sizeOf(context).width;

    final double padding = screenWidth < 600 ? 10 : 12;

    // ============================================================
    // RESPONSIVE FONT SIZE
    // ============================================================

    final double titleSize;

    if (screenWidth < 360) {
      titleSize = 10;
    } else if (screenWidth < 600) {
      titleSize = 11;
    } else if (screenWidth < 1000) {
      titleSize = 12;
    } else {
      titleSize = fontSize12;
    }

    final double descriptionSize;

    if (screenWidth < 360) {
      descriptionSize = 9;
    } else if (screenWidth < 600) {
      descriptionSize = 10;
    } else if (screenWidth < 1000) {
      descriptionSize = 10;
    } else {
      descriptionSize = fontSize10;
    }

    return Container(
      width: double.infinity,
      height: cardHeight,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: gPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // IMAGE + TITLE
          // ========================================================
          if (thumbnail.isNotEmpty || title.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (thumbnail.isNotEmpty)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Image.asset(
                      thumbnails[index % thumbnails.length],
                      fit: BoxFit.contain,
                    ),
                  ),

                if (thumbnail.isNotEmpty && title.isNotEmpty)
                  const SizedBox(width: 6),

                if (title.isNotEmpty)
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: gMainColor,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
              ],
            ),

          // ========================================================
          // DESCRIPTION
          // ========================================================
          if (title.isNotEmpty && description.isNotEmpty)
            const SizedBox(height: 7),

          if (description.isNotEmpty)
            Expanded(
              child: Text(
                description,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: gWhiteColor,
                  fontSize: descriptionSize,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
