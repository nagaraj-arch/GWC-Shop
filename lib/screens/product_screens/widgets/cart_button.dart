import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../controllers/routers/app_router.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';

class GlobalCartButton extends StatefulWidget {
  const GlobalCartButton({super.key});

  @override
  State<GlobalCartButton> createState() => _GlobalCartButtonState();
}

class _GlobalCartButtonState extends State<GlobalCartButton> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    bool shouldShow = cart.totalQuantity > 0;

    if (!shouldShow) return const SizedBox.shrink();
    return SafeArea(
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        offset: shouldShow ? Offset.zero : const Offset(0, 3),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: shouldShow ? 1 : 0,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            scale: shouldShow ? 1 : .9,
            child: IgnorePointer(
              ignoring: !shouldShow,
              child: GestureDetector(
                onTap: () {
                  appRouter.go("/cart");
                },
                child: _buildCartUI(cart, context),
              ),
            ),
          ),
        ),
      ),
    );
    // return Positioned(
    //   left: 0,
    //   right: 0,
    //   bottom: 20,
    //   child: SafeArea(
    //     child: AnimatedSlide(
    //       duration: const Duration(milliseconds: 550),
    //       curve: Curves.easeInOutCubic,
    //       offset: shouldShow ? Offset.zero : const Offset(0, 3),
    //       child: AnimatedOpacity(
    //         duration: const Duration(milliseconds: 500),
    //         curve: Curves.easeInOut,
    //         opacity: shouldShow ? 1.0 : 0.0,
    //         child: AnimatedScale(
    //           duration: const Duration(milliseconds: 500),
    //           curve: Curves.easeOutBack,
    //           scale: shouldShow ? 1.0 : 0.9,
    //           child: IgnorePointer(
    //             ignoring: !shouldShow,
    //             child: Center(
    //               child: GestureDetector(
    //                 onTap: () => context.go("/cart"),
    //                 child: _buildCartUI(cart, context),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _buildCartUI(CartProvider cart, BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      width: responsive.isDesktop
          ? 360
          : responsive.isTablet
          ? 340
          : MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: kNumberCircleRed,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${cart.totalQuantity} Items",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,decoration: TextDecoration.none,
                    ),
                  ),SizedBox(height: 5),
                  const Text(
                    "OPEN BASKET",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.2,decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "₹${cart.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}