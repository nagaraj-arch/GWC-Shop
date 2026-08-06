import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../../../widgets/dialog_widgets/common_dialog.dart';
import 'otp_popup.dart';

class ProceedButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ProceedButton({super.key, required this.formKey});

  @override
  State<ProceedButton> createState() => _ProceedButtonState();
}

class _ProceedButtonState extends State<ProceedButton> {
  bool _isOtpDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;


    return Consumer<CartProvider>(builder: (context, cart, child) {
      if (cart.isCompanyCoupon) {
        return Center(
          child: ButtonWidget(
            text: "Proceed to Pay ₹${cart.grandTotal.toStringAsFixed(0)}",
            onPressed: (cart.isLoading(CartLoadingType.emailOtp) ||
                    _isOtpDialogOpen)
                ? null
                : () async {
                    if (!(widget.formKey.currentState?.validate() ?? false)) {
                      return;
                    }

                    await cart.fetchEmailOtp(
                        context, cart.couponController.text);

                    if (!mounted || cart.otp.isEmpty) return;

                    setState(() => _isOtpDialogOpen = true);

                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => CommonDialog(
                        title: "Verify Your Email Address",
                        width: isDesktop ? 40 : double.maxFinite,
                        isButtons: false,
                        content: CommonOtpPopup(otp: cart.otp),
                      ),
                    );

                    if (mounted) {
                      setState(() => _isOtpDialogOpen = false);
                    }
                  },
            isLoading: cart.isLoading(CartLoadingType.emailOtp),
            radius: 8,
            buttonHeight: isDesktop ? 6.h : 5.h,
          ),
        );
      }
      return Center(
        child: ButtonWidget(
          text: "Place Order (₹${cart.grandTotal.toStringAsFixed(0)})",
          color: gPrimaryColor,
          onPressed: (cart.isLoading(CartLoadingType.submitItems))
              ? null
              : () async {
                  if (!(widget.formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  await cart.submitProgramApi(context);
                },
          isLoading: cart.isLoading(CartLoadingType.submitItems),
          radius: 8,
          buttonHeight: isDesktop ? 6.h : 5.h,
        ),
      );
    });
  }
}
