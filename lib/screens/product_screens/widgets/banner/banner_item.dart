import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/button_widgets/button_widget.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../price_widget.dart';

class BannerItem extends StatefulWidget {
  final Products product;
  final VoidCallback onTap;

  const BannerItem({super.key, required this.product, required this.onTap});

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return InkWell(
      onTap: widget.onTap,
      child: SizedBox(
        width: double.infinity,
        height: isDesktop ? 35.h : 35.h,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 5.w : 4.w,
            vertical: isDesktop ? 4.h : 2.h,
          ),
          child: isDesktop ? _desktopLayout(context) : _mobileLayout(context),
        ),
      ),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        /// LEFT SIDE
        Expanded(flex: 5, child: _details()),

        SizedBox(width: 3.w),

        /// RIGHT SIDE
        Expanded(flex: 5, child: _productImage()),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 6, child: _productImage()),
        SizedBox(height: 1.h),
        Expanded(flex: 4, child: _details()),
      ],
    );
  }

  Widget _details() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Popular Badge
        if (widget.product.isProductPopular == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.amber,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  "Popular Choice",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: fontMedium,
                    fontSize: fontSize10,
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: 2.h),

        /// Product Name
        Text(
          widget.product.productTitle ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cormorantGaramond(
            fontSize: fontSize20,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: gWhiteColor,
          ),
        ),

        SizedBox(height: 0.5.h),

        /// Description
        Text(
          widget.product.productDescription ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(.92),
            fontSize: fontSize11,
          ),
        ),

        SizedBox(height: 1.h),

        CommonPriceWidget(
          actualPrice: widget.product.actualPrice,
          discountPrice: widget.product.discountPrice,
          discountPercentage: widget.product.discountPercentage,
          showLabel: false,
        ),

        SizedBox(height: 1.h),

        /// Shop Now Button
        ButtonWidget(
          text: "Shop Now",
          onPressed: widget.onTap,
          isLoading: false,
          color: gWhiteColor,
          textColor: gBlackColor,
          icon: Icons.shopping_cart_outlined,
          iconColor: gBlackColor,
        ),
      ],
    );
  }

  Widget _productImage() {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return ThumbnailView(
      imageUrl: widget.product.productThumbnailsUrls?.first ?? "",
      fit: BoxFit.contain,
      height: isDesktop ? 30.h : 30.h,
      width: isDesktop ? 22.w : 40.w,
      context: context,
    );
  }
}
