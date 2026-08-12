import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/shop_provider.dart';
import '../../utils/constants.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      "All Products",
      "Shop Food Farmacy",
      "Learn"
      // "Shop Gut Rhythm Products",
      // "Learn",
      // "Our Story",
    ];

    return Drawer(
      child: SafeArea(
        child: Consumer<ShopProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: menus.length,
              itemBuilder: (_, index) {
                final selected = provider.selectedTab == index;

                return ListTile(
                  selected: selected,
                  selectedTileColor: gPrimaryColor.withOpacity(0.08),
                  title: Text(
                    menus[index],
                    style: GoogleFonts.inter(
                      fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? gPrimaryColor : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: selected ? gPrimaryColor : Colors.grey,
                  ),
                  onTap: () {
                    final shopProvider = context.read<ShopProvider>();
                    final isSameTab = shopProvider.selectedTab == index;

                    Navigator.of(context).pop();

                    if (GoRouterState.of(context).uri.path != "/") {
                      context.go("/");
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      shopProvider.changeTab(index);

                      if (isSameTab) {
                        shopProvider.onTabReClicked(index);
                      }
                    });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}