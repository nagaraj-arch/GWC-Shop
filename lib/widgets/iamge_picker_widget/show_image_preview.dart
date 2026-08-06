import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';

/// Build image widget for preview (auto-size on web)
/// Build image widget for preview
Widget _buildPreviewImage(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (_, __, ___) {
          return Image.asset(
            'assets/images/placeholder.png',
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  return Image.asset(
    'assets/images/placeholder.png',
    fit: BoxFit.contain,
  );
}

void showImagePreview({required BuildContext context, String? imageUrl}) {
  assert(imageUrl != null);

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Image",
    barrierColor: gBlackColor.withAlpha(50),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, __, ___) {
      final media = MediaQuery.of(context);

      return Material(
        color: gBlackColor.withAlpha(70),
        child: Stack(
          children: [
            /// Click outside to close
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SizedBox.expand(),
              ),
            ),

            /// Image
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: media.size.width * .80,
                    maxHeight: media.size.height * .80,
                  ),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 8,
                    boundaryMargin: const EdgeInsets.all(300),
                    clipBehavior: Clip.none,
                    child: _buildPreviewImage(imageUrl),
                  ),
                ),
              ),
            ),

            /// Close button
            Positioned(
              top: 24,
              right: 24,
              child: Material(
                color: newLightGreyColor,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.close,
                      color: gWhiteColor,
                      size: 2.5.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
