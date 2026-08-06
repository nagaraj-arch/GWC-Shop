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
import '../product_screens/product_screen.dart';
import 'tab_screens/food_farmacy_tab/food_farmacy_tab.dart';
import 'tab_screens/our_story_tab/our_story_tab.dart';
import 'tab_screens/shop_tab/shop_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchCategory();
      context.read<ProductsProvider>().fetchAdditionalProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    final shopProvider = context.watch<ShopProvider>();


    return Scaffold(
      backgroundColor: gWhiteColor,
      endDrawer: const MobileDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(),
            const AnnouncementBar(),
            Expanded(
              child:
                  shopProvider.isLoading(ShopLoadingType.getIngredientCategory)
                  ? const LoadingIndicator()
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTabBody(isDesktop, shopProvider.selectedTab),
                        FooterSection(),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBody(bool isDesktop, int tab) {
    if (tab == 0) return const ShopTab();
    if (tab == 1) return const FoodFarmacyTab();
    if (tab == 2) return const ProductScreen();
    if (tab == 3) return const OurStoryTab();
    return const ShopTab();
  }
}
