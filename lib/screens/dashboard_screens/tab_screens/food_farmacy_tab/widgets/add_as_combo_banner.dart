import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gwc_shop/controllers/models/shop_models/category_model.dart';
import 'package:gwc_shop/controllers/models/shop_models/products_by_category_model.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/widgets/button_widgets/button_widget.dart';
import 'package:gwc_shop/widgets/iamge_picker_widget/thumbnail_view.dart';

import '../../../../../controllers/models/shop_models/get_cluster_list_model.dart';
import '../../../../../utils/responsive_helper.dart';

class AddAsComboBanner extends StatelessWidget {
  final List<Products> products;
  final double originalPrice;
  final double comboPrice;
  final VoidCallback onBuyCombo;
  final CategoryList category;
  final ClusterList? cluster;

  const AddAsComboBanner({
    super.key,
    required this.products,
    required this.originalPrice,
    required this.comboPrice,
    required this.onBuyCombo,
    required this.category,
    this.cluster,
  });

  double get savedAmount => originalPrice - comboPrice;

  @override
  Widget build(BuildContext context) {
    if (products.length <= 1) {
      return const SizedBox.shrink();
    }

    final responsive = ScreenSizeHelper(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobileOrTablet = responsive.isMobile || responsive.isTablet;

        final content = _buildMobile(
          context,
          isMobileOrTablet: isMobileOrTablet,
        );

        // ============================================================
        // MOBILE + TABLET
        // ============================================================

        if (isMobileOrTablet) {
          return content;
        }

        // ============================================================
        // LAPTOP + DESKTOP
        // ============================================================

        return Align(alignment: Alignment.center, child: content);
      },
    );
  }

  // ============================================================
  // MOBILE + TABLET
  // ============================================================

  Widget _buildMobile(BuildContext context, {required bool isMobileOrTablet}) {
    final clusterName = (cluster?.clusterName ?? "")
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final screenWidth = MediaQuery.sizeOf(context).width;

    final bool isMobile = screenWidth < 600;
    final bool isSmallMobile = screenWidth < 360;
    final bool isBigDevice = screenWidth >= 600;

    // ============================================================
    // IMAGE SIZE
    // ============================================================

    final double imageSize;

    if (isSmallMobile) {
      imageSize = 52;
    } else if (isMobile) {
      imageSize = 62;
    } else {
      imageSize = 72;
    }

    // ============================================================
    // PADDING
    // ============================================================

    final double horizontalPadding = isMobile ? 10 : 16;
    final double verticalPadding = isMobile ? 9 : 12;

    // ============================================================
    // CONTENT WIDGET
    // ============================================================

    Widget contentColumn() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------------
          // CLUSTER NAME
          // --------------------------------------------------------
          Text(
            clusterName.isEmpty ? "COMBO" : clusterName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoCondensed(
              fontSize: fontSize16,
              fontWeight: FontWeight.w800,
              color: gPrimaryColor,
              height: 1,
            ),
          ),

          const SizedBox(height: 4),

          // --------------------------------------------------------
          // PRODUCT NAMES
          // --------------------------------------------------------
          Text(
            products
                .map((e) => e.productTitle ?? '')
                .where((e) => e.trim().isNotEmpty)
                .join(" + "),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: fontSize12,
              fontWeight: FontWeight.w500,
              color: gPrimaryColor,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 6),

          // --------------------------------------------------------
          // PRICE
          // --------------------------------------------------------
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "₹${comboPrice.toStringAsFixed(0)}",
                style: GoogleFonts.robotoCondensed(
                  fontSize: fontSize20,
                  fontWeight: FontWeight.w900,
                  color: gPrimaryColor,
                  height: 1,
                ),
              ),

              if (originalPrice > comboPrice) ...[
                const SizedBox(width: 5),
                Text(
                  "₹${originalPrice.toStringAsFixed(0)}",
                  style: GoogleFonts.roboto(
                    fontSize: 8,
                    color: const Color(0xff77766F),
                    decoration: TextDecoration.lineThrough,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 7),

          // --------------------------------------------------------
          // BUTTON
          // --------------------------------------------------------
          ButtonWidget(
            text: "ADD COMBO TO CART",
            onPressed: onBuyCombo,
            isLoading: false,
            radius: 10,
          ),
        ],
      );
    }

    // ============================================================
    // OUTER CONTAINER
    // ============================================================

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffFAF9F4),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xffE7E2D7)),
      ),

      // ==========================================================
      // CENTER THE ACTUAL CONTENT
      // ==========================================================
      child: Center(
        child: isBigDevice
            ? Row(
                // IMPORTANT:
                // Don't let Row take the complete width.
                // This makes the ACTUAL content group centered.
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ------------------------------------------------
                  // IMAGE
                  // ------------------------------------------------
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: ClipOval(
                      child: ThumbnailView(
                        context: context,
                        imageUrl: cluster?.clusterThumbnailUrl,
                        enablePreview: false,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ------------------------------------------------
                  // CONTENT
                  // ------------------------------------------------
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: contentColumn(),
                  ),
                ],
              )
            // ======================================================
            // MOBILE
            // ======================================================
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ------------------------------------------------
                  // IMAGE
                  // ------------------------------------------------
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: ClipOval(
                      child: ThumbnailView(
                        context: context,
                        imageUrl: cluster?.clusterThumbnailUrl,
                        enablePreview: false,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ------------------------------------------------
                  // CONTENT
                  // ------------------------------------------------
                  Expanded(child: contentColumn()),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _productImage(
    BuildContext context, {
    required double size,
    required double imageSize,
  }) {
    final imageUrl = products.first.productThumbnailsUrls?.first ?? "";

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffF0E9D8),
      ),
      child: ClipOval(
        child: ThumbnailView(
          context: context,
          imageUrl: imageUrl,
          enablePreview: false,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  Widget _description({double titleSize = 12, double descriptionSize = 8}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Better together. Greater impact.",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.robotoCondensed(
            fontSize: fontSize18,
            fontWeight: FontWeight.w700,
            color: const Color(0xff34352E),
          ),
        ),

        const SizedBox(height: 3),

        Text(
          "Take all ${products.length} shots as a combo and support your gut naturally — every day.",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
            fontSize: fontSize12,
            height: 1.2,
            color: const Color(0xff77766F),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider(double horizontalMargin) {
    return Container(
      height: 48,
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      color: borderColor,
    );
  }

  // ============================================================
  // PRICE
  // ============================================================

  Widget _price({
    double priceSize = 20,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    final hasOriginalPrice = originalPrice.isFinite && originalPrice > 0;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          "Total Price",
          style: GoogleFonts.roboto(
            fontSize: fontSize08,
            fontWeight: FontWeight.w600,
            color: gBlackColor,
            height: 0,
          ),
        ),

        Row(
          children: [
            if (hasOriginalPrice) ...[
              Text(
                "₹${originalPrice.toStringAsFixed(2)}",
                style: GoogleFonts.roboto(
                  fontSize: fontSize11,
                  color: const Color(0xff77766F),
                  height: 0,
                  decoration: TextDecoration.lineThrough,
                ),
              ),

              const SizedBox(width: 10),
            ],

            Text(
              "₹${comboPrice.toStringAsFixed(0)}",
              style: GoogleFonts.robotoCondensed(
                fontSize: fontSize24,
                fontWeight: FontWeight.w900,
                height: 0,
                color: category.color,
              ),
            ),

            if (hasOriginalPrice) ...[const SizedBox(width: 10), _saveBadge()],
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SAVE BADGE
  // ============================================================

  Widget _saveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: gMainColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            "SAVE",
            style: GoogleFonts.roboto(
              fontSize: fontSize08,
              fontWeight: FontWeight.w600,
              color: gWhiteColor,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            "₹${savedAmount.toStringAsFixed(0)}",
            style: GoogleFonts.robotoCondensed(
              fontSize: fontSize11,
              fontWeight: FontWeight.w800,
              color: gWhiteColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUY BUTTON
  // ============================================================

  Widget _buyButton({required double height}) {
    return Column(
      children: [
        ButtonWidget(
          text: "BUY AS COMBO",
          onPressed: onBuyCombo,
          isLoading: false,
          icon: Icons.shopping_bag_outlined,
          borderClr: category.color,
          color: category.color,
          radius: 8,
        ),

        const SizedBox(height: 10),

        Text(
          "All ${products.length} Shots • "
          "${products.first.itemQty}"
          "${products.first.weightType?.unit} Each • "
          "${products.first.servings} Servings Each",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: fontSize09,
            color: gHintTextColor,
          ),
        ),
      ],
    );
  }
}
