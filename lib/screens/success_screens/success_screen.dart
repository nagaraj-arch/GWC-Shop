import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_shop/screens/dashboard_screens/dashboard_screen.dart';
import 'package:gwc_shop/utils/navigation_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controllers/models/get_phone_details_model/update_product_model.dart';
import '../../controllers/providers/cart_provider.dart';
import '../../utils/constants.dart';

class SuccessScreen extends StatefulWidget {
  // final List<GwcProducts> productList;
  final UpdateModel? model;
  const SuccessScreen({
    super.key,
    // required this.productList,
    this.model,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  double _totalPrice = 0.0;
  double discount = 0.0;
  double deliveryFee = 0.0;
  double grandTotal = 0.0;

  // Calculate total price of items in the cart
  void _calculateTotal() {
    final cartItems = Provider.of<CartProvider>(context, listen: false).items;
    setState(() {
      _totalPrice = cartItems.fold(
        0,
        (sum, item) => sum + (item.price! * item.quantity),
      );

      deliveryFee = _totalPrice < 599 ? 99 : 0;

      grandTotal = _totalPrice - discount + deliveryFee;
    });
  }

  // Clear the cart
  Future<void> clearCart() async {
    final cartManager = Provider.of<CartProvider>(context, listen: false);
    cartManager.clearCart();
    _calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: gBgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ProductsHeader(onBack: () {
            //   context.go('/');
            // }),
            Expanded(child: buildMobileScreen()),
          ],
        ),
      ),
    );
  }

  buildMobileScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.shortestSide > 600 ? 30.w : 3.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 2.h),
            Center(
              child: SizedBox(
                height: 15.h,
                child: Lottie.asset('assets/lottie/success_animation.json'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                'PAYMENT SUCCESSFUL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gPrimaryColor,
                  fontSize: 16.dp,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Text(
              'Thank you for your order!',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.8,
                fontFamily: kFontMedium,
                color: gBlackColor,
                fontSize: 13.dp,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              'We have received your order and we will contact you as soon as your package is shipped. You will receive a Email confirmation for the same.',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.8,
                fontFamily: kFontMedium,
                color: gBlackColor,
                decoration: TextDecoration.none,
                fontSize: 13.dp,
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              'Your Payment Reference No. is ${widget.model?.paymentId} ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kFontMedium,
                height: 1.8,
                color: gBlackColor,
                decoration: TextDecoration.none,
                fontSize: 13.dp,
              ),
            ),
            SizedBox(height: 2.h),
            buildAddress(),
            Center(
              child: GestureDetector(
                onTap: () async {
                  clearCart();
                  NavigationHelper.push(context, const DashboardScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.5.h,
                    horizontal: 3.w,
                  ),
                  decoration: BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: gGreyColor.withAlpha(20)),
                  ),
                  child: Text(
                    "Shop More",
                    style: TextStyle(
                      fontFamily: kFontMedium,
                      color: gBlackColor,
                      fontSize: eUser().buttonTextSize,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  buildAddress() {
    String editAddress =
        "${widget.model?.name},\n${widget.model?.phone},\n${widget.model?.email},\nNo.${widget.model?.houseNo},${widget.model?.address},\n${widget.model?.country}, ${widget.model?.state}, ${widget.model?.city} - ${widget.model?.pincode}.";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping To : ',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.8,
                fontFamily: kFontMedium,
                color: gBlackColor,
                fontSize: 13.dp,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              editAddress,
              style: TextStyle(
                fontFamily: kFontBook,
                height: 1.5,
                color: eUser().mainHeadingColor,
                fontSize: 12.dp,
              ),
            ),
            SizedBox(height: 2.h),
            Consumer<CartProvider>(
              builder: (context, cartManager, child) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary : ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.8,
                          fontFamily: kFontMedium,
                          color: gBlackColor,
                          fontSize: 13.dp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      ListView.builder(
                        itemCount: cartManager.items.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = cartManager.items[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MediaQuery.of(context).size.shortestSide > 600
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            item.thumbnail.toString(),
                                            fit: BoxFit.contain,
                                            height: 8.h,
                                            width: 5.w,
                                            errorBuilder:
                                                (
                                                  BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace,
                                                ) {
                                                  // Show an asset image if the network image fails to load
                                                  return Image.asset(
                                                    'assets/images/meal_placeholder.png',
                                                    fit: BoxFit.contain,
                                                    height: 10.h,
                                                    width: 15.w,
                                                  );
                                                },
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            item.thumbnail.toString(),
                                            fit: BoxFit.contain,
                                            height: 10.h,
                                            width: 15.w,
                                            errorBuilder:
                                                (
                                                  BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace,
                                                ) {
                                                  // Show an asset image if the network image fails to load
                                                  return Image.asset(
                                                    'assets/images/meal_placeholder.png',
                                                    fit: BoxFit.contain,
                                                    height: 10.h,
                                                    width: 15.w,
                                                  );
                                                },
                                          ),
                                        ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 2.h),
                                        Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                            fontSize: 13.dp,
                                            fontFamily: kFontBold,
                                            color: gBlackColor,
                                          ),
                                        ),
                                        Text(
                                          item.category ?? '',
                                          style: TextStyle(
                                            color: gBlackColor,
                                            fontFamily: kFontBook,
                                            fontSize: 10.dp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '₹',
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.dp,
                                            fontFamily: kFontBook,
                                            color: gBlackColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${item.price! * item.quantity}",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 15.dp,
                                            fontFamily: kFontMedium,
                                            color: gBlackColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ".00",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.dp,
                                            fontFamily: kFontBook,
                                            color: gBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          SizedBox(height: 8.h, width: 30.w),
                          Expanded(
                            child: Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 13.dp,
                                fontFamily: kFontBook,
                                color: gBlackColor,
                              ),
                            ),
                          ),
                          Text(
                            "₹${grandTotal.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 15.dp,
                              fontFamily: kFontMedium,
                              color: gBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
