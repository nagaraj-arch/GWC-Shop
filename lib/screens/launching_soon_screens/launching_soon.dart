import 'package:flutter/material.dart';

import '../footer_widget/footer_wrapper.dart';

class LaunchingSoon extends StatelessWidget {
  const LaunchingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return FooterWrapper(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Image.asset(
          "assets/images/launching_soon.png",
          fit: BoxFit.fill,
        ),
      )
    );
  }
}
