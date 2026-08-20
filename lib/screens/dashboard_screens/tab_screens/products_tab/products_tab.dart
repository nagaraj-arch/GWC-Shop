import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/providers/products_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/loading_widgets/loading_indicator.dart';
import '../../../category_page/category_product_card.dart';
import '../../../footer_widget/footer_section.dart';
import '../../../product_screens/widgets/category_tab.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({super.key});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ProductsProvider>();

      while (provider.isLoading(LoadingType.getAdditionalProducts)) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!mounted) return;

      // 🔥 Reset category + products to first category
      if (provider.additionalCategories.isNotEmpty) {
        provider.changeAdditionalCategory(provider.additionalCategories.first);
      }

      // Then create controller at first category
      _createTabController(provider);
    });
  }

  void _createTabController(ProductsProvider provider) {
    _tabController?.dispose();

    if (provider.additionalCategories.isEmpty) {
      return;
    }

    _tabController = TabController(
      length: provider.additionalCategories.length,
      vsync: this,
      initialIndex: 0,
    );

    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging &&
          _tabController!.index >= 0 &&
          _tabController!.index < provider.additionalCategories.length) {
        provider.changeAdditionalCategory(
          provider.additionalCategories[_tabController!.index],
        );
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final provider = context.watch<ProductsProvider>();
    return provider.isLoading(LoadingType.getAdditionalProducts)
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const Center(child: LoadingIndicator()),
          )
        : provider.searchController.text.isEmpty
        ? Column(
            children: [
              if (_tabController != null &&
                  _tabController!.length ==
                      provider.additionalCategories.length)
                CategoryTabs(
                  controller: _tabController!,
                  categories: provider.additionalCategories,
                  getCount: provider.getCategoryCount,
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.isMobile ? 20 : 100,
                          vertical: 20,
                        ),
                        child: AdditionalProductsGrid(
                          products: provider.filteredAdditionalProducts,
                          isShop: true,
                        ),
                      ),
                      GwcFooter(),
                    ],
                  ),

                  // productsSection(responsive, provider),
                ),
              ),
            ],
          )
        : Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.isMobile || responsive.isTablet
                      ? 20
                      : 80.0,
                ),
                child: AdditionalProductsGrid(
                  products: provider.filteredAdditionalProducts,
                  isShop: true,
                ),
              ),
              SizedBox(height: 40),
            ],
          );
  }

  // Widget productsSection(
  //   ScreenSizeHelper responsive,
  //   ProductsProvider provider,
  // ) {
  //   if (provider.filteredAdditionalProducts.isEmpty) {
  //     return emptyWidget(responsive);
  //   }
  //
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       final width = constraints.maxWidth;
  //
  //       int columns;
  //       if (width >= 1000) {
  //         columns = 3;
  //       } else if (width >= 650) {
  //         columns = 2;
  //       } else {
  //         columns = 1;
  //       }
  //
  //       const spacing = 20.0;
  //       final cardWidth = (width - ((columns - 1) * spacing)) / columns;
  //       final cardHeight = responsive.isMobile
  //           ? 360
  //           : responsive.isTablet
  //           ? 420
  //           : 450;
  //
  //       return GridView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: provider.filteredAdditionalProducts.length,
  //         padding: EdgeInsets.symmetric(
  //           vertical: 2.h,
  //           horizontal: responsive.isMobile ? 3.w : 2.w,
  //         ),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: columns,
  //           crossAxisSpacing: spacing,
  //           mainAxisSpacing: spacing,
  //           childAspectRatio: cardWidth / cardHeight,
  //         ),
  //         itemBuilder: (context, index) {
  //           final item = provider.filteredAdditionalProducts[index];
  //           return KeyedSubtree(
  //             key: ValueKey(
  //               '${provider.selectedAdditionalCategory}_${item.productId}',
  //             ),
  //             child: ProductCard(item: item),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // Widget emptyWidget(ScreenSizeHelper responsive) {
  //   return Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           Icons.inventory_2_outlined,
  //           size: responsive.isMobile ? 60 : 80,
  //           color: Colors.grey.shade400,
  //         ),
  //         SizedBox(height: 2.h),
  //         Text(
  //           'No Products Found',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: responsive.isMobile ? 16 : 18,
  //             fontWeight: FontWeight.w600,
  //             color: gPrimaryColor,
  //           ),
  //         ),
  //         SizedBox(height: 1.h),
  //         Text(
  //           'Products are not available for this category.',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: responsive.isMobile ? 12 : 14,
  //             color: Colors.grey,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _CategoryTabItem extends StatefulWidget {
  final TabController controller;
  final int index;
  final String categoryName;
  final bool isMobile;

  const _CategoryTabItem({
    required this.controller,
    required this.index,
    required this.categoryName,
    required this.isMobile,
  });

  @override
  State<_CategoryTabItem> createState() => _CategoryTabItemState();
}

