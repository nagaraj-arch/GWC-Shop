
import 'dart:math';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget webImage(
    String url, {
      double? width,
      double? height,
      BoxFit fit = BoxFit.cover,
      double borderRadius = 0,
      bool isHovered = false,
    }) {
  if (!kIsWeb) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  return _WebImage(
    url: url,
    width: width,
    height: height,
    fit: fit,
    borderRadius: borderRadius,
    isHovered: isHovered,
  );
}

class _WebImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool isHovered;

  const _WebImage({
    required this.url,
    this.width,
    this.height,
    required this.fit,
    required this.borderRadius,
    required this.isHovered,
  });

  @override
  State<_WebImage> createState() => _WebImageState();
}

class _WebImageState extends State<_WebImage> {
  late final String viewType;

  double? naturalWidth;
  double? naturalHeight;

  @override
  void initState() {
    super.initState();

    viewType =
    "img_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(99999)}";

    final image = html.ImageElement();

    image.src = widget.url;

    image.onLoad.listen((_) {
      setState(() {
        naturalWidth = image.naturalWidth.toDouble();
        naturalHeight = image.naturalHeight.toDouble();
      });
    });

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(viewType, (id) {
      final wrapper = html.DivElement()
        ..style.display = "flex"
        ..style.justifyContent = "center"
        ..style.alignItems = "center"
        ..style.overflow = "hidden"
        ..style.borderRadius = "${widget.borderRadius}px";

      image.onError.listen((_) {
        image.src = 'assets/images/placeholder.png';
      });

      image.style.transition = "transform 300ms";
      image.style.transform = widget.isHovered ? "scale(1.05)" : "scale(1)";
      image.style.borderRadius = "${widget.borderRadius}px";

      switch (widget.fit) {
        case BoxFit.cover:
          image.style.width = "100%";
          image.style.height = "100%";
          image.style.objectFit = "cover";
          break;

        case BoxFit.fill:
          image.style.width = "100%";
          image.style.height = "100%";
          image.style.objectFit = "fill";
          break;

        case BoxFit.contain:
          image.style.maxWidth = "100%";
          image.style.maxHeight = "100%";
          image.style.objectFit = "contain";
          break;

        default:
          image.style.objectFit = "contain";
      }

      wrapper.append(image);

      return wrapper;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? naturalWidth ?? 200;
    final h = widget.height ?? naturalHeight ?? 200;

    return SizedBox(
      width: w,
      height: h,
      child: HtmlElementView(viewType: viewType),
    );
  }
}

// Widget webImage(
//     String url, {
//       double? width,
//       double? height,
//       BoxFit fit = BoxFit.cover,
//       // VoidCallback? onTap,
//       double borderRadius = 0,
//       bool isHovered = false,
//     }) {
//   if (!kIsWeb) {
//     return GestureDetector(
//       // onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Image.network(
//           url,
//           width: width,
//           height: height,
//           fit: fit,
//         ),
//       ),
//     );
//   }
//
//   /// Every widget gets its own ViewType
//   final viewType =
//       'img_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(999999)}';
//
//   // ignore: undefined_prefixed_name
//   ui.platformViewRegistry.registerViewFactory(
//     viewType,
//         (int viewId) {
//       final wrapper = html.DivElement()
//         ..style.width = '100%'
//         ..style.height = '100%'
//         ..style.display = 'flex'
//         ..style.alignItems = 'center'
//         ..style.justifyContent = 'center'
//         ..style.overflow = 'hidden'
//         ..style.borderRadius = '${borderRadius}px';
//
//       final image = html.ImageElement()
//         ..src = url
//         ..style.display = 'block'
//         ..style.borderRadius = '${borderRadius}px'
//         ..style.transition = 'transform 300ms ease'
//         ..style.transformOrigin = 'center center';
//
//       image.onError.listen((_) {
//         image.src = 'assets/images/placeholder.png';
//       });
//
//       switch (fit) {
//         case BoxFit.none:
//           image.style.width = 'auto';
//           image.style.height = 'auto';
//           image.style.maxWidth = 'none';
//           image.style.maxHeight = 'none';
//           image.style.objectFit = 'none';
//           break;
//
//         case BoxFit.contain:
//           image.style.maxWidth = '100%';
//           image.style.maxHeight = '100%';
//           image.style.width = 'auto';
//           image.style.height = 'auto';
//           image.style.objectFit = 'contain';
//           break;
//
//         case BoxFit.cover:
//           image.style.width = '100%';
//           image.style.height = '100%';
//           image.style.objectFit = 'cover';
//           break;
//
//         case BoxFit.fill:
//           image.style.width = '100%';
//           image.style.height = '100%';
//           image.style.objectFit = 'fill';
//           break;
//
//         default:
//           image.style.maxWidth = '100%';
//           image.style.maxHeight = '100%';
//           image.style.objectFit = 'contain';
//       }
//
//       image.style.transform =
//       isHovered ? 'scale(1.05)' : 'scale(1)';
//
//       wrapper.append(image);
//
//       return wrapper;
//     },
//   );
//
//   Widget child = width == null && height == null
//       ? HtmlElementView(viewType: viewType)
//       : SizedBox(
//     width: width,
//     height: height,
//     child: HtmlElementView(viewType: viewType),
//   );
//
//   // if (onTap != null) {
//   //   child = GestureDetector(
//   //     behavior: HitTestBehavior.deferToChild,
//   //     onTap: onTap,
//   //     child: child,
//   //   );
//   // }
//
//   return child;
// }
