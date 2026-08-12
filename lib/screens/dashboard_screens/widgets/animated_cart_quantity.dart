import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/get_additional_products_model/product_flavors_model.dart';
import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';

class AnimatedCartQuantity extends StatefulWidget {
  final Products item;

  const AnimatedCartQuantity({super.key, required this.item});

  @override
  State<AnimatedCartQuantity> createState() => _AnimatedCartQuantityState();
}

class _AnimatedCartQuantityState extends State<AnimatedCartQuantity>
    with TickerProviderStateMixin {
  bool isHovered = false;

  late AnimationController bounceController;
  late Animation<double> bounceAnimation;
  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();

    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    bounceAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: .92,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: .92,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
    ]).animate(bounceController);

    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    shakeAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: -6.0),
        weight: 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -6.0, end: 6.0),
        weight: 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 6.0, end: -5.0),
        weight: 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -5.0, end: 5.0),
        weight: 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 5.0, end: 0.0),
        weight: 20,
      ),
    ]).animate(shakeController);
  }

  @override
  void dispose() {
    bounceController.dispose();
    shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    final item = widget.item;

    return Consumer<CartProvider>(
      builder: (context, cartManager, child) {
        final cartItem = cartManager.items.firstWhere(
          (e) => e.id == item.productId,
          orElse: () =>
              Item(id: item.productId ?? 0, name: '', price: 0, category: ''),
        );

        final quantity = cartManager.items
            .where((e) => e.id == item.productId)
            .fold<int>(0, (sum, e) => sum + e.quantity);

        final selectedFlavors = cartManager.items
            .where(
              (e) =>
                  e.id == item.productId && (e.flavorName?.isNotEmpty ?? false),
            )
            .map((e) => e.flavorName!)
            .toList();

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            width: quantity == 0 ? 46 : (isDesktop ? 70 : 80),
            height: 40,
            decoration: BoxDecoration(
              color: isHovered ? const Color(0xFF971515) : gPrimaryColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: gPrimaryColor.withAlpha(isHovered ? 70 : 35),
                  blurRadius: isHovered ? 18 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: quantity == 0
                  ? _buildCartOnly(cartManager, selectedFlavors)
                  : _buildQuantityView(
                      quantity,
                      cartManager,
                      cartItem,
                      selectedFlavors,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartOnly(
    CartProvider cartManager,
    List<String> selectedFlavors,
  ) {
    if (widget.item.hasFlavours == "1") {
      return Center(
        child: Text(
          "COMING SOON",
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoCondensed(
            fontSize: fontSize08,
            fontWeight: FontWeight.w700,
            color: gWhiteColor,
          ),
        ),
      );
    }

    return InkWell(
      key: const ValueKey("cart"),
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        cartManager.addItem(
          context,
          Item(
            id: widget.item.productId ?? 0,
            name: widget.item.productTitle ?? '',
            price: double.parse(widget.item.discountPrice ?? "0"),
            description: widget.item.productDescription,
            category: widget.item.category?.name ?? '',
            specialTag: widget.item.productSpecialTag,
            weight: widget.item.itemQty,
            unitId: widget.item.weightType?.id.toString(),
            unitName: widget.item.weightType?.unit,
            servings: widget.item.servings,
            thumbnail: widget.item.productThumbnailsUrls?.first,
          ),
        );
        bounceController.forward(from: 0);
        shakeController.forward(from: 0);
      },
      child: Center(
        child: AnimatedBuilder(
          animation: shakeController,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.asset(
              "assets/images/cart.png",
              width: 18,
              height: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityView(
    int quantity,
    CartProvider cartManager,
    Item cartItem,
    List<String> selectedFlavors,
  ) {
    return Row(
      children: [
        _circleButton(Icons.remove, () {
          cartManager.removeItem(
            context,
            widget.item.productId ?? 0,
            cartItem.flavorName,
          );
        }),

        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                quantity.toString(),
                key: ValueKey(quantity),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: fontBold,
                  fontSize: fontSize15,
                ),
              ),
            ),
          ),
        ),

        _circleButton(Icons.add, () {
          cartManager.addItem(
            context,
            Item(
              id: widget.item.productId ?? 0,
              name: widget.item.productTitle ?? '',
              price: double.parse(widget.item.discountPrice ?? "0"),
              description: widget.item.productDescription,
              category: widget.item.category?.name ?? '',
              specialTag: widget.item.productSpecialTag,
              weight: widget.item.itemQty,
              unitId: widget.item.weightType?.id.toString(),
              unitName: widget.item.weightType?.unit,
              servings: widget.item.servings,
              thumbnail: widget.item.productThumbnailsUrls?.first,
            ),
          );

          bounceController.forward(from: 0);
          shakeController.forward(from: 0);
        }),
      ],
    );
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
      cartProvider.removeItem(context, item.productId!, flavorName);
    }

    /// ===========================
    /// NO FLAVOUR SELECTED
    /// ===========================
    if (newSelectedFlavors.length == 1 &&
        newSelectedFlavors.first.finalProductName == "No Flavour") {
      cartProvider.addItem(
        context,
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
      cartProvider.addItem(
        context,
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

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 1,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: gPrimaryColor),
        ),
      ),
    );
  }
}
