import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/get_additional_products_model/get_additional_products_model.dart';
import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../controllers/providers/products_providers.dart';
import '../../../../utils/responsive_helper.dart';
import 'banner_arrow.dart';
import 'banner_color_helper.dart';
import 'banner_item.dart';

class PopularProductBanner extends StatefulWidget {
  final List<Products> products;

  /// Called when user clicks the banner
  final Function(Products product)? onTap;

  const PopularProductBanner({
    super.key,
    required this.products,
    this.onTap,
  });

  @override
  State<PopularProductBanner> createState() =>
      _PopularProductBannerState();
}

class _PopularProductBannerState
    extends State<PopularProductBanner> {

  final PageController _pageController =
  PageController(viewportFraction: .95);

  Timer? _timer;

  int _currentIndex = 0;

  final Map<int, DominantGradient> _gradients = {};

  @override
  void initState() {
    super.initState();

    _loadGradients();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlider();
    });
  }

  Future<void> _loadGradients() async {
    for (int i = 0; i < widget.products.length; i++) {
      final product = widget.products[i];

      final gradient = await DominantColorHelper.getGradient(
        product.productThumbnailsUrls?.first ?? "",
      );

      _gradients[i] = gradient;
    }

    if (mounted) {
      context.read<ProductsProvider>().changeBannerColor(
        _gradients[0]!.primary,
      );
    }
  }

  void _startAutoSlider() {
    if (widget.products.length <= 1) return;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) {
        if (!_pageController.hasClients) return;

        _currentIndex++;

        if (_currentIndex >= widget.products.length) {
          _currentIndex = 0;
        }

        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void _next() {
    if (!_pageController.hasClients) return;

    final next = (_currentIndex + 1) % widget.products.length;

    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _previous() {
    if (!_pageController.hasClients) return;

    final previous =
        (_currentIndex - 1 + widget.products.length) %
            widget.products.length;

    _pageController.animateToPage(
      previous,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: isDesktop ? 40.h : 40.h,
      child: Stack(
        children: [

          /// PAGE VIEW
          PageView.builder(
            controller: _pageController,
            itemCount: widget.products.length,
            onPageChanged: (index) {

              setState(() {
                _currentIndex = index;
              });

              context.read<ProductsProvider>().changeBannerColor(
                _gradients[index]!.primary,
              );

              _timer?.cancel();
              _startAutoSlider();
            },
            itemBuilder: (context, index) {

              return AnimatedScale(
                duration: const Duration(milliseconds: 350),
                scale: index == _currentIndex ? 1 : .97,
                child: BannerItem(
                  product: widget.products[index],
                  onTap: () {
                    widget.onTap?.call(widget.products[index]);
                  },
                ),
              );
            },
          ),

          /// LEFT ARROW
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: BannerArrow(
                isLeft: true,
                onTap: _previous,
              ),
            ),
          ),

          /// RIGHT ARROW
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: BannerArrow(
                isLeft: false,
                onTap: _next,
              ),
            ),
          ),

          // /// PAGE INDICATOR
          // Positioned(
          //   bottom: 15,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: BannerIndicator(
          //       controller: _pageController,
          //       count: widget.products.length,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}