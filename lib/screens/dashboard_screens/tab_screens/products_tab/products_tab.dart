import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/providers/products_providers.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/loading_widgets/loading_indicator.dart';
import '../../../category_page/category_product_card.dart';
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
    return SingleChildScrollView(
      child: provider.isLoading(LoadingType.getAdditionalProducts)
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.isMobile ? 0 : 100,
                    vertical: 40,
                  ),
                  child: AdditionalProductsGrid(
                    products: provider.filteredAdditionalProducts,
                    isShop: true,
                  ),
                  // productsSection(responsive, provider),
                ),
              ],
            )
          : Column(
              children: [
                SizedBox(height: 40),
                AdditionalProductsGrid(
                  products: provider.filteredAdditionalProducts,
                  isShop: true,
                ),
                SizedBox(height: 40),
              ],
            ),
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
