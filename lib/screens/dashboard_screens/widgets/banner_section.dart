import 'package:flutter/material.dart';

import '../../../controllers/models/shop_models/category_model.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class BannerSection extends StatelessWidget {
  final CategoryList? category;
  final bool showCoverSection;
  final VoidCallback? onChooseProducts;
  final VoidCallback? onLearnMore;
  final VoidCallback? isFoodFarmacy;

  const BannerSection({
    super.key,
    required this.category,
    this.showCoverSection = false,
    this.onChooseProducts,
    this.onLearnMore,
    this.isFoodFarmacy,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ScreenSizeHelper(context);
    final screenWidth = responsive.screenWidth;

    final mobileDesign = responsive.isMobile || responsive.isTablet;

    late final double bannerHeight;

    if (screenWidth <= 500) {
      // 500px and below
      bannerHeight = screenWidth * 0.40;
    } else if (screenWidth <= 600) {
      // 501px - 600px
      bannerHeight = screenWidth * 0.45;
    } else if (responsive.isTablet) {
      bannerHeight = screenWidth * 0.50;
    } else if (responsive.isLaptop) {
      bannerHeight = screenWidth * 0.45;
    } else if (responsive.isDesktop) {
      bannerHeight = screenWidth * 0.45;
    } else {
      bannerHeight = screenWidth * 0.45;
    }

    if (mobileDesign) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: bannerHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: ThumbnailView(
                  context: context,
                  imageUrl: category?.bannerLaptop ?? '',
                  enablePreview: true,
                  onTap: isFoodFarmacy ?? onChooseProducts ?? () {},
                  borderRadius: 0,
                  width: double.infinity,
                  height: bannerHeight,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Container(
            //   height: 50,
            //   decoration: BoxDecoration(
            //     color: widget.category.color.withAlpha(50),
            //     // borderRadius: BorderRadius.only(
            //     //     bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)
            //     // ),
            //   ),
            // )
          ],
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: ThumbnailView(
        context: context,
        imageUrl: category?.bannerLaptop ?? '',
        enablePreview: true,
        onTap: isFoodFarmacy ?? onChooseProducts ?? () {},
        borderRadius: 0,
        width: double.infinity,
        height: bannerHeight,
        fit: BoxFit.fill,
      ),
    );
  }
}
