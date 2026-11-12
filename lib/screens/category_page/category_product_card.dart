import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final double rowGap1;
  final double rowGap2;
  final double gapBeforeButton;

  const _CardSizing({
    required this.titleSize,
    required this.priceSize,
    required this.infoSize,
    required this.buttonHeight,
    required this.iconSize,
    required this.contentPadding,
    required this.rowGap1,
    required this.rowGap2,
    required this.gapBeforeButton,
  });

  factory _CardSizing.fromWidth(double width) {
    final scale = (width / 220).clamp(0.75, 1.35);

    return _CardSizing(
      titleSize: (14 * scale).clamp(10.5, 18),
      priceSize: (14 * scale).clamp(10.5, 17),
      infoSize: (11 * scale).clamp(8.5, 14),
      buttonHeight: (36 * scale).clamp(30, 44),
      iconSize: (16 * scale).clamp(11, 20),
      contentPadding: (9 * scale).clamp(6, 13),
      rowGap1: (6 * scale).clamp(4, 8),
      rowGap2: (7 * scale).clamp(5, 9),
      gapBeforeButton: (10 * scale).clamp(6, 16),
    );
  }
}

class AdditionalProductsGrid extends StatelessWidget {
  final List<Products> products;
  final Color? category;
  final bool isShop;

  final bool mobileDesign;
  final bool showAllProducts;

  final Widget? afterFirstRow;

  const AdditionalProductsGrid({
    super.key,
    required this.products,
    this.category,
    this.isShop = false,
    this.mobileDesign = false,
    this.showAllProducts = false,
    this.afterFirstRow,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final int count = responsive.isMobile
            ? 2
            : responsive.isTablet
            ? 3
            : responsive.isLaptop
            ? 4
            : responsive.isDesktop
            ? 5
            : responsive.isLargeDesktop
            ? 6
            : 7;

        final spacing = responsive.isMobile ? 20.0 : 40.0;

        final padding = responsive.isMobile || responsive.isTablet ? 0.0 : 0.0;

        final cardWidth = (width - padding * 2 - spacing * (count - 1)) / count;
        final sizing = _CardSizing.fromWidth(cardWidth);

        const imageAspectRatio = 1.15;

        final imageHeight = cardWidth / imageAspectRatio;

        final mainAxisExtent =
            imageHeight +
                sizing.contentPadding * 2 +
                sizing.titleSize * 1.35 * 2 +
                sizing.rowGap1 +
                sizing.priceSize * 1.35 +
                sizing.rowGap2 +
                sizing.infoSize * 1.35 +
                sizing.gapBeforeButton +
                sizing.buttonHeight +
                sizing.contentPadding * 2;

        // ============================================================
// MOBILE + TABLET
// ============================================================

        if (mobileDesign) {
          final int firstRowCount =
          products.length > count ? count : products.length;

          final firstRowProducts =
          products.take(firstRowCount).toList();

          final remainingProducts =
          products.skip(firstRowCount).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ======================================================
              // FIRST ROW
              // ======================================================

              if (firstRowProducts.isNotEmpty)
                _buildGrid(
                  products: firstRowProducts,
                  count: count,
                  spacing: spacing,
                  padding: padding,
                  cardWidth: cardWidth,
                  mainAxisExtent: mainAxisExtent,
                ),

              // ======================================================
              // MOBILE / TABLET SECTION
              // ======================================================

              if (afterFirstRow != null &&
                  remainingProducts.isNotEmpty) ...[
                const SizedBox(height: 20),

                afterFirstRow!,

                const SizedBox(height: 20),
              ],

              // ======================================================
              // REMAINING PRODUCTS
              // ======================================================

              if (remainingProducts.isNotEmpty)
                _buildGrid(
                  products: remainingProducts,
                  count: count,
                  spacing: spacing,
                  padding: padding,
                  cardWidth: cardWidth,
                  mainAxisExtent: mainAxisExtent,
                ),
            ],
          );
        }

// ============================================================
// LAPTOP / DESKTOP / BIG DEVICES
// ============================================================

// ALWAYS SHOW ALL PRODUCTS
        return _buildGrid(
          products: products,
          count: count,
          spacing: spacing,
          padding: padding,
          cardWidth: cardWidth,
          mainAxisExtent: mainAxisExtent,
        );
      },
    );
  }

  Widget _buildGrid({
    required List<Products> products,
    required int count,
    required double spacing,
    required double padding,
    required double cardWidth,
    required double mainAxisExtent,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      padding: EdgeInsets.symmetric(horizontal: padding),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing + 10,
        mainAxisExtent: mainAxisExtent,
      ),

      itemCount: products.length,

      itemBuilder: (_, i) {
        final product = products[i];

        return ProductCard(
          key: ValueKey('${product.productTitle}_$i'),
          item: product,
          category: isShop ? product.category?.color : category,
          cardWidth: cardWidth,
        );
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Products item;
  final Color? category;
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
    final sizing = _CardSizing.fromWidth(widget.cardWidth);

    const imageAspectRatio = 1.05;
    final imageHeight = widget.cardWidth / imageAspectRatio;

    final titleSize = sizing.titleSize;
    final priceSize = sizing.priceSize;
    final infoSize = sizing.infoSize;
    final buttonHeight = sizing.buttonHeight;
    final iconSize = sizing.iconSize;
    final contentPadding = sizing.contentPadding;

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
            color: widget.category ?? const Color(0xff3B2415),
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
              ThumbnailView(
                context: context,
                imageUrl:
                // "assets/images/new_image.jpg",
                widget.item.productThumbnailsUrls?.first ?? "",
                enablePreview: false,
                borderRadius: 8,
                height: imageHeight,
                width: double.infinity,
                // BoxFit.fill stretches product photos non-uniformly;
                // BoxFit.cover preserves their real proportions.
                fit: BoxFit.fill,
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
                            ),
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
                          "₹${double.parse(widget.item.discountPrice ?? "0").toStringAsFixed(0)}",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: priceSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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
                            ),
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
                              ProductDetailsDialog(item: widget.item),
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
                            ),
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
                    color: widget.category ?? const Color(0xff3B2415),
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
