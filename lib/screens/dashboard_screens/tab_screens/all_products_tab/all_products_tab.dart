import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/category_model.dart';
import '../../../../controllers/providers/products_providers.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../category_page/category_product_card.dart';
import '../../../footer_widget/footer_section.dart';
import '../best_seller_tab/best_seller_tab.dart';
import 'category_by_products.dart';

class AllProductsTab extends StatefulWidget {
  const AllProductsTab({super.key});

  @override
  State<AllProductsTab> createState() => _AllProductsTabState();
}

class _AllProductsTabState extends State<AllProductsTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // 0 = Best Sellers
  // 1+ = Normal categories
  int _selectedCategoryIndex = 0;

  bool _firstProductsLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupTabs();
    });
  }

  // ==============================================================
  // SETUP
  // ==============================================================

  void _setupTabs() {
    if (!mounted) return;

    final provider = context.read<ShopProvider>();
    final categories = provider.categories;

    if (categories.isEmpty) return;

    // ============================================================
    // FOOTER CATEGORY
    // ============================================================

    final pendingCategoryId = provider.pendingFooterCategoryId;

    if (pendingCategoryId != null) {
      final footerCategoryIndex = categories.indexWhere(
        (category) => category.id == pendingCategoryId,
      );

      if (footerCategoryIndex != -1) {
        // Best Sellers = 0
        // Category starts from 1
        _selectedCategoryIndex = footerCategoryIndex + 1;
      }

      provider.clearFooterCategory();
    }

    // +1 = Best Sellers
    final totalTabs = categories.length + 1;

    if (_selectedCategoryIndex < 0 || _selectedCategoryIndex >= totalTabs) {
      _selectedCategoryIndex = 0;
    }

    _createTabController(categories);

    // ============================================================
    // INITIAL CATEGORY API
    // ============================================================

    if (!_firstProductsLoaded) {
      _firstProductsLoaded = true;

      // Don't call category API when Best Sellers is selected.
      if (_selectedCategoryIndex > 0) {
        final categoryIndex = _selectedCategoryIndex - 1;

        final selectedCategory = categories[categoryIndex];

        if (selectedCategory.id != null) {
          provider.fetchProductsByCategory(selectedCategory.id.toString());
        }
      }
    }
  }

  // ==============================================================
  // FOOTER CATEGORY
  // ==============================================================

  void _handleFooterCategory() {
    if (!mounted) return;

    final provider = context.read<ShopProvider>();
    final categories = provider.categories;

    final pendingCategoryId = provider.pendingFooterCategoryId;

    if (pendingCategoryId == null || categories.isEmpty) {
      return;
    }

    final index = categories.indexWhere(
      (category) => category.id == pendingCategoryId,
    );

    provider.clearFooterCategory();

    if (index == -1) return;

    // Best Sellers = 0
    // Normal category = category index + 1
    final tabIndex = index + 1;

    setState(() {
      _selectedCategoryIndex = tabIndex;
    });

    if (_tabController != null &&
        _tabController!.length == categories.length + 1) {
      _tabController!.animateTo(
        tabIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }

    final categoryId = categories[index].id;

    if (categoryId != null) {
      provider.fetchProductsByCategory(categoryId.toString());
    }
  }

  // ==============================================================
  // TAB CONTROLLER
  // ==============================================================

  void _createTabController(List<CategoryList> categories) {
    if (!mounted || categories.isEmpty) {
      return;
    }

    // +1 = Best Sellers
    final totalTabs = categories.length + 1;

    if (_selectedCategoryIndex < 0 || _selectedCategoryIndex >= totalTabs) {
      _selectedCategoryIndex = 0;
    }

    if (_tabController != null && _tabController!.length == totalTabs) {
      return;
    }

    _tabController?.dispose();

    _tabController = TabController(
      length: totalTabs,
      vsync: this,
      initialIndex: _selectedCategoryIndex,
    );

    _tabController!.addListener(() {
      final controller = _tabController;

      if (controller == null) return;

      if (controller.indexIsChanging) {
        return;
      }

      final index = controller.index;

      if (index < 0 || index >= totalTabs) {
        return;
      }

      // ==========================================================
      // BEST SELLERS - INDEX 0
      // ==========================================================

      if (index == 0) {
        if (!mounted) return;

        setState(() {
          _selectedCategoryIndex = 0;
        });

        return;
      }

      // ==========================================================
      // NORMAL CATEGORY
      // ==========================================================

      final categoryIndex = index - 1;

      if (categoryIndex >= 0 && categoryIndex < categories.length) {
        _onCategorySelected(categoryIndex, categories[categoryIndex]);
      }
    });

    setState(() {});
  }

  // ==============================================================
  // CATEGORY SELECT
  // ==============================================================

  Future<void> _onCategorySelected(int index, CategoryList category) async {
    if (!mounted) return;

    // +1 because Best Sellers occupies index 0.
    setState(() {
      _selectedCategoryIndex = index + 1;
    });

    final categoryId = category.id;

    if (categoryId == null) return;

    await context.read<ShopProvider>().fetchProductsByCategory(
      categoryId.toString(),
    );
  }

  // ==============================================================
  // DISPOSE
  // ==============================================================

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);

    final productsProvider = context.watch<ProductsProvider>();

    final shopProvider = context.watch<ShopProvider>();

    // ============================================================
    // SEARCH
    // ============================================================

    if (productsProvider.searchController.text.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.isMobile || responsive.isTablet
                    ? 20
                    : 80.0,
              ),
              child: AdditionalProductsGrid(
                products: productsProvider.filteredAdditionalProducts,
                isShop: true,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      );
    }

    // ============================================================
    // PRODUCTS
    // ============================================================

    return PageView(
      controller: shopProvider.shopPageController,
      onPageChanged: shopProvider.changeShopPage,
      children: [
        Consumer<ShopProvider>(
          builder: (context, shopProvider, child) {
            final categories = shopProvider.categories;

            if (categories.isEmpty) {
              return const SizedBox.shrink();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _handleFooterCategory();
              }
            });

            // +1 because Best Sellers is
            // the first tab.
            if (_selectedCategoryIndex > categories.length) {
              _selectedCategoryIndex = 0;
            }

            // ======================================================
            // CREATE TAB CONTROLLER
            // ======================================================

            if (_tabController == null ||
                _tabController!.length != categories.length + 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _createTabController(categories);
                }
              });

              return const SizedBox.shrink();
            }

            // ======================================================
            // BEST SELLER CHECK
            // ======================================================

            final isBestSeller = _selectedCategoryIndex == 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==================================================
                // CATEGORY TAB BAR
                // ==================================================
                _buildCategoryTabBar(categories),

                // ==================================================
                // CONTENT
                // ==================================================
                Expanded(
                  child: isBestSeller
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: const [BestSellerTab(), GwcFooter()],
                          ),
                        )
                      : CategoryByProducts(
                          key: ValueKey(
                            categories[_selectedCategoryIndex - 1].id,
                          ),
                          category: categories[_selectedCategoryIndex - 1],
                        ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ==============================================================
  // CATEGORY TAB BAR
  // ==============================================================

  Widget _buildCategoryTabBar(List<CategoryList> categories) {
    final isMobile = ScreenSizeHelper(context).isMobile;

    if (categories.isEmpty || _tabController == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: isMobile ? 70 : 96,
      decoration: BoxDecoration(
        color: gWhiteColor,
        border: Border(
          bottom: BorderSide(color: borderColor.withAlpha(120), width: 1),
        ),
      ),
      child: Center(
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 12),
          labelPadding: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 5),
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,

          // ========================================================
          // TABS
          // ========================================================
          tabs: [
            // ======================================================
            // BEST SELLERS - FIRST TAB
            // ======================================================
            _CategoryTabItem(
              controller: _tabController!,
              index: 0,
              categoryName: 'Best Sellers',
              isMobile: isMobile,
              isBestSeller: true,
            ),

            // ======================================================
            // EXISTING CATEGORY TABS
            // ======================================================
            ...List.generate(categories.length, (index) {
              final category = categories[index];

              return _CategoryTabItem(
                controller: _tabController!,

                // +1 because Best Sellers
                // is index 0.
                index: index + 1,

                categoryName: category.name ?? '',

                isMobile: isMobile,
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// CATEGORY TAB ITEM
// ==================================================================

class _CategoryTabItem extends StatefulWidget {
  final TabController controller;
  final int index;
  final String categoryName;
  final bool isMobile;
  final bool isBestSeller;

  const _CategoryTabItem({
    required this.controller,
    required this.index,
    required this.categoryName,
    required this.isMobile,
    this.isBestSeller = false,
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
    final isSelected = widget.controller.index == widget.index;

    final double tabWidth = widget.isMobile ? 76 : 118;

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
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        },
        child: SizedBox(
          width: tabWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: widget.isMobile ? 30 : 34,
                child: Center(child: _buildExistingIcon(isSelected)),
              ),

              SizedBox(height: widget.isMobile ? 3 : 4),

              SizedBox(
                height: 25,
                width: double.infinity,
                child: Text(
                  widget.categoryName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w800,
                    color: isSelected ? gMainColor : gPrimaryColor,
                    fontSize: widget.isMobile ? 9.5 : fontSize10,
                    height: 1.05,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // ICON
  // ==============================================================

  Widget _buildExistingIcon(bool isSelected) {
    // ============================================================
    // BEST SELLER ICON
    // ============================================================

    if (widget.isBestSeller) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.isMobile ? 28 : 32,
        height: widget.isMobile ? 28 : 32,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(widget.isMobile ? 1.5 : 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gWhiteColor,
              border: Border.all(
                color: isSelected ? gMainColor : gPrimaryColor,
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
            child: Icon(
              Icons.local_fire_department_rounded,
              color: isSelected ? gMainColor : gPrimaryColor,
              size: widget.isMobile ? 14 : 17,
            ),
          ),
        ),
      );
    }

    // ============================================================
    // EXISTING CATEGORY ICONS
    // ============================================================

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
      duration: const Duration(milliseconds: 200),
      width: widget.isMobile ? 28 : 32,
      height: widget.isMobile ? 28 : 32,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(widget.isMobile ? 1.5 : 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: gWhiteColor,
            border: Border.all(
              color: isSelected ? gMainColor : gPrimaryColor,
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
            padding: EdgeInsets.all(widget.isMobile ? 3 : 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: gWhiteColor,
            ),
            child: Icon(
              getCategoryIcon(widget.categoryName),
              color: isSelected ? gMainColor : gPrimaryColor,
              size: widget.isMobile ? 12 : 14,
            ),
          ),
        ),
      ),
    );
  }
}
