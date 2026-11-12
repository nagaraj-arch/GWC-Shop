import 'package:flutter/material.dart';

import '../../utils/responsive_helper.dart';
import '../../widgets/iamge_picker_widget/thumbnail_view.dart';

class FooterSection extends StatelessWidget {
  final String? footerThumbnail;
  final String? footerThumbnailMobile;
  final String? footerThumbnailLaptop;
  final String? footerThumbnailTab;
  final String? footerThumbnailDesktop;
  final String? footerTitle;
  final String? footerDescription;
  final String? footerHighlightText;
  final bool isFoodFarmacy;

  const FooterSection({
    super.key,
    this.footerThumbnail,
    this.footerThumbnailMobile,
    this.footerThumbnailLaptop,
    this.footerThumbnailTab,
    this.footerThumbnailDesktop,
    this.footerTitle,
    this.footerDescription,
    this.footerHighlightText,
    this.isFoodFarmacy = false,
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

    // if (responsive.isMobile) {
    //   imageUrl = footerThumbnailMobile ?? '';
    //   bannerHeight = screenWidth * 0.55;
    // } else if (responsive.isTablet) {
    //   imageUrl = footerThumbnailTab ?? '';
    //   bannerHeight = screenWidth * 0.50;
    // } else if (responsive.isLaptop) {
    //   imageUrl = footerThumbnailLaptop ?? '';
    //   bannerHeight = screenWidth * 0.45;
    // } else {
    //   imageUrl = footerThumbnailDesktop ?? '';
    //   bannerHeight = screenWidth * 0.40;
    // }

    if (mobileDesign) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ThumbnailView(
          context: context,
          imageUrl: footerThumbnailMobile,
          enablePreview: false,
          borderRadius: 12,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      );
    }

    return ThumbnailView(
      context: context,
      imageUrl: footerThumbnailDesktop ?? footerThumbnail ?? '',
      enablePreview: false,
      borderRadius: 0,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }
}
