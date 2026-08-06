import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/opacity_to_alpha.dart';
import 'loading_indicator.dart';

class AppLoader {
  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) => Container(
          width: double.infinity,
          height: double.infinity,
          color: gBlackColor.withAlpha(
            AlphaHelper.fromOpacity(0.4),
          ),
          child: Center(child: LoadingIndicator()),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
