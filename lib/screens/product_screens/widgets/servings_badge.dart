import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../widgets/container_widgets/common_card.dart';

class ItemInfoBadge extends StatelessWidget {
  final String? orderQuantity;
  final String? orderServings;
  final Color? backgroundClr;
  final Color? borderClr;
  final Color? textClr;
  final double? fontSize;
  const ItemInfoBadge({
    super.key,
    this.orderQuantity,
    this.orderServings,
    this.backgroundClr,
    this.borderClr,this.textClr,this.fontSize,

  });

  @override
  Widget build(BuildContext context) {
    final List<String> values = [];

    if (orderQuantity != null &&
        orderQuantity!.isNotEmpty &&
        orderQuantity != "null") {
      values.add(orderQuantity!);
    }

    if (orderServings != null &&
        orderServings!.isNotEmpty &&
        orderServings != "null") {
      values.add("$orderServings Servings");
    }

    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    final backgroundColor = backgroundClr ?? Color(0xffFFF8F0);
    final borderColour = borderClr ?? Color(0xffE8DED1);
    final textColor = textClr ?? gBlackColor;

    return CommonCard(
      elevation: 2,
      backgroundColor: backgroundColor,
      borderClr: borderColour,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: EdgeInsets.zero,
      borderRadius: 6,
      child: Text(
        values.join(" | "),
        style: TextStyle(
          fontSize: fontSize ?? fontSize09,
          fontFamily: "Courier Prime",
          color: textColor,
          fontWeight: FontWeight.w400
        ),
      ),
    );
  }
}
