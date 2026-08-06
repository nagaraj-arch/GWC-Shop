import 'package:flutter/material.dart';

import '../../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class ProductInfoBanner extends StatelessWidget {
  final String bannerUrl;
  const ProductInfoBanner({super.key, required this.bannerUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ThumbnailView(
        context: context,
        imageUrl: bannerUrl,
        width: 900,
        height: 500,
        fit: BoxFit.contain,
        enablePreview: false,
      ),
    );
  }
}
