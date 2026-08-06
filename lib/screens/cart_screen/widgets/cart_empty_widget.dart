import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../widgets/button_widgets/button_widget.dart';

class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.h),
            decoration: BoxDecoration(
              color: gPrimaryColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 10.h,
              color: gPrimaryColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Your Basket is Empty",
            style: GoogleFonts.cormorantGaramond(
              fontSize: fontSize20,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: gPrimaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Add wellness formulations to begin your journey.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize12,
              color: newLightGreyColor,
              fontFamily: fontBook,
            ),
          ),
          SizedBox(height: 3.h),
          ButtonWidget(
            text: "Continue Shopping",
            color: gPrimaryColor,
            radius: 12,
            onPressed: () {
              GoRouter.of(context).go('/');
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
