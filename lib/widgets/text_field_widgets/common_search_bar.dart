import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../utils/constants.dart';

class CommonSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final bool autoFocus;
  final double width;
  final double topPadding;
  final Color fillColor;
  final Color borderColor;
  final double prefixIconWidth;

  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = "Search...",
    this.autoFocus = false,
    this.width = 20,
    this.fillColor = gBgColor,
    this.borderColor = gHintTextColor,
    this.prefixIconWidth = 2,
    this.topPadding = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: width.w,
        height: 35, // 🔑 FIXED height = stable on web
        child: TextField(
          controller: controller,
          textAlignVertical: TextAlignVertical.center, // 🔥 MAIN FIX
          cursorColor: gBlackColor,
          autofocus: autoFocus,
          style: TextStyle(
            fontSize: fontSize11,
            color: gBlackColor,
            fontFamily: fontMedium,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor.withAlpha(20),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor.withAlpha(20),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor.withAlpha(40),
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: prefixIconWidth.h,
              color: gHintTextColor,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                if (value.text.isEmpty) return const SizedBox.shrink();

                return IconButton(
                  icon: Icon(
                    Icons.close_outlined,
                    size: 2.h,
                    color: gHintTextColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    if (onClear != null) onClear!();
                  },
                );
              },
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: fontSize10,
              color: gHintTextColor,
              fontFamily: fontBook,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
