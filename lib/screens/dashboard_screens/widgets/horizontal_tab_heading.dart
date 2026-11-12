import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../utils/constants.dart';

class HorizontalTabHeading extends StatelessWidget {
  final String title;
  const HorizontalTabHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "Courier Prime",
            fontSize: fontSize13,
            fontWeight: FontWeight.w700,
            letterSpacing: .4,
            color: gMainColor,
          ),
        ),

        const SizedBox(width: 6),

        Image.asset(
          'assets/images/arrow.png',
          height: 2.h,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
