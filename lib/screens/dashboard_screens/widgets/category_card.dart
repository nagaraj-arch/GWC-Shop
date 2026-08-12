import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/utils/app_config.dart';
import 'package:gwc_shop/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../controllers/providers/shop_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class CategoryCard extends StatefulWidget {
  final CategoryList item;
  final double width;
  final double height;
  final double? imageHeight;
  final EdgeInsetsGeometry? margin;
  final bool showShadow;

  const CategoryCard({
    super.key,
    required this.item,
    this.width = 460,
    this.height = 260,
    this.imageHeight,
    this.margin = EdgeInsets.zero,
    this.showShadow = true,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool hover = false;

  void _navigate() async {
    debugPrint("Clicked ${widget.item.id}");

    final prefs = AppConfig().preferences;
    await prefs?.setString("selectedCategory", widget.item.id.toString());

    debugPrint(
      "Saved selectedCategory = ${prefs?.getString("selectedCategory")}",
    );

    // ✅ If archived, always go to Launching screen
    if (widget.item.isArchived?.trim() == "1") {
      context.go('/launching');
      return;
    }

    // ✅ Food Farmacy
    if (widget.item.id == 32) {
      final shopProvider = context.read<ShopProvider>();

      shopProvider.changeTab(1);
      context.go('/');
      return;
    }

    // ✅ Other categories
    context.go('/category/${widget.item.id}');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: _navigate,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: gBgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: hover && widget.showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: ThumbnailView(
                    context: context,
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl: widget.item.thumbnail,
                    enablePreview: false,
                    borderRadius: 0,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: (widget.width * 0.04).clamp(12.0, 22.0),
                    ),
                    decoration: const BoxDecoration(color: gPrimaryColor),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Explore ${SafeString().toTitleCase(widget.item.name ?? '')} Categories",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cormorantGaramond(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: (widget.width * 0.037).clamp(12.0, 18.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: gWhiteColor,
                          size: (widget.width * 0.05).clamp(16.0, 22.0),
                        ),
                      ],
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
}
