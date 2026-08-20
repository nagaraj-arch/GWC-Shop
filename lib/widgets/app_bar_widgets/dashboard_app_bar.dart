import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/products_providers.dart';
import '../../controllers/providers/shop_provider.dart';
import '../../screens/product_screens/widgets/cart_icon_widget.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../button_widgets/floating_button_widget.dart';
import '../button_widgets/icon_button.dart';
import '../text_field_widgets/common_search_bar.dart';

class DashboardAppBar extends StatefulWidget {
  final ScrollController? scrollController;

  const DashboardAppBar({super.key, this.scrollController});

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  int hoverIndex = -1;
  bool showSearch = false;

  final menus = [
    "Home",
    "All Products",
    "Shop Food Farmacy",
    // "Shop Gut Rhythm Products",
    // "Our Story",
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final provider = context.watch<ShopProvider>();

    if (isDesktop) {
      return Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        color: gWhiteColor,
        child: Row(
          children: [
            _logo(),

            const Spacer(),

            Row(
              children: List.generate(
                menus.length,
                (index) => _menuItem(index, provider),
              ),
            ),

            const Spacer(),

            buildActionButtons(),
          ],
        ),
      );
    }

    return _mobileNavbar();
  }

  Widget _logo() {
    return InkWell(
      onTap: () {
        final shopProvider = context.read<ShopProvider>();

        // Already in Home tab
        if (shopProvider.selectedTab == 0 &&
            GoRouterState.of(context).uri.path == "/") {
          widget.scrollController?.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
          return;
        }

        // Navigate to Home
        shopProvider.changeTab(0);
        context.go("/");
      },
      child: Image.asset("assets/images/Gut welness logo.png", height: 40),
    );
  }

  Widget _menuItem(int index, ShopProvider provider) {
    final hover = hoverIndex == index;
    final selected = provider.selectedTab == index;

    double getResponsiveFontSize(BuildContext context) {
      final r = ScreenSizeHelper(context);

      if (r.isUltraWide) return 24;
      if (r.isLargeDesktop) return 22;
      if (r.isDesktop) return 18;
      if (r.isLaptop) return 16;
      if (r.isTablet) return 14;
      return 12;
    }

    final fontSize = getResponsiveFontSize(context);

    return MouseRegion(
      onEnter: (_) => setState(() => hoverIndex = index),
      onExit: (_) => setState(() => hoverIndex = -1),
      child: GestureDetector(
        onTap: () {
          final shopProvider = context.read<ShopProvider>();

          final isSameTab = shopProvider.selectedTab == index;

          if (GoRouterState.of(context).uri.path != "/") {
            context.go("/");
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            shopProvider.changeTab(index);

            if (isSameTab) {
              shopProvider.onTabReClicked(index);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: fontSize,
                  fontWeight: selected
                      ? FontWeight
                            .w700 // Heavy
                      : FontWeight.w500, // Roman
                  color: selected || hover ? gPrimaryColor : gBlackColor,
                  letterSpacing: 1,
                ),
                child: Text(menus[index]),
              ),

              // const SizedBox(height: 8),
              //
              // AnimatedContainer(
              //   duration: const Duration(milliseconds: 250),
              //   width: selected || hover ? 35 : 0,
              //   height: 2.5,
              //   decoration: BoxDecoration(
              //     color: gPrimaryColor,
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButtons({double searchWidth = 240}) {
    final shopProvider = context.watch<ShopProvider>();

    return Consumer<ProductsProvider>(
      builder: (context, productProvider, _) {
        final isSearchOpen = productProvider.isSearchOpen;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (shopProvider.selectedTab == 1)
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: isSearchOpen ? searchWidth : 42,
                height: 42,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSearchOpen)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 8,
                            top: 3,
                          ),
                          child: searchWidget(),
                        ),
                      ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(
                          turns: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: isSearchOpen
                          ? IconButtonWidget(
                        key: const ValueKey("close"),
                        msg: "Close Search",
                        icon: Icons.close,
                        onTap: () {
                          productProvider.closeSearch();
                        },
                      )
                          : IconButtonWidget(
                        key: const ValueKey("search"),
                        msg: "Search",
                        icon: Icons.search,
                        onTap: () {
                          productProvider.openSearch();
                        },
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(width: 10),

            FloatingButtonWidget(),

            const SizedBox(width: 10),

            const CartIconWidget(),
          ],
        );
      },
    );
  }

  Widget searchWidget() {
    return Consumer<ProductsProvider>(
      builder: (_, provider, __) {
        return CommonSearchBar(
          controller: provider.searchController,
          hintText: "Search products...",
          onChanged: (value) {
            provider.search(value);
          },
          borderColor: gHintTextColor,
          width: ResponsiveHelper(context).isDesktop ? 20 : double.maxFinite,
          onClear: provider.clearSearch,
        );
      },
    );
  }

  Widget _mobileNavbar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.white,
      child: Row(
        children: [
          Builder(
            builder: (drawerContext) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(drawerContext).openDrawer();
                },
                child: const Icon(Icons.menu),
              );
            },
          ),

          const SizedBox(width: 16),
          _logo(),
          const Spacer(),
          buildActionButtons(),
        ],
      ),
    );
  }
}
