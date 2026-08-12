import 'package:flutter/material.dart';
import 'package:gwc_shop/widgets/iamge_picker_widget/thumbnail_view.dart';

import 'screens/footer_widget/footer_wrapper.dart';
import 'utils/responsive_helper.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return FooterWrapper(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ResponsiveBanner(
              bannerSmall:
              'https://gutandhealth.com/storage/uploads/ingredient_category_images/soup_mobile.png',
              bannerTab:
              'https://gutandhealth.com/storage/uploads/ingredient_category_images/soup_tab.png',
              bannerLaptop:
              'https://gutandhealth.com/storage/uploads/ingredient_category_images/sslaptop.webp',
              bannerDesktop:
              'https://gutandhealth.com/storage/uploads/ingredient_category_images/supdsktp.png',
              bannerLargeDesktop:
              'https://gutandhealth.com/storage/uploads/ingredient_category_images/supdsktp.png',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Text('Your content here'),
                ],
              ),
            ),
          ],
        ),));
    // return Scaffold(
    //   body: Column(
    //     children: [
    //       Expanded(
    //         child: SingleChildScrollView(
    //           child:
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class ResponsiveBanner extends StatelessWidget {
  final String bannerSmall;
  final String bannerTab;
  final String bannerLaptop;
  final String bannerDesktop;
  final String bannerLargeDesktop;

  const ResponsiveBanner({
    super.key,
    required this.bannerSmall,
    required this.bannerTab,
    required this.bannerLaptop,
    required this.bannerDesktop,
    required this.bannerLargeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;

    late final String imageUrl;
    late final double bannerHeight;

    if (responsive.isMobile) {
      imageUrl = bannerSmall;
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isTablet) {
      imageUrl = bannerTab;
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isLaptop) {
      imageUrl = bannerLaptop;
      bannerHeight = screenWidth * 0.45;
    } else if (responsive.isDesktop) {
      imageUrl = bannerDesktop;
      bannerHeight = screenWidth * 0.30;
    } else {
      imageUrl = bannerLargeDesktop;
      bannerHeight = screenWidth * 0.26;
    }

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: ThumbnailView(
        context: context,
        imageUrl: "https://gutandhealth.com/storage/uploads/ingredient_category_images/sslaptop.webp",
        width: double.infinity,
        height: bannerHeight,
        fit: BoxFit.fill,
      ),
    );
  }
}