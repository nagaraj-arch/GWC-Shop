import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/responsive_helper.dart';
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
  late final PageController _singleController;
  late final PageController _multiController;

  static const double _horizontalMargin = 8.0;
  static const double _verticalPadding = 20.0;
  static const double _cardWidth = 460.0;
  static const double _cardHeight = 260.0;

  @override
  void initState() {
    super.initState();
    _singleController = PageController();
    _multiController = PageController(viewportFraction: 0.5);
  }

  @override
  void dispose() {
    _singleController.dispose();
    _multiController.dispose();
    super.dispose();
  }

  void _prevPage(PageController controller, int count, {int step = 1}) {
    if (count == 0 || !controller.hasClients) return;
    final current = (controller.page ?? 0).round();
    final prev = (current - step + count) % count;
    controller.animateToPage(
      prev,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage(PageController controller, int count, {int step = 1}) {
    if (count == 0 || !controller.hasClients) return;
    final current = (controller.page ?? 0).round();
    final next = (current + step) % count;
    controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  double _arrowSize(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    return responsive.isMobile ? 22.0 : 32.0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final category = provider.categories;
    final responsive = ScreenSizeHelper(context);

    if (category.isEmpty) {
      return const SizedBox.shrink();
    }

    final arrowSize = _arrowSize(context);
    final isMultiTwoCards = widget.mode == SliderMode.multi && !responsive.isMobile;

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          _ArrowButton(
            image: "assets/images/slider_left_arrow.png",
            size: arrowSize,
            onTap: () {
              if (widget.mode == SliderMode.single) {
                _prevPage(_singleController, category.length);
              } else {
                _prevPage(
                  _multiController,
                  category.length,
                  step: isMultiTwoCards ? 2 : 1,
                );
              }
            },
          ),
          Expanded(
            child: widget.mode == SliderMode.single
                ? _buildSingleMode(category)
                : _buildMultiMode(category),
          ),
          _ArrowButton(
            image: "assets/images/slider_right_arrow.png",
            size: arrowSize,
            onTap: () {
              if (widget.mode == SliderMode.single) {
                _nextPage(_singleController, category.length);
              } else {
                _nextPage(
                  _multiController,
                  category.length,
                  step: isMultiTwoCards ? 2 : 1,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSingleMode(List<dynamic> category) {
    return PageView.builder(
      controller: _singleController,
      itemCount: category.length,
      padEnds: false,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: _verticalPadding,
              horizontal: 20,
            ),
            child: CategoryCard(
              item: category[index],
              width: _cardWidth,
              height: _cardHeight,
              margin: EdgeInsets.zero,
              showShadow: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMultiMode(List<dynamic> category) {
    return PageView.builder(
      controller: _multiController,
      itemCount: category.length,
      padEnds: false,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalMargin,
            vertical: _verticalPadding,
          ),
          child: Center(
            child: CategoryCard(
              item: category[index],
              width: _cardWidth,
              height: _cardHeight,
              margin: EdgeInsets.zero,
              showShadow: true,
            ),
          ),
        );
      },
    );
  }
}

class _ArrowButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String image;
  final double size;

  const _ArrowButton({
    this.onTap,
    required this.image,
    this.size = 32,
  });

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Image.asset(widget.image, height: widget.size),
    );
  }
}