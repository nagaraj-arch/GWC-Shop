import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'show_image_preview.dart';

class ThumbnailView extends StatefulWidget {
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

  /// false = load immediately
  /// true  = load only when visible
  final bool lazyLoad;

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
    this.lazyLoad = false,
  });

  @override
  State<ThumbnailView> createState() => _ThumbnailViewState();
}

class _ThumbnailViewState extends State<ThumbnailView> {
  bool _shouldLoad = false;

  @override
  void initState() {
    super.initState();

    // Banner and all normal ThumbnailViews
    // load immediately.
    if (!widget.lazyLoad) {
      _shouldLoad = true;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_shouldLoad) return;

    // Load only when Cover/Footer becomes visible.
    if (info.visibleFraction > 0) {
      if (!mounted) return;

      setState(() {
        _shouldLoad = true;
      });
    }
  }

  void _openPreview() {
    debugPrint("ThumbnailView _openPreview");

    if (widget.imageUrl != null &&
        widget.imageUrl!.trim().isNotEmpty) {
      showImagePreview(
        context: widget.context,
        imageUrl: widget.imageUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _shouldLoad
        ? _buildImage()
        : _emptySpace();

    // Normal image → no visibility detector required.
    if (!widget.lazyLoad) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: VisibilityDetector(
        key: ValueKey(
          'lazy_thumbnail_${widget.imageUrl}',
        ),
        onVisibilityChanged: _onVisibilityChanged,
        child: child,
      ),
    );
  }

  /// Keeps the exact required space without showing
  /// placeholder.png while waiting for the image.
  Widget _emptySpace() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
    );
  }

  Widget _buildImage() {
    final VoidCallback? previewCallback = widget.enablePreview
        ? (widget.onTap ?? _openPreview)
        : widget.onTap;

    if (widget.imageUrl == null ||
        widget.imageUrl!.trim().isEmpty ||
        widget.imageUrl == 'null') {
      return _errorImage();
    }

    final imageUrl = "${widget.imageUrl!.trim()}?v=2";

    final image = Image.network(
      imageUrl,

      // IMPORTANT:
      // Keep this because your API/server needs CORS fallback.
      webHtmlElementStrategy:
      WebHtmlElementStrategy.fallback,

      // IMPORTANT:
      // Keep your original fill behavior.
      fit: widget.fit,

      width: widget.width,
      height: widget.height,

      filterQuality: FilterQuality.low,

      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/placeholder.png',
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );

    if (previewCallback == null) {
      return image;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        image,

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
  }

  Widget _errorImage() {
    return Image.asset(
      'assets/images/placeholder.png',
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}