import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/products_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/button_widgets/icon_button.dart';

class ProductSortWidget extends StatefulWidget {
  const ProductSortWidget({super.key});

  @override
  State<ProductSortWidget> createState() => _ProductSortWidgetState();
}

class _ProductSortWidgetState extends State<ProductSortWidget> {
  /// Sort Menu
  final MenuController controller = MenuController();

  /// Overlay
  OverlayEntry? _tagOverlay;

  /// GlobalKey of Special Tag row
  final GlobalKey _tagKey = GlobalKey();
  final GlobalKey _selectedTagKey = GlobalKey();

  bool _popupVisible = false;

  bool _hoverMenu = false;
  bool _hoverPopup = false;

  @override
  void dispose() {
    _hideTagPopup();
    super.dispose();
  }

  void _hideTagPopup() {
    if (!_popupVisible) return;

    _tagOverlay?.remove();
    _tagOverlay = null;
    _popupVisible = false;
  }

  void _checkClosePopup() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_hoverMenu && !_hoverPopup) {
        _hideTagPopup();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (_, provider, __) {
        final hasSort = provider.selectedSort != "default";

        return MenuAnchor(
          controller: controller,
          alignmentOffset: const Offset(0, 8),
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(gWhiteColor),
            elevation: const WidgetStatePropertyAll(8),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 6),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          menuChildren: [
            _menuItem(
              Icons.arrow_upward,
              "Price : Low → High",
              "price_low",
              provider,
            ),
            const Divider(height: 1),
            _menuItem(
              Icons.arrow_downward,
              "Price : High → Low",
              "price_high",
              provider,
            ),
            const Divider(height: 1),
            _menuItem(
              Icons.sort_by_alpha,
              "A → Z",
              "az",
              provider,
            ),
            const Divider(height: 1),
            _menuItem(
              Icons.sort_by_alpha,
              "Z → A",
              "za",
              provider,
            ),
            // const Divider(height: 1),
            // _specialTagButton(provider),
          ],
          builder: (context, menuController, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasSort)
                  _selectedChip(
                    provider,
                    () {
                      menuController.isOpen
                          ? menuController.close()
                          : menuController.open();
                    },
                  )
                else
                  _filterButton(menuController),
                if (provider.selectedSpecialTag.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _selectedTagChip(
                    provider,
                        () {
                      _showTagPopup(provider);
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Widget _filterButton(MenuController menuController) {
    return IconButtonWidget(
      msg: "Sort",
      icon: Icons.filter_alt_outlined,
      onTap: () {
        menuController.isOpen ? menuController.close() : menuController.open();
      },
    );
  }

  void _showTagPopup(ProductsProvider provider) {
    if (_popupVisible) return;

    final BuildContext anchorContext;

    if (provider.selectedSpecialTag.isNotEmpty &&
        _selectedTagKey.currentContext != null) {
      anchorContext = _selectedTagKey.currentContext!;
    } else {
      anchorContext = _tagKey.currentContext!;
    }

    final RenderBox box =
    anchorContext.findRenderObject() as RenderBox;

    final Offset position = box.localToGlobal(Offset.zero);

    _tagOverlay = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideTagPopup,
              ),
            ),
            Positioned(
              left: position.dx - 270,
              top: position.dy - 8,
              child: MouseRegion(
                onEnter: (_) {
                  _hoverPopup = true;
                },
                onExit: (_) {
                  _hoverPopup = false;

                  if (MediaQuery.of(context).size.width > 900) {
                    _checkClosePopup();
                  }
                },
                child: Material(
                  elevation: 12,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 260,
                    constraints: const BoxConstraints(
                      maxHeight: 360,
                    ),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      itemCount: provider.specialTags.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (_, index) {
                        final tag = provider.specialTags[index];

                        final selected = provider.selectedSpecialTag == tag;

                        return InkWell(
                          hoverColor: const Color(0xffF8F9FA),
                          onTap: () {
                            if (selected) {
                              provider.clearSpecialTag();
                            } else {
                              provider.changeSpecialTag(tag);
                            }

                            _hideTagPopup();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            height: 46,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            color: selected
                                ? gPrimaryColor.withAlpha(18)
                                : Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 18,
                                  color:
                                      selected ? gPrimaryColor : gHintTextColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    tag,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize10,
                                      fontFamily:
                                          selected ? fontBold : fontMedium,
                                      color: selected
                                          ? gPrimaryColor
                                          : gBlackColor,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Icon(
                                    Icons.check_circle,
                                    color: gPrimaryColor,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(
      _tagOverlay!
    );

    _popupVisible = true;
  }

  Widget _menuItem(
    IconData icon,
    String title,
    String value,
    ProductsProvider provider,
  ) {
    final selected = provider.selectedSort == value;
    return MenuItemButton(
      style: MenuItemButton.styleFrom(
        minimumSize: const Size(240, 42),
        backgroundColor: selected ? gsecondaryColor.withAlpha(10) : gWhiteColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 20,
        ),
      ),
      leadingIcon: Icon(
        icon,
        size: 2.h,
        color: selected ? gsecondaryColor : gHintTextColor,
      ),
      trailingIcon: selected
          ? Icon(
              Icons.check_circle,
              size: 2.h,
              color: gsecondaryColor,
            )
          : null,
      onPressed: () {
        provider.changeSort(value);
        controller.close();
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: selected ? fontSize11 : fontSize10,
          fontFamily: selected ? fontBold : fontMedium,
          color: selected ? gsecondaryColor : gHintTextColor,
        ),
      ),
    );
  }

  Widget _selectedChip(ProductsProvider provider, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 38,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffFFF8E8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffFFD58A),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sort,
                size: 16,
                color: gPrimaryColor,
              ),
              const SizedBox(width: 5),
              Text(
                provider.sortTitle,
                style: TextStyle(
                  fontSize: 10.dp,
                  fontFamily: fontMedium,
                  color: gPrimaryColor,
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  provider.changeSort(
                    "default",
                  );
                },
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedTagChip(ProductsProvider provider, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        key: _selectedTagKey,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (_popupVisible) {
              _hideTagPopup();
            } else {
              controller.close();
              _showTagPopup(provider);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 38,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffEEF9F1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 5),
                Text(
                  provider.selectedSpecialTag,
                  style: TextStyle(
                    fontSize: 10.dp,
                    fontFamily: fontMedium,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    provider.clearSpecialTag();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
