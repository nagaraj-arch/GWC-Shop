import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../utils/constants.dart';
import 'common_search_bar.dart';

class CommonDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final bool isApp;
  final List<String>? priority;
  final ValueChanged<String?> onChanged;
  final bool isFullBorder;
  final String? Function(String?)? validator;
  final double? height;
  final double? fullWidth;
  final Color? borderClr;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? borderWidth;
  final bool showCheckIcon;
  final bool enable;
  final Color? fillColor;
  final bool enableSearch;

  const CommonDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.priority,
    this.isFullBorder = false,
    this.isApp = false,
    this.validator,
    this.height,
    this.fullWidth,
    this.borderClr,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.showCheckIcon = true,
    this.enable = true,
    this.fillColor,
    this.enableSearch = false,
  });

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  final TextEditingController searchController = TextEditingController();

  InputBorder getInputBorder(Color color, double width) {
    return widget.isFullBorder
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: color, width: width),
          )
        : UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: width),
          );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final defaultColor = widget.borderClr ?? borderColor;
    final focusColor = widget.focusedBorderColor ?? borderColor;
    final errColor = widget.errorBorderColor ?? borderColor;
    final width = widget.borderWidth ?? 1.2;

    return SizedBox(
      width: widget.fullWidth ?? 20.w,
      child: DropdownButtonFormField2<String>(
        value: widget.value?.isNotEmpty == true ? widget.value : null,
        isExpanded: true,

        // TEXT STYLE
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: fontSize12,
          color: gBlackColor,
          fontFamily: fontMedium,
        ),

        // REMOVE hintText from decoration
        decoration: InputDecoration(
          isDense: true,
          enabled: widget.enable,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 1.w,
            vertical: widget.isFullBorder ? 1.3.h : 1.h,
          ),
          border: getInputBorder(defaultColor, width),
          filled: true,
          fillColor: widget.fillColor ?? gWhiteColor, // ✅ FIX
          enabledBorder: getInputBorder(defaultColor, width),
          focusedBorder: getInputBorder(focusColor, width + 0.3),
          disabledBorder: getInputBorder(Colors.transparent, 0),
          errorBorder: getInputBorder(errColor, width),
          focusedErrorBorder: getInputBorder(errColor, width + 0.3),
          errorStyle: const TextStyle(height: 0.8, fontSize: 11),
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showCheckIcon &&
                  widget.value != null &&
                  widget.value!.isNotEmpty &&
                  widget.value != 'Select Vendor')
                Icon(Icons.check, color: gPrimaryColor, size: 3.h),
              Icon(Icons.keyboard_arrow_down, color: gGreyColor, size: 3.h),
              SizedBox(width: 1.w),
            ],
          ),
        ),

// ⭐ PERFECT CENTER HINT — HERE
        hint: Text(
          widget.label,
          style: TextStyle(
            fontSize: fontSize10,
            fontFamily: fontBook,
            color: gGreyColor,
          ),
        ),

        iconStyleData: const IconStyleData(icon: SizedBox.shrink()),

        // ⭐ MENU STYLE
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.zero,
          width: double.infinity,
        ),

        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: gWhiteColor,
          ),
        ),

        menuItemStyleData: const MenuItemStyleData(
          height: 42, // uniform height -> no jumping
        ),

        // ITEMS
        items: widget.priority?.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item.contains("||") ? item.split("||").last : item,
              style: TextStyle(
                fontSize: fontSize12,
                fontFamily: fontMedium,
                color: gBlackColor,
              ),
            ),
          );
        }).toList(),

        // VALIDATION
        validator: widget.validator ??
            (val) {
              if (val == null || val.isEmpty || val == widget.label) {
                return 'Please select ${widget.label}';
              }
              return null;
            },

        onChanged: widget.enable ? widget.onChanged : null,

        dropdownSearchData: widget.enableSearch
            ? DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 5.h,
                searchInnerWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                  child:CommonSearchBar(
                    controller: searchController,
                    width: 100,
                    autoFocus: true,
                  )
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              )
            : null,
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            searchController.clear();
          }
        },
      ),
    );
  }
}
