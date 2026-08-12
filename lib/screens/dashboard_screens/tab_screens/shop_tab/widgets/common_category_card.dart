import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../widgets/category_card.dart';

enum SliderMode { single, multi }

class CommonCategorySlider extends StatefulWidget {
  final SliderMode mode;
  final double height;

  const CommonCategorySlider({
    super.key,
    this.mode = SliderMode.single,
    this.height = 260,
  });

  @override
  State<CommonCategorySlider> createState() => _CommonCategorySliderState();
}

class _CommonCategorySliderState extends State<CommonCategorySlider> {
  final CarouselSliderController _carouselController =
  CarouselSliderController();

  void _previousPage() {
    _carouselController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    _carouselController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final categories = provider.categories;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Responsive arrow size
        final arrowSize = (availableWidth * 0.075).clamp(20.0, 32.0);

// Responsive gap
        final arrowGap = (availableWidth * 0.025).clamp(6.0, 14.0);

// Horizontal padding
        final horizontalPadding = (availableWidth * 0.02).clamp(8.0, 22.0);

        final arrowInnerPadding = (arrowSize * 0.20).clamp(5.0, 9.0);

        final arrowButtonWidth =
            arrowSize + (arrowInnerPadding * 2);

        final reservedWidth =
            (horizontalPadding * 2) +
                (arrowButtonWidth * 2) +
                (arrowGap * 2);

// Card width — slightly reduced
        final cardWidth = (availableWidth - reservedWidth - 12).clamp(
          160.0,
          430.0,
        );

        final cardHeight = (cardWidth * 0.82).clamp(
          165.0,
          290.0,
        );

        final carouselHeight = cardHeight + 10;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ArrowButton(
                image: "assets/images/slider_left_arrow.png",
                size: arrowSize,
                onTap: _previousPage,
              ),

              SizedBox(width: arrowGap),

              SizedBox(
                width: cardWidth,
                height: carouselHeight,
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: categories.length,
                  itemBuilder: (context, index, realIndex) {
                    return Center(
                      child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: CategoryCard(
                          item: categories[index],
                          width: cardWidth,
                          height: cardHeight,
                          margin: EdgeInsets.zero,
                          showShadow: true,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: carouselHeight,
                    viewportFraction: 1,
                    padEnds: true,
                    clipBehavior: Clip.hardEdge,
                    initialPage: 0,
                    enableInfiniteScroll: categories.length > 1,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),

              SizedBox(width: arrowGap),

              _ArrowButton(
                image: "assets/images/slider_right_arrow.png",
                size: arrowSize,
                onTap: _nextPage,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final double size;

  const _ArrowButton({
    required this.onTap,
    required this.image,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: Padding(
          padding: EdgeInsets.all(
            (size * 0.20).clamp(6.0, 12.0),
          ),
          child: Image.asset(
            image,
            height: size,
            width: size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
