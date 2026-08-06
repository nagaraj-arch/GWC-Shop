import 'package:flutter/material.dart';
import 'package:gwc_shop/utils/constants.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';

/// A 2-column grid of feature cards (1 column on mobile), each showing:
/// a numbered label ("01"/"02"/...) with a small underline, a circular
/// icon overlapping the top edge, a bold centered title with its own
/// underline, and a left-aligned description.
///
/// Every size inside a card is derived from that card's own width
/// (cardWidth), so the whole card scales together as one proportional
/// system instead of some parts scaling with width while others stay
/// fixed-pixel — that mismatch is what causes a layout's spacing to
/// grow or shrink oddly as the screen resizes.
class FeatureGrid extends StatelessWidget {
  final List<ImportantPoints>? category;
  final Color? color;

  const FeatureGrid({super.key, this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Per-breakpoint card width ceiling and outer padding. Measured
    // against the reference design rather than guessed — these values
    // keep cards a consistent, moderate size instead of stretching to
    // fill the full viewport on wide screens (every element in a card
    // scales with cardWidth, so an uncapped width makes the whole card
    // oversized, not just wider).
    late final double maxCardWidth;
    late final double horizontalPadding;

    if (responsive.isMobile) {
      // 1 column on mobile — the single card fills (most of) the phone
      // width rather than being capped to a multi-column value.
      maxCardWidth = double.infinity;
      horizontalPadding = 16;
    } else if (responsive.isTablet) {
      maxCardWidth = 300;
      horizontalPadding = 24;
    } else if (responsive.isLaptop) {
      maxCardWidth = 380;
      horizontalPadding = 40;
    } else if (responsive.isDesktop) {
      maxCardWidth = 420;
      horizontalPadding = 50;
    } else {
      // largeDesktop / ultra-wide
      maxCardWidth = 460;
      horizontalPadding = 60;
    }

    // 1 column on mobile, 2 columns everywhere else.
    final crossAxisCount = responsive.isMobile ? 1 : 2;
    final gridSpacing = responsive.isMobile ? 16.0 : 24.0;

    // Caps the grid's total width and centers it, instead of letting
    // cards stretch to fill the entire viewport on wide screens.
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
            final cardWidth = (constraints.maxWidth -
                totalSpacing -
                (horizontalPadding * 2)) /
                crossAxisCount;

            // Landscape, but milder than a previous 1.35 attempt — at
            // 1.35 the card's fixed content (icon margin + index +
            // title + underline) alone exceeded the available height
            // before the description even got any room, causing a
            // real overflow. This value is paired with the trimmed
            // avatarSize/gaps/description maxLines below to actually
            // fit everything within a genuinely landscape card.
            const childAspectRatio = 1.1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: category?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: responsive.isMobile ? 20 : 32,
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
    // Minimum-size floors as a general safety net — guarantees
    // legibility on any narrow card (e.g. tablet's 2-column layout, or
    // if this card is ever reused somewhere narrower) without affecting
    // wider screens, where the proportional value already exceeds them.
    // titleSize proportion reduced from 0.065 — at 0.065, the title's
    // required width grows at almost the same rate as the card's
    // available width as cardWidth increases, so it would stay right at
    // the wrap point no matter how wide the card got. This lower
    // proportion, combined with the wider cardWidth values above,
    // actually leaves room for the title to fit on one line.
    // avatarSize reduced from 0.34 — at the shorter landscape card
    // height, the icon and its top margin/padding were consuming too
    // large a share of the available vertical space, leaving no room
    // for anything below it.
    final avatarSize = cardWidth * 0.30;
    final titleSize = (cardWidth * 0.055) < 13.0 ? 13.0 : cardWidth * 0.055;
    final descSize = (cardWidth * 0.050) < 11.0 ? 11.0 : cardWidth * 0.050;
    final indexSize = cardWidth * 0.045;

    final cardColor = color ?? const Color(0xff3B2415);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: avatarSize / 2),
          padding: EdgeInsets.only(
           left: cardWidth * 0.08,
            // avatarSize / 2 + 12,
          right:  cardWidth * 0.08,
           bottom:  cardWidth * 0.08,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(cardWidth * 0.08),
          ),
          child: Column(
            children: [
              SizedBox(height: cardWidth * 0.03),

              // Index label ("01"/"02"/...) with its small underline.
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${index + 1}".padLeft(2, '0'),
                      style: TextStyle(
                        color: gMainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: indexSize,
                      ),
                    ),
                    SizedBox(height: cardWidth * 0.012),
                    Container(
                      width: cardWidth * 0.06,
                      height: 2,
                      color: gMainColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: cardWidth * 0.15),

              // Title
              Text(
                item?.title?.toUpperCase() ?? "",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w700,
                  fontSize: titleSize,
                  color: Colors.white,
                  // Was a fixed 2.0px — a fixed pixel value eats into
                  // the required width at a rate unrelated to how much
                  // room the card actually has, working against the
                  // one-line fit. Removed.
                  height: 1.4,
                ),
              ),

              SizedBox(height: cardWidth * 0.03),

              Container(
                width: cardWidth * 0.18,
                height: 2,
                color: gMainColor,
              ),

              SizedBox(height: cardWidth * 0.04),

              // Description — maxLines reduced from 5/6, since a
              // genuinely landscape (shorter) card has less vertical
              // room than the previous portrait shape did.
              Expanded(
                child: Text(
                  item?.description ?? "",
                  textAlign: TextAlign.left,
                  // maxLines: 3,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w500,
                    fontSize: descSize,
                    color: const Color(0xffF5EDE6),
                    letterSpacing: 0.0,
                    height: 1.31,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Avatar thumbnail
        Positioned(
          top: avatarSize * 0.18,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: const Color(0xffD7A100), width: 2),
            ),
            padding: const EdgeInsets.all(5),
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
    );
  }
}
