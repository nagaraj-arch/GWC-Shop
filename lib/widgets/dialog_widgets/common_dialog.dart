import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';
import '../button_widgets/button_widget.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final double width;
  final bool isButtons;
  final bool isLoading;
  final Alignment alignment;
  final double radius;

  const CommonDialog({
    super.key,
    required this.title,
    required this.content,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText = "Close",
    this.onSecondaryPressed,
    this.width = 40,
    this.isButtons = false,
    this.isLoading = false,
    this.alignment = Alignment.bottomRight,this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Container(
        width: width.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---------- TITLE ----------
            Padding(
              padding: EdgeInsets.only(top: 1.5.h, left: 2.w, right: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: fontMedium,
                      fontSize: fontSize14,
                      color: gBlackColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: gBlackColor, size: 3.h),
                  ),
                ],
              ),
            ),

            const Divider(),

            // ---------- CONTENT WITH AUTO HEIGHT + SCROLL ----------
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Allow dialog to grow until 80% of screen height
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h, left: 2.w,right: 2.w),
                    child: Center(child: content),
                  ),
                ),
              ),
            ),

            // SizedBox(height: 2.h),

            // ---------- BUTTONS ----------
            if (isButtons)
              Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.only(right: 2.w, bottom: 2.h, top: 1.h),
                    child: Align(
                      alignment: alignment,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ButtonWidget(
                            text: secondaryButtonText,
                            onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
                            isLoading: false,
                            radius: 5,
                            color: gGreyColor,
                          ),
                          SizedBox(width: 2.w),
                          ButtonWidget(
                            text: primaryButtonText ?? '',
                            onPressed: onPrimaryPressed ?? () {},
                            isLoading: isLoading,
                            radius: 5,
                            color: gBlueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
