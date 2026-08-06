import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../utils/opacity_to_alpha.dart';
import '../../../widgets/button_widgets/button_widget.dart';

class CommonOtpPopup extends StatefulWidget {
  final String otp;

  const CommonOtpPopup({super.key, required this.otp});

  @override
  State<CommonOtpPopup> createState() => _CommonOtpPopupState();
}

class _CommonOtpPopupState extends State<CommonOtpPopup> {
  late final TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: TextStyle(
        fontFamily: fontMedium,
        color: gBlackColor,
        fontSize: fontSize13,
      ),
      decoration: BoxDecoration(
        color: gGreyColor.withAlpha(AlphaHelper.fromOpacity(0.3)),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "We have sent an OTP to your email.",
          style: TextStyle(
            fontFamily: fontMedium,
            fontSize: fontSize13,
          ),
        ),

        SizedBox(height: 3.h),

        /// OTP FIELD
        Pinput(
          controller: otpController,
          length: 6,
          defaultPinTheme: defaultPinTheme,closeKeyboardWhenCompleted: true,useNativeKeyboard: true,
          onCompleted: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: (value) {
            return value == widget.otp ? null : 'Pin is incorrect';
          },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          autofillHints: kIsWeb ? null : const [AutofillHints.oneTimeCode],
        ),

        SizedBox(height: 3.h),

        Consumer<CartProvider>(builder: (context, cart, _) {
          return ButtonWidget(
            text: "Verify",
            radius: 6,
            isLoading: cart.isLoading(CartLoadingType.employeeSubmitItems),
            onPressed: cart.isLoading(CartLoadingType.employeeSubmitItems)
                ? null
                : () async {
                    if (otpController.text.isEmpty) {
                      AppConfig().showSnackBar(context, "Please enter OTP",
                          isError: true);
                      return;
                    }

                    if (otpController.text != widget.otp) {
                      AppConfig()
                          .showSnackBar(context, "Invalid OTP", isError: true);
                      return;
                    }

                    /// 🔥 PROGRAM FLOW
                    bool success = await cart.submitEmployeeProgramApi(context);

                    if (success) {
                      FocusManager.instance.primaryFocus?.unfocus();

                      await Future.delayed(const Duration(milliseconds: 200));

                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    }
                  },
          );
        }),
        SizedBox(height: 4.h),
      ],
    );
  }
}
