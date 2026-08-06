import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'icon_button.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButtonWidget(
      msg: "Track Order",
      icon: Icons.location_on_outlined,
      onTap: () {
        context.go('/order');
      },
    );
    // return ButtonWidget(
    //   text: "Track Order",
    //   icon: Icons.location_on_outlined,
    //   onPressed: () {
    //     context.go('/order');
    //   },
    //   isLoading: false,
    //   borderClr: gPrimaryColor,
    //   color: gPrimaryColor,
    //   radius: 8,
    // );
    // SizedBox(
    //   height: 5.h,
    //   child: FloatingActionButton.extended(
    //     onPressed: () {
    //       context.go('/order');
    //     },
    //     elevation: 1,
    //     hoverElevation: 2,
    //     highlightElevation: 2,
    //     focusElevation: 1,
    //     backgroundColor: gBlackColor,
    //     icon: Icon(
    //       Icons.location_on_outlined,
    //       color: gWhiteColor,
    //       size: 2.5.h,
    //     ),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     label: Text(
    //       "Track Order",
    //       style: TextStyle(
    //         fontSize: 12.dp,
    //         fontFamily: kFontMedium,
    //         color: gWhiteColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}
