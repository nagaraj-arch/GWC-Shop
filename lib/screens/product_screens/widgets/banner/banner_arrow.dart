import 'package:flutter/material.dart';

class BannerArrow extends StatelessWidget {
  final bool isLeft;
  final VoidCallback onTap;

  const BannerArrow({
    super.key,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Icon(
          isLeft
              ? Icons.arrow_back_ios_new_rounded
              : Icons.arrow_forward_ios_rounded,
          color: Colors.black87,
          size: 26,
        ),
      ),
    );
  }
}