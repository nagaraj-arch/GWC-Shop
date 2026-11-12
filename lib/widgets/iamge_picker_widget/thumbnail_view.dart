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
  /// true = load only when visible
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

    // Load immediately only when lazyLoad is false.
    _shouldLoad = !widget.lazyLoad;
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_shouldLoad) return;

    if (info.visibleFraction > 0) {
      if (!mounted) return;

      setState(() {
        _shouldLoad = true;
      });
    }
  }

  void _openPreview() {
    debugPrint("ThumbnailView _openPreview");

    final url = widget.imageUrl?.trim();

    if (url != null && url.isNotEmpty && url != 'null') {
      showImagePreview(
        context: widget.context,
        imageUrl: url,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _shouldLoad ? _buildImage() : _emptySpace();

    if (!widget.lazyLoad) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: VisibilityDetector(
        key: ValueKey('lazy_thumbnail_${widget.imageUrl}'),
        onVisibilityChanged: _onVisibilityChanged,
        child: child,
      ),
    );
  }

  Widget _emptySpace() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
    );
  }

  Widget _buildImage() {
    final String? originalUrl = widget.imageUrl?.trim();

    if (originalUrl == null ||
        originalUrl.isEmpty ||
        originalUrl == 'null') {
      return _errorImage();
    }

    // Avoid breaking URLs that already contain query parameters.
    final String imageUrl = originalUrl.contains('?')
        ? '$originalUrl&v=2'
        : '$originalUrl?v=2';

    final VoidCallback? previewCallback = widget.enablePreview
        ? (widget.onTap ?? _openPreview)
        : widget.onTap;

    // IMPORTANT:
    // width/height can be Infinity when ThumbnailView is inside
    // an unbounded parent such as certain Row/Column/List layouts.
    //
    // Never call .round() on Infinity.
    // final int? cacheWidth =
    // widget.width != null &&
    //     widget.width!.isFinite &&
    //     widget.width! > 0
    //     ? (widget.width! * 1.5).round()
    //     : null;
    //
    // final int? cacheHeight =
    // widget.height != null &&
    //     widget.height!.isFinite &&
    //     widget.height! > 0
    //     ? (widget.height! * 1.5).round()
    //     : null;

    // debugPrint(
    //   'ThumbnailView dimensions: '
    //       'width=${widget.width}, '
    //       'height=${widget.height}, '
    //       'cacheWidth=$cacheWidth, '
    //       'cacheHeight=$cacheHeight',
    // );

    final Widget image = Image.network(
      imageUrl,

      // Keep this for your current CORS/Web behavior.
      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,

      width: widget.width,
      height: widget.height,

      // Only finite values are passed.
      // cacheWidth: cacheWidth,
      // cacheHeight: cacheHeight,

      fit: widget.fit,
      filterQuality: FilterQuality.low,

      errorBuilder: (context, error, stackTrace) {
        debugPrint(
          'ThumbnailView image error: $imageUrl\n$error',
        );

        return _errorImage();
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