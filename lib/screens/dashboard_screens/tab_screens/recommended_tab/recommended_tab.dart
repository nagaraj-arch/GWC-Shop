import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/providers/products_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../widgets/common_cart_button.dart';

class RecommendedTab extends StatefulWidget {
  const RecommendedTab({super.key});

  @override
  State<RecommendedTab> createState() => _RecommendedTabState();
}

class _RecommendedTabState extends State<RecommendedTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;

    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        final products = provider.popularProducts;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 12
                : isTablet
                ? 18
                : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ============================================================
              // BANNER
              // ============================================================

              _buildBanner(
                context,
                isMobile: isMobile,
                isTablet: isTablet,
              ),

              SizedBox(height: isMobile ? 16 : 22),

              // ============================================================
              // HEADER
              // ============================================================

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildSectionHeader(
                    context,
                    isMobile: isMobile,
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // ============================================================
              // PRODUCTS
              // ============================================================

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildProducts(
                    context,
                    products,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
              ),

              const SizedBox(height: 35),
            ],
          ),
        );
      },
    );
  }

  // ========================================================================
  // BANNER
  // ========================================================================

  Widget _buildBanner(
      BuildContext context, {
        required bool isMobile,
        required bool isTablet,
      }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        child: Image.asset(
          isMobile
              ? "assets/images/recommended_mobile.png"
              : "assets/images/recommended_banner.png",
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // ========================================================================
  // SECTION HEADER
  // ========================================================================

  Widget _buildSectionHeader(
      BuildContext context, {
        required bool isMobile,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isMobile ? 28 : 30,
                    height: isMobile ? 28 : 30,
                    decoration: BoxDecoration(
                      color: gPrimaryColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: isMobile ? 15 : 16,
                      color: gPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    "Picked for you",
                    style: TextStyle(
                      fontFamily: "Avenir",
                      fontSize: isMobile ? 17 : 21,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff18212B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.only(left: 39),
                child: Text(
                  "Products selected based on your preferences",
                  style: TextStyle(
                    fontFamily: "Avenir",
                    fontSize: isMobile ? 9 : 11,
                    color: const Color(0xff7B7B7B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========================================================================
  // RESPONSIVE PRODUCT SECTION
  //
  // IMPORTANT:
  // Using Wrap instead of GridView removes the forced tile height.
  // Each card gets its natural height -> no huge blank space below button.
  // ========================================================================

  Widget _buildProducts(
      BuildContext context,
      List products, {
        required bool isMobile,
        required bool isTablet,
      }) {
    if (products.isEmpty) {
      return _emptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        int crossAxisCount;

        if (availableWidth < 600) {
          // Phones
          crossAxisCount = 2;
        } else if (availableWidth < 1000) {
          // Tablets / small laptops
          crossAxisCount = 3;
        } else {
          // Desktop
          crossAxisCount = 4;
        }

        const double gapDesktop = 16;
        const double gapMobile = 10;

        final gap = crossAxisCount == 2
            ? gapMobile
            : gapDesktop;

        final totalGap =
            gap * (crossAxisCount - 1);

        final cardWidth =
            (availableWidth - totalGap) /
                crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: isMobile ? 12 : 18,
          children: List.generate(
            products.length,
                (index) {
              final product = products[index];

              return SizedBox(
                width: cardWidth,
                child: _AnimatedRecommendedProductCard(
                  key: ValueKey(
                    product.productTitle ?? index,
                  ),
                  product: product,
                  index: index,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ========================================================================
  // EMPTY STATE
  // ========================================================================

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 65,
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: gPrimaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_outlined,
              size: 32,
              color: gPrimaryColor.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Recommendations are coming soon",
            style: TextStyle(
              fontFamily: "Avenir",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "We're finding something special for you.",
            style: TextStyle(
              fontFamily: "Avenir",
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// RECOMMENDED PRODUCT CARD
// ============================================================================

class _AnimatedRecommendedProductCard extends StatefulWidget {
  final dynamic product;
  final int index;

  const _AnimatedRecommendedProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  State<_AnimatedRecommendedProductCard> createState() =>
      _AnimatedRecommendedProductCardState();
}

class _AnimatedRecommendedProductCardState
    extends State<_AnimatedRecommendedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 450 + (widget.index * 70),
      ),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(
      Duration(
        milliseconds: widget.index * 70,
      ),
          () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        // ================================================================
        // RESPONSIVE SIZING
        // ================================================================

        final bool smallMobile = cardWidth < 170;
        final bool mobile = cardWidth < 220;

        final double imageHeight = smallMobile
            ? cardWidth * 0.90
            : mobile
            ? cardWidth * 0.88
            : cardWidth * 0.72;

        final double horizontalPadding = smallMobile
            ? 8
            : mobile
            ? 9
            : 10;

        final double titleSize = smallMobile
            ? 10
            : mobile
            ? 11
            : 12;

        final double priceSize = smallMobile
            ? 12
            : mobile
            ? 13
            : 14;

        final double infoSize = smallMobile
            ? 7
            : mobile
            ? 7.5
            : 8;

        final double buttonHeight = smallMobile
            ? 34
            : mobile
            ? 36
            : 38;

        final title =
        product.productTitle?.toString().trim().isNotEmpty == true
            ? product.productTitle.toString()
            : "Product";

        final price =
        product.discountPrice?.toString().trim().isNotEmpty == true
            ? product.discountPrice.toString()
            : "0";

        final tag =
            product.productSpecialTag?.toString().trim() ?? "";

        final recommendation = _recommendationText(
          title,
          tag,
          widget.index,
        );

        final quantity = _productQuantity(product);
        final servings = _productServings(product);

        return FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: MouseRegion(
              onEnter: (_) {
                if (!mounted) return;

                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                if (!mounted) return;

                setState(() {
                  isHovered = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 220,
                ),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()
                  ..translate(
                    0.0,
                    isHovered ? -5.0 : 0.0,
                  ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    mobile ? 13 : 16,
                  ),
                  border: Border.all(
                    color: isHovered
                        ? gPrimaryColor.withValues(
                      alpha: 0.28,
                    )
                        : const Color(0xffE9E9E9),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isHovered ? 0.12 : 0.045,
                      ),
                      blurRadius: isHovered ? 20 : 9,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // =====================================================
                    // PRODUCT IMAGE
                    // =====================================================

                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedScale(
                            scale: isHovered ? 1.035 : 1.0,
                            duration: const Duration(
                              milliseconds: 350,
                            ),
                            curve: Curves.easeOut,
                            child: Container(
                              color: const Color(0xffF8F3E9),
                              child: _productImage(product),
                            ),
                          ),

                          // =================================================
                          // RECOMMENDATION BADGE
                          // =================================================

                          Positioned(
                            top: mobile ? 6 : 8,
                            left: mobile ? 6 : 8,
                            right: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _buildRecommendationBadge(
                                recommendation,
                                fontSize: smallMobile
                                    ? 6.5
                                    : mobile
                                    ? 7
                                    : 7.5,
                              ),
                            ),
                          ),

                          // =================================================
                          // WISHLIST
                          // =================================================

                          Positioned(
                            top: mobile ? 6 : 8,
                            right: mobile ? 6 : 8,
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              width: mobile ? 27 : 30,
                              height: mobile ? 27 : 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.94,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.07,
                                    ),
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_border_rounded,
                                size: mobile ? 14 : 16,
                                color: isHovered
                                    ? gPrimaryColor
                                    : const Color(0xff777777),
                              ),
                            ),
                          ),

                          // =================================================
                          // IMAGE BOTTOM SHADOW
                          // =================================================

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 30,
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =====================================================
                    // PRODUCT CONTENT
                    // =====================================================

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        9,
                        horizontalPadding,
                        // IMPORTANT:
                        // small bottom padding prevents unnecessary space
                        // after the cart button.
                        10,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // =================================================
                          // PRODUCT NAME
                          // =================================================

                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Avenir",
                              fontSize: titleSize,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff20252B),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // =================================================
                          // PRICE + META
                          // =================================================

                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Text(
                                "₹$price",
                                style: TextStyle(
                                  fontFamily: "Avenir",
                                  fontSize: priceSize,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xffD91B12),
                                ),
                              ),

                              const SizedBox(width: 7),

                              Expanded(
                                child: Text(
                                  _buildProductMeta(
                                    quantity,
                                    servings,
                                  ),
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Avenir",
                                    fontSize: infoSize,
                                    color:
                                    const Color(0xff777777),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          // =================================================
                          // DIVIDER
                          // =================================================

                          Container(
                            height: 1,
                            color: const Color(0xffF0F0F0),
                          ),

                          const SizedBox(height: 7),

                          // =================================================
                          // WHY RECOMMENDED
                          // =================================================

                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: mobile ? 21 : 23,
                                height: mobile ? 21 : 23,
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xfffff3ef),
                                  borderRadius:
                                  BorderRadius.circular(7),
                                ),
                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: mobile ? 11 : 13,
                                  color:
                                  const Color(0xffE52218),
                                ),
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Why recommended",
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontSize: infoSize,
                                        fontWeight:
                                        FontWeight.w800,
                                        color:
                                        const Color(0xff303030),
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      _whyRecommended(
                                        title,
                                        tag,
                                      ),
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontSize:
                                        infoSize - 0.2,
                                        height: 1.15,
                                        color:
                                        const Color(0xff777777),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          // =================================================
                          // PERSONALIZED MATCH
                          // =================================================

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: mobile ? 6 : 7,
                              vertical: mobile ? 5 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF7FAF5),
                              borderRadius:
                              BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                const Color(0xffE5EDE2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .check_circle_outline_rounded,
                                  size: mobile ? 11 : 13,
                                  color: gPrimaryColor,
                                ),

                                const SizedBox(width: 5),

                                Expanded(
                                  child: Text(
                                    "Fits your personalised recommendations",
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "Avenir",
                                      fontSize:
                                      infoSize - 0.1,
                                      fontWeight:
                                      FontWeight.w600,
                                      color:
                                      const Color(0xff536052),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =================================================
                          // ADD TO CART
                          // =================================================

                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: CommonCartButton(
                              product: widget.product,
                              color: gPrimaryColor,
                              height: buttonHeight,
                            ),
                          ),

                          // Small controlled bottom spacing.
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ========================================================================
  // PRODUCT META
  // ========================================================================

  String _productQuantity(dynamic product) {
    final qty = product.itemQty?.toString() ?? "";
    final unit = product.weightType?.unit?.toString() ?? "";

    if (qty.isEmpty || qty == "null") {
      return "";
    }

    return "$qty$unit";
  }

  String _productServings(dynamic product) {
    final servings = product.servings?.toString() ?? "";

    if (servings.isEmpty || servings == "null") {
      return "";
    }

    return "$servings Servings";
  }

  String _buildProductMeta(
      String quantity,
      String servings,
      ) {
    final values = <String>[];

    if (quantity.isNotEmpty) {
      values.add(quantity);
    }

    if (servings.isNotEmpty) {
      values.add(servings);
    }

    if (values.isEmpty) {
      return "";
    }

    return values.join(" • ");
  }

  // ========================================================================
  // RECOMMENDATION BADGE
  // ========================================================================

  Widget _buildRecommendationBadge(
      String text, {
        required double fontSize,
      }) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 145,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gPrimaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: fontSize + 2,
            color: gPrimaryColor,
          ),

          const SizedBox(width: 4),

          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "Avenir",
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xffD91B12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================================
  // RECOMMENDATION TEXT
  // ========================================================================

  String _recommendationText(
      String title,
      String tag,
      int index,
      ) {
    if (tag.isNotEmpty) {
      return tag;
    }

    switch (index % 4) {
      case 0:
        return "Digestive";
      case 1:
        return "Fibre-Rich";
      case 2:
        return "Strengthening";
      default:
        return "Cooling";
    }
  }

  String _whyRecommended(
      String title,
      String tag,
      ) {
    if (tag.isNotEmpty) {
      return tag;
    }

    return "Matches your wellness preferences";
  }

  // ========================================================================
  // PRODUCT IMAGE
  // ========================================================================

  Widget _productImage(dynamic product) {
    final List<String> images =
    product.productThumbnailsUrls is List
        ? List<String>.from(
      product.productThumbnailsUrls ?? [],
    )
        : [];

    final imageUrl =
    images.isNotEmpty ? images.first : "";

    if (imageUrl.isEmpty) {
      return Container(
        color: const Color(0xffF7F2E9),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 30,
        ),
      );
    }

    return ThumbnailView(
      context: context,
      imageUrl: imageUrl,
      enablePreview: false,
      borderRadius: 0,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}