import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/opacity_to_alpha.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../product_screen.dart';

class CommonSuccessDialog {
  static void show(
      BuildContext context, {
        String? status,
        bool isSuccess = false,
        String? paymentId,
      }) {
    showDialog(
      barrierDismissible: false,
      barrierColor: gWhiteColor.withAlpha(
        AlphaHelper.fromOpacity(0.8),
      ),
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.shortestSide > 600
                ? 50.w
                : double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: gGreyColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔥 SUCCESS / FAILURE UI
                isSuccess
                    ? Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                      child: Lottie.asset(
                          'assets/lottie/success_animation.json'),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      status ?? "PAYMENT SUCCESSFUL",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: kNumberCircleGreen,
                        fontSize: 16.dp,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    const Text("Thank you for your order!"),
                    SizedBox(height: 1.h),
                    Text(
                      "Payment Ref No: $paymentId",
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                    : Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                      child:
                      Lottie.asset('assets/lottie/failure.json'),
                    ),
                    SizedBox(height: 2.h),
                    Text(status ?? "OOPS !!"),
                    SizedBox(height: 1.h),
                    Text("Payment Failed"),
                  ],
                ),

                SizedBox(height: 2.h),

                /// 🔥 BUTTON
                ButtonWidget(
                  text: isSuccess ? "Got It" : "Back",
                  radius: 8,
                  onPressed: () async {
                    Navigator.pop(context);

                    if (isSuccess) {
                      /// 🔥 CLEAR PROVIDERS HERE
                      final cart =
                      context.read<CartProvider>();

                      await cart.clearAllData();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductScreen(),
                        ),
                            (route) => false,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  isLoading: false,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}