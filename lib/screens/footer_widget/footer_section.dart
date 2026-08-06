import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gwc_shop/utils/constants.dart';
import 'package:gwc_shop/widgets/container_widgets/common_divider.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../controllers/providers/shop_provider.dart';
import '../../../utils/app_config.dart';
import '../../../utils/responsive_helper.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final disclaimerSize = isDesktop ? 11.0 : 10.0;
    final copyrightSize = isDesktop ? 13.0 : 12.0;

    return Container(
      color: gTapColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommonDivider(color: borderColor, verticalMargin: 0),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 150 : 20,
              vertical: isDesktop ? 40 : 30,
            ),
            child: const FooterLinks(),
          ),
          CommonDivider(color: borderColor),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 150 : 20,
              vertical: isDesktop ? 40 : 20,
            ),
            child: Column(
              children: [
                Text(
                  "GWC products are foods. They support everyday digestive comfort and nourishment, and are not intended to prevent, treat or cure any disease.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: disclaimerSize,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "© 2026 Farmbody Private Limited • Bengaluru • FSSAI Lic. No. placeholder",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: copyrightSize,
                    color: const Color(0xff7A7A7A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    final provider = context.watch<ShopProvider>();
    final categories = provider.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isDesktop
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _LogoSection(),
            _CategoryMenu(title: "SHOP", categories: categories),
            _Menu(
              title: "ABOUT",
              items: [
                "Terms & Conditions",
                "Refunds & Cancellations",
                "Contact Us",
              ],
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LogoSection(),
            const SizedBox(height: 35),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CategoryMenu(
                    title: "SHOP",
                    categories: categories,
                  ),
                ),
                Expanded(
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
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryMenu extends StatelessWidget {
  final String title;
  final List<CategoryList> categories;

  const _CategoryMenu({required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final titleSize = isDesktop ? 18.0 : 16.0;
    final itemSize = isDesktop ? 16.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xff666666),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: isDesktop ? 400 : double.infinity,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((cat) {
              return SizedBox(
                width: isDesktop
                    ? 194
                    : (MediaQuery.of(context).size.width * 0.45) - 20,
                child: FooterMenuItem(
                  text: cat.name ?? '',
                  itemSize: itemSize,
                  onTap: () async {
                    final prefs = AppConfig().preferences;
                    await prefs?.setString(
                      "selectedCategory",
                      cat.id.toString(),
                    );

                    context.go('/category/${cat.id}');
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final logoHeight = isDesktop ? 60.0 : 44.0;
    final descSize = isDesktop ? 15.0 : 13.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset("assets/images/Gut welness logo.png", height: logoHeight),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            "Address what is troubling your gut.\n"
                "Maintain its natural biological rhythm.\n"
                "Nourish it with 100% everyday food choices.",
            style: GoogleFonts.inter(
              fontSize: descSize,
              height: 1.7,
              color: const Color(0xff666666),
            ),
          ),
        ),
      ],
    );
  }
}

enum FooterMenuType { shop, learn, about }

class _Menu extends StatelessWidget {
  final String title;
  final List<String> items;
  final FooterMenuType menuType;

  const _Menu({
    required this.title,
    required this.items,
    this.menuType = FooterMenuType.about,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final titleSize = isDesktop ? 18.0 : 16.0;
    final itemSize = isDesktop ? 16.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xff666666),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 18),
        ...items.map((e) {
          VoidCallback? onTap;

          if (menuType == FooterMenuType.about) {
            onTap = () {
              context.go('/page/${Uri.encodeComponent(e)}');
            };
          }

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
                style: GoogleFonts.inter(
                  fontSize: fontSize,
                  fontWeight:
                  hover ? FontWeight.w700 : FontWeight.w500,
                  color: hover
                      ? const Color(0xffB7861A)
                      : const Color(0xff555555),
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
                width: hover ? 40 : 0,
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
