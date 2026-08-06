import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../../../widgets/container_widgets/common_card.dart';
import '../../../widgets/loading_widgets/address_loader.dart';
import '../../../widgets/text_field_widgets/custom_date_text_field.dart';
import 'cart_title_widget.dart';

class CouponWidget extends StatefulWidget {
  const CouponWidget({super.key});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, child) {
      return CommonCard(
        elevation: 2,
        backgroundColor: const Color(0xffFAF4ED),
        borderClr: borderColor,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.5.h),
        borderRadius: 16,
        child: Column(
          children: [
            CommonSectionHeader(
              icon: Icons.wallet_giftcard_sharp,
              title: "WELLNESS PROMO AVAILABLE",
              titleSize: fontSize15,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: provider.couponController,
                    hintText: "Enter Coupon (e.g. HEALTHY20)",
                    borderType: TextFieldBorderType.full,
                    radius: 8,
                  ),
                ),
                SizedBox(width: 1.w),
                ValueListenableBuilder<TextEditingValue>(
                    valueListenable: provider.couponController,
                    builder: (context, value, child) {
                      final isCouponEntered = value.text.trim().isNotEmpty;

                      return ButtonWidget(
                        text: "Apply",
                        onPressed: (!isCouponEntered ||
                                provider.isLoading(CartLoadingType.employee))
                            ? null
                            : () async {
                                final coupon = provider.couponController.text
                                    .trim()
                                    .toLowerCase();

                                if (coupon.endsWith("@fembuddy.com")) {
                                  if (provider.employeeData?.email != coupon) {
                                    AppLoader.show(context);

                                    await provider.fetchEmployeeDetails(
                                        context, coupon);

                                    AppLoader.hide(context);
                                  }
                                } else {
                                  provider.employeeData = null;
                                  provider.availableBalance = "";
                                  provider.availableCredits = 0;
                                  provider.usedCredits = 0;
                                  provider.calculateBill();

                                  FocusScope.of(context).unfocus();

                                  AppConfig().showSnackBar(
                                      context, "Invalid Coupon Code",
                                      isError: true);
                                }
                              },
                        isLoading: provider.isLoading(CartLoadingType.employee),
                        color: gPrimaryColor,
                        radius: 6,
                      );
                    }),
              ],
            ),
          ],
        ),
      );
    });
  }
}
