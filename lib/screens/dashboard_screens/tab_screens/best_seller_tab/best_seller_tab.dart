import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/providers/products_providers.dart';
import '../../../../utils/constants.dart';
import '../../../category_page/category_product_card.dart';

class BestSellerTab extends StatefulWidget {
  const BestSellerTab({super.key});

  @override
  State<BestSellerTab> createState() => _BestSellerTabState();
}

class _BestSellerTabState extends State<BestSellerTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        final bestSellerProducts = provider.popularProducts;

        if (bestSellerProducts.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // ====================================================
                // SECTION HEADER
                // ====================================================
                // _buildSectionHeader(bestSellerProducts.length),
                //
                // const SizedBox(height: 20),

                // ====================================================
                // BEST SELLER PRODUCTS
                // ====================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AdditionalProductsGrid(
                    products: bestSellerProducts,
                    category: gPrimaryColor,
                    isShop: false,
                    mobileDesign: false,
                    showAllProducts: true,
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // SECTION HEADER
  // ================================================================

  Widget _buildSectionHeader(int productCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 28,
            decoration: BoxDecoration(
              color: gPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Best Sellers",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202823),
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Loved by thousands for everyday gut care",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 11,
                    color: Color(0xFF89938D),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F7F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 15,
                  color: gPrimaryColor,
                ),

                const SizedBox(width: 5),

                Text(
                  "$productCount products",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: gPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F7F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star_border_rounded,
                  size: 40,
                  color: gPrimaryColor,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "No best sellers yet",
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Popular products will appear here.",
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
