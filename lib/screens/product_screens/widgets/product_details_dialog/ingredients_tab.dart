import 'package:flutter/material.dart';

import '../../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../../utils/constants.dart';

class IngredientsTab extends StatelessWidget {
  final Products item;

  const IngredientsTab({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: item.productIngredients!
          .split(',')
          .map(
            (ingredient) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xffFFF8F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xffE8DED1),
            ),
          ),
          child: Text(
            ingredient.trim(),
            style: TextStyle(
              color: gBlackColor,
              fontSize: fontSize09,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
