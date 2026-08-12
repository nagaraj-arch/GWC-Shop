import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../../controllers/providers/shop_provider.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../../widgets/animated_cart_quantity.dart';

class GutClockVerticalSlider extends StatefulWidget {
  final String categoryName;
  final List<Products> products; // ✅ Added products list
  const GutClockVerticalSlider({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  State<GutClockVerticalSlider> createState() => _GutClockVerticalSliderState();
}

class _GutClockVerticalSliderState extends State<GutClockVerticalSlider> {
  late final PageController _controller;
  int current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.5,
      initialPage: 0,
      keepPage: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ShopProvider>().selectTimelineCategory(widget.categoryName);
    });
  }

  @override
  void didUpdateWidget(covariant GutClockVerticalSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryName != widget.categoryName) {
      current = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_controller.hasClients) {
          _controller.jumpToPage(0);
        }
        context.read<ShopProvider>().selectTimelineCategory(
          widget.categoryName,
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (widget.products.isEmpty || !_controller.hasClients) return;
    current = (current + 1) % widget.products.length;
    _controller.animateToPage(
      current,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
    setState(() {});
  }

  void _previous() {
    if (widget.products.isEmpty || !_controller.hasClients) return;
    current = (current - 1 + widget.products.length) % widget.products.length;
    _controller.animateToPage(
      current,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.products; // ✅ Use passed products

    if (products.isEmpty) {
      return const SizedBox(
        height: 520,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 520,
      child: Column(
        children: [
          _arrowButton(icon: Icons.arrow_upward_rounded, onTap: _previous),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              padEnds: false,
              onPageChanged: (index) {
                setState(() => current = index);
              },
              itemBuilder: (_, index) {
                return GutClockVerticalProductCard(
                  item: products[index],
                );
              },
            ),
          ),
          _arrowButton(icon: Icons.arrow_downward_rounded, onTap: _next),
        ],
      ),
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: gPrimaryColor, width: 1.2),
          color: Colors.white,
        ),
        child: Icon(icon, size: 18, color: gPrimaryColor),
      ),
    );
  }
}

class GutClockVerticalProductCard extends StatefulWidget {
  final dynamic item; // ✅ Changed to dynamic
  final VoidCallback? onCartTap;

  const GutClockVerticalProductCard({
    super.key,
    required this.item,
    this.onCartTap,
  });

  @override
  State<GutClockVerticalProductCard> createState() =>
      _GutClockVerticalProductCardState();
}

class _GutClockVerticalProductCardState
    extends State<GutClockVerticalProductCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(hover ? 25 : 15),
              blurRadius: hover ? 18 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: ThumbnailView(
                      context: context,
                      imageUrl: widget.item.productThumbnailsUrls?.first ?? "",
                      fit: BoxFit.contain,
                      enablePreview: false,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: const BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.productTitle ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cormorantGaramond(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.dp,
                                ),
                              ),
                              Text(
                                "₹${widget.item.discountPrice}",
                                style: TextStyle(
                                  color: gWhiteColor,
                                  fontSize: fontSize09,
                                  fontFamily: fontMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                          AnimatedCartQuantity(item: widget.item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
