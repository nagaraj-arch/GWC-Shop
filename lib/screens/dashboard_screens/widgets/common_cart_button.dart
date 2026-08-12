import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/responsive_helper.dart';

class CommonCartButton extends StatefulWidget {
  final Products product;
  final Color color;
  final double height;

  const CommonCartButton({
    super.key,
    required this.product,
    required this.color,
    required this.height,
  });

  @override
  State<CommonCartButton> createState() => _CommonCartButtonState();
}

class _CommonCartButtonState extends State<CommonCartButton> {
  int _lastQuantity = 0;
  DateTime? _lastChangeTime;

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    return Consumer<CartProvider>(
      builder: (context, cartManager, child) {
        final quantity = cartManager.items
            .where((e) => e.id == widget.product.productId)
            .fold<int>(0, (sum, e) => sum + e.quantity);

        final cartItem = cartManager.items.firstWhere(
          (e) => e.id == widget.product.productId,
          orElse: () => Item(
            id: widget.product.productId ?? 0,
            name: '',
            price: 0,
            category: '',
          ),
        );

        if (quantity != _lastQuantity) {
          _lastQuantity = quantity;
          _lastChangeTime = DateTime.now();
        }

        final changedJustNow =
            _lastChangeTime != null &&
            DateTime.now().difference(_lastChangeTime!).inMilliseconds < 300;

        return quantity == 0
            ? _addButton(cartManager, responsive)
            : _qtyRow(
                cartManager,
                quantity,
                cartItem,
                changedJustNow,
                responsive,
              );
      },
    );
  }

  Widget _addButton(CartProvider cartManager, ScreenSizeHelper responsive) {
    if(widget.product.hasFlavours == "1"){
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xffEEEAD7),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Text(
              "LAUNCHING SOON",
              style: GoogleFonts.robotoCondensed(
                fontSize: fontSize10,
                fontWeight: FontWeight.w700,
                color: gBlackColor,
              )
          ),
        ),

    );
    }
    return InkWell(
      onTap: () {
        cartManager.addItem(
          context,
          Item(
            id: widget.product.productId ?? 0,
            name: widget.product.productTitle ?? '',
            price: double.parse(widget.product.discountPrice ?? "0"),
            description: widget.product.productDescription,
            category: widget.product.category?.name ?? '',
            specialTag: widget.product.productSpecialTag,
            weight: widget.product.itemQty,
            unitId: widget.product.weightType?.id.toString(),
            unitName: widget.product.weightType?.unit,
            servings: widget.product.servings,
            thumbnail: widget.product.productThumbnailsUrls?.first,
          ),
        );
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xffEEEAD7),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            "ADD TO CART",
              style: GoogleFonts.robotoCondensed(
                fontSize: fontSize10,
                fontWeight: FontWeight.w700,
                color: gBlackColor,
              )
          ),
        ),
      ),
    );
  }

  Widget _qtyRow(
    CartProvider cartManager,
    int quantity,
    Item cartItem,
    bool changedJustNow,
    ScreenSizeHelper responsive,
  ) {
    return Container(
      padding: EdgeInsets.all(responsive.isMobile ? 3 : 5),
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xffEEEAD7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _qtyButton(Icons.remove, () {
              cartManager.removeItem(
                context,
                widget.product.productId ?? 0,
                cartItem.flavorName,
              );
            }),
            const SizedBox(width: 15),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                "$quantity",
                key: ValueKey(quantity),
                  style: GoogleFonts.robotoCondensed(
                    fontSize: fontSize10,
                    fontWeight: FontWeight.w700,
                    color: gBlackColor,
                  )
              ),
            ),

            const SizedBox(width: 15),

            _qtyButton(Icons.add, () {
              cartManager.addItem(
                context,
                Item(
                  id: widget.product.productId ?? 0,
                  name: widget.product.productTitle ?? '',
                  price: double.parse(widget.product.discountPrice ?? "0"),
                  description: widget.product.productDescription,
                  category: widget.product.category?.name ?? '',
                  specialTag: widget.product.productSpecialTag,
                  weight: widget.product.itemQty,
                  unitId: widget.product.weightType?.id.toString(),
                  unitName: widget.product.weightType?.unit,
                  servings: widget.product.servings,
                  thumbnail: widget.product.productThumbnailsUrls?.first,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: gWhiteColor, size: 14),
      ),
    );
  }
}
