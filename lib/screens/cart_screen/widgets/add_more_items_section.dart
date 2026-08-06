import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/cart_provider.dart';
import '../../../controllers/providers/products_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../product_screens/widgets/item_quantity.dart';
import '../../product_screens/widgets/price_widget.dart';
import '../../product_screens/widgets/product_details_dialog.dart';
import '../../product_screens/widgets/servings_badge.dart';
import 'cart_title_widget.dart';

class AddMoreItemsSection extends StatelessWidget {
  const AddMoreItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();
    final responsive = ResponsiveHelper(context);

    final cart = context.watch<CartProvider>();

    final cartIds = cart.items.map((e) => e.id).toSet();

    final products = provider.additionalProducts
        .where(
            (e) => e.isProductPopular == true && !cartIds.contains(e.productId))
        .toList();

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Heading
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.isMobile ? 4 : 8,
          ),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 20,
                decoration: BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CommonSectionHeader(
                  title: "ADD MORE ITEMS",
                  subtitle: "${products.length} Products",
                  horizontalLayout: true,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 215,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: responsive.isMobile ? 4 : 8, vertical: 1.h),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final item = products[index];

              return _PopularProductCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _PopularProductCard extends StatefulWidget {
  final Products item;

  const _PopularProductCard({required this.item});

  @override
  State<_PopularProductCard> createState() => _PopularProductCardState();
}

class _PopularProductCardState extends State<_PopularProductCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final item = widget.item;

    final image =
        item.productThumbnailsUrls != null && item.productThumbnailsUrls!.isNotEmpty
            ? item.productThumbnailsUrls!.first
            : (item.productThumbnailsUrls?.first ?? "");

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: responsive.isMobile ? 150 : 170,
        padding: EdgeInsets.all(8),
        transform: isHovered
            ? (Matrix4.identity()
              ..translate(0.0, -4)
              ..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffE5E5E5),
          ),
          boxShadow: [
            BoxShadow(
              color: gBlackColor.withAlpha(isHovered ? 20 : 10),
              blurRadius: isHovered ? 12 : 5,
              offset: Offset(0, isHovered ? 5 : 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => ProductDetailsDialog(item: item),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThumbnailView(
                context: context,
                imageUrl: image,
                height: 80,
                width: 120,
                fit: BoxFit.contain,
                borderRadius: 6,
                enablePreview: false,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productTitle ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                          fontWeight: FontWeight.w900,
                          color: gPrimaryColor,
                          fontSize: fontSize15),
                    ),
                    const SizedBox(height: 4),
                    ItemInfoBadge(
                      orderQuantity: "${item.itemQty}${item.weightType?.unit}",
                      orderServings: item.servings,
                      fontSize: fontSize07,
                    ),
                    SizedBox(height: 4),
                    CommonPriceWidget(
                      actualPrice: item.actualPrice,
                      showLabel: false,
                      discountPrice: item.discountPrice,
                      discountPercentage: item.discountPercentage,
                    ),
                    Spacer(),
                    ItemQuantity(item: item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
