import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../utils/constants.dart';

class LabelWidget extends StatelessWidget {
  final String text;
  final bool isRequired;
  final Color clr;
  final Widget child;
  final double? size;
final CrossAxisAlignment? isRowAlign;
  /// 🔥 NEW
  final bool isRow;        // row or column layout

  const LabelWidget({
    super.key,
    required this.text,
    this.isRequired = false,
    this.clr = gHintTextColor,
    required this.child,
    this.size,
    this.isRow = false,
    this.isRowAlign = CrossAxisAlignment.center,
  });

  Widget _label() {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: clr,
          fontFamily: "Courier Prime",
          fontSize: size ?? fontSize12,
          fontWeight: FontWeight.w400
        ),
        children: isRequired
            ? const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: gsecondaryColor),
          )
        ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    /// ================= COLUMN MODE (DEFAULT) =================
    if (!isRow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(),
          SizedBox(height: 1.h),
          child,
        ],
      );
    }

    /// ================= ROW MODE =================
    return Row(
      crossAxisAlignment: isRowAlign!,
      children: [
        Expanded(child: _label()),
        SizedBox(width: 0.w),
        Expanded(child: child),
      ],
    );
  }
}
