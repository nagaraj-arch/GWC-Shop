import 'package:flutter/material.dart';

import 'show_image_preview.dart';
import 'web_image.dart';

class ThumbnailView extends StatelessWidget {
  final BuildContext context;
  final String? imageUrl;
  final String? fileName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool isHovered;
  final bool enablePreview;

  const ThumbnailView({
    super.key,
    required this.context,
    this.imageUrl,
    this.fileName,
    this.width,
    this.height,
    this.onTap,
    this.enablePreview = true,
    this.fit = BoxFit.cover,
    this.borderRadius = 6,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: _buildImage(),
    );
  }

  void _openPreview() {
    debugPrint("ThumbnailView _openPreview");
    showImagePreview(context: context, imageUrl: imageUrl);
  }

  Widget _buildImage() {
    final VoidCallback? previewCallback = enablePreview
        ? (onTap ?? _openPreview)
        : onTap;

    /// NETWORK
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      Widget image = Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child:
              Image.network(
                imageUrl!,
                fit: fit,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                width: width,
                height: height,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    width: width,
                    height: height,
                    fit: fit,
                  );
                },
              ),
            ),
          ),
          // webImage(
          //   imageUrl!,
          //   width: width,
          //   height: height,
          //   fit: fit,
          //   borderRadius: borderRadius,
          //   isHovered: isHovered,
          // ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: previewCallback,
              ),
            ),
          ),
        ],
      );

      if (previewCallback == null) return image;

      return image;
    }

    return _errorImage();
  }

  Widget _errorImage() {
    return Image.asset(
      'assets/images/placeholder.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
