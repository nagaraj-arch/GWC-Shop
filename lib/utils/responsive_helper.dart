import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;

  ResponsiveHelper(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // bool get isDesktop    => screenWidth >= 1024 && screenWidth < 1440;
  // bool get  isLaptop => screenWidth >= 1440 && screenWidth < 1920;
  // bool get isLargeDesktop => screenWidth >= 1920 && screenWidth < 2560;
  // bool get isUltraWide => screenWidth >= 2560;
}

class ScreenSizeHelper {
  final BuildContext context;

  ScreenSizeHelper(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Mobile Breakpoints
  // bool get isMiniMobile => screenWidth >= 100 && screenWidth < 400;
  bool get isMobile => screenWidth >= 100 && screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Desktop Breakpoints
  bool get isLaptop => screenWidth >= 1024 && screenWidth < 1600;
  bool get isDesktop => screenWidth >= 1600 && screenWidth < 1920;
  bool get isLargeDesktop => screenWidth >= 1920 && screenWidth < 2560;
  bool get isUltraWide => screenWidth >= 2560;
}
