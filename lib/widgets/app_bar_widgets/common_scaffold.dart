import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/products_providers.dart';
import '../../screens/product_screens/widgets/cart_icon_widget.dart';
import '../../screens/product_screens/widgets/product_sort_widget.dart';
import '../../utils/constants.dart';
import '../../utils/opacity_to_alpha.dart';
import '../../utils/responsive_helper.dart';
import '../button_widgets/floating_button_widget.dart';
import '../container_widgets/common_divider.dart';
import '../text_field_widgets/common_search_bar.dart';

class CommonScaffold extends StatelessWidget {
  final bool isMain;
  final Widget child;
  final VoidCallback? func;
  final String? title;
  final bool isCart;
  final bool showVersion;

  const CommonScaffold({
    super.key,
    this.isMain = true,
    required this.child,
    this.func,
    this.title,
    this.isCart = true,
    this.showVersion = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDesktop = responsive.isDesktop;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: gBgColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            responsive.isDesktop ? 8.h : 14.h,
          ),
          child: Container(
            height: responsive.isDesktop ? 8.h : 14.h,
            padding: EdgeInsets.symmetric(
                vertical: 1.h, horizontal: isDesktop ? 5.w : 3.w),
            decoration: isDesktop
                ? const BoxDecoration(color: gWhiteColor)
                : BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            gBlackColor.withAlpha(AlphaHelper.fromOpacity(0.1)),
                        blurRadius: 8,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
            child: isMain
                ? (isDesktop
                    ? Row(
                        children: [
                          Image.asset(
                            "assets/images/progress_logo.png",
                            height: 5.h,
                          ),
                          SizedBox(width: 1.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Products By Gut Wellness Club",
                                style: TextStyle(
                                  fontFamily: kFontBold,
                                  fontSize: fontSize14,
                                  color: gBlackColor,
                                ),
                              ),
                              Text(
                                "v.1.2.1",
                                style: TextStyle(
                                  fontFamily: kFontBook,
                                  color: gGreyColor,
                                  fontSize: 8.dp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: buildSearchField(context),
                          ),
                          SizedBox(width: 1.w),
                          buildTrackerButton(),
                          SizedBox(width: 1.w),
                          if (isCart) const CartIconWidget(),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/progress_logo.png",
                                height: 4.h,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  "Products By Gut Wellness Club",
                                  style: TextStyle(
                                    fontFamily: kFontBold,
                                    fontSize: fontSize11,
                                  ),
                                ),
                              ),
                              if (isCart) const CartIconWidget(),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Expanded(
                                child: buildSearchField(context),
                              ),
                              SizedBox(width: 2.w),
                              buildTrackerButton(),
                            ],
                          ),
                        ],
                      ))
                : Row(
                    children: [
                      InkWell(
                        onTap: func,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: gBlackColor,
                            size: 2.5.h,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title ?? '',
                          style: TextStyle(
                            fontSize: 15.dp,
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      if (isCart) const CartIconWidget(),
                    ],
                  ),
          ),
        ),
        body: Column(
          children: [
            if (responsive.isDesktop) const CommonDivider(verticalMargin: 0),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget buildSearchField(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (_, provider, __) {
        return SizedBox(
          height: 45,
          child: TextField(
            controller: provider.searchController,
            decoration: InputDecoration(
              hintText: "Search products...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: provider.searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: provider.clearSearch,
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTrackerButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Navigate tracker screen
      },
      icon: const Icon(Icons.local_shipping_outlined),
      label: const Text("Track Order"),
      style: ElevatedButton.styleFrom(
        backgroundColor: gPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class ProductsHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final bool showVersion;

  const ProductsHeader({
    super.key,
    this.onBack,
    this.showVersion = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDesktop = responsive.isDesktop;

    final version = "v.1.2.4";

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 3.w : 3.w, vertical: 2.h),
      decoration: const BoxDecoration(
        color: gWhiteColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: isDesktop
          ? Row(
              children: [
                if (onBack != null) ...[
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: gBlackColor,
                    ),
                  ),
                  SizedBox(width: .5.w),
                ],
                _logoWidget(version),
                const Spacer(),
                if (onBack == null) ...[
                  searchWidget(isDesktop),
                  SizedBox(width: 0.8.w),
                  const FloatingButtonWidget(),
                  SizedBox(width: .8.w),
                  const ProductSortWidget(),
                  SizedBox(width: .8.w),
                  const CartIconWidget(),
                ],

              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    if (onBack != null)
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: gBlackColor,
                        ),
                      ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/progress_logo.png",
                            height: 4.h,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Products By Gut Wellness Club",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: kFontBold,
                                    fontSize: fontSize12,
                                    color: gBlackColor,
                                  ),
                                ),
                                if (showVersion)
                                  Text(
                                    version,
                                    style: TextStyle(
                                      fontFamily: kFontBook,
                                      color: gGreyColor,
                                      fontSize: 8.dp,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (onBack == null) const CartIconWidget(),
                  ],
                ),
                if (onBack == null) ...[
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: searchWidget(false),
                      ),
                      SizedBox(width: 2.w),
                      const FloatingButtonWidget(),
                      SizedBox(width: 2.w),
                      const ProductSortWidget(),
                    ],
                  ),
                ],
              ],
            ),
    );
  }

  Widget _logoWidget(String version) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/progress_logo.png",
          height: 5.h,
        ),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Products By Gut Wellness Club",
              style: TextStyle(
                fontFamily: kFontBold,
                fontSize: fontSize14,
                color: gBlackColor,
              ),
            ),
            if (showVersion)
              Text(
                version,
                style: TextStyle(
                  fontFamily: kFontBook,
                  color: gGreyColor,
                  fontSize: 8.dp,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget searchWidget(bool isDesktop) {
    return Consumer<ProductsProvider>(
      builder: (_, provider, __) {
        return CommonSearchBar(
          controller: provider.searchController,
          hintText: "Search products...",
          onChanged: (v) {
            provider.search(v);
          },
          borderColor: gHintTextColor,
          width: isDesktop ? 20 : double.maxFinite,
          onClear: provider.clearSearch,
        );
      },
    );
  }
}
