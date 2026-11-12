import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/api_urls.dart';
import '../../utils/app_config.dart';
import '../../utils/network_service.dart';
import '../models/shop_models/category_model.dart';
import '../models/shop_models/get_cluster_list_model.dart';
import '../models/shop_models/products_by_category_model.dart';

enum ShopLoadingType {
  getIngredientCategory,
  getProductsByCategory,
  getClusterList,
}

class ShopProvider extends ChangeNotifier {
  int selectedTab = kDebugMode ? 1 : 1;
  // ============================================================
  // SHOP PAGE VIEW
  // ============================================================

  final PageController shopPageController = PageController(
    initialPage: 0,
  );

  int _shopPageIndex = 0;

  int get shopPageIndex => _shopPageIndex;

  void changeShopPage(int pageIndex) {
    if (_shopPageIndex == pageIndex) return;

    _shopPageIndex = pageIndex;
    notifyListeners();
  }

  void navigateShopPage(int pageIndex) {
    _shopPageIndex = pageIndex;

    if (shopPageController.hasClients) {
      shopPageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }

    notifyListeners();
  }

  void onTabReClicked(int index) {
    if (index == 0) {
      // Shop tab: reset to first page
      navigateShopPage(0);
    }
  }

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  final Set<ShopLoadingType> _loadingTypes = {};

  bool isLoading(ShopLoadingType type) => _loadingTypes.contains(type);

  void setLoading(ShopLoadingType type, bool value) {
    value ? _loadingTypes.add(type) : _loadingTypes.remove(type);
    notifyListeners();
  }

  void handleError(BuildContext context, Object error) {
    AppConfig().showSnackBar(context, "Error: $error", isError: true);
  }

  List<CategoryList> allCategories = [];
  List<CategoryList> categories = [];

  Future<void> fetchCategory() async {
    setLoading(ShopLoadingType.getIngredientCategory, true);

    try {
      final data = await NetworkService.get(GwcApi.getCategoryListApiUrl(),showResponse: false);
      if (data['status'] == true) {
        final model = CategoryModel.fromJson(data);
        allCategories = model.data ?? [];
        categories = allCategories
            .where((item) => item.hasAdditional == true)
            .toList();

        categories.sort((a, b) {
          final orderA = int.tryParse(a.orderBy ?? '') ?? 999;
          final orderB = int.tryParse(b.orderBy ?? '') ?? 999;

          return orderA.compareTo(orderB);
        });

        // debugPrint("All Categories: $allCategories");
        // debugPrint("Categories: $categories");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setLoading(ShopLoadingType.getIngredientCategory, false);
    }
  }

  /// GUT CLOCK TIMELINE
  CategoryList? selectedCategory;

  Future<void> selectTimelineCategory(String categoryName) async {
    try {
      final category = allCategories.firstWhere(
        (e) =>
            (e.name ?? "").trim().toUpperCase() ==
            categoryName.trim().toUpperCase(),
      );

      selectedCategory = category;

      if (category.id != null) {
        await fetchProductsByCategory(category.id.toString());
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Timeline category not found : $categoryName");
    }
  }

  List<Products> products = [];

  Future<void> fetchProductsByCategory(String categoryId) async {
    setLoading(ShopLoadingType.getProductsByCategory, true);

    products.clear();

    try {
      final data = await NetworkService.get(
        GwcApi.getProductsByCategoryApiUrl(categoryId),showResponse: false
      );

      // debugPrint("========== PRODUCT API ==========");
      // debugPrint("STATUS : ${data['status']}");
      // debugPrint("DATA : ${data['data']}");
      // debugPrint("================================");

      if (data['status'] == 200) {
        final model = ProductsByCategoryModel.fromJson(data);

        products = model.data ?? [];

        // for (final product in products) {
        //   debugPrint(
        //     "PRODUCT : ${product.productTitle} | "
        //     "hasFlavours : ${product.hasFlavours} | "
        //     "nested flavours : ${product.product?.flavours}",
        //   );
        // }

        notifyListeners();
      }
    } catch (e, st) {
      debugPrint("Error: $e");
      debugPrintStack(stackTrace: st);
    } finally {
      setLoading(ShopLoadingType.getProductsByCategory, false);
    }
  }

  List<ClusterList> clusterList = [];

  Future<void> fetchClusterList() async {
    setLoading(ShopLoadingType.getClusterList, true);

    try {
      final data = await NetworkService.get(GwcApi.getClusterListApiUrl());
      if (data['status'] == 200) {
        final model = GetClusterListModel.fromJson(data);
        clusterList = model.data ?? [];
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setLoading(ShopLoadingType.getClusterList, false);
    }
  }

  // ============================================================
  // FOOTER CATEGORY NAVIGATION
  // ============================================================

  int? _pendingFooterCategoryId;

  int? get pendingFooterCategoryId => _pendingFooterCategoryId;

  void openFooterCategory(int categoryId) {
    _pendingFooterCategoryId = categoryId;

    // Open All Products tab
    selectedTab = 1;

    notifyListeners();
  }

  void clearFooterCategory() {
    _pendingFooterCategoryId = null;
  }
}
