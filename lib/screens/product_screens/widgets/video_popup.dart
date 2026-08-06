import 'dart:html' as html;
import 'dart:math';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';

class VideoPopup extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPopup({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  State<VideoPopup> createState() => _VideoPopupState();
}

class _VideoPopupState extends State<VideoPopup> {
  late html.VideoElement _videoElement;
  late String _viewType;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _viewType =
        'videoElement-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(99999)}';

    _videoElement = html.VideoElement()
      ..src = widget.videoUrl
      ..controls = true
      ..autoplay = true
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.borderRadius = '0 0 28px 28px'
      ..style.overflow = 'hidden'
      ..setAttribute('controlsList', 'nodownload nopictureinpicture')
      ..setAttribute('disablePictureInPicture', 'true');

    _videoElement.style.setProperty('background', 'transparent');

    _videoElement.onCanPlay.listen((_) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });

    _videoElement.onError.listen((_) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });

    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _videoElement,
    );
  }

  @override
  void dispose() {
    _videoElement.pause();
    _videoElement.src = '';
    _videoElement.load();
    super.dispose();
  }

  /// 🔹 Back button pressed
  Future<void> onBackPressed(BuildContext context) async {
    _videoElement.pause();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: responsive.isDesktop ? 15.w : 2.w,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
              ),
              decoration: const BoxDecoration(
                color: gsecondaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize13,
                        fontFamily: fontMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onBackPressed(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: 70.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff4C0000),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28)),
                ),
                child: loading
                    ? Center(
                        child: Icon(Icons.graphic_eq,
                            size: 10.h, color: Colors.amber),
                      )
                    : Center(child: HtmlElementView(viewType: _viewType))),
          ],
        ),
      ),
    );
  }
}
