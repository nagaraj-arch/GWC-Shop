import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/get_additional_products_model/get_additional_products_model.dart';
import '../../../controllers/models/get_additional_products_model/product_flavors_model.dart';
import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/products_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../widgets/loading_widgets/loading_indicator.dart';
import 'price_widget.dart';
import 'servings_badge.dart';

class FlavorSelectionDialog extends StatefulWidget {
  final Products product;
  final Function(List<Flavours>)? onConfirm;

  final List<String> selectedFlavorNames;

  const FlavorSelectionDialog({
    super.key,
    required this.product,
    this.onConfirm,
    this.selectedFlavorNames = const [],
  });

  @override
  State<FlavorSelectionDialog> createState() => _FlavorSelectionDialogState();
}

class _FlavorSelectionDialogState extends State<FlavorSelectionDialog> {
  late List<Flavours> flavors;
  bool noFlavorSelected = false;
  final Set<int> selectedFlavorIds = {};
  final Set<int> hoveredIds = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProductsProvider>(
        context,
        listen: false,
      );

      await provider.fetchProductFlavors(
        widget.product.productId ?? 0,
      );

      if (widget.selectedFlavorNames.contains("No Flavour")) {
        noFlavorSelected = true;
      } else {
        for (final f in provider.flavours ?? []) {
          if (widget.selectedFlavorNames.contains(f.finalProductName)) {
            selectedFlavorIds.add(f.id ?? 0);
          }
        }
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Flavours> get selectedFlavors {
    final provider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );

    return provider.flavours
            ?.where((e) => selectedFlavorIds.contains(e.id))
            .toList() ??
        [];
  }

  double get basePrice =>
      double.tryParse(widget.product.discountPrice.toString()) ?? 0;

