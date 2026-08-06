import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../dashboard_screens/widgets/common_cart_button.dart';
import '../product_screens/widgets/product_details_dialog.dart';

/// All per-breakpoint sizing for a product card, in one place. Both
/// AdditionalProductsGrid (to compute exactly how tall each grid cell
/// needs to be) and ProductCard (to actually render at that size) read
/// from this single source, so the two can never drift out of sync.
class _CardSizing {
  final double titleSize;
  final double priceSize;
  final double infoSize;
  final double buttonHeight;
  final double iconSize;
  final double contentPadding;
  final double imageHeightMultiplier;
  final bool titleTwoLines;
  final double rowGap1; // between title row and price row
  final double rowGap2; // between price row and "what's inside" row
  final double gapBeforeButton;

  const _CardSizing({
    required this.titleSize,
    required this.priceSize,
    required this.infoSize,
    required this.buttonHeight,
    required this.iconSize,
    required this.contentPadding,
    required this.imageHeightMultiplier,
    required this.titleTwoLines,
    required this.rowGap1,
    required this.rowGap2,
    required this.gapBeforeButton,
  });

  static _CardSizing forBreakpoint(ScreenSizeHelper responsive) {
    if (responsive.isMobile) {
      return const _CardSizing(
        titleSize: 10.5,
        priceSize: 10.5,
        infoSize: 8.5,
        buttonHeight: 30,
        iconSize: 11,
        contentPadding: 6,
        imageHeightMultiplier: 0.95,
        titleTwoLines: true,
        rowGap1: 4,
        rowGap2: 5,
        gapBeforeButton: 8,
      );
    } else if (responsive.isTablet) {
      return const _CardSizing(
        titleSize: 12.5,
        priceSize: 12,
        infoSize: 10,
        buttonHeight: 34,
        iconSize: 14,
        contentPadding: 8,
        imageHeightMultiplier: 0.90,
        titleTwoLines: false,
        rowGap1: 6,
        rowGap2: 8,
        gapBeforeButton: 10,
      );
    } else if (responsive.isLaptop) {
      return const _CardSizing(
        titleSize: 15,
        priceSize: 14,
        infoSize: 12,
        buttonHeight: 36,
        iconSize: 16,
        contentPadding: 10,
        imageHeightMultiplier: 0.75,
        titleTwoLines: false,
        rowGap1: 6,
        rowGap2: 8,
        gapBeforeButton: 12,
      );
    } else if (responsive.isDesktop) {
      return const _CardSizing(
        titleSize: 16,
        priceSize: 15,
        infoSize: 13,
        buttonHeight: 38,
        iconSize: 16,
        contentPadding: 10,
        imageHeightMultiplier: 0.78,
        titleTwoLines: false,
        rowGap1: 6,
        rowGap2: 8,
        gapBeforeButton: 14,
      );
    } else {
      return const _CardSizing(
        titleSize: 17,
        priceSize: 16,
        infoSize: 14,
        buttonHeight: 40,
        iconSize: 18,
        contentPadding: 12,
        imageHeightMultiplier: 0.75,
        titleTwoLines: false,
        rowGap1: 6,
        rowGap2: 8,
        gapBeforeButton: 16,
      );
    }
  }

  double imageHeight(double cardWidth) => cardWidth * imageHeightMultiplier;

  // Height of the title/price/"what's inside" text block, using a
  // 1.3x line-height approximation per row. A small buffer is folded in
  // via the caller when computing mainAxisExtent, so minor rounding
  // differences don't cause the Spacer below to overflow.
  double get textBlockHeight =>
      contentPadding +
          (titleSize * 1.3 * (titleTwoLines ? 2 : 1)) +
          rowGap1 +
          (priceSize * 1.3) +
          rowGap2 +
          (infoSize * 1.3);

  double get buttonSectionHeight => buttonHeight + contentPadding * 2;
}

class AdditionalProductsGrid extends StatelessWidget {
  final List<Products> products;
  final CategoryList? category;

