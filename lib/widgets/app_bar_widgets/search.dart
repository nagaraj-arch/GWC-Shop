import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/products_providers.dart';
import '../../utils/constants.dart';

class GlobalSearchResults extends StatelessWidget {
  const GlobalSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        if (!provider.isSearchOpen) {
          return const SizedBox.shrink();
        }

        final query = provider.searchController.text.trim();

        if (query.isEmpty) {
          return const SizedBox.shrink();
        }

        final results = provider.searchResults;

        return Positioned(
          top: 0,
          right: 30,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Container(
              width: 360,
              constraints: const BoxConstraints(
                maxHeight: 420,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: results.isEmpty
                  ? _emptyResult()
                  : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                itemCount: results.length,
                separatorBuilder: (_, __) {
                  return Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  );
                },
                itemBuilder: (context, index) {
                  final product = results[index];

                  return _resultItem(product);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _resultItem(dynamic product) {
    return InkWell(
      onTap: () {
        // Next we can add product details navigation.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                product.productTitle ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: gBlackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyResult() {
    return const Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Text(
          'No products found',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}