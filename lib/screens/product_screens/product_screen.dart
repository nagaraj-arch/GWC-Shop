import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_shop/widgets/loading_widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/products_providers.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/app_bar_widgets/announcement_bar.dart';
import '../../widgets/app_bar_widgets/dashboard_app_bar.dart';
import '../../widgets/app_bar_widgets/mobile_drawer.dart';
import '../footer_widget/footer_section.dart';
import 'widgets/category_tab.dart';
import 'widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
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

      _createTabController(provider);
    });
  }

  void _createTabController(ProductsProvider provider) {
    _tabController?.dispose();

    _tabController = TabController(
      length: provider.additionalCategories.length,
      vsync: this,
    );

    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
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
          : Column(
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
                      horizontal: responsive.isMobile ? 0 : 100),
                  child: productsSection(responsive, provider),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
    return Scaffold(
      backgroundColor: gWhiteColor,
      endDrawer: const MobileDrawer(),
      body: Column(
        children: [
          const DashboardAppBar(),
          const AnnouncementBar(),
          Expanded(
            child: SingleChildScrollView(
              child: provider.isLoading(LoadingType.getAdditionalProducts)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(child: LoadingIndicator()),
                    )
                  : Column(
                      children: [
                        if (_tabController != null &&
                            _tabController!.length ==
                                provider.additionalCategories.length)
                          CategoryTabs(
                            controller: _tabController!,
                            categories: provider.additionalCategories,
                            getCount: provider.getCategoryCount,
                          ),
                        productsSection(responsive, provider),
                        const SizedBox(height: 40),
                        GwcFooter(),
                        const SizedBox(height: 40),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productsSection(ScreenSizeHelper responsive, ProductsProvider provider) {
    if (provider.filteredAdditionalProducts.isEmpty) {
      return emptyWidget(responsive);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns;
        if (width >= 1000) {
          columns = 3;
        } else if (width >= 650) {
          columns = 2;
        } else {
          columns = 1;
        }

        const spacing = 20.0;
        final cardWidth = (width - ((columns - 1) * spacing)) / columns;
        final cardHeight = responsive.isMobile
            ? 360
            : responsive.isTablet
            ? 420
            : 450;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.filteredAdditionalProducts.length,
          padding: EdgeInsets.symmetric(
            vertical: 2.h,
            horizontal: responsive.isMobile ? 3.w : 2.w,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemBuilder: (context, index) {
            final item = provider.filteredAdditionalProducts[index];
            return KeyedSubtree(
              key: ValueKey(
                '${provider.selectedAdditionalCategory}_${item.productId}',
              ),
              child: ProductCard(item: item),
            );
          },
        );
      },
    );
  }

  Widget emptyWidget(ScreenSizeHelper responsive) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: responsive.isMobile ? 60 : 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Products Found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: gPrimaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Products are not available for this category.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: responsive.isMobile ? 12 : 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:gwc_masalas/screens/footer_screens/footer_widget.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/products_providers.dart';
// import '../../utils/constants.dart';
// import '../../utils/responsive_helper.dart';
// import '../../widgets/app_bar_widgets/common_scaffold.dart';
// import '../../widgets/loading_indicator_widget.dart';
// import '../flip_card_design/flip_review_card.dart';
// import '../flip_card_design/review_model.dart';
// import '../footer_screens/payment_methods_widget.dart';
// import 'widgets/banner/product_info_banner.dart';
// import 'widgets/cart_button.dart';
// import 'widgets/category_tab.dart';
// import 'widgets/popular_product_showcase.dart';
// import 'widgets/category_card.dart';
// import 'widgets/second_tab_banner/second_banner.dart';
//
// class ProductScreen extends StatefulWidget {
//   const ProductScreen({super.key});
//
//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final provider = context.read<ProductsProvider>();
//
//       while (provider.isLoading(LoadingType.getAdditionalProducts)) {
//         await Future.delayed(const Duration(milliseconds: 100));
//       }
//
//       if (!mounted) return;
//
//       _createTabController(provider);
//     });
//   }
//
//   void _createTabController(ProductsProvider provider) {
//     _tabController?.dispose();
//
//     _tabController = TabController(
//       length: provider.additionalCategories.length,
//       vsync: this,
//     );
//
//     /// IMPORTANT: Set initial selected category
//     if (provider.additionalCategories.isNotEmpty) {
//       provider.changeAdditionalCategory(
//         provider.additionalCategories.first,
//       );
//     }
//
//     _tabController!.addListener(() {
//       if (!_tabController!.indexIsChanging) {
//         provider.changeAdditionalCategory(
//           provider.additionalCategories[_tabController!.index],
//         );
//       }
//     });
//
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = ResponsiveHelper(context).isDesktop;
//
//     final provider = context.watch<ProductsProvider>();
//
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         backgroundColor: gBgColor,
//         body: Column(
//           children: [
//             Expanded(
//               child: provider.isLoading(LoadingType.getAdditionalProducts)
//                   ? const Center(child: LoadingIndicatorWidget())
//                   : Stack(
//                       children: [
//                         provider.searchController.text.isEmpty
//                             ? productsWidget(isDesktop, provider)
//                             : Column(
//                                 children: [productsWidget(isDesktop, provider)],
//                               ),
//                         CartButton(),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   emptyWidget(bool isDesktop) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.inventory_2_outlined,
//             size: isDesktop ? 80 : 60,
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             'No Products Found',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: isDesktop ? 18 : 16,
//               fontWeight: FontWeight.w600,
//               color: gPrimaryColor,
//             ),
//           ),
//           SizedBox(height: 1.h),
//           Text(
//             'Products are not available for this category.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: isDesktop ? 14 : 12,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildBanner(ProductsProvider provider) {
//     switch (provider.selectedAdditionalCategory) {
//       case "INFUSION":
//         return FoodPharmacyBanner(products: provider.popularProducts);
//
//       case "FOOD FARMACY":
//         return PopularProductsShowcase(products: provider.popularProducts);
//
//       default:
//         return const SizedBox.shrink();
//     }
//   }
//
//   Widget productsWidget(bool isDesktop, ProductsProvider provider) {
//     final responsive = ResponsiveHelper(context);
//
//     final int bannerIndex = isDesktop ? 3 : 2;
//
//     final bool showFoodFarmacyBanner =
//         provider.selectedAdditionalCategory.trim().toUpperCase() ==
//                 "FOOD FARMACY" ||
//             provider.selectedAdditionalCategory.trim().toUpperCase() == "SOUP";
//
//     if (provider.selectedAdditionalCategory.isEmpty) {
//       return const Center(
//         child: LoadingIndicatorWidget(),
//       );
//     }
//
//     if (provider.filteredAdditionalProducts.isEmpty) {
//       return emptyWidget(isDesktop);
//     }
//
//     return provider.filteredAdditionalProducts.isEmpty
//         ? emptyWidget(isDesktop)
//         : AnimatedContainer(
//             duration: const Duration(milliseconds: 500),
//             decoration: BoxDecoration(
//               color: gWhiteColor,
//               // gradient: LinearGradient(
//               //   begin: Alignment.topCenter,
//               //   end: Alignment.bottomCenter,
//               //   colors: [
//               //     provider.bannerColor,
//               //     provider.bannerColor,
//               //     provider.bannerColor.withAlpha(80),
//               //     provider.bannerColor.withAlpha(45),
//               //     provider.bannerColor.withAlpha(22),
//               //   ],
//               //   stops: const [
//               //     0,
//               //     .28,
//               //     .55,
//               //     .75,
//               //     .92,
//               //   ],
//               // ),
//             ),
//             child: Column(
//               children: [
//                 const ProductsHeader(),
//                 if (_tabController != null &&
//                     _tabController!.length ==
//                         provider.additionalCategories.length)
//                   CategoryTabs(
//                     controller: _tabController!,
//                     categories: provider.additionalCategories,
//                     getCount: provider.getCategoryCount,
//                   ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: isDesktop ? 5.w : 3.w),
//                           child: buildBanner(provider),
//                         ),
//
//                         LayoutBuilder(
//                           builder: (context, constraints) {
//                             final width = constraints.maxWidth;
//
//                             int columns;
//
//                             if (width >= 1000) {
//                               columns = 3;
//                             } else if (width >= 650) {
//                               columns = 2;
//                             } else {
//                               columns = 1;
//                             }
//
//                             const spacing = 20.0;
//
//                             final cardWidth =
//                                 (width - ((columns - 1) * spacing)) / columns;
//
//                             final cardHeight = responsive.isMobile
//                                 ? 400
//                                 : responsive.isTablet
//                                     ? 480
//                                     : 520;
//
//                             return Column(
//                               children: [
//                                 GridView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: bannerIndex,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 2.h,
//                                       horizontal: isDesktop ? 5.w : 3.w),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: columns,
//                                     crossAxisSpacing: spacing,
//                                     mainAxisSpacing: spacing,
//                                     childAspectRatio: cardWidth / cardHeight,
//                                   ),
//                                   itemBuilder: (_, index) {
//                                     return ProductCard(
//                                       item: provider
//                                           .filteredAdditionalProducts[index],
//                                     );
//                                   },
//                                 ),
//                                 if (showFoodFarmacyBanner)
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: isDesktop ? 5.w : 3.w,
//                                         vertical: 2.h),
//                                     child: const ProductInfoBanner(
//                                       bannerUrl:
//                                           'https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/newitem.png',
//                                     ),
//                                   ),
//                                 GridView.builder(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 2.h,
//                                       horizontal: isDesktop ? 5.w : 3.w),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: provider
//                                           .filteredAdditionalProducts.length -
//                                       bannerIndex,
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: columns,
//                                     crossAxisSpacing: spacing,
//                                     mainAxisSpacing: spacing,
//                                     childAspectRatio: cardWidth / cardHeight,
//                                   ),
//                                   itemBuilder: (_, index) {
//                                     return ProductCard(
//                                       item: provider.filteredAdditionalProducts[
//                                           index + bannerIndex],
//                                     );
//                                   },
//                                 ),
//                                 // GridView.builder(
//                                 //   shrinkWrap: true,
//                                 //   physics: const NeverScrollableScrollPhysics(),
//                                 //   padding: EdgeInsets.symmetric(
//                                 //     vertical: 2.h,
//                                 //     horizontal: isDesktop ? 5.w : 3.w,
//                                 //   ),
//                                 //   itemCount:
//                                 //       provider.filteredAdditionalProducts.length +
//                                 //           1,
//                                 //   gridDelegate:
//                                 //       SliverGridDelegateWithFixedCrossAxisCount(
//                                 //     crossAxisCount: columns,
//                                 //     crossAxisSpacing: spacing,
//                                 //     mainAxisSpacing: spacing,
//                                 //     childAspectRatio: cardWidth / cardHeight,
//                                 //   ),
//                                 //   itemBuilder: (context, index) {
//                                 //     final int bannerIndex = isDesktop ? 3 : 2;
//                                 //
//                                 //     if (index == bannerIndex) {
//                                 //       return ProductInfoBanner(
//                                 //           bannerUrl:
//                                 //               'https://gutandhealth.com/storage/uploads/users/feeds/photos_videos/newitem.png');
//                                 //     }
//                                 //
//                                 //     final productIndex =
//                                 //         index > bannerIndex ? index - 1 : index;
//                                 //
//                                 //     return ProductCard(
//                                 //       item: provider
//                                 //           .filteredAdditionalProducts[productIndex],
//                                 //     );
//                                 //   },
//                                 // ),
//                               ],
//                             );
//                           },
//                         ),
//
//                         /// Space before footer
//                         CarouselSlider.builder(
//                           itemCount: reviews.length,
//                           options: CarouselOptions(
//                             height: 250,
//                             viewportFraction: .24,
//                             enlargeCenterPage: false,
//                             enableInfiniteScroll: true,
//                             autoPlay: true,
//                             autoPlayInterval: const Duration(seconds: 4),
//                           ),
//                           itemBuilder: (_, index, realIndex) {
//                             return FlipReviewCard(review: reviews[index]);
//                           },
//                         ),
//                         PaymentMethodsWidget(),
//                         SizedBox(height: 3.h),
//                         FooterWidget(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }
