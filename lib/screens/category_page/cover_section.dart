import 'package:flutter/material.dart';

import '../../utils/responsive_helper.dart';
import '../../widgets/iamge_picker_widget/thumbnail_view.dart';

class CoverSection extends StatelessWidget {
  final String? coverImage;
  final String? coverImageMobile;
  final String? coverImageLaptop;
  final String? coverImageTab;
  final String? coverImageDesktop;
  final String? coverTitle;
  final String? coverDesc;
  const CoverSection({
    super.key,
    this.coverImage,
    this.coverImageMobile,
    this.coverImageLaptop,
    this.coverImageTab,
    this.coverImageDesktop,
    this.coverTitle,
    this.coverDesc,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final mobileDesign = responsive.isMobile || responsive.isTablet;

    // final screenWidth = responsive.screenWidth;
    //
    // late final double bannerHeight;
    //
    // if (screenWidth <= 500) {
    //   // 500px and below
    //   bannerHeight = screenWidth * 0.40;
    // } else if (screenWidth <= 600) {
    //   // 501px - 600px
    //   bannerHeight = screenWidth * 0.45;
    // } else if (responsive.isTablet) {
    //   bannerHeight = screenWidth * 0.50;
    // } else if (responsive.isLaptop) {
    //   bannerHeight = screenWidth * 0.45;
    // } else if (responsive.isDesktop) {
    //   bannerHeight = screenWidth * 0.45;
    // } else {
    //   bannerHeight = screenWidth * 0.45;
    // }

    if (mobileDesign) {
      return ThumbnailView(
        context: context,
        imageUrl: coverImageMobile,
        enablePreview: false,
        borderRadius: 0,
        width: double.infinity,
        fit: BoxFit.fill,
      );
    }

    return ThumbnailView(
      context: context,
      imageUrl: coverImageDesktop ?? coverImage ?? '',
      enablePreview: false,
      borderRadius: 0,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }
}
