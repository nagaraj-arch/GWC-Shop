import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';

enum TextFieldBorderType { underline, full }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final int maxLength;
  final TextFieldBorderType borderType;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? autofocus;
  final double? height;
  final Color? borderClr;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? borderWidth;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final TextAlign align;
  final double contentPadding;
  final bool enable;
  final List<TextInputFormatter>? inputFormatters;
  final double? radius;
  final double contentHeight;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLength = 1,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.borderType = TextFieldBorderType.underline,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.height,
    this.borderClr,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.obscureText = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.align = TextAlign.start,
    this.contentPadding = 12,
    this.enable = true,
    this.inputFormatters,
    this.radius,
    this.contentHeight = 1.6,
  });

  InputBorder getBorder({
    required BuildContext context,
    required bool enabled,
    required Color color,
    required double width,
  }) {
    if (!enabled) {
      return borderType == TextFieldBorderType.full
          ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius ?? 6),
        borderSide: BorderSide.none, // 🔥 KEY FIX
      )
          : const UnderlineInputBorder(
        borderSide: BorderSide.none, // 🔥 KEY FIX
      );
    }

    switch (borderType) {
      case TextFieldBorderType.full:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 6),
          borderSide: BorderSide(color: color, width: width),
        );
      case TextFieldBorderType.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ KEY FIX: NO BORDER WHEN DISABLED
    final Color effectiveBorderColor =
    enable ? (borderClr ?? borderColor) : Colors.transparent;

    final Color effectiveFocusColor = focusedBorderColor ?? borderColor;

    final Color effectiveErrorColor = errorBorderColor ?? borderColor;

    final double effectiveBorderWidth = borderWidth ?? 1.2;

    final Color effectiveFillColor =
        fillColor ?? (enable ? gWhiteColor : gTapColor);

    final Color textColor = enable ? gBlackColor : gGreyColor;

    final Color iconColor = enable ? gHintTextColor : gGreyColor;

    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        enabled: enable,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLength,
        textAlign: align,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofocus: autofocus ?? false,
        obscureText: obscureText,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontFamily: fontMedium,
          fontSize: fontSize12,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: fontBook,
            color: newLightGreyColor,
            fontSize: fontSize10,
          ),
          filled: true,
          fillColor: effectiveFillColor,

          prefixIcon: prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              prefixIcon,
              size: 2.5.h,
              color: iconColor,
            ),
          )
              : null,

          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),

          suffixIcon: suffixWidget ??
              (suffixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  suffixIcon,
                  size: 2.2.h, // slightly smaller
                  color: iconColor,
                ),
              )
                  : null),

          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),

          // 🔥 BORDER HANDLING
          border: getBorder(
            context: context,
            enabled: enable,
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),
          enabledBorder: getBorder(
            context: context,
            enabled: enable,
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),
          focusedBorder: enable
              ? getBorder(
            context: context,
            enabled: true,
            color: effectiveFocusColor,
            width: effectiveBorderWidth + 0.3,
          )
              : getBorder(
            context: context,
            enabled: false,
            color: Colors.transparent,
            width: effectiveBorderWidth,
          ),

          errorBorder: getBorder(
            context: context,
            color: effectiveErrorColor,
            width: effectiveBorderWidth,
            enabled: enable,
          ),
          focusedErrorBorder: getBorder(
            context: context,
            color: effectiveErrorColor,
            width: effectiveBorderWidth + 0.3,
            enabled: enable,
          ),

          isDense: true,
          contentPadding:
          EdgeInsets.symmetric(horizontal: contentPadding, vertical: contentHeight.h),
        ),
      ),
    );
  }
}
