import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/shop_provider.dart';
import '../../controllers/routers/app_router.dart';

class FloatingShopButton extends StatefulWidget {
  const FloatingShopButton({super.key});

  @override
  State<FloatingShopButton> createState() => _FloatingShopButtonState();
}

class _FloatingShopButtonState extends State<FloatingShopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool hovering = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = context.watch<ShopProvider>();

    return shopProvider.selectedTab == 0
        ? SizedBox()
        : AnimatedBuilder(
            animation: controller,
            builder: (_, child) {
              final offset = math.sin(controller.value * math.pi) * 8;

              return Transform.translate(
                offset: Offset(0, -offset),
                child: child,
              );
            },
            child: MouseRegion(
              onEnter: (_) => setState(() => hovering = true),
              onExit: (_) => setState(() => hovering = false),
              cursor: SystemMouseCursors.click,
              child: AnimatedScale(
                scale: hovering ? 1.08 : 1,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Circle Button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gBlackColor.withAlpha(hovering ? 35 : 18),
                            blurRadius: hovering ? 22 : 12,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: gPrimaryColor,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () async {
                            appRouter.go("/");

                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );

                            if (mounted) {
                              context.read<ShopProvider>().changeTab(0);
                            }
                          },
                          child: Icon(
                            Icons.shopping_basket_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),

                    /// Shop Now Text
                    const SizedBox(height: 6),
                    Text(
                      "Shop Now",
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: fontBold,
                        fontSize: fontSize10,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
