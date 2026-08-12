import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../../widgets/animated_cart_quantity.dart';

class GutClockProductCard extends StatelessWidget {
  final Products item;

  const GutClockProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withAlpha(20),
        //     blurRadius: 18,
        //     offset: const Offset(0, 10),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            /// IMAGE
            Expanded(
              flex: 6,
              child: Container(
                color: const Color(0xffFAFAFA),
                alignment: Alignment.center,
                child: ThumbnailView(
                  context: context,
                  imageUrl: item.productThumbnailsUrls?.first ?? "",
                  width: 110,
                  height: 115,
                  fit: BoxFit.contain,
                  enablePreview: false,
                ),
              ),
            ),

            /// RED SECTION
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                color: gPrimaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                item.productTitle ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cormorantGaramond(
                                  color: Colors.white,
                                  fontSize: 15,height: 1.1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                item.productDescription ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 08.dp,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedCartQuantity(item: item),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
