import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/container_widgets/common_card.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import 'product_details_dialog.dart';

class PopularProductsShowcase extends StatefulWidget {
  final List<Products> products;

  const PopularProductsShowcase({
    super.key,
    required this.products,
  });

  @override
  State<PopularProductsShowcase> createState() =>
      _PopularProductsShowcaseState();
}

class _PopularProductsShowcaseState extends State<PopularProductsShowcase> {
  final CarouselSliderController controller = CarouselSliderController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    // final bool isDesktop = responsive.isDesktop;
    final bool isTablet = responsive.isTablet;

    double viewport = .34;

    if (isTablet) {
      viewport = .45;
    }

    if (responsive.isMobile) {
      viewport = .82;
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 2.w),
      child: responsive.isMobile
          ? _mobileView(viewport)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// LEFT CONTENT
                Expanded(
                  flex: 3,
                  child: _leftContent(),
                ),

                SizedBox(width: 2.w),

                /// LEFT ARROW
                _arrowButton(
                  icon: Icons.arrow_back,
                  onTap: () => controller.previousPage(),
                ),

                /// PRODUCTS
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 1.w),
                    child: CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: widget.products.length,
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: viewport,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (_, index, realIndex) {
                        return PopularProductCard(item: widget.products[index]);
                      },
                    ),
                  ),
                ),

                /// RIGHT ARROW
                _arrowButton(
                  icon: Icons.arrow_forward,
                  onTap: () => controller.nextPage(),
                ),
              ],
            ),
    );
  }

  Widget _mobileView(double viewport) {
    return Column(
      children: [
        _leftContent(),
        SizedBox(height: 3.h),
        CarouselSlider.builder(
          carouselController: controller,
          itemCount: widget.products.length,
          options: CarouselOptions(
            height: 380,
            viewportFraction: viewport,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          itemBuilder: (_, index, realIndex) {
            return PopularProductCard(item: widget.products[index]);
          },
        ),
      ],
    );
  }

  Widget _leftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "We make\nreal food.",
          style: TextStyle(
            fontFamily: fontBold,
            fontSize: 42.dp,
            height: .95,
            color: const Color(0xff141B2D),
          ),
        ),
        SizedBox(height: 3.h),
        Container(
          width: 18.w,
          height: 4,
          color: gPrimaryColor,
        ),
        SizedBox(height: 2.h),
        Text(
          "Food so clean, we declare each and every ingredient, proudly, upfront.",
          style: TextStyle(
            fontFamily: fontMedium,
            fontSize: fontSize13,
            height: 1.8,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: gPrimaryColor, width: 2),
        ),
        child: Icon(icon, color: gPrimaryColor),
      ),
    );
  }
}

class PopularProductCard extends StatefulWidget {
  final Products item;

  const PopularProductCard({super.key, required this.item});

  @override
  State<PopularProductCard> createState() => _PopularProductCardState();
}

class _PopularProductCardState extends State<PopularProductCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    // final responsive = ResponsiveHelper(context);
    // final bool isDesktop = responsive.isDesktop;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return ProductDetailsDialog(item: widget.item);
            },
          );
        },
        child: SizedBox(
          height: 380,
          child: CommonCard(
            elevation: 9,
            margin: EdgeInsets.only(
                top: hovered ? 0 : 14,
                bottom: hovered ? 14 : 10,
                right: 10,
                left: 10),
            padding: EdgeInsets.zero,
            backgroundColor: gBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  /// IMAGE
                  Expanded(
                    flex: 7,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 350),
                      scale: hovered ? 1.08 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: ThumbnailView(
                          context: context,
                          imageUrl: widget.item.productThumbnailsUrls?.first,
                          fit: BoxFit.contain,
                          enablePreview: false,
                        ),
                      ),
                    ),
                  ),

                  /// FOOTER
                  Expanded(
                    flex: 3,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: hovered
                              ? [
                                  gPrimaryColor,
                                  const Color(0xff8B0010),
                                ]
                              : [
                                  const Color(0xffFF6A62),
                                  const Color(0xffFF5C64),
                                ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.productTitle ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: fontSize14,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    color: gWhiteColor,
                                  ),
                                ),
                                Text(
                                  widget.item.productDescription ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: gWhiteColor,
                                    fontSize: fontSize10,
                                    fontFamily: fontBook,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 1.w),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white24, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
