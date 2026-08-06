import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppConfig {
  static AppConfig? instance;
  factory AppConfig() => instance ??= AppConfig._();
  AppConfig._();

  SharedPreferences? preferences;

  final String baseUrl = "https://gutandhealth.com/api/";

  final String bearerToken = "Bearer";

  void showSnackBar(
    BuildContext context,
    String message, {
    int? duration,
    bool? isError,
    SnackBarAction? action,
    double? bottomPadding,
  }) {
    final bool error = isError ?? false;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final bool isDesktop = MediaQuery.of(context).size.width > 700;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(seconds: duration ?? 3),
        margin: EdgeInsets.only(
          left: isDesktop ? MediaQuery.of(context).size.width * .28 : 12,
          right: isDesktop ? MediaQuery.of(context).size.width * .28 : 12,
          bottom: bottomPadding ?? 18,
        ),
        padding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: error
                    ? [const Color(0xffEF5350), const Color(0xffC62828)]
                    : [const Color(0xff43A047), const Color(0xff1B5E20)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (error ? Colors.red : Colors.green).withAlpha(60),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: gWhiteColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    error ? Icons.error : Icons.check_circle,
                    color: gWhiteColor,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error ? "Oops!" : "Success",
                        style: TextStyle(
                          color: gWhiteColor,
                          fontFamily: fontBold,
                          fontSize: fontSize12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: TextStyle(
                          color: gWhiteColor.withAlpha(90),
                          fontFamily: fontMedium,
                          fontSize: fontSize10,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: gWhiteColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: gWhiteColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
