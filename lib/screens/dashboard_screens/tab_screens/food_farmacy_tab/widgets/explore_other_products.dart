import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/providers/products_providers.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/responsive_helper.dart';
import '../../../../category_page/category_product_card.dart';

class ExploreOtherProducts extends StatelessWidget {
  final Color clr;
  const ExploreOtherProducts({super.key, required this.clr});

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    final provider = context.watch<ProductsProvider>();

    final products = provider.foodFarmacyProducts;

    debugPrint("FOOD : $products");

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EXPLORE OTHER FOOD FARMACY PRODUCTS",
          style: TextStyle(
            color: gMainColor,
            fontSize: responsive.isMobile ? 10 : 14,
            fontFamily: fontMedium,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 40),
        AdditionalProductsGrid(products: products, category: clr),
      ],
    );
  }
}
