import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/get_additional_products_model/get_additional_products_model.dart';
import '../../../controllers/models/get_additional_products_model/product_flavors_model.dart';
import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import 'flavours_popup.dart';

class ItemQuantity extends StatefulWidget {
  final Products item;

  const ItemQuantity({super.key, required this.item});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;

  AnimationController? bounceController;
  Animation<double>? bounceAnimation;

  @override
  void initState() {
    super.initState();

    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    bounceAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
    ]).animate(bounceController!);
  }

  @override
  void dispose() {
    bounceController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return Consumer<CartProvider>(
      builder: (context, cartManager, child) {
        final cartItem = cartManager.items.firstWhere(
          (e) => e.id == item.productId,
          orElse: () => Item(
            id: item.productId ?? 0,
            name: '',
            price: 0,
            category: '',
          ),
        );

        final quantity = cartManager.items
            .where((e) => e.id == item.productId)
            .fold<int>(0, (sum, e) => sum + e.quantity);

        final selectedFlavors = cartManager.items
            .where((e) =>
                e.id == item.productId && (e.flavorName?.isNotEmpty ?? false))
            .map((e) => e.flavorName!)
            .toList();

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Card(
            color: gBgColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            child: quantity > 0
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _qtyBtn(
                          icon: Icons.remove,
                          onTap: () {
                            // if (item.productTitle!
                            //     .toLowerCase()
                            //     .contains("beet juice")) {
                            if (item.hasFlavours == "1") {
                              final oldSelectedFlavors = selectedFlavors;

                              showDialog(
                                context: context,
                                builder: (_) => FlavorSelectionDialog(
                                  product: item,
                                  selectedFlavorNames: oldSelectedFlavors,
                                  onConfirm: (newSelectedFlavors) {
                                    updateFlavors(
                                      context: context,
                                      item: item,
                                      oldFlavors: oldSelectedFlavors,
                                      newSelectedFlavors: newSelectedFlavors,
                                    );
                                  },
                                ),
                              );
                            } else {
                              cartManager.removeItem(context,
                                  item.productId ?? 0, cartItem.flavorName);

                              bounceController?.forward().then((_) {
                                bounceController?.reverse();
                              });
                            }
                          },
                        ),
                        SizedBox(width: isDesktop ? 0.8.w : 2.w),
                        AnimatedBuilder(
                          animation: bounceAnimation ??
                              const AlwaysStoppedAnimation(1),
                          builder: (context, child) {
                            final scale = bounceAnimation?.value ?? 1.0;

                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: fontSize13,
                              fontFamily: fontBold,
                              color: gPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: isDesktop ? 0.8.w : 2.w),
                        _qtyBtn(
                          icon: Icons.add,
                          onTap: () {
                            // if (item.productTitle!
                            //     .toLowerCase()
                            //     .contains("beet juice")) {
                            if (item.hasFlavours == "1") {
                              final oldSelectedFlavors = selectedFlavors;

                              showDialog(
                                context: context,
                                builder: (_) => FlavorSelectionDialog(
                                  product: item,
                                  selectedFlavorNames: oldSelectedFlavors,
                                  onConfirm: (newSelectedFlavors) {
                                    updateFlavors(
                                      context: context,
                                      item: item,
                                      oldFlavors: oldSelectedFlavors,
                                      newSelectedFlavors: newSelectedFlavors,
                                    );
                                  },
                                ),
                              );
                            } else {
                              cartManager.addItem(context,
                                Item(
                                  id: item.productId ?? 0,
                                  name: item.productTitle ?? '',
                                  description: item.productDescription,
                                  price: double.parse(
                                      item.discountPrice.toString()),
                                  category: item.category?.name ?? '',
                                  specialTag: item.productSpecialTag,
                                  weight: item.itemQty,
                                  unitId: item.weightType?.id.toString(),
                                  unitName: item.weightType?.unit,
                                  servings: item.servings,
                                  thumbnail: item.productThumbnails?.first,
                                ),
                              );

                              bounceController?.forward().then((_) {
                                bounceController?.reverse();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // if (item.productTitle!
                      //     .toLowerCase()
                      //     .contains("beet juice")) {
                      if (item.hasFlavours == "1") {
                        final oldSelectedFlavors = selectedFlavors;

                        showDialog(
                          context: context,
                          builder: (_) => FlavorSelectionDialog(
                            product: item,
                            selectedFlavorNames: oldSelectedFlavors,
                            onConfirm: (newSelectedFlavors) {
                              updateFlavors(
                                context: context,
                                item: item,
                                oldFlavors: oldSelectedFlavors,
                                newSelectedFlavors: newSelectedFlavors,
                              );
                            },
                          ),
                        );
                      } else {
                        cartManager.addItem(context,
                          Item(
                            id: item.productId ?? 0,
                            name: item.productTitle ?? '',
                            price: double.parse(item.discountPrice.toString()),
                            description: item.productDescription,
                            category: item.category?.name ?? '',
                            specialTag: item.productSpecialTag,
                            weight: item.itemQty,
                            unitId: item.weightType?.id.toString(),
                            unitName: item.weightType?.unit,
                            servings: item.servings,
                            thumbnail: item.productThumbnails?.first,
                          ),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: gPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: fontBold,
                              fontSize: fontSize10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return HoverButton(icon: icon, onTap: onTap);
  }

  void updateFlavors({
    required BuildContext context,
    required Products item,
    required List<String> oldFlavors,
    required List<Flavours> newSelectedFlavors,
  }) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final productPrice = double.parse(item.discountPrice.toString());

    /// Remove all previously selected flavors
    for (final flavorName in oldFlavors) {
      cartProvider.removeItem(context,
        item.productId!,
        flavorName,
      );
    }

    /// ===========================
    /// NO FLAVOUR SELECTED
    /// ===========================
    if (newSelectedFlavors.length == 1 &&
        newSelectedFlavors.first.finalProductName == "No Flavour") {
      cartProvider.addItem(context,
        Item(
          id: item.productId!,
          name: item.productTitle ?? "",

          /// Pass to API
          flavorName: "No Flavour",

          /// No extra price
          flavorPrice: 0,

          /// Base product price only
          price: productPrice,

          category: item.category?.name ?? "",
          thumbnail: item.productThumbnails?.first,
          weight: item.itemQty,
          unitId: item.weightType?.id.toString(),
          unitName: item.weightType?.unit,
          servings: item.servings,
          description: item.productDescription,
          specialTag: item.productSpecialTag,
        ),
      );

      return;
    }

    /// ===========================
    /// NORMAL FLAVOURS
    /// ===========================
    for (final flavor in newSelectedFlavors) {
      cartProvider.addItem(context,
        Item(
          id: item.productId!,
          name: item.productTitle ?? "",

          /// Flavor Name
          flavorName: flavor.finalProductName,

          /// Extra Flavor Price
          flavorPrice: double.tryParse(flavor.discountedPrice ?? "0") ?? 0,

          /// Base Product Price
          price: productPrice,

          category: item.category?.name ?? "",
          thumbnail: item.productThumbnails?.first,
          weight: item.itemQty,
          unitId: item.weightType?.id.toString(),
          unitName: item.weightType?.unit,
          servings: item.servings,
          description: item.productDescription,
          specialTag: item.productSpecialTag,
        ),
      );
    }
  }
}

class HoverButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HoverButton({super.key, required this.icon, required this.onTap});

  @override
  State<HoverButton> createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isHover ? gPrimaryColor : gWhiteColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isHover ? gPrimaryColor : borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: isHover ? 4 : 2,
              )
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              widget.icon,
              key: ValueKey(isHover),
              size: 16,
              color: isHover ? gWhiteColor : gPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
