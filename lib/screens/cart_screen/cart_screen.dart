import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/cart_provider.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/app_bar_widgets/common_scaffold.dart';
import '../../widgets/container_widgets/common_card.dart';
import '../../widgets/container_widgets/common_divider.dart';
import '../../widgets/loading_widgets/address_loader.dart';
import '../../widgets/text_field_widgets/custom_date_text_field.dart';
import '../../widgets/text_field_widgets/text_field_title.dart';
import '../../widgets/text_field_widgets/validation_utils.dart';
import 'widgets/add_more_items_section.dart';
import 'widgets/billing_summary_card.dart';
import 'widgets/cart_empty_widget.dart';
import 'widgets/cart_items_widget.dart';
import 'widgets/cart_title_widget.dart';
import 'widgets/coupon_widget.dart';
import 'widgets/proceed_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  bool showProducts = false;
  final formKey = GlobalKey<FormState>();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    /// EMAIL
    emailFocusNode.addListener(() async {
      if (!emailFocusNode.hasFocus) {
        final provider = context.read<CartProvider>();
        final email = provider.emailController.text.trim().toLowerCase();

        if (email.endsWith("@fembuddy.com")) {
          if (provider.employeeData?.email != email) {
            AppLoader.show(context);

            await provider.fetchEmployeeDetails(context, email);

            AppLoader.hide(context);
          }
        } else {
          /// Normal customer
          provider.employeeData = null;
          provider.availableCredits = 0;
          provider.calculateBill();
        }
      }
    });

    ///Phone
    phoneFocusNode.addListener(() async {
      if (!phoneFocusNode.hasFocus) {
        final provider = context.read<CartProvider>();
        final phone = provider.phoneController.text;

        if (phone.isNotEmpty) {
          try {
            AppLoader.show(context);

            await provider.fetchPhoneDetails(context, phone);
          } catch (e) {
            debugPrint("Email API Error: $e");
          } finally {
            AppLoader.hide(context);
          }
        }
      }
    });

    /// 🔥 PINCODE
    pinFocusNode.addListener(() async {
      if (!pinFocusNode.hasFocus) {
        final provider = context.read<CartProvider>();
        final pin = provider.pinCodeController.text.trim();

        if (pin.isEmpty) {
          provider.pinCodeList.clear();
          provider.partners.clear();
          provider.deliveryFee = 0;
          provider.calculateBill();
          return;
        }

        if (pin.length == 6) {
          try {
            AppLoader.show(context);

            provider.pinCodeList.clear();
            provider.partners.clear();
            provider.deliveryFee = 0;
            provider.calculateBill();

            await provider.fetchPinCode(context, pin);
          } catch (e) {
            debugPrint("Pincode API Error: $e");
          } finally {
            AppLoader.hide(context);
          }
        } else {
          AppConfig().showSnackBar(context, "Pin code should be 6 digits");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final bool isDesktop = ResponsiveHelper(context).isDesktop;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: gBgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductsHeader(onBack: () => context.go('/')),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 6.w : 3.w, vertical: 2.h),
                child: cart.items.isEmpty
                    ? CartEmptyWidget()
                    : isDesktop
                        ? desktopView(cart, isDesktop)
                        : mobileView(cart, isDesktop),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row desktopView(CartProvider cart, bool isDesktop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Expanded(
                child: CommonCard(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      CommonSectionHeader(
                        title: "Selected Products (${cart.items.length})",
                        subtitle: "Freshly ground on-demand",
                        horizontalLayout: true,
                      ),
                      const CommonDivider(color: borderColor),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: CartItemsWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BillingSummaryCard(formKey: formKey),
            ],
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(flex: 6, child: deliveryInformationCard(isDesktop, cart)),
      ],
    );
  }

  mobileView(CartProvider cart, bool isDesktop) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _buildExpandableProducts(cart, isDesktop),
              const SizedBox(height: 14),
              deliveryInformationCard(isDesktop, cart),
              const SizedBox(height: 14),
              BillingSummaryCard(formKey: formKey, showButton: false),
              SizedBox(height: 7.h),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: 0,
          right: 0,
          bottom: isKeyboardOpen ? -120 : 0,
          child: SafeArea(
            top: false,
            child: ProceedButton(
              formKey: formKey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableProducts(CartProvider cart, bool isDesktop) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          showProducts = !showProducts;
        });
      },
      child: CommonCard(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: gPrimaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: gPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonSectionHeader(
                    title: "Selected Products (${cart.items.length})",
                    subtitle: "Freshly ground on-demand",
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: showProducts ? .5 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: gPrimaryColor,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: showProducts
                  ? Column(
                      children: [
                        const CommonDivider(verticalMargin: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: CartItemsWidget(),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// Address and Billing
  deliveryInformationCard(bool isDesktop, CartProvider provider) {
    return CommonCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AddMoreItemsSection(),
            SizedBox(height: 2.h),
            CouponWidget(),
            SizedBox(height: 2.h),
            CommonSectionHeader(
                icon: Icons.local_shipping_outlined,
                title: "Delivery Information"),
            const CommonDivider(opacity: 0.4),
            Form(key: formKey, child: buildForm(provider)),
            // isDesktop
            //     ? Expanded(
            //         child: Form(
            //           key: formKey,
            //           child: SingleChildScrollView(child: buildForm(provider)),
            //         ),
            //       )
            //     : Form(
            //         key: formKey,
            //         child: buildForm(provider),
            //       ),
          ],
        ),
      ),
    );
  }

 Widget buildForm(CartProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        LabelWidget(
          text: 'Phone',
          isRequired: true,
          child: CustomTextField(
            controller: provider.phoneController,
            hintText: "Phone",
            prefixIcon: Icons.phone_outlined,
            contentPadding: 0,
            borderType: TextFieldBorderType.full,
            keyboardType: TextInputType.phone,
            focusNode: phoneFocusNode,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: ValidationUtils().phoneValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: 'Recipient Full Name',
          isRequired: true,
          child: CustomTextField(
            controller: provider.nameController,
            borderType: TextFieldBorderType.full,
            contentPadding: 0,
            prefixIcon: Icons.person_outline,
            hintText: "e.g. Rachel Green",
            validator: ValidationUtils().nameValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: "Email Address (Order Tracking)",
          isRequired: true,
          child: CustomTextField(
            controller: provider.emailController,
            borderType: TextFieldBorderType.full,
            focusNode: emailFocusNode,
            hintText: "rachel@domain.com",
            prefixIcon: Icons.email_outlined,
            contentPadding: 0,
            validator: ValidationUtils().emailValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: 'Flat/House Number',
          isRequired: true,
          child: CustomTextField(
            controller: provider.address1Controller,
            borderType: TextFieldBorderType.full,
            contentPadding: 0,
            prefixIcon: Icons.home_outlined,
            hintText: "Flat/House Number",
            validator: ValidationUtils().houseValidator,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: "Home Delivery Address",
          isRequired: true,
          child: CustomTextField(
            controller: provider.address2Controller,
            borderType: TextFieldBorderType.full,
            contentPadding: 0,
            prefixIcon: Icons.location_on_outlined,
            hintText: "123 Wellness Blvd, Apt 4",
            validator: ValidationUtils().addressValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: 'Pin Code',
          isRequired: true,
          child: CustomTextField(
            controller: provider.pinCodeController,
            borderType: TextFieldBorderType.full,
            focusNode: pinFocusNode, // 🔥 IMPORTANT
            hintText: "Enter your Pin Code",
            contentPadding: 0, prefixIcon: Icons.pin_drop_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: ValidationUtils().pinCodeValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: 'City',
          isRequired: true,
          child: CustomTextField(
            controller: provider.cityController,
            borderType: TextFieldBorderType.full,
            contentPadding: 0,
            prefixIcon: Icons.location_city_outlined,
            hintText: "City",
            validator: ValidationUtils().cityValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: 'State',
          isRequired: true,
          child: CustomTextField(
            controller: provider.stateController,
            borderType: TextFieldBorderType.full,
            contentPadding: 0,
            hintText: "State",
            prefixIcon: Icons.map_outlined,
            validator: ValidationUtils().stateValidator,
          ),
        ),
        SizedBox(height: 2.h),
        LabelWidget(
          text: 'Country',
          isRequired: true,
          child: CustomTextField(
            controller: provider.countryController,
            borderType: TextFieldBorderType.full,
            contentPadding: 0,
            prefixIcon: Icons.public,
            hintText: "Country",
            validator: ValidationUtils().countryValidator,
          ),
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget buildDeliveryTitle() {
    return Row(
      children: [
        Icon(
          Icons.inventory_2_outlined,
          size: 2.h,
          color: gPrimaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          "DELIVERY DETAILS & PRESERVATIONS",
          style: TextStyle(
            fontSize: fontSize12,
            fontFamily: fontBold,
            color: gPrimaryColor,
          ),
        ),
      ],
    );
  }
}
//
// class CheckoutSummaryCard extends StatefulWidget {
//   const CheckoutSummaryCard({super.key});
//
//   @override
//   State<CheckoutSummaryCard> createState() => _CheckoutSummaryCardState();
// }
//
// class _CheckoutSummaryCardState extends State<CheckoutSummaryCard> {

//   Widget buildBillSection(CartProvider cart) {
//     return Column(
//       children: [
//         /// Company Employee
//         if (cart.isCompanyEmail) ...[
//           billRow(
//             "Item Total",
//             "₹${cart.totalPrice.toStringAsFixed(0)}",
//           ),
//           SizedBox(height: 1.h),
//           billRow(
//             "Available Credits",
//             "- ₹${cart.availableCredits.toStringAsFixed(0)}",
//             txtClr: Colors.green,
//             priceClr: Colors.green,
//           ),
//           const CommonDivider(),
//           billRow(
//             "Subtotal",
//             "₹${cart.subtotal.toStringAsFixed(0)}",
//           ),
//           SizedBox(height: 1.h),
//           billRow(
//             "Discount (50%)",
//             "- ₹${cart.discount.toStringAsFixed(0)}",
//             txtClr: Colors.green,
//             priceClr: Colors.green,
//           ),
//           SizedBox(height: 1.h),
//         ]
//
//         /// Normal User
//         else ...[
//           billRow(
//             "Subtotal",
//             "₹${cart.totalPrice.toStringAsFixed(0)}",
//           ),
//           SizedBox(height: 1.h),
//         ],
//
//         billRow(
//           "Shipping Charges",
//           cart.deliveryFee == 0
//               ? "FREE"
//               : "₹${cart.deliveryFee.toStringAsFixed(0)}",
//           isShow: true,
//         ),
//
//         const CommonDivider(opacity: .5),
//
//         billRow(
//           "Grand Total",
//           "₹${cart.grandTotal.toStringAsFixed(0)}",
//           isBold: true,
//           fontSize: 14,
//         ),
//       ],
//     );
//   }
//
//   Widget billRow(
//     String title,
//     String value, {
//     double fontSize = 11,
//     bool isBold = false,
//     isShow = false,
//     Color txtClr = gBlackColor,
//     Color priceClr = gPrimaryColor,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: fontSize.dp,
//                 fontFamily: isBold ? fontBold : fontMedium,
//                 color: txtClr,
//               ),
//             ),
//             if (isShow)
//               Text(
//                 "(Free Delivery above ₹499)",
//                 style: TextStyle(
//                   fontSize: 10.dp,
//                   height: 1,
//                   color: Colors.grey,
//                 ),
//               ),
//           ],
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: (fontSize + 1).dp,
//             fontFamily: fontBold,
//             color: priceClr,
//           ),
//         ),
//       ],
//     );
//   }
//
//   buttonView(CartProvider cart) {
//     final isDesktop = ResponsiveHelper(context).isDesktop;
//
//     if (cart.isCompanyEmail) {
//       return Center(
//         child: ButtonWidget(
//           text: "Proceed to Pay ₹${cart.grandTotal.toStringAsFixed(0)}",
//           onPressed: (cart.isLoading(CartLoadingType.emailOtp))
//               ? null
//               : () async {
//                   if (!(formKey.currentState?.validate() ?? false)) {
//                     return;
//                   }
//                   await cart.fetchEmailOtp(
//                     context,
//                     cart.emailController.text,
//                   );
//
//                   if (cart.otp.isNotEmpty) {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (context) => CommonDialog(
//                         title: 'Verify Your Email Address',
//                         width: 40,
//                         isButtons: false,
//                         content: CommonOtpPopup(otp: cart.otp),
//                       ),
//                     );
//                   }
//                 },
//           isLoading: cart.isLoading(CartLoadingType.emailOtp),
//           radius: 8,
//           buttonHeight: isDesktop ? 6.h : 5.h,
//         ),
//       );
//     }
//     return Center(
//       child: ButtonWidget(
//         text: "Place Order (₹${cart.grandTotal.toStringAsFixed(0)})",
//         color: gPrimaryColor,
//         onPressed: (cart.isLoading(CartLoadingType.submitItems))
//             ? null
//             : () async {
//                 if (!(formKey.currentState?.validate() ?? false)) {
//                   return;
//                 }
//
//                 if (cart.items.isEmpty) {
//                   AppConfig().showSnackBar(
//                     context,
//                     "Please add at least one product",
//                   );
//                   return;
//                 }
//
//                 await cart.submitProgramApi(context);
//               },
//         isLoading: cart.isLoading(CartLoadingType.submitItems),
//         radius: 8,
//       ),
//     );
//   }
// }
