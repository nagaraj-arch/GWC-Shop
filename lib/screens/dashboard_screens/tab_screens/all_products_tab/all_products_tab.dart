import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/models/shop_models/category_model.dart';
import '../../../../controllers/providers/shop_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import 'category_by_products.dart';

class AllProductsTab extends StatefulWidget {
  const AllProductsTab({super.key});

  @override
  State<AllProductsTab> createState() => _AllProductsTabState();
}

class _AllProductsTabState extends State<AllProductsTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int _selectedCategoryIndex = 0;
  bool _firstProductsLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupTabs();
    });
  }

  void _setupTabs() {
    if (!mounted) return;

    final provider = context.read<ShopProvider>();
    final categories = provider.categories;

    if (categories.isEmpty) return;

    if (_selectedCategoryIndex >= categories.length) {
      _selectedCategoryIndex = 0;
    }

    _createTabController(categories);

    if (!_firstProductsLoaded) {
      _firstProductsLoaded = true;

      final firstCategory = categories[_selectedCategoryIndex];

      if (firstCategory.id != null) {
        provider.fetchProductsByCategory(firstCategory.id.toString());
      }
    }
  }

  void _createTabController(List<CategoryList> categories) {
    if (!mounted || categories.isEmpty) return;

    if (_selectedCategoryIndex >= categories.length) {
      _selectedCategoryIndex = 0;
    }

    if (_tabController != null && _tabController!.length == categories.length) {
      return;
    }

    _tabController?.dispose();

    _tabController = TabController(
      length: categories.length,
      vsync: this,
      initialIndex: _selectedCategoryIndex,
    );

    _tabController!.addListener(() {
      final controller = _tabController;

      if (controller == null) return;
      if (controller.indexIsChanging) return;

      final index = controller.index;

      if (index < 0 || index >= categories.length) return;

      _onCategorySelected(index, categories[index]);
    });

    setState(() {});
  }

  Future<void> _onCategorySelected(int index, CategoryList category) async {
    if (!mounted) return;

    setState(() {
      _selectedCategoryIndex = index;
    });

    final categoryId = category.id;

    if (categoryId == null) return;

    await context.read<ShopProvider>().fetchProductsByCategory(
      categoryId.toString(),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories;

        // DashboardScreen handles the category loading indicator.
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        if (_selectedCategoryIndex >= categories.length) {
          _selectedCategoryIndex = 0;
        }

        if (_tabController == null ||
            _tabController!.length != categories.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _createTabController(categories);
            }
          });

          return const SizedBox.shrink();
        }

        final selectedCategory = categories[_selectedCategoryIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryTabBar(categories),
            Expanded(
              child: CategoryByProducts(
                key: ValueKey(selectedCategory.id),
                category: selectedCategory,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryTabBar(
      List<CategoryList> categories,
      ) {
    final isMobile = ScreenSizeHelper(context).isMobile;

    if (categories.isEmpty || _tabController == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: isMobile ? 80 : 96,
      decoration: BoxDecoration(
        color: gWhiteColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor.withAlpha(120),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: SizedBox(
          height: isMobile ? 68 : 78,
          child: TabBar(
            controller: _tabController,

            isScrollable: true,

            // ⭐ Important — don't spread tabs
            tabAlignment: TabAlignment.center,

            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 6 : 12,
            ),

            // ⭐ Reduce space between tabs
            labelPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 2 : 5,
            ),

            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,

            overlayColor: WidgetStateProperty.all(
              Colors.transparent,
            ),

            splashFactory: NoSplash.splashFactory,

            tabs: List.generate(
              categories.length,
                  (index) {
                final category = categories[index];

                return _CategoryTabItem(
                  controller: _tabController!,
                  index: index,
                  categoryName: category.name ?? '',
                  isMobile: isMobile,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTabItem extends StatefulWidget {
  final TabController controller;
  final int index;
  final String categoryName;
  final bool isMobile;

  const _CategoryTabItem({
    required this.controller,
    required this.index,
    required this.categoryName,
    required this.isMobile,
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
    final isSelected =
        widget.controller.index == widget.index;

    // ⭐ Reduced width
    final double tabWidth = widget.isMobile
        ? 76
        : 118;

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
            duration: const Duration(
              milliseconds: 280,
            ),
            curve: Curves.easeOutCubic,
          );
        },
        child: SizedBox(
          width: tabWidth,

          // ⭐ Fixed height keeps every tab aligned
          height: widget.isMobile ? 64 : 72,

          child: AnimatedScale(
            scale: isSelected ? 1.0 : 1.0,
            duration: const Duration(
              milliseconds: 200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ==================================================
                // ICON
                // ==================================================

                SizedBox(
                  height: widget.isMobile ? 30 : 34,
                  child: Center(
                    child: _buildExistingIcon(
                      isSelected,
                    ),
                  ),
                ),

                SizedBox(
                  height: widget.isMobile ? 3 : 4,
                ),

                // ==================================================
                // TEXT
                // ==================================================

                SizedBox(
                  height: widget.isMobile ? 28 : 32,
                  width: double.infinity,
                  child: Text(
                    widget.categoryName,
                    textAlign: TextAlign.center,

                    maxLines: 2,
                    softWrap: true,

                    // No "..."
                    overflow: TextOverflow.clip,

                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? gPrimaryColor
                          : gHintTextColor,
                      fontSize: widget.isMobile
                          ? 9.5
                          : fontSize10,
                      height: 1.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // KEEP YOUR EXISTING ICON DESIGN HERE
  // ==============================================================

  Widget _buildExistingIcon(bool isSelected) {

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
      duration: const Duration(
        milliseconds: 200,
      ),
      width: widget.isMobile ? 28 : 32,
      height: widget.isMobile ? 28 : 32,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(
            widget.isMobile ? 1.5 : 2,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: gWhiteColor,
            border: Border.all(
              color: isSelected
                  ? gPrimaryColor
                  : borderColor,
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
            padding: EdgeInsets.all(
              widget.isMobile ? 3 : 4,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? gPrimaryColor
                  : gWhiteColor,
            ),
            child: Icon(
              getCategoryIcon(widget.categoryName),
              color: isSelected
                  ? gWhiteColor
                  : gPrimaryColor,
              size: widget.isMobile ? 12 : 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTabItems extends StatefulWidget {
  final TabController controller;
  final int index;
  final String categoryName;
  final bool isMobile;

  const _CategoryTabItems({
    required this.controller,
    required this.index,
    required this.categoryName,
    required this.isMobile,
  });

  @override
  State<_CategoryTabItems> createState() => _CategoryTabItemsState();
}

class _CategoryTabItemsState extends State<_CategoryTabItems> {
  bool isHovered = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  IconData _getCategoryIcon(String name) {
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

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.controller.index == widget.index;

    final scale = isSelected || isHovered ? 1.08 : 1.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        scale: scale,
        alignment: Alignment.center,

        child: SizedBox(
          width: widget.isMobile ? 120 : 140,

          // ⭐ Give scale enough breathing room
          height: widget.isMobile ? 60 : 64,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ---------------- ICON ----------------

              SizedBox(
                // was 34
                height: 30,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(
                      widget.isMobile ? 1.5 : 2,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gWhiteColor,
                      border: Border.all(
                        color: isSelected
                            ? gPrimaryColor
                            : borderColor,
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
                      padding: EdgeInsets.all(
                        widget.isMobile ? 3 : 4,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? gPrimaryColor
                            : gWhiteColor,
                      ),
                      child: Icon(
                        _getCategoryIcon(widget.categoryName),
                        color: isSelected
                            ? gWhiteColor
                            : gPrimaryColor,
                        size: widget.isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                ),
              ),

              // ---------------- GAP ----------------

              SizedBox(
                height: widget.isMobile ? 2 : 3,
              ),

              // ---------------- TEXT ----------------

              SizedBox(
                width: double.infinity,

                // was 32
                height: 26,

                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.categoryName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? gPrimaryColor
                          : gHintTextColor,
                      fontSize: fontSize10,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
