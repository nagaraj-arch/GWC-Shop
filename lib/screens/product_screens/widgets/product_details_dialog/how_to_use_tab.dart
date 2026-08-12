import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/container_widgets/common_card.dart';

class HowToUseTab extends StatelessWidget {
  final Products item;
  const HowToUseTab({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final recipeContent = item.productRecipeContent ?? '';

    final steps =
    recipeContent.split('\n').where((e) => e.trim().isNotEmpty).toList();

    return Column(
      children: [
        CommonCard(
          elevation: 2,
          backgroundColor: const Color(0xffFFF8F0),
          borderClr: const Color(0xffE8DED1),
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.zero,
          borderRadius: 24,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: gPrimaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: gPrimaryColor,
                      size: 2.h,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HOW TO USE",
                          style: TextStyle(
                            color: gPrimaryColor,
                            fontSize: fontSize10,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w800,
                            height: 1.4,
                          ),
                        ),
                        Text(
                          "Follow these easy cooking steps",
                          style: TextStyle(
                            color: gHintTextColor,
                            fontSize: fontSize08,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ...List.generate(
                steps.length,
                    (index) => TweenAnimationBuilder<double>(
                  duration: Duration(
                    milliseconds: 300 + (index * 150),
                  ),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(30 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            steps[index]
                                .replaceFirst(RegExp(r'Step\s*\d+\s*:\s*'), '')
                                .trim(),
                            style: TextStyle(
                              color: gBlackColor,
                              fontSize: fontSize10,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
