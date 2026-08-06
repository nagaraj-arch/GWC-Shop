import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_shop/controllers/providers/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/providers/cart_provider.dart';
import 'controllers/providers/products_providers.dart';
import 'controllers/providers/track_my_order_provider.dart';
import 'controllers/routers/app_router.dart';
import 'screens/product_screens/widgets/cart_button.dart';
import 'utils/app_config.dart';
import 'widgets/button_widgets/floating_shop_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  AppConfig().preferences = prefs;

  debugPaintSizeEnabled = false;
  debugRepaintRainbowEnabled = false;

  // ✅ Clear cart only if first time
  bool isFirstTimeUser = prefs.getBool('first_time_user') ?? true;
  if (isFirstTimeUser) {
    await prefs.remove('cart');
    await prefs.setBool('first_time_user', false);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ShopProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
            ChangeNotifierProvider(
              create: (_) => ProductsProvider()..fetchAdditionalProducts(),
            ),
            ChangeNotifierProvider(create: (_) => TrackMyOrderProvider()),
          ],
          child: PopScope(
            canPop: false,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              scrollBehavior: MyCustomScrollBehavior(),
              builder: (context, child) {
                return Stack(
                  children: [
                    // Your main app content
                    child ?? const SizedBox.shrink(),
                    // ✅ Global cart button overlay - shows on ALL pages

                    Positioned(
                      right:30,
                      bottom: 20, // above cart button
                      child: SafeArea(child: FloatingShopButton()),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: const SafeArea(
                        child: Center(
                          child: GlobalCartButton(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<ui.PointerDeviceKind> get dragDevices => {
    ui.PointerDeviceKind.touch,
    ui.PointerDeviceKind.mouse,
    ui.PointerDeviceKind.trackpad,
  };
}
