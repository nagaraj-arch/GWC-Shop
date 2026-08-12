import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/api_urls.dart';
import '../../utils/network_service.dart';
import '../models/get_additional_products_model/get_additional_products_model.dart';
import '../models/get_additional_products_model/get_gwc_products_model.dart';
import '../models/get_additional_products_model/product_flavors_model.dart';
import '../models/shop_models/products_by_category_model.dart';

enum LoadingType {
  getProducts,
  getAdditionalProducts,
  productFlavors,
  submitProducts,
}

class ProductsProvider extends ChangeNotifier {
  /// Tab Func
  int selectedTab = 0;

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  /// ================= LOADING STATE =================
  final Set<LoadingType> _loadingTypes = {};

  bool isLoading(LoadingType type) => _loadingTypes.contains(type);

  void setLoading(LoadingType type, bool value) {
    value ? _loadingTypes.add(type) : _loadingTypes.remove(type);
    notifyListeners();
  }

  bool submitLoading = false;

  Map<String, List<GwcProducts>> details = {};
  List<MapEntry<String, GwcProducts>> filteredItems = [];

  final ScrollController slideController = ScrollController();
  final ScrollController scrollController = ScrollController();

  /// NEW DESIGN
  List<GwcProducts> products = [];
  final searchController = TextEditingController();
  String selectedCategory = "All";

  List<String> get categories {
    return ["All", ...details.keys];
  }

  List<GwcProducts> get filteredProducts {
    List<GwcProducts> data = [];

    if (selectedCategory == "All") {
      data = details.values.expand((e) => e).toList();
    } else {
      data = details[selectedCategory] ?? [];
    }

    final query = searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      data = data.where((item) {
        return (item.orderName ?? '').toLowerCase().contains(query) ||
            (item.category?.name ?? '').toLowerCase().contains(query);
      }).toList();
    }

    return data;
  }

  void changeCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void search(String value) {
    notifyListeners();
  }

  void clearNewSearch() {
    searchController.clear();
    notifyListeners();
  }

  ///

  final Map<String, GlobalKey> sectionKeys = {};
  String? selectedKey;
  int currentPage = 0;

  void setSelectedCategory(String key) {
    selectedKey = key;
    notifyListeners();
  }

  ProductsProvider() {
    searchController.addListener(filterItems);
    slideController.addListener(_onSlideScroll);
  }

  Future<void> fetchProducts() async {
    setLoading(LoadingType.getProducts, true);

    try {
      final data = await NetworkService.get(getGwcProductsUrl);
      final model = GetGwcProductsModel.fromJson(data);
      details = model.data;

      products = details.values.expand((productList) => productList).toList();

      // if (details.isNotEmpty) {
      //   selectedKey = details.keys.first;
      // }

      // Assign section keys
      for (var key in details.keys) {
        sectionKeys[key] = GlobalKey();
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error: $e");
    }

    setLoading(LoadingType.getProducts, false);
  }

  /// ADDITIONAL PRODUCTS

  List<Products> additionalProducts = [];
  List<Products> foodFarmacyProducts =[];

  bool isSearchOpen = false;

  void openSearch() {
    isSearchOpen = true;
    notifyListeners();
  }

  void closeSearch() {
    isSearchOpen = false;
    searchController.clear();
    clearSearch();
    notifyListeners();
  }

  /// Global search results for DashboardAppBar
  List<Products> get searchResults {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    return additionalProducts.where((product) {
      return (product.productTitle ?? '').toLowerCase().contains(query) ||
          (product.productDescription ?? '').toLowerCase().contains(query) ||
          (product.category?.name ?? '').toLowerCase().contains(query) ||
          (product.productSpecialTag ?? '').toLowerCase().contains(query);
    }).toList();
  }

  Future<void> fetchAdditionalProducts() async {
    setLoading(LoadingType.getAdditionalProducts, true);

    try {
      final data = await NetworkService.get(getAdditionalProductsUrl);

      if (data['success'] == true) {
        final model = GetAdditionalProductsModel.fromJson(data);

        final allProducts = model.data ?? [];

        foodFarmacyProducts = allProducts
            .where((product) => product.category?.id?.toString() == "32")
            .toList();

        additionalProducts = allProducts;

        additionalProducts.sort((a, b) {
          final orderA =
              int.tryParse(a.orderBy?.toString() ?? "") ?? 999999;
          final orderB =
              int.tryParse(b.orderBy?.toString() ?? "") ?? 999999;

          return orderA.compareTo(orderB);
        });

        foodFarmacyProducts.sort((a, b) {
          final orderA =
              int.tryParse(a.orderBy?.toString() ?? "") ?? 999999;
          final orderB =
              int.tryParse(b.orderBy?.toString() ?? "") ?? 999999;

          return orderA.compareTo(orderB);
        });

        if (selectedAdditionalCategory.isEmpty &&
            additionalCategoryWiseProducts.isNotEmpty) {
          selectedAdditionalCategory =
              additionalCategoryWiseProducts.keys.first;
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    setLoading(LoadingType.getAdditionalProducts, false);
  }

  List<Products> get popularProducts {
    return additionalProducts.where((e) => e.isProductPopular == true).toList();
  }

  Color _bannerColor = const Color(0xff28B8F4);

  Color get bannerColor => _bannerColor;

  void changeBannerColor(Color color) {
    _bannerColor = color;
    notifyListeners();
  }

  Map<String, List<Products>> get additionalCategoryWiseProducts {
    final Map<String, List<Products>> grouped = {};

    for (final product in additionalProducts) {
      final categoryName = product.category?.name ?? "Others";

      grouped.putIfAbsent(categoryName, () => []);

      grouped[categoryName]!.add(product);
    }

    // Sort each category by order_by
    grouped.forEach((key, value) {
      value.sort((a, b) {
        final orderA = int.tryParse(a.orderBy?.toString() ?? "") ?? 999999;
        final orderB = int.tryParse(b.orderBy?.toString() ?? "") ?? 999999;

        return orderA.compareTo(orderB);
      });
    });

    return grouped;
  }

  String selectedSort = "default";

  void changeSort(String value) {
    selectedSort = value;
    notifyListeners();
  }

  List<String> get additionalCategories {
    return [
      // "All",
      // "POPULAR",
      ...additionalCategoryWiseProducts.keys,
    ];
  }

  int getCategoryCount(String category) {
    // if (category == "All") {
    //   return additionalProducts.length;
    // }

    // if (category == "POPULAR") {
    //   return additionalProducts.where((e) => e.isProductPopular == true).length;
    // }

    return additionalProducts.where((e) {
      return (e.category?.name ?? "").toLowerCase() == category.toLowerCase();
    }).length;
  }

  // String selectedAdditionalCategory = "All";

  // String selectedAdditionalCategory = "POPULAR";

  String selectedAdditionalCategory = "";

  void changeAdditionalCategory(String category) {
    selectedAdditionalCategory = category;
    notifyListeners();
  }

  String selectedSpecialTag = "";

  List<String> get specialTags {
    final tags = additionalProducts
        .map((e) => (e.productSpecialTag ?? "").trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    tags.sort();

    return tags;
  }

  void changeSpecialTag(String tag) {
    selectedSpecialTag = tag;
    notifyListeners();
  }

  void clearSpecialTag() {
    selectedSpecialTag = "";
    notifyListeners();
  }

  String get sortTitle {
    switch (selectedSort) {
      case "price_low":
        return "Price ↑";

      case "price_high":
        return "Price ↓";

      case "az":
        return "A-Z";

      case "za":
        return "Z-A";

      default:
        return "";
    }
  }

  List<Products> get filteredAdditionalProducts {
    List<Products> data;

    final query = searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      data = List.from(additionalProducts); // Search all products
    }
    // else if (selectedAdditionalCategory == "All") {
    //   data = List.from(additionalProducts);
    // }
    // else if (selectedAdditionalCategory == "POPULAR") {
    //   data = additionalProducts.where((product) {
    //     return product.isProductPopular == true;
    //   }).toList();
    // }
    else {
      data = additionalCategoryWiseProducts[selectedAdditionalCategory] ?? [];
    }

    if (query.isNotEmpty) {
      data = data.where((product) {
        return (product.productTitle ?? '').toLowerCase().contains(query) ||
            (product.productDescription ?? '').toLowerCase().contains(query) ||
            (product.category?.name ?? '').toLowerCase().contains(query) ||
            (product.productSpecialTag ?? '').toLowerCase().contains(query);
      }).toList();
    }

    if (selectedSpecialTag.isNotEmpty) {
      data = data.where((e) {
        return (e.productSpecialTag ?? "").toLowerCase().trim() ==
            selectedSpecialTag.toLowerCase().trim();
      }).toList();
    }

    switch (selectedSort) {
      case "price_low":
        data.sort(
          (a, b) => (double.tryParse(a.discountPrice ?? "0") ?? 0).compareTo(
            double.tryParse(b.discountPrice ?? "0") ?? 0,
          ),
        );
        break;

      case "price_high":
        data.sort(
          (a, b) => (double.tryParse(b.discountPrice ?? "0") ?? 0).compareTo(
            double.tryParse(a.discountPrice ?? "0") ?? 0,
          ),
        );
        break;

      case "az":
        data.sort(
          (a, b) => (a.productTitle ?? "").compareTo(b.productTitle ?? ""),
        );
        break;

      case "za":
        data.sort(
          (a, b) => (b.productTitle ?? "").compareTo(a.productTitle ?? ""),
        );
        break;
    }

    return data;
  }

  List<Flavours>? flavours = [];

  Future<void> fetchProductFlavors(int productId) async {
    setLoading(LoadingType.productFlavors, true);

    try {
      final data = await NetworkService.get("$getProductFlavorsUrl$productId");
      if (data['success'] == true) {
        final model = ProductFlavorsModel.fromJson(data);
        flavours = model.data?.flavours;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    setLoading(LoadingType.productFlavors, false);
  }

  ///
  void filterItems() {
    final query = searchController.text.toLowerCase();
    filteredItems = details.entries
        .expand(
          (entry) => entry.value.map((product) => MapEntry(entry.key, product)),
        )
        .where(
          (entry) =>
              entry.value.orderName?.toLowerCase().contains(query) ?? false,
        )
        .toList();
    notifyListeners();
  }

  void scrollToSection(String key) {
    final sectionKey = sectionKeys[key];
    final context = sectionKey?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSlideScroll() {
    final offset = slideController.offset;
    const itemWidth = 300.0; // Adjust as needed
    currentPage = (offset / itemWidth).round();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filterItems();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    slideController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
