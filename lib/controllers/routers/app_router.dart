import 'package:go_router/go_router.dart';
import 'package:gwc_shop/screens/launching_soon_screens/launching_soon.dart';

import '../../screens/cart_screen/cart_screen.dart';
import '../../screens/category_page/category_page.dart';
import '../../screens/dashboard_screens/dashboard_screen.dart';
import '../../screens/footer_widget/about_section.dart';
import '../../screens/product_screens/product_screen.dart';
import '../../screens/track_my_order_screen/track_order.dart';

/// ✅ App Router (like shipping app)
final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  /// 🔥 Redirect (future ready for login)
  redirect: (context, state) {
    return null;
  },

  routes: [
    /// 🏠 Home
    GoRoute(
      path: '/',
      builder: (context, state) =>
          // BannerPage(),
      DashboardScreen()
    ),

    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CategoryPage(categoryId: id);
      },
    ),

    GoRoute(
      path: '/products',
      builder: (context, state) => ProductScreen(),
    ),

    /// 🛒 Cart
    GoRoute(path: '/cart', builder: (context, state) => CartScreen()),

    /// 📦 Order Tracking
    GoRoute(path: '/order', builder: (context, state) => TrackOrder()),

    /// 📄 Footer Pages
    GoRoute(
      path: '/page/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return AboutSection(title: name);
      },
    ),

    GoRoute(path: '/launching', builder: (context, state) => LaunchingSoon()),

  ],
);
