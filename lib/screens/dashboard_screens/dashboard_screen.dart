import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/products_providers.dart';
import '../../controllers/providers/shop_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/app_bar_widgets/announcement_bar.dart';
import '../../widgets/app_bar_widgets/dashboard_app_bar.dart';
import '../../widgets/app_bar_widgets/mobile_drawer.dart';
import '../../widgets/loading_widgets/loading_indicator.dart';
import '../footer_widget/footer_section.dart';
import 'tab_screens/all_products_tab/all_products_tab.dart';
import 'tab_screens/food_farmacy_tab/food_farmacy_tab.dart';
import 'tab_screens/shop_tab/shop_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController scrollController = ScrollController();

  int _previousTab = 0;

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

    // Reset main dashboard scroll whenever tab changes
    _resetScrollWhenTabChanges(selectedTab);

    return Scaffold(
      backgroundColor: gWhiteColor,
      drawer: const MobileDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            DashboardAppBar(scrollController: scrollController),

            const AnnouncementBar(),

            Expanded(
              child: shopProvider.isLoading(
                ShopLoadingType.getIngredientCategory,
              )
                  ? const LoadingIndicator()
                  : _buildTabBody(
                isDesktop,
                selectedTab,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBody(bool isDesktop, int tab) {
    if (tab == 0) {
      return const AllProductsTab();
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          if (tab == 1)
            const FoodFarmacyTab()
          else if (tab == 2)
            const ShopTab()
          else
            const ShopTab(),

          GwcFooter(),
        ],
      ),
    );
  }
}
