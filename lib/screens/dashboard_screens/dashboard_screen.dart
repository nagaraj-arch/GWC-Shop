import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/products_providers.dart';
import '../../controllers/providers/shop_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/app_bar_widgets/announcement_bar.dart';
import '../../widgets/app_bar_widgets/dashboard_app_bar.dart';
import '../../widgets/loading_widgets/loading_indicator.dart';
import '../footer_widget/footer_section.dart';
import '../track_my_order_screen/track_order.dart';

import 'tab_screens/all_products_tab/all_products_tab.dart';
import 'tab_screens/home_tab/home_tab.dart';
import 'tab_screens/shop_food_farmacy_tab/shop_food_farmacy_tab.dart';
import 'widgets/request_doctor_call.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController scrollController = ScrollController();

  int _previousTab = 0;
  bool showSpecialOffer = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchCategory();
      context.read<ProductsProvider>().fetchAdditionalProducts();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _closeSpecialOffer() {
    if (!mounted) return;

    setState(() {
      showSpecialOffer = false;
    });
  }

  void _openSpecialOffer() {
    if (!mounted) return;

    setState(() {
      showSpecialOffer = true;
    });
  }

  void _resetScrollWhenTabChanges(int currentTab) {
    if (_previousTab != currentTab) {
      _previousTab = currentTab;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    final shopProvider = context.watch<ShopProvider>();
    final selectedTab = shopProvider.selectedTab;
    _resetScrollWhenTabChanges(selectedTab);

    return Scaffold(
      backgroundColor: gWhiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: DoctorCallAndCartButtons(selectedTab: selectedTab),
      bottomNavigationBar: isDesktop
          ? null
          : _buildGlassBottomNavigation(shopProvider),

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                DashboardAppBar(scrollController: scrollController),
                AnnouncementBar(),
                Expanded(
                  child:
                      shopProvider.isLoading(
                        ShopLoadingType.getIngredientCategory,
                      )
                      ? LoadingIndicator()
                      : _buildTabBody(isDesktop, selectedTab),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOfferFloatingIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: Alignment.centerRight,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _openSpecialOffer,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: gPrimaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: gPrimaryColor.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: gWhiteColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.card_giftcard_rounded,
                color: gPrimaryColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBottomNavigation(ShopProvider provider) {
    const items = [
      (
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: 'Home',
        tabIndex: 0,
      ),
      (
        icon: Icons.shopping_bag_outlined,
        selectedIcon: Icons.shopping_bag_rounded,
        label: 'Products',
        tabIndex: 1,
      ),
      (
        icon: Icons.spa_outlined,
        selectedIcon: Icons.spa_rounded,
        label: 'Food Farmacy',
        tabIndex: 2,
      ),

      // Recommended remains commented out.
      // (
      //   icon: Icons.auto_awesome_outlined,
      //   selectedIcon: Icons.auto_awesome_rounded,
      //   label: 'Recommended',
      //   tabIndex: 3,
      // ),
      (
        icon: Icons.location_on_outlined,
        selectedIcon: Icons.location_on_rounded,
        label: 'Track',
        tabIndex: 4,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: gPrimaryColor.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [gWhiteColor, Color(0xFFFCFEFC), Color(0xFFF1F8F2)],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final tabIndex = item.tabIndex;
                final selected = provider.selectedTab == tabIndex;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Track is bottom-bar index 3,
                      // but its actual provider tab is 4.
                      if (tabIndex == 4) {
                        if (provider.selectedTab != 4) {
                          provider.changeTab(4);
                        } else {
                          provider.onTabReClicked(4);
                        }
                        return;
                      }

                      if (selected) {
                        provider.onTabReClicked(tabIndex);
                        return;
                      }

                      provider.changeTab(tabIndex);

                      if (tabIndex == 0) {
                        context.go("/");
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeOutBack,
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            selected ? item.selectedIcon : item.icon,
                            key: ValueKey('${item.label}-$selected'),
                            size: 18,
                            color: selected ? gPrimaryColor : gHintTextColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 9.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected ? gPrimaryColor : gHintTextColor,
                          ),
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBody(bool isDesktop, int tab) {
    // ALL PRODUCTS
    if (tab == 1) {
      return AllProductsTab();
    }

    // TRACK ORDER
    if (tab == 4) {
      return TrackOrder();
    }

    // NORMAL TABS
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          // HOME
          if (tab == 0)
            HomeTab()
          // FOOD FARMACY
          else if (tab == 2)
            ShopFoodFarmacyTab(),
          // RECOMMENDED
          // else if (tab == 3)
          //   RecommendedTab(),

          // FOOTER
          GwcFooter(),
        ],
      ),
    );
  }
}
