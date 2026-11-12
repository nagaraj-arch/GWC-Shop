import 'package:flutter/material.dart';

import '../../../../../controllers/models/shop_models/category_model.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/iamge_picker_widget/thumbnail_view.dart';

class MobileCategoryHighlight extends StatelessWidget {
  final CategoryList category;

  const MobileCategoryHighlight({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = category.subTextThubnail?.trim() ?? '';

    // No thumbnail data → don't show this widget
    if (thumbnail.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;

    final scale = (screenWidth / 1440.0).clamp(0.82, 1.08);

    final titleSize =
    (40.0 * scale).clamp(20.0, 60.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xffEEEAD7).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Text(
            category.subTextHighlight ?? '',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: "Archivo Narrow",
              fontSize: titleSize,
              color: gBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          ThumbnailView(
            context: context,
            imageUrl: category.subTextThubnail,
            enablePreview: false,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}