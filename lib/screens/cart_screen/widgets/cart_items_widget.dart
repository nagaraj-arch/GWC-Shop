import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../../../widgets/button_widgets/hover_button.dart';
import '../../../widgets/container_widgets/common_card.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../product_screens/widgets/servings_badge.dart';

class CartItemsWidget extends StatefulWidget {
  const CartItemsWidget({super.key});

  @override
  State<CartItemsWidget> createState() => _CartItemsWidgetState();
}

class _CartItemsWidgetState extends State<CartItemsWidget>
    with SingleTickerProviderStateMixin {
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
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
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
    final isDesktop = ResponsiveHelper(context).isDesktop;
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          itemBuilder: (context, index) {
            final item = cart.items[index];
            int quantity = item.quantity;

            final hasFlavor =
                (item.flavorName ?? "").trim().isNotEmpty &&
                item.flavorName != "null";

            debugPrint("Flavors : ${item.flavorName}");
            return CommonCard(
              elevation: 2,
              borderClr: gBlackColor.withAlpha(50),
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(12),
              borderRadius: 22,
              child: Row(
                children: [
                  ThumbnailView(
                    context: context,
                    imageUrl: item.thumbnail,
                    fileName: item.name,
                    width: 30,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: isDesktop ? 1.w : 2.w),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: TextStyle(
                            fontFamily: "Caveat",
                            fontSize: fontSize18,
                            fontWeight: FontWeight.w700,
                            color: gPrimaryColor,
                          ),
                        ),
                        // SizedBox(height: .5.h),
                        // Text(
                        //   item.description?.replaceAll(RegExp(r'^\s+'), "") ??
                        //       '',
                        //   style: TextStyle(
                        //     color: newLightGreyColor,
                        //     fontSize: fontSize10,
                        //     fontFamily: fontBook,
                        //   ),
                        // ),
                        SizedBox(height: .6.h),
                        if (hasFlavor) ...[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Flavor : ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: fontSize10,
                                    fontFamily: fontMedium,
                                  ),
                                ),
                                TextSpan(
                                  text: item.flavorName!,
                                  style: TextStyle(
                                    color: gPrimaryColor,
                                    fontSize: fontSize10,
                                    fontFamily: fontBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                        ],
                        ItemInfoBadge(
                          orderQuantity: "${item.weight}${item.unitName}",
                          orderServings: item.servings,
                        ),
                        SizedBox(height: 1.h),
                        CommonCard(
                          elevation: 2,
                          backgroundColor: const Color(0xffEEFDF4),
                          borderClr: const Color(0xff77D4A5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          margin: EdgeInsets.zero,
                          borderRadius: 6,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "₹${item.price?.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: fontSize13,
                                    fontFamily: "Caveat",
                                    color: gPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if ((item.flavorName ?? "").trim().isNotEmpty &&
                                    item.flavorName != "null")
                                  TextSpan(
                                    text:
                                        " (+₹${(item.flavorPrice ?? 0).toStringAsFixed(0)})",
                                    style: TextStyle(
                                      fontSize: fontSize11,
                                      fontFamily: "Caveat",
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 1.w),

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Unit Price",
                  //       style: TextStyle(
                  //         color: newLightGreyColor,
                  //         fontSize: fontSize09,
                  //         fontFamily: fontBook,
                  //       ),
                  //     ),
                  //     SizedBox(height: .3.h),
                  //     RichText(
                  //       text: TextSpan(
                  //         children: [
                  //           TextSpan(
                  //             text: "₹${item.price.toStringAsFixed(0)}",
                  //             style: TextStyle(
                  //               fontSize: fontSize12,
                  //               fontFamily: fontBold,
                  //               color: gPrimaryColor,
                  //             ),
                  //           ),
                  //           if ((item.flavorName ?? "")
                  //                   .trim()
                  //                   .isNotEmpty &&
                  //               item.flavorName != "null")
                  //             TextSpan(
                  //               text:
                  //                   " (+₹${(item.flavorPrice ?? 0).toStringAsFixed(0)})",
                  //               style: TextStyle(
                  //                 fontSize: fontSize10,
                  //                 fontFamily: fontMedium,
                  //                 color: Colors.green,
                  //               ),
                  //             ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // SizedBox(width: 1.w),
                  Card(
                    color: gBgColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          _qtyBtn(
                            icon: Icons.remove,
                            onTap: () async {
                              if (quantity == 1) {
                                final remove = await showDeleteConfirmation(
                                  context,
                                  item.name ?? '',
                                );

                                if (remove == true) {
                                  cart.removeItem(
                                    context,
                                    item.id,
                                    item.flavorName,
                                  );
                                }
                              } else {
                                cart.removeItem(
                                  context,
                                  item.id,
                                  item.flavorName,
                                );
                              }

                              bounceController?.forward().then((_) {
                                bounceController?.reverse();
                              });
                            },
                          ),
                          SizedBox(width: isDesktop ? 0.8.w : 1.5.w),
                          AnimatedBuilder(
                            animation:
                                bounceAnimation ??
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
                          SizedBox(width: isDesktop ? 0.8.w : 1.5.w),
                          _qtyBtn(
                            icon: Icons.add,
                            onTap: () {
                              cart.addItem(context, item);

                              bounceController?.forward().then((_) {
                                bounceController?.reverse();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: isDesktop ? 1.w : 2.w),

                  /// TOTAL
                  Column(
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          color: newLightGreyColor,
                          fontSize: fontSize12,
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(height: .5.h),
                      Text(
                        "₹${((item.price! + (item.flavorPrice ?? 0)) * item.quantity).toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: fontSize15,
                          fontFamily: "Caveat",
                          color: gPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: isDesktop ? 1.w : 2.w),
                  HoverButton(
                    icon: Icons.delete_outline,
                    onTap: () async {
                      final remove = await showDeleteConfirmation(
                        context,
                        item.name ?? '',
                      );

                      if (remove == true) {
                        cart.removeProductCompletely(item.id, item.flavorName);

                        bounceController?.forward().then((_) {
                          bounceController?.reverse();
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return HoverButton(icon: icon, onTap: onTap);
  }

  Future<bool?> showDeleteConfirmation(
    BuildContext context,
    String productName,
  ) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Remove Item",
      barrierColor: Colors.black.withAlpha(45),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        final dialog = Material(
          color: Colors.transparent,
          child: Container(
            width: isDesktop ? 550 : double.infinity,
            margin: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black26,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red.shade50, Colors.red.shade100],
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: gPrimaryColor,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "Remove from Cart?",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: fontBold,
                      color: gPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: fontBold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This item will be removed from your cart.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          text: "Keep",
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          isLoading: false,
                          borderClr: borderColor,
                          color: gWhiteColor,
                          textColor: gBlackColor,
                          radius: 8,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ButtonWidget(
                          text: "Remove",
                          icon: Icons.delete_outline,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          isLoading: false,
                          radius: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        if (isDesktop) {
          return Center(child: dialog);
        }

        return SafeArea(
          child: Align(alignment: Alignment.bottomCenter, child: dialog),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        if (!isDesktop) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          );
        }

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: .85, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
