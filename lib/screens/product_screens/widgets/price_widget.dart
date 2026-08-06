import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class CommonPriceWidget extends StatelessWidget {
  final String? actualPrice;
  final String? discountPrice;
  final String? discountPercentage;
  final bool showLabel;

  const CommonPriceWidget({
    super.key,
    this.actualPrice,
    this.discountPrice,
    this.discountPercentage,
    this.showLabel = true,
  });

  bool _isValid(String? value) {
    if (value == null) return false;

    final v = value.trim().toLowerCase();

    return v.isNotEmpty &&
        v != 'null' &&
        v != 'did not get' &&
        v != 'n/a' &&
        v != '0' &&
        v != '0.0' &&
        v != '0.00';
  }

  @override
  Widget build(BuildContext context) {
    final hasActual = _isValid(actualPrice);
    final hasDiscount = _isValid(discountPrice);
    final hasPercentage = _isValid(discountPercentage);

    double? calculatedPercentage;

    if (!hasPercentage && hasActual && hasDiscount) {
      final actual = double.tryParse(actualPrice!);
      final discount = double.tryParse(discountPrice!);

      if (actual != null &&
          discount != null &&
          actual > 0 &&
          discount < actual) {
        calculatedPercentage = ((actual - discount) / actual) * 100;
      }
    }

    /// Nothing available
    if (!hasActual && !hasDiscount && !hasPercentage) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// PRICE LABEL
        if (showLabel && (hasActual || hasDiscount))
          Text(
            "PRICE",
            style: TextStyle(
              color: gHintTextColor,
              fontSize: fontSize07,
              fontFamily: fontMedium,
            ),
          ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DISCOUNT PRICE
            if (hasDiscount)
              Text(
                "₹${discountPrice!}",
                style: TextStyle(
                  color: gPrimaryColor,
                  fontSize: fontSize11,
                  fontFamily: fontBold,
                ),
              ),

            /// ACTUAL PRICE
            if (hasActual) ...[
              if (hasDiscount) const SizedBox(width: 8),
              Text(
                "₹${actualPrice!}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: fontSize09,
                  fontFamily: fontMedium,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],

            /// DISCOUNT %
            if (hasPercentage || calculatedPercentage != null) ...[
              if (hasActual || hasDiscount) const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: gPrimaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${hasPercentage ? (double.tryParse(discountPercentage!)?.toStringAsFixed(0) ?? discountPercentage) : calculatedPercentage!.toStringAsFixed(0)}% OFF",
                  style: TextStyle(
                    color: gPrimaryColor,
                    fontSize: fontSize07,
                    fontFamily: fontBold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
