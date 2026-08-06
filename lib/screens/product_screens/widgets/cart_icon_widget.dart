import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/button_widgets/icon_button.dart';

class CartIconWidget extends StatefulWidget {
  const CartIconWidget({super.key});

  @override
  State<CartIconWidget> createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget>
    with SingleTickerProviderStateMixin {
  bool isHover = false;

  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> rotate;

  int previousQty = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    scale = Tween(begin: 1.0, end: 1.2).animate(curve);
    rotate = Tween(begin: 0.0, end: 0.08).animate(curve);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final totalQuantity = cart.totalQuantity;

    /// 🔥 trigger only when quantity changes
    if (totalQuantity != previousQty) {
      previousQty = totalQuantity;

      controller.forward(from: 0).then((_) {
        controller.reverse();
      });
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotate.value,
          child: ScaleTransition(scale: scale, child: child),
        );
      },

      /// 🔥 STATIC CHILD (NO REBUILD)
      child: GestureDetector(
        onTap: () {
          context.go("/cart");
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => isHover = true),
              onExit: (_) => setState(() => isHover = false),
              child: IconButtonWidget(
                msg: "Cart",
                image: "assets/images/cart.png",
                icon: Icons.shopping_cart_outlined,
                onTap: () {
                  context.go("/cart");
                },
              ),
            ),
            if (totalQuantity > 0)
              Positioned(
                right: -7,
                top: -7,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isHover ? gWhiteColor : gPrimaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: gPrimaryColor),
                  ),
                  child: Text(
                    totalQuantity.toString(),
                    style: TextStyle(
                      fontSize: fontSize08,
                      color: isHover ? gPrimaryColor : gWhiteColor,
                      fontFamily: fontBold,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
