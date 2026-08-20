import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/controllers/models/shop_models/category_model.dart';
import 'package:gwc_shop/controllers/models/shop_models/products_by_category_model.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/widgets/button_widgets/button_widget.dart';
import 'package:gwc_shop/widgets/container_widgets/common_divider.dart';
import 'package:gwc_shop/widgets/iamge_picker_widget/thumbnail_view.dart';

import '../../../../../utils/responsive_helper.dart';

class AddAsComboBanner extends StatelessWidget {
  final List<Products> products;
  final double originalPrice;
  final double comboPrice;
  final VoidCallback onBuyCombo;
  final CategoryList category;

  const AddAsComboBanner({
    super.key,
    required this.products,
    required this.originalPrice,
    required this.comboPrice,
    required this.onBuyCombo,
    required this.category,
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
        if (responsive.isMobile || responsive.isTablet) {
          return _buildMobile(context);
        }
        return _buildDesktop(context);
      },
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================
  Widget _buildDesktop(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFAF9F4),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xffE7E2D7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _productImage(context, size: 72, imageSize: 42),
          const SizedBox(width: 10),
          _description(titleSize: 12, descriptionSize: 8),
          Spacer(),
          _divider(30),
          _price(priceSize: 20, crossAxisAlignment: CrossAxisAlignment.start),
          _divider(20),
          _buyButton(height: 30),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  /// ============================================================
  /// MOBILE
  /// ============================================================
  Widget _buildMobile(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFAF9F4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE7E2D7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _productImage(context, size: 66, imageSize: 38),
              const SizedBox(width: 15),
              Expanded(
                child: _description(titleSize: 11, descriptionSize: 7.5),
              ),
            ],
          ),
          CommonDivider(verticalMargin: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _price(
                  priceSize: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              const SizedBox(width: 7),

              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: _buyButton(height: 34),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ],
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

  Widget _saveBadge({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          SizedBox(width: 5),
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
        SizedBox(height: 10),
        Text(
          "All ${products.length} Shots • ${products.first.itemQty}${products.first.weightType?.unit} Each • ${products.first.servings} Servings Each",
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