  double get total {
    if (noFlavorSelected) {
      return basePrice;
    }

    double value = 0;

    for (final f in selectedFlavors) {
      value += basePrice + (double.tryParse(f.discountedPrice ?? "0") ?? 0);
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isDesktop ? 52.w : double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            ///================ HEADER ================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(bottom: BorderSide(color: borderColor))),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ThumbnailView(
                      context: context,
                      imageUrl: widget.product.productThumbnails?.first,
                      fileName: widget.product.productTitle,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isDesktop
                            ? Row(
                                children: [
                                  Text(
                                    "Customize ${widget.product.productTitle}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: gPrimaryColor,
                                      fontFamily: fontBold,
                                      fontSize: fontSize13,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ItemInfoBadge(
                                    orderQuantity:
                                        "${widget.product.itemQty}${widget.product.weightType?.unit}",
                                    orderServings: widget.product.servings,
                                  ),
                                  SizedBox(width: 1.w),
                                  ItemInfoBadge(
                                    orderQuantity:
                                        "₹${double.parse(widget.product.discountPrice ?? '').toStringAsFixed(0)}",
                                    borderClr: const Color(0xff77D4A5),
                                    backgroundClr: const Color(0xffEEFDF4),
                                    textClr: Colors.green,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customize ${widget.product.productTitle}",
                                    style: TextStyle(
                                      color: gPrimaryColor,
                                      fontFamily: fontBold,
                                      fontSize: fontSize13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      ItemInfoBadge(
                                        orderQuantity:
                                            "${widget.product.itemQty}${widget.product.weightType?.unit}",
                                        orderServings: widget.product.servings,
                                      ),
                                      SizedBox(width: 1.w),
                                      ItemInfoBadge(
                                        orderQuantity:
                                            "₹${double.parse(widget.product.discountPrice ?? '').toStringAsFixed(0)}",
                                        borderClr: const Color(0xff77D4A5),
                                        backgroundClr: const Color(0xffEEFDF4),
                                        textClr: Colors.green,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        const SizedBox(height: 5),
                        Text(
                          "Choose the bio-active spice density suited to your body",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: fontSize10,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.brown.shade100,
                        ),
                      ),
                      child: Icon(Icons.close, size: 2.5.h),
                    ),
                  ),
                ],
              ),
            ),

            ///=============== BODY ==================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2.w, top: 2.h),
                    child: Text(
                      "SELECT THERAPEUTIC RECIPE VARIANT",
                      style: TextStyle(
                        fontFamily: fontMedium,
                        color: gPrimaryColor,
                        fontSize: fontSize10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<ProductsProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading(LoadingType.productFlavors)) {
                          return const Center(child: LoadingIndicator());
                        }

                        if ((provider.flavours ?? []).isEmpty) {
                          return const Center(
                              child: Text("No Flavors Available"));
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 2.h),
                          itemCount: provider.flavours!.length + 1,
                          itemBuilder: (_, index) {
                            if (index == 0) {
                              return buildNoFlavorCard();
                            }

                            return buildFlavorCard(
                                provider.flavours![index - 1]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            ///================ FOOTER ================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: const Color(0xffFFF8F0),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(24)),
                  border: Border(top: BorderSide(color: borderColor))),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(
                          color: gHintTextColor,
                          fontSize: fontSize07,
                          fontFamily: fontMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹${total.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: gPrimaryColor,
                          fontSize: fontSize13,
                          fontFamily: fontBold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ButtonWidget(
                    icon: Icons.shopping_bag_outlined,
                    text: "Confirm and Add",
                    color: gPrimaryColor,
                    radius: 8,
                    isLoading: false,
                    onPressed: () {
                      if (!noFlavorSelected && selectedFlavors.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a flavour"),
                          ),
                        );
                        return;
                      }

                      if (noFlavorSelected) {
                        widget.onConfirm?.call([
                          Flavours(
                            id: -1,
                            flavourName: "No Flavour",
                            finalProductName: "No Flavour",
                            discountedPrice: "0",
                            actualPrice: "0",
                          ),
                        ]);
                      } else {
                        widget.onConfirm?.call(selectedFlavors);
                      }

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool hasValue(String? value) {
    return value != null &&
        value.trim().isNotEmpty &&
        value.trim().toLowerCase() != "null";
  }

  Widget buildNoFlavorCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          noFlavorSelected = true;
          selectedFlavorIds.clear();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: noFlavorSelected
              ? const Color(0xffEEFDF4)
              : const Color(0xffFCFCFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: noFlavorSelected
                ? const Color(0xff77D4A5)
                : const Color(0xffE6DDD2),
            width: noFlavorSelected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 40,
                height: 40,
                child: ThumbnailView(
                  context: context,
                  imageUrl: widget.product.productThumbnails?.first,
                  fileName: widget.product.productTitle,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Flavour",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: gPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Continue with the original product.",
                    style: TextStyle(
                      color: newLightGreyColor,
                      fontSize: fontSize10,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Original Recipe",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontFamily: fontBold,
                        fontSize: fontSize08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: noFlavorSelected ? Colors.brown : Colors.white,

                border: Border.all(
                  color: noFlavorSelected ? Colors.brown : Colors.grey,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 2.h,
                color: noFlavorSelected ? Colors.white : Colors.transparent,

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFlavorCard(Flavours flavor) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredIds.add(flavor.id ?? 0);
        });
      },
      onExit: (_) {
        setState(() {
          hoveredIds.remove(flavor.id ?? 0);
        });
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          setState(() {
            noFlavorSelected = false;

            if (selectedFlavorIds.contains(flavor.id)) {
              selectedFlavorIds.remove(flavor.id);
            } else {
              selectedFlavorIds.add(flavor.id ?? 0);
            }
          });
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: hoveredIds.contains(flavor.id) ? 1.015 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selectedFlavorIds.contains(flavor.id)
                  ? const Color(0xffEEFDF4)
                  : hoveredIds.contains(flavor.id)
                      ? const Color(0xffFCFBF8)
                      : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selectedFlavorIds.contains(flavor.id)
                    ? const Color(0xff77D4A5)
                    : hoveredIds.contains(flavor.id)
                        ? gPrimaryColor.withAlpha(50)
                        : const Color(0xffE6DDD2),
                width: selectedFlavorIds.contains(flavor.id) ? 2 : 1.2,
              ),
              boxShadow: hoveredIds.contains(flavor.id)
                  ? [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Left Icon
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: ThumbnailView(
                      context: context,
                      imageUrl: flavor.thumbnail,
                      fileName: flavor.flavourName,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              flavor.finalProductName ?? '',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: gPrimaryColor,
                              ),
                            ),
                          ),
                          if (hasValue(flavor.flavourName))
                            Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: gPrimaryColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                flavor.flavourName!,
                                style: TextStyle(
                                  color: gPrimaryColor,
                                  fontSize: fontSize08,
                                  fontFamily: fontBold,
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedFlavorIds.contains(flavor.id)
                                  ? Colors.brown
                                  : Colors.white,
                              border: Border.all(
                                color: selectedFlavorIds.contains(flavor.id)
                                    ? Colors.brown
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 2.h,
                              color: selectedFlavorIds.contains(flavor.id)
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ),

                      /// Description
                      if (hasValue(flavor.description))
                        Padding(
                          padding: EdgeInsets.only(top: .2.h),
                          child: Row(
                            children: [
                              Text(
                                "${flavor.description}  ",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: fontSize10,
                                  height: 1.5,
                                ),
                              ),
                              if (hasValue(flavor.productTag))
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFFF7F3),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xffE8CFC4),
                                    ),
                                  ),
                                  child: Text(
                                    flavor.productTag!,
                                    style: TextStyle(
                                      fontSize: fontSize07,
                                      color: Colors.brown,
                                      fontFamily: fontBold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      SizedBox(height: 0.5.h),

                      /// Price
                      Row(
                        children: [
                          Text(
                            "Flavor Price",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: fontSize09,
                            ),
                          ),
                          const Spacer(),
                          CommonPriceWidget(
                            actualPrice: flavor.actualPrice,
                            discountPrice: flavor.discountedPrice,
                            showLabel: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
