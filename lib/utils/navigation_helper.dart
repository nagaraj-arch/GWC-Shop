import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  /// -------------------------------
  /// GO ROUTER BASED NAVIGATION
  /// -------------------------------

  /// Push (keeps previous page → back works)
  static void goPush(
      BuildContext context,
      String location, {
        Map<String, dynamic>? extra,
      }) {
    context.push(location, extra: extra);
  }

  /// Replace current route (no back)
  static void goReplace(
      BuildContext context,
      String location, {
        Map<String, dynamic>? extra,
      }) {
    context.go(location, extra: extra);
  }

  /// Safe back (prevents "nothing to pop")
  static void goBack(
      BuildContext context, {
        String fallback = '/dash',
      }) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallback);
    }
  }

  /// -------------------------------
  /// NAVIGATOR (legacy support)
  /// -------------------------------

  static void push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void pushAndRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
          (route) => false,
    );
  }

  static void pop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
