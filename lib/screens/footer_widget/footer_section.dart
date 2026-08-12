import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../controllers/providers/shop_provider.dart';
import '../../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../widgets/container_widgets/common_divider.dart';

class GwcFooter extends StatelessWidget {
  const GwcFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final isDesktop = width >= 1000;

        final pagePadding = (width * 0.075).clamp(20.0, 150.0);
        final verticalPadding = (width * 0.025).clamp(20.0, 40.0);

        final copyrightSize = ((width * 0.0085) * 0.80).clamp(10.0, 14.0);

        return Container(
          color: gTapColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonDivider(color: borderColor, verticalMargin: 0),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: pagePadding,
                  vertical: verticalPadding,
                ),
                child: const FooterLinks(),
              ),

              CommonDivider(color: borderColor),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: pagePadding,
                  vertical: isDesktop ? verticalPadding : 20,
                ),
                child: Column(
                  children: [
                    // Text(
                    //   "GWC products are foods. They support everyday digestive comfort and nourishment, and are not intended to prevent, treat or cure any disease.",
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.inter(
                    //     fontSize: disclaimerSize,
                    //     color: Colors.grey,
                    //     fontStyle: FontStyle.italic,
                    //     height: 1.5,
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: copyrightSize,
                          color: const Color(0xff7A7A7A),
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: "© ",
                          ),
                          TextSpan(
                            text: "2026 Fembuddy Private Limited • Bengaluru",
                            style: GoogleFonts.inter(
                              fontSize: copyrightSize + 3,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff555555),
                            ),
                          ),
                          TextSpan(
                            text: "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final categories = provider.categories;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isDesktop = width >= 900;
        final sectionGap = (width * 0.06).clamp(24.0, 90.0);

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Flexible(flex: 4, child: _LogoSection()),

              SizedBox(width: sectionGap),

              Flexible(
                flex: 5,
                child: _CategoryMenu(title: "SHOP", categories: categories),
              ),

              SizedBox(width: sectionGap),

              const Flexible(
                flex: 3,
                child: _Menu(
                  title: "ABOUT",
                  items: [
                    "Terms & Conditions",
                    "Refunds & Cancellations",
                    "Contact Us",
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LogoSection(),

            SizedBox(height: (width * 0.08).clamp(24.0, 35.0)),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CategoryMenu(title: "SHOP", categories: categories),
                ),

                SizedBox(width: (width * 0.06).clamp(16.0, 30.0)),

                Expanded(
                  child: _Menu(
                    title: "ABOUT",
                    items: const [
                      "Terms & Conditions",
                      "Refunds & Cancellations",
                      "Contact Us",
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final logoHeight = (width * 0.15).clamp(44.0, 72.0);
        final descSize = ((width * 0.04) * 0.90).clamp(12.0, 15.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/Gut welness logo.png",
              height: logoHeight,
            ),

            const SizedBox(height: 18),

            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: (width * 0.85).clamp(280.0, 360.0),
              ),
              child: Text(
                "Address what is troubling your gut.\n"
                "Maintain its natural biological rhythm.\n"
                "Nourish it with right food choices.",
                style: GoogleFonts.inter(
                  fontSize: descSize,
                  height: 1.7,
                  color: const Color(0xff666666),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryMenu extends StatelessWidget {
  final String title;
  final List<CategoryList> categories;

  const _CategoryMenu({required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 900;

        final screenWidth = MediaQuery.sizeOf(context).width;

        final titleSize =
        ((screenWidth * 0.012) * 0.80).clamp(13.0, 18.0);

        final itemSize =
        ((screenWidth * 0.010) * 0.80).clamp(11.0, 15.0);

        // Always keep category items in two columns.
        final columnSpacing = (width * 0.025).clamp(12.0, 24.0);

        final itemWidth = isDesktop
            ? ((width - columnSpacing) / 2).clamp(150.0, 240.0)
            : ((width - columnSpacing) / 2).clamp(120.0, 220.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Avenir",
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
                color: gHintTextColor,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 18),

            Wrap(
              spacing: columnSpacing,
              runSpacing: 12,
              children: categories.map((cat) {
                return SizedBox(
                  width: itemWidth,
                  child: FooterMenuItem(
                    text: cat.name ?? '',
                    itemSize: itemSize,
                    onTap: () async {
                      debugPrint("Clicked ${cat.id}");

                      final prefs = AppConfig().preferences;
                      await prefs?.setString("selectedCategory", cat.id.toString());

                      debugPrint(
                        "Saved selectedCategory = ${prefs?.getString("selectedCategory")}",
                      );

                      // ✅ If archived, always go to Launching screen
                      if (cat.isArchived?.trim() == "1") {
                        context.go('/launching');
                        return;
                      }

                      // ✅ Food Farmacy
                      if (cat.id == 32) {
                        final shopProvider = context.read<ShopProvider>();

                        shopProvider.changeTab(1);
                        context.go('/');
                        return;
                      }

                      // ✅ Other categories
                      context.go('/category/${cat.id}');
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

enum FooterMenuType { shop, learn, about }

class _Menu extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Menu({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.sizeOf(context).width;

        final titleSize =
        ((screenWidth * 0.012) * 0.80).clamp(13.0, 18.0);

// ABOUT text slightly increased to visually match uppercase SHOP text
        final itemSize =
        ((screenWidth * 0.010) * 0.88).clamp(12.0, 16.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Avenir",
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
                color: gHintTextColor,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 18),

            ...items.map((e) {
              VoidCallback? onTap;

              onTap = () {
                context.go('/page/${Uri.encodeComponent(e)}');
              };

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FooterMenuItem(
                  text: e,
                  itemSize: itemSize,
                  onTap: onTap,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class FooterMenuItem extends StatefulWidget {
  final String text;
  final double? itemSize;
  final VoidCallback? onTap;

  const FooterMenuItem({
    super.key,
    required this.text,
    this.itemSize,
    this.onTap,
  });

  @override
  State<FooterMenuItem> createState() => _FooterMenuItemState();
}

class _FooterMenuItemState extends State<FooterMenuItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.itemSize ?? 16.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontSize: fontSize,
                  fontWeight: hover ? FontWeight.w600 : FontWeight.w500,
                  color: hover ? gMainColor : gHintTextColor,
                  letterSpacing: 0.2,
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: hover ? 1.04 : 1.0,
                  alignment: Alignment.centerLeft,
                  child: Text(widget.text),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: hover ? (fontSize * 2.5).clamp(32.0, 48.0) : 0,
                decoration: BoxDecoration(
                  color: const Color(0xffB7861A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
