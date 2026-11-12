import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../controllers/providers/shop_provider.dart';
import '../../../../category_page/category_product_card.dart';

class RecommendedProductsSection extends StatelessWidget {
  final List<Products> products;
  final Color? category;
  const RecommendedProductsSection({
    super.key,
    required this.products,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final lst = products.take(2).toList();

    if (lst.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended for you",
                      style: TextStyle(
                        fontSize: fontSize14,
                        fontFamily: fontBold,
                        height: 1.5,
                        color: gPrimaryColor,
                      ),
                    ),
                    Text(
                      "Handpicked products you may love",
                      style: TextStyle(
                        fontSize: fontSize09,
                        color: gHintTextColor,
                        fontFamily: fontBook,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<ShopProvider>().navigateShopPage(1);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View All",
                      style: TextStyle(
                        fontSize: fontSize10,
                        fontFamily: fontBold,
                        color: gPrimaryColor,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 2.5.h,
                      color: gPrimaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AdditionalProductsGrid(products: lst, category: category),
        ],
      ),
    );
  }
}
