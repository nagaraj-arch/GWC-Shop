import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/container_widgets/common_card.dart';
import '../../../widgets/container_widgets/common_divider.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import 'item_quantity.dart';
import 'new_badge.dart';
import 'price_widget.dart';
import 'product_details_dialog.dart';
import 'rating_widget.dart';
import 'servings_badge.dart';
import 'video_popup.dart';

class ProductCard extends StatefulWidget {
  final Products item;

  const ProductCard({super.key, required this.item});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isHovered = false;

  late PageController pageController;

  int currentPage = 0;
  final int initialPage = 3000;

  Timer? hoverSlideTimer;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: initialPage);

    currentPage = 0;
  }

  void startHoverSlide() {
    if ((widget.item.productThumbnails?.length ?? 0) <= 1) return;

    hoverSlideTimer?.cancel();

    hoverSlideTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        if (!mounted || !pageController.hasClients) return;

        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void stopHoverSlide() {
    hoverSlideTimer?.cancel();
  }

  @override
  void dispose() {
    hoverSlideTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void nextImage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void previousImage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isVideo(String url) {
    final lower = url.toLowerCase();

    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.m4v') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.webm') ||
        lower.contains('.mp4?');
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final responsive = ResponsiveHelper(context);

    final thumbnails = item.productThumbnailsUrls ?? [];

    final imageHeight = responsive.isMobile
        ? 160.0
        : responsive.isTablet
            ? 190.0
            : 230.0;

    final productName = item.productTitle ?? '';

    final description =
        (widget.item.productDescription ?? '').replaceAll(RegExp(r'^\s+'), '');

    final boughtCount =
        int.tryParse(widget.item.boughtByUsersCount?.trim() ?? '0') ?? 0;

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);

        if (pageController.hasClients) {
          pageController.jumpToPage(initialPage);
        }

        startHoverSlide();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        stopHoverSlide();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: isHovered
            ? (Matrix4.identity()
              ..translate(0.0, -6.0)
              ..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered
                ? gPrimaryColor.withAlpha(50)
                : const Color(0xffD9CBB9),
          ),
          boxShadow: [
            BoxShadow(
              color: gBlackColor.withAlpha(isHovered ? 30 : 15),
              blurRadius: isHovered ? 18 : 8,
              offset: Offset(
                0,
                isHovered ? 8 : 3,
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            /// IMAGE
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value % thumbnails.length;
                      });
                    },
                    itemBuilder: (_, index) {
                      final imageIndex = index % thumbnails.length;

                      final mediaUrl = thumbnails[imageIndex];

                      final isMediaVideo = isVideo(mediaUrl);

                      return AnimatedScale(
                        scale: isHovered ? 1.08 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: isMediaVideo
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => VideoPopup(
                                      title: item.productTitle ?? '',
                                      videoUrl: mediaUrl,
                                    ),
                                  );
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ThumbnailView(
                                      context: context,
                                      imageUrl: item.productThumbnailsUrls?.first ?? '',
                                      fileName: item.productTitle ?? '',
                                      fit: BoxFit.contain,
                                      borderRadius: isHovered ? 2 : 12,
                                      enablePreview: false,
                                    ),
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: gWhiteColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 3.5.h,
                                          color: gPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ThumbnailView(
                                context: context,
                                imageUrl: mediaUrl,
                                fit: BoxFit.contain,
                                borderRadius: isHovered ? 2 : 12,
                              ),
                      );
                    },
                  ),

                  /// LEFT ARROW
                  if (isHovered)
                    Positioned(
                      left: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CommonCard(
                          elevation: 2,
                          backgroundColor: const Color(0xffFFF8F0),
                          borderClr: const Color(0xffE8DED1),
                          padding: const EdgeInsets.all(6),
                          margin: EdgeInsets.zero,
                          borderRadius: 50,
                          child: InkWell(
                            onTap: previousImage,
                            child: Icon(
                              Icons.chevron_left,
                              size: 2.5.h,
                            ),
                          ),
                        ),
                      ),
                    ),

                  /// RIGHT ARROW
                  if (isHovered)
                    Positioned(
                      right: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CommonCard(
                          elevation: 2,
                          backgroundColor: const Color(0xffFFF8F0),
                          borderClr: const Color(0xffE8DED1),
                          padding: const EdgeInsets.all(6),
                          margin: EdgeInsets.zero,
                          borderRadius: 50,
                          child: InkWell(
                            onTap: nextImage,
                            child: Icon(
                              Icons.chevron_right,
                              size: 2.5.h,
                            ),
                          ),
                        ),
                      ),
                    ),

                  /// TAG
                  Positioned(
                    left: 12,
                    top: 12,
                    child: CommonCard(
                      elevation: 2,
                      backgroundColor: const Color(0xffFFF8F0),
                      borderClr: const Color(0xffE8DED1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      margin: EdgeInsets.zero,
                      borderRadius: 6,
                      child: Text(
                        widget.item.productSpecialTag ?? '',
                        style: TextStyle(
                          color: gPrimaryColor,
                          fontSize: fontSize07,
                          fontFamily: fontBold,
                        ),
                      ),
                    ),
                  ),

                  if (widget.item.isNew == true)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: NewBadge(),
                    ),

                  if (widget.item.hasFlavours == "1")
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.95, end: 1),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeInOut,
                        builder: (_, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        onEnd: () {
                          if (mounted) setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xffFFB347),
                                Color(0xffFF7A18),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withAlpha(55),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 14,
                                color: gWhiteColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Multiple Flavors",
                                style: TextStyle(
                                  color: gWhiteColor,
                                  fontFamily: fontBold,
                                  fontSize: fontSize10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            if ((thumbnails.length) > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  thumbnails.length,
                  (index) {
                    final selected = currentPage == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: selected ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color:
                            selected ? gPrimaryColor : newLightGreyColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(responsive.isMobile ? 8 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Rating
                    CommonRatingWidget(
                      rating: widget.item.productRating,
                      userCount: widget.item.productUsersCount,
                    ),
                    SizedBox(height: .8.h),

                    /// Product Name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: fontSize16,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: gPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ItemInfoBadge(
                          orderQuantity:
                              "${widget.item.itemQty}${widget.item.weightType?.unit}",
                          orderServings: widget.item.servings,
                        ),
                      ],
                    ),

                    SizedBox(height: .5.h),

                    /// Description
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: gBlackColor,
                        fontSize: fontSize10,
                        fontFamily: fontBook,
                        height: 1.4,
                      ),
                    ),

                    if (boughtCount > 0) ...[
                      SizedBox(height: .5.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$boughtCount+ bought ",
                              style: TextStyle(
                                color: gBlackColor,
                                fontSize: fontSize10,
                                fontFamily: fontBold,
                                height: 1.4,
                              ),
                            ),
                            TextSpan(
                              text: 'in past month',
                              style: TextStyle(
                                color: gBlackColor,
                                fontSize: fontSize10,
                                fontFamily: fontBook,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Spacer(),
                    CommonDivider(),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CommonPriceWidget(
                                actualPrice: widget.item.actualPrice,
                                discountPrice: widget.item.discountPrice,
                                discountPercentage:
                                    widget.item.discountPercentage,
                              ),
                            ),
                            HoverButton(
                              icon: Icons.remove_red_eye_rounded,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) {
                                    return
                                        // const AmazonZoomExample();
                                        ProductDetailsDialog(item: widget.item);
                                  },
                                );
                              },
                            ),
                            SizedBox(width: .5.w),
                            ItemQuantity(item: widget.item),
                          ],
                        ),
                        Consumer<CartProvider>(
                          builder: (_, cartProvider, __) {
                            final flavors = cartProvider.items
                                .where((e) =>
                                    e.id == widget.item.productId &&
                                    (e.flavorName?.isNotEmpty ?? false))
                                .map((e) => e.flavorName!)
                                .toList();

                            if (flavors.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: EdgeInsets.only(top: .5.h),
                              child: Row(
                                children: [
                                  Text(
                                    "Selected Flavors : ",
                                    style: TextStyle(
                                      fontSize: fontSize09,
                                      color: gGreyColor,
                                      fontFamily: fontBook,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      flavors.join(", "),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: fontSize09,
                                        fontFamily: fontBold,
                                        color: gPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
