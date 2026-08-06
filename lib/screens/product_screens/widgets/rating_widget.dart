import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../utils/constants.dart';

class CommonRatingWidget extends StatelessWidget {
  final String? rating;
  final String? userCount;
  final double starSize;

  const CommonRatingWidget({
    super.key,
    this.rating,
    this.userCount,
    this.starSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final hasRating = rating != null &&
        rating!.trim().isNotEmpty &&
        rating!.toLowerCase() != 'null';

    final hasUserCount = userCount != null &&
        userCount!.trim().isNotEmpty &&
        userCount!.toLowerCase() != 'null';

    if (!hasRating && !hasUserCount) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasRating) ...[
          RatingBarIndicator(
            rating: double.tryParse(rating!) ?? 0,
            itemBuilder: (_, __) => const Icon(
              Icons.star,
              color: gPrimaryColor,
            ),
            itemCount: 5,
            itemSize: starSize,
          ),
          const SizedBox(width: 4),
          Text(
            rating!,
            style: TextStyle(
              fontSize: fontSize10,
              fontFamily: fontBold,
              color: gBlackColor,
            ),
          ),
        ],

        if (hasRating && hasUserCount)
          const SizedBox(width: 4),

        if (hasUserCount)
          Text(
            "($userCount reviews)",
            style: TextStyle(
              color: gGreyColor,
              fontSize: fontSize09,
              fontFamily: fontBook,
            ),
          ),
      ],
    );
  }
}