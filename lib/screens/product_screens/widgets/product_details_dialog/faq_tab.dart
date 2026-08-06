import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../controllers/models/get_additional_products_model/get_additional_products_model.dart';
import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_helper.dart';
import '../../../../widgets/container_widgets/common_card.dart';
import '../../../../widgets/container_widgets/common_divider.dart';

class FaqTab extends StatefulWidget {
  final Products item;

  const FaqTab({super.key, required this.item});

  @override
  State<FaqTab> createState() => _FaqTabState();
}

class _FaqTabState extends State<FaqTab> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final List<FAQ> faqList =
        (widget.item.faq != null && widget.item.faq!.isNotEmpty)
            ? widget.item.faq!
            : [
                FAQ(
                  qus: "What is Agni according to Ayurveda?",
                  ans:
                      "Agni refers to the digestive fire responsible for digesting food, absorbing nourishment, and supporting the body's metabolic processes.",
                ),
                FAQ(
                  qus: "Why is it taken three times a day?",
                  ans:
                      "Taking one ball after each main meal provides digestive support throughout the day rather than concentrating the full routine around a single meal.",
                ),
                FAQ(
                  qus: "Can I take all three balls together?",
                  ans:
                      "No. Consume only one ball after each main meal. Do not take the entire daily quantity at once.",
                ),
              ];

    return Column(
      children: List.generate(faqList.length, (index) {
        final faq = faqList[index];
        final isExpanded = expandedIndex == index;

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              expandedIndex = isExpanded ? -1 : index;
            });
          },
          child: CommonCard(
            elevation: 0,
            backgroundColor: gBlueColor.withAlpha(05),
            borderClr: gBlueColor.withAlpha(30),
            padding: EdgeInsets.symmetric(
                horizontal: responsive.isDesktop ? 1.5.w : 3.w, vertical: 2.h),
            margin: EdgeInsets.only(bottom: 2.h),
            borderRadius: 10,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  /// Question
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          faq.qus ?? "",
                          style: TextStyle(
                            fontFamily: fontMedium,
                            fontSize: fontSize10,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? .5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ],
                  ),

                  /// Divider + Answer
                  if (isExpanded) ...[
                    CommonDivider(verticalMargin: 2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faq.ans ?? "",
                        style: TextStyle(
                          fontFamily: fontBook,
                          fontSize: fontSize10,
                          color: gHintTextColor,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