  const AdditionalProductsGrid({
    super.key,
    required this.products,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final sizing = _CardSizing.forBreakpoint(responsive);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int count = responsive.isMobile
            ? 2
            : responsive.isTablet
            ? 2
            : responsive.isLaptop
            ? 3
            : responsive.isDesktop
            ? 4
            : responsive.isLargeDesktop
            ? 5
            : 6;

        final spacing = responsive.isMobile ? 20.0 : 40.0;
        final padding = responsive.isMobile ? 12.0 : 60.0;

        final cardWidth = (width - padding * 2 - spacing * (count - 1)) / count;

        // Previously a fixed childAspectRatio was used, which makes
        // cell height scale linearly with cardWidth — but only the
        // product image should scale with card width; the text rows
        // and button below it are roughly fixed-pixel regardless of
        // card width. A static ratio can only match at one specific
        // width, so as the window resized (even within one breakpoint
        // tier, not just across tiers), the Column's Spacer had to
        // absorb an ever-growing or shrinking gap. Computing the exact
        // required height for the *current* cardWidth and using
        // mainAxisExtent instead fixes this at every width, not just
        // the handful originally eyeballed.
        final mainAxisExtent = sizing.imageHeight(cardWidth) +
            sizing.textBlockHeight +
            sizing.gapBeforeButton +
            sizing.buttonSectionHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing +10,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(
            key: ValueKey('${products[i].productTitle}_$i'),
            item: products[i],
            category: category,
            cardWidth: cardWidth,
          ),
        );
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Products item;
  final CategoryList? category;
  final double cardWidth;

  const ProductCard({
    super.key,
    required this.item,
    this.category,
    required this.cardWidth,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final sizing = _CardSizing.forBreakpoint(responsive);

    final titleSize = sizing.titleSize;
    final priceSize = sizing.priceSize;
    final infoSize = sizing.infoSize;
    final buttonHeight = sizing.buttonHeight;
    final iconSize = sizing.iconSize;
    final contentPadding = sizing.contentPadding;
    final imageHeight = sizing.imageHeight(widget.cardWidth);

    final orderQuantity =
        "${widget.item.itemQty}${widget.item.weightType?.unit}";
    final orderServings = widget.item.servings;

    final List<String> values = [];

    if (orderQuantity.isNotEmpty && orderQuantity != "null") {
      values.add(orderQuantity);
    }

    if (orderServings != null &&
        orderServings.isNotEmpty &&
        orderServings != "null") {
      values.add("$orderServings Servings");
    }

    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: hover ? 1.02 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: widget.category?.color ?? const Color(0xff3B2415),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: ThumbnailView(
                  context: context,
                  imageUrl: widget.item.productThumbnailsUrls?.first ?? "",
                  enablePreview: false,
                  borderRadius: 12,
                  height: imageHeight,
                  width: double.infinity,
                  // BoxFit.fill stretches product photos non-uniformly;
                  // BoxFit.cover preserves their real proportions.
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  contentPadding,
                  contentPadding,
                  contentPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// PRODUCT NAME
                    Row(
                      children: [
                        Icon(
                          Icons.soup_kitchen_outlined,
                          color: const Color(0xffF5EFE6),
                          size: iconSize,
                        ),

                        SizedBox(width: responsive.isMobile ? 4 : 6),

                        Expanded(
                          child: Text(
                              widget.item.productTitle ?? "",
                              maxLines: responsive.isMobile ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.robotoCondensed(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sizing.rowGap1),

                    /// PRICE + WEIGHT
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            "₹${double
                                .parse(widget.item.discountPrice ?? "0")
                                .toStringAsFixed(0)}",
                            style: GoogleFonts.robotoCondensed(
                              fontSize: priceSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )
                        ),

                        SizedBox(width: responsive.isMobile ? 6 : 10),

                        Expanded(
                          child: Text(
                              values.join(" | "),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: infoSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              )
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sizing.rowGap2),

                    /// WHAT'S INSIDE
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) =>
                              ProductDetailsDialog(
                                item: widget.item,
                              ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "What's inside",
                              style: GoogleFonts.roboto(
                                fontSize: infoSize,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xffE7D5C3),
                              )
                          ),

                          SizedBox(width: responsive.isMobile ? 4 : 6),

                          Icon(
                            Icons.login_outlined,
                            size: iconSize,
                            color: const Color(0xffE7D5C3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Kept as a flexible Spacer (rather than a fixed gap) so
              // it still absorbs small estimation error gracefully — but
              // since the grid's mainAxisExtent above now matches the
              // actual content height almost exactly, this only ever
              // expands by a small, consistent amount (sizing.
              // gapBeforeButton) instead of an unpredictable, width-
              // dependent one.
              const Spacer(),

              Padding(
                padding: EdgeInsets.all(contentPadding),
                // CommonCartButton wasn't given an explicit width, so it
                // was free to size itself to its own content. If it
                // renders differently between the plain "ADD TO CART"
                // state and an in-cart quantity-stepper state, that would
                // produce exactly the width mismatch between cards seen
                // in testing. Forcing full width here removes that
                // ambiguity regardless of CommonCartButton's internals.
                child: SizedBox(
                  width: double.infinity,
                  child: CommonCartButton(
                    product: widget.item,
                    color: widget.category?.color ?? const Color(0xff3B2415),
                    height: buttonHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
