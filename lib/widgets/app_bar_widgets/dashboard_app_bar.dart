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

  final VoidCallback? onRecommendedTap;

  const DashboardAppBar({
    super.key,
    this.scrollController,
    this.onRecommendedTap,
  });

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  int hoverIndex = -1;

  final menus = [
    "Home", "All Products",
    // "Recommended",
    "Shop Food Farmacy",
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

  // ============================================================
  // LOGO
  // ============================================================

  Widget _logo() {
    return InkWell(
      onTap: () {
        final shopProvider = context.read<ShopProvider>();

        if (shopProvider.selectedTab == 0 &&
            GoRouterState.of(context).uri.path == "/") {
          widget.scrollController?.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );

          return;
        }

        shopProvider.changeTab(0);

        context.go("/");
      },

      child: Image.asset("assets/images/Gut welness logo.png", height: 40),
    );
  }

  // ============================================================
  // DESKTOP MENU
  // ============================================================

  Widget _menuItem(int index, ShopProvider provider) {
    final hover = hoverIndex == index;

    // ------------------------------------------------------------
    // APP BAR INDEX -> SHOP PROVIDER TAB INDEX
    // ------------------------------------------------------------
    final int tabIndex;

    switch (index) {
      case 0:
        // Home
        tabIndex = 0;
        break;

      case 1:
        // All Products
        tabIndex = 1;
        break;

      // case 2:
      //   // Recommended
      //   tabIndex = 3;
      //   break;

      case 2:
        // Shop Food Farmacy
        tabIndex = 2;
        break;

      default:
        tabIndex = 0;
    }

    final selected = provider.selectedTab == tabIndex;

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
      onEnter: (_) {
        setState(() {
          hoverIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoverIndex = -1;
        });
      },
      child: GestureDetector(
        onTap: () {
          // ========================================================
          // RECOMMENDED
          // ========================================================

          // if (index == 2) {
          //   widget.onRecommendedTap?.call();
          //   return;
          // }

          final shopProvider = context.read<ShopProvider>();

          final isSameTab = shopProvider.selectedTab == tabIndex;

          // ========================================================
          // MAKE SURE WE ARE ON DASHBOARD
          // ========================================================

          if (GoRouterState.of(context).uri.path != "/") {
            context.go("/");
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            shopProvider.changeTab(tabIndex);

            if (isSameTab) {
              shopProvider.onTabReClicked(tabIndex);
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
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: fontSize,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected || hover ? gPrimaryColor : gBlackColor,
                  letterSpacing: 1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Recommended icon
                    if (index == 2) ...[
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: fontSize,
                        color: selected || hover ? gPrimaryColor : gBlackColor,
                      ),
                      const SizedBox(width: 5),
                    ],

                    Text(menus[index]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget buildActionButtons({
    double searchWidth = 240,
    bool showTrackOrder = true,
  }) {
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
                          padding: const EdgeInsets.only(right: 8, top: 3),
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
                              onTap: productProvider.closeSearch,
                            )
                          : IconButtonWidget(
                              key: const ValueKey("search"),
                              msg: "Search",
                              icon: Icons.search,
                              onTap: productProvider.openSearch,
                            ),
                    ),
                  ],
                ),
              ),

            const SizedBox(width: 10),

            if (showTrackOrder) ...[
              FloatingButtonWidget(),
              const SizedBox(width: 10),
            ],

            const CartIconWidget(),
          ],
        );
      },
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

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

  // ============================================================
  // MOBILE NAVBAR
  // ============================================================

  Widget _mobileNavbar() {
    return Container(
      height: 70,

      padding: const EdgeInsets.symmetric(horizontal: 18),

      color: gWhiteColor,

      child: Row(
        children: [
          _logo(),

          const Spacer(),

          buildActionButtons(showTrackOrder: false),
        ],
      ),
    );
  }
}
