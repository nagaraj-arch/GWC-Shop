import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../widgets/container_widgets/common_card.dart';
import '../../../widgets/container_widgets/common_divider.dart';
import 'cart_title_widget.dart';
import 'proceed_button.dart';

class BillingSummaryCard extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool showButton;
  const BillingSummaryCard(
      {super.key, required this.formKey, this.showButton = true});

  @override
  State<BillingSummaryCard> createState() => _BillingSummaryCardState();
}

class _BillingSummaryCardState extends State<BillingSummaryCard> {
  final pref = AppConfig().preferences!;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    return CommonCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          CommonSectionHeader(
              icon: Icons.receipt_long_outlined, title: "Billing Summary"),
          CommonDivider(),
          buildBillSection(provider),
          SizedBox(height: 1.h),
          if (widget.showButton) ...[
            const CommonDivider( opacity: 0.5),
            SizedBox(height: 1.h),
            ProceedButton(formKey: widget.formKey),
          ],
        ],
      ),
    );
  }

  Widget buildBillSection(CartProvider cart) {
    return Column(
      children: [
        /// Company Employee
        if (cart.isCompanyCoupon) ...[
          SizedBox(height: 1.h),
          billRow(
            "Item Total",
            "₹${cart.totalPrice.toStringAsFixed(0)}",
          ),
          SizedBox(height: 1.h),
          billRow(
            "Available Credits",
            "- ₹${cart.availableCredits.toStringAsFixed(0)}",
            txtClr: Colors.green,
            priceClr: Colors.green,
          ),
          const CommonDivider(),
          billRow(
            "Subtotal",
            "₹${cart.subtotal.toStringAsFixed(0)}",
          ),
          SizedBox(height: 1.h),
          billRow(
            "Discount (50%)",
            "- ₹${cart.discount.toStringAsFixed(0)}",
            txtClr: Colors.green,
            priceClr: Colors.green,
          ),
          SizedBox(height: 1.h),
        ]

        /// Normal User
        else ...[
          SizedBox(height: 1.h),
          billRow(
            "Subtotal",
            "₹${cart.totalPrice.toStringAsFixed(0)}",
          ),
          SizedBox(height: 1.h),
        ],
        if (cart.deliveryFee > 0) ...[
          billRow(
            "Shipping Charges",
            "₹${cart.deliveryFee.toStringAsFixed(0)}",
            isShow: true,
            priceClr: gPrimaryColor,
          ),
          SizedBox(height: 1.h),
        ],
        // billRow(
        //   "Shipping Charges",
        //   cart.deliveryFee == 0
        //       ? "FREE"
        //       : "₹${cart.deliveryFee.toStringAsFixed(0)}",
        //   isShow: true,
        //   priceClr: cart.deliveryFee == 0 ? Colors.green : gPrimaryColor,
        // ),
        const CommonDivider(opacity: .5),
        billRow(
          "Grand Total",
          "₹${cart.grandTotal.toStringAsFixed(0)}",
          isBold: true,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget billRow(
    String title,
    String value, {
    double fontSize = 11,
    bool isBold = false,
    isShow = false,
    Color txtClr = gBlackColor,
    Color priceClr = gPrimaryColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize.dp,
                fontFamily: isBold ? fontBold : fontMedium,
                color: txtClr,
              ),
            ),
            if (isShow)
              Text(
                "(Free Delivery above ₹499)",
                style: TextStyle(
                  fontSize: 10.dp,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: (fontSize + 1).dp,
            fontFamily: fontBold,
            color: priceClr,
          ),
        ),
      ],
    );
  }
}