class _CategoryTabItemState extends State<_CategoryTabItem> {
  bool isHovered = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected =
        widget.controller.index == widget.index;

    // ⭐ Reduced width
    final double tabWidth = widget.isMobile
        ? 76
        : 118;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.isMobile) {
          setState(() {
            isHovered = true;
          });
        }
      },
      onExit: (_) {
        if (!widget.isMobile) {
          setState(() {
            isHovered = false;
          });
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.controller.animateTo(
            widget.index,
            duration: const Duration(
              milliseconds: 280,
            ),
            curve: Curves.easeOutCubic,
          );
        },
        child: SizedBox(
          width: tabWidth,

          // ⭐ Fixed height keeps every tab aligned
          height: widget.isMobile ? 64 : 72,

          child: AnimatedScale(
            scale: isSelected ? 1.0 : 1.0,
            duration: const Duration(
              milliseconds: 200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ==================================================
                // ICON
                // ==================================================

                SizedBox(
                  height: widget.isMobile ? 30 : 34,
                  child: Center(
                    child: _buildExistingIcon(
                      isSelected,
                    ),
                  ),
                ),

                SizedBox(
                  height: widget.isMobile ? 3 : 4,
                ),

                // ==================================================
                // TEXT
                // ==================================================

                SizedBox(
                  height: widget.isMobile ? 28 : 32,
                  width: double.infinity,
                  child: Text(
                    widget.categoryName,
                    textAlign: TextAlign.center,

                    maxLines: 2,
                    softWrap: true,

                    // No "..."
                    overflow: TextOverflow.clip,

                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? gPrimaryColor
                          : gHintTextColor,
                      fontSize: widget.isMobile
                          ? 9.5
                          : fontSize10,
                      height: 1.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // KEEP YOUR EXISTING ICON DESIGN HERE
  // ==============================================================

  Widget _buildExistingIcon(bool isSelected) {

    IconData getCategoryIcon(String name) {
      switch (name.toLowerCase().trim()) {
        case 'food farmacy':
          return Icons.eco_rounded;

        case 'amla shots':
          return Icons.spa_rounded;

        case 'infusion':
          return Icons.local_cafe_rounded;

        case 'juice':
          return Icons.local_drink_rounded;

        case 'khichdi':
          return Icons.rice_bowl_rounded;

        case 'soup':
          return Icons.soup_kitchen_rounded;

        case 'chutney & podi':
          return Icons.grass_rounded;

        case 'dessert':
          return Icons.icecream_rounded;

        case 'ambalis':
          return Icons.breakfast_dining_rounded;

        case 'nutri meal':
          return Icons.restaurant_rounded;

        case 'flavours':
          return Icons.grain_rounded;

        default:
          return Icons.category_rounded;
      }
    }

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: widget.isMobile ? 28 : 32,
      height: widget.isMobile ? 28 : 32,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(
            widget.isMobile ? 1.5 : 2,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: gWhiteColor,
            border: Border.all(
              color: isSelected
                  ? gPrimaryColor
                  : borderColor,
              width: isSelected ? 1.5 : 0,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: gBlackColor.withAlpha(20),
                blurRadius: 5,
                offset: const Offset(0, 4),
              ),
            ]
                : const [],
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(
              widget.isMobile ? 3 : 4,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? gPrimaryColor
                  : gWhiteColor,
            ),
            child: Icon(
              getCategoryIcon(widget.categoryName),
              color: isSelected
                  ? gWhiteColor
                  : gPrimaryColor,
              size: widget.isMobile ? 12 : 14,
            ),
          ),
        ),
      ),
    );
  }
}
