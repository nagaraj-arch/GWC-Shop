import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../banner/banner_indicator.dart';
import 'banner_arrow.dart';

class FoodPharmacyBanner extends StatefulWidget {
  final List<Products> products;
  final Function(Products product)? onTap;

  const FoodPharmacyBanner({super.key, required this.products, this.onTap});

  @override
  State<FoodPharmacyBanner> createState() => _FoodPharmacyBannerState();
}

class _FoodPharmacyBannerState extends State<FoodPharmacyBanner> {
  final PageController _pageController = PageController(viewportFraction: 1);
  Timer? _timer;

  int currentIndex = 0;

  List<String> banners = [
    "https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/banner1.png",
    "https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/banner2.png",
    "https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/banner3.png",
    // "https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/banner4.png",
    // "https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/banner5.png",
    // "https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/banner6.png",
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlider();
    });
  }

  void _startAutoSlider() {
    if (banners.length <= 1) return;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!_pageController.hasClients) return;

        currentIndex++;

        if (currentIndex >= banners.length) {
          currentIndex = 0;
        }

        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void next() {
    final next = (currentIndex + 1) % banners.length;

    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void previous() {
    final previous = (currentIndex - 1 + banners.length) % banners.length;

    _pageController.animateToPage(
      previous,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    if (banners.isEmpty) {
      return const SizedBox();
    }

    return Container(
      height: isDesktop ? 60.h : 30.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            padEnds: false,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });

              _timer?.cancel();
              _startAutoSlider();
            },
            itemBuilder: (context, index) {
              final product = banners[index];
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1450 : double.infinity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 20 : 0,
                      vertical: isDesktop ? 16 : 0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(35),
                              blurRadius: 8,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: ThumbnailView(
                            context: context,
                            imageUrl: product,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          /// LEFT ARROW
          Positioned(
            left: 4.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: BannerArrow(
                isLeft: true,
                onTap: previous,
              ),
            ),
          ),

          /// RIGHT ARROW
          Positioned(
            right: 4.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: BannerArrow(
                isLeft: false,
                onTap: next,
              ),
            ),
          ),

          /// INDICATOR
          Positioned(
            bottom: 5.h,
            left: 0,
            right: 0,
            child: Center(
              child: BannerIndicator(
                controller: _pageController,
                count: banners.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
