import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controllers/models/shop_models/products_by_category_model.dart';
import '../../../controllers/providers/products_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/container_widgets/common_card.dart';
import '../../../widgets/container_widgets/common_divider.dart';
import '../../../widgets/iamge_picker_widget/thumbnail_view.dart';
import '../../../widgets/loading_widgets/loading_indicator.dart';
import 'item_quantity.dart';
import 'new_badge.dart';
import 'price_widget.dart';
import 'product_details_dialog/faq_tab.dart';
import 'product_details_dialog/how_to_use_tab.dart';
import 'product_details_dialog/ingredients_tab.dart';
import 'rating_widget.dart';
import 'servings_badge.dart';
import 'video_popup.dart';

class ProductTabModel {
  final String title;
  final Widget child;

  ProductTabModel({required this.title, required this.child});
}

class ProductDetailsDialog extends StatefulWidget {
  final Products item;

  const ProductDetailsDialog({super.key, required this.item});

  @override
  State<ProductDetailsDialog> createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  final GlobalKey imageKey = GlobalKey();

  bool hideImage = false;

  bool isHovered = false;

  int selectedTab = 0;
  late PageController pageController;

  int currentImage = 0;

  final int initialPage = 3000;

  AnimationController? bounceController;
  Animation<double>? bounceAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ProductsProvider>(
        context,
        listen: false,
      ).fetchProductFlavors(widget.item.productId ?? 0);
    });

    pageController = PageController(initialPage: initialPage);

    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    bounceAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
    ]).animate(bounceController!);

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse && !hideImage) {
        setState(() {
          hideImage = true;
        });
      }

      if (direction == ScrollDirection.forward && hideImage) {
        setState(() {
          hideImage = false;
        });
      }
    });
  }

  // ============================
  // FREQUENTLY BOUGHT TOGETHER
  // ============================

  final Set<int> _selectedBoughtTogether = {};

  List<Products> _getBoughtTogetherProducts(Products currentItem) {
    final provider = Provider.of<ProductsProvider>(context, listen: false);

    final products = provider.popularProducts
        .where((product) {
          return product.productId != currentItem.productId;
        })
        .take(3)
        .toList();

    return products;
  }

  double _productPrice(Products product) {
    return double.tryParse(product.discountPrice?.toString() ?? '') ??
        double.tryParse(product.actualPrice?.toString() ?? '') ??
        0;
  }

  double _boughtTogetherTotal(List<Products> products) {
    return products
        .asMap()
        .entries
        .where((entry) => _selectedBoughtTogether.contains(entry.key))
        .fold(0, (total, entry) => total + _productPrice(entry.value));
  }

  List<ProductTabModel> getAvailableTabs(Products item) {
    final tabs = <ProductTabModel>[];

    /// How To Use
    if ((item.productRecipeContent ?? '').trim().isNotEmpty) {
      tabs.add(
        ProductTabModel(
          title: "How To Use",
          child: HowToUseTab(item: item),
        ),
      );
    }

    /// Testimonials
    if ((item.productTestimonials ?? []).isNotEmpty) {
      tabs.add(
        ProductTabModel(title: "Testimonial", child: _testimonialTab(item)),
      );
    }

    /// Recipe Video
    if ((item.productRecipeVideo ?? '').trim().isNotEmpty &&
        item.productRecipeVideo != 'null') {
      tabs.add(
        ProductTabModel(title: "Recipe Videos", child: _recipeVideoTab(item)),
      );
    }

    /// Ingredients
    if ((item.productIngredients ?? '').trim().isNotEmpty) {
      tabs.add(
        ProductTabModel(
          title: "Ingredients",
          child: IngredientsTab(item: item),
        ),
      );
    }

    /// Ingredients
    if (item.hasFlavours == "1") {
      tabs.add(ProductTabModel(title: "Flavors", child: _flavorsTab(item)));
    }

    /// FAQ
    if ((item.faq ?? []).isNotEmpty) {
      tabs.add(
        ProductTabModel(
          title: "FAQ",
          child: FaqTab(item: item),
        ),
      );
    }

    return tabs;
  }

  void nextImage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousImage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bounceController?.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final isMobile = MediaQuery.of(context).size.width < 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 40,
        vertical: isMobile ? 20 : 40,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: isMobile ? 700 : 800,
        ),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isMobile ? _buildMobile(item) : _buildDesktop(item),
      ),
    );
  }

  Widget _buildDesktop(Products item) {
    final currentMedia = item.productThumbnailsUrls![currentImage];

    final isCurrentVideo = isVideo(currentMedia);
    return Row(
      children: [
        Expanded(flex: 5, child: _buildImageSection(item)),
        Container(width: 1, color: borderColor),
        Expanded(
          flex: 6,
          child: (_isZooming && !isCurrentVideo)
              ? _buildAmazonZoomWindow(item)
              : _buildRightSection(item),
        ),
      ],
    );
  }

  Widget _buildMobile(Products item) {
    final tabs = getAvailableTabs(item);

    return Column(
      children: [
        /// Header Fixed
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildHeader(item),
        ),

        /// Scroll Area
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              /// IMAGE
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildImageSection(item, showBadge: false),
                  ),
                ),
              ),

              /// Sticky Tabs
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabsDelegate(
                  minHeight: 55,
                  maxHeight: 55,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildTabs(tabs),
                        const CommonDivider(verticalMargin: 0),
                      ],
                    ),
                  ),
                ),
              ),

              /// CONTENT
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: tabs.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text("No information available"),
                          ),
                        )
                      : tabs[selectedTab].child,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),

        /// Bottom Fixed
        _buildBottomBar(item),
      ],
    );
  }

  bool isVideo(String url) {
    final lower = url.toLowerCase();

    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.m4v') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.webm') ||
        lower.contains('.mp4?');
  }

  // Widget _buildImageSliderMobile(AdditionalProducts item) {
  //   return SizedBox(
  //     height: 220,
  //     child: MouseRegion(
  //       onEnter: (_) => setState(() => isHovered = true),
  //       onExit: (_) => setState(() => isHovered = false),
  //       child: Stack(
  //         children: [
  //           PageView.builder(
  //             controller: pageController,
  //             onPageChanged: (value) {
  //               setState(() {
  //                 currentImage = value % item.productThumbnails!.length;
  //               });
  //             },
  //             itemBuilder: (_, index) {
  //               final imageIndex = index % item.productThumbnails!.length;
  //               final mediaUrl = item.productThumbnails![imageIndex];
  //
  //               final isMediaVideo = isVideo(mediaUrl);
  //
  //               return AnimatedScale(
  //                 scale: isHovered ? 1.08 : 1,
  //                 duration: const Duration(milliseconds: 300),
  //                 child: isMediaVideo
  //                     ? GestureDetector(
  //                         onTap: () {
  //                           showDialog(
  //                             context: context,
  //                             barrierDismissible: false,
  //                             builder: (_) => VideoPopup(
  //                               title: item.productTitle ?? '',
  //                               videoUrl: mediaUrl,
  //                             ),
  //                           );
  //                         },
  //                         child: Stack(
  //                           fit: StackFit.expand,
  //                           children: [
  //                             ThumbnailView(
  //                               context: context,
  //                               imageUrl: item.primaryThumbnailUrl ?? '',
  //                               fileName: item.productTitle,
  //                               fit: BoxFit.contain,
  //                               borderRadius: isHovered ? 2 : 12,
  //                               enablePreview: false,
  //                             ),
  //                             Center(
  //                               child: Container(
  //                                 padding: const EdgeInsets.all(6),
  //                                 decoration: const BoxDecoration(
  //                                   color: gWhiteColor,
  //                                   shape: BoxShape.circle,
  //                                 ),
  //                                 child: Icon(
  //                                   Icons.play_arrow_rounded,
  //                                   size: 3.5.h,
  //                                   color: gsecondaryColor,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : ThumbnailView(
  //                         context: context,
  //                         imageUrl: mediaUrl,
  //                         fileName: item.productTitle,
  //                         fit: BoxFit.contain,
  //                         borderRadius: isHovered ? 2 : 12,
  //                         enablePreview: false,
  //                       ),
  //               );
  //             },
  //           ),
  //
  //           /// Left Arrow
  //           if (isHovered)
  //             Positioned(
  //               left: 15,
  //               top: 0,
  //               bottom: 0,
  //               child: Center(
  //                 child: CommonCard(
  //                   elevation: 2,
  //                   backgroundColor: const Color(0xffFFF8F0),
  //                   borderClr: const Color(0xffE8DED1),
  //                   padding: const EdgeInsets.all(6),
  //                   margin: EdgeInsets.zero,
  //                   borderRadius: 50,
  //                   child: InkWell(
  //                     onTap: previousImage,
  //                     child: const Icon(Icons.chevron_left),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //
  //           /// Right Arrow
  //           if (isHovered)
  //             Positioned(
  //               right: 15,
  //               top: 0,
  //               bottom: 0,
  //               child: Center(
  //                 child: CommonCard(
  //                   elevation: 2,
  //                   backgroundColor: const Color(0xffFFF8F0),
  //                   borderClr: const Color(0xffE8DED1),
  //                   padding: const EdgeInsets.all(6),
  //                   margin: EdgeInsets.zero,
  //                   borderRadius: 50,
  //                   child: InkWell(
  //                     onTap: nextImage,
  //                     child: const Icon(Icons.chevron_right),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           Positioned(
  //             left: 12,
  //             top: 12,
  //             child: CommonCard(
  //               elevation: 2,
  //               backgroundColor: const Color(0xffFFF8F0),
  //               borderClr: const Color(0xffE8DED1),
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //               margin: EdgeInsets.zero,
  //               borderRadius: 6,
  //               child: Text(
  //                 item.productSpecialTag ?? '',
  //                 style: TextStyle(
  //                   color: gPrimaryColor,
  //                   fontSize: fontSize07,
  //                   fontFamily: fontMedium,
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           /// Thumbnail Selector
  //           Positioned(
  //             bottom: 18,
  //             left: 10,
  //             right: 10,
  //             child: SizedBox(
  //               height: 30,
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   CommonCard(
  //                     elevation: 2,
  //                     borderRadius: 8,
  //                     borderClr: borderColor,
  //                     backgroundColor: gWhiteColor,
  //                     margin: EdgeInsets.zero,
  //                     padding: const EdgeInsets.all(3),
  //                     child: Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: List.generate(
  //                         item.productThumbnails!.length,
  //                         (index) {
  //                           final isSelected = currentImage == index;
  //
  //                           return GestureDetector(
  //                             behavior: HitTestBehavior.opaque,
  //                             onTap: () {
  //                               final currentRealPage =
  //                                   pageController.page?.round() ??
  //                                       (item.productThumbnails!.length * 1000);
  //
  //                               final basePage = currentRealPage -
  //                                   (currentRealPage %
  //                                       item.productThumbnails!.length);
  //
  //                               pageController.animateToPage(
  //                                 basePage + index,
  //                                 duration: const Duration(milliseconds: 300),
  //                                 curve: Curves.easeInOut,
  //                               );
  //                             },
  //                             child: Container(
  //                               margin:
  //                                   const EdgeInsets.symmetric(horizontal: 2),
  //                               width: 25,
  //                               height: 70,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(6),
  //                                 border: Border.all(
  //                                   color: isSelected
  //                                       ? const Color(0xffA54B4B)
  //                                       : const Color(0xffE5E5E5),
  //                                   width: isSelected ? 2 : 1,
  //                                 ),
  //                               ),
  //                               child: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(6),
  //                                 child: IgnorePointer(
  //                                   child: isVideo(
  //                                           item.productThumbnails![index])
  //                                       ? Stack(
  //                                           fit: StackFit.expand,
  //                                           children: [
  //                                             ThumbnailView(
  //                                               context: context,
  //                                               imageUrl:
  //                                                   item.primaryThumbnailUrl ??
  //                                                       '',
  //                                               fileName:
  //                                                   item.productTitle ?? '',
  //                                               fit: BoxFit.cover,
  //                                               enablePreview: false,
  //                                             ),
  //                                             Container(
  //                                               color: Colors.black26,
  //                                             ),
  //                                             const Center(
  //                                               child: Icon(
  //                                                 Icons.play_circle_fill,
  //                                                 color: Colors.white,
  //                                                 size: 16,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         )
  //                                       : ThumbnailView(
  //                                           context: context,
  //                                           imageUrl:
  //                                               item.productThumbnails![index],
  //                                           fileName: item.productTitle ?? '',
  //                                           fit: BoxFit.cover,
  //                                           enablePreview: false,
  //                                         ),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  int selectedImageIndex = 0;
  bool _isZooming = false;
  Offset _mousePosition = Offset.zero;

  Widget _buildImageSection(Products item, {bool showBadge = true}) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: isDesktop ? 3.h : 0.h,
      ),
      child: Column(
        children: [
          Expanded(flex: 4, child: _buildMainImage(item)),
          SizedBox(height: 2.h),
          _buildThumbnailList(item),
          SizedBox(height: 2.h),
          // if (showBadge) ...[
          //   SizedBox(height: 2.h),
          //   _buildHealthBadge(item),
          // ],
        ],
      ),
    );
  }

  Widget _buildMainImage(Products item) {
    final currentMedia = item.productThumbnailsUrls![currentImage];
    final isCurrentVideo = isVideo(currentMedia);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return MouseRegion(
          onEnter: (_) => setState(() => _isZooming = true),
          onExit: (_) => setState(() => _isZooming = false),
          onHover: (event) => setState(() {
            _mousePosition = event.localPosition;
          }),
          child: Stack(
            children: [
              Center(
                child: isCurrentVideo
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => VideoPopup(
                              title: item.productTitle ?? '',
                              videoUrl: currentMedia,
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ThumbnailView(
                              context: context,
                              imageUrl: item.productThumbnailsUrls?.first ?? '',
                              fileName: item.productTitle ?? '',
                              fit: BoxFit.contain,
                              enablePreview: false,
                            ),
                            const Center(
                              child: CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ThumbnailView(
                        context: context,
                        key: ValueKey(currentMedia),
                        imageUrl: currentMedia,
                        fileName: item.productTitle ?? '',
                        fit: BoxFit.contain,
                        enablePreview: false,
                      ),
              ),
              if (_isZooming)
                Positioned(
                  left: (_mousePosition.dx - 75).clamp(0.0, width - 150),
                  top: (_mousePosition.dy - 75).clamp(0.0, height - 150),
                  child: IgnorePointer(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0x55FFF3A0),
                        border: Border.all(color: const Color(0xff666666)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThumbnailList(Products item) {
    return SizedBox(
      height: 40,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(item.productThumbnailsUrls?.length ?? 0, (
              index,
            ) {
              final selected = currentImage == index;
              final imageUrl = item.productThumbnailsUrls![index];

              return Padding(
                padding: EdgeInsets.only(
                  right: index == (item.productThumbnailsUrls!.length - 1)
                      ? 0
                      : 6,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentImage = index;
                    });

                    if (isVideo(imageUrl)) {
                      _isZooming = false;
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      if (currentImage == index) return;

                      setState(() {
                        currentImage = index;

                        if (isVideo(imageUrl)) {
                          _isZooming = false;
                        }
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: selected
                                ? gPrimaryColor
                                : Colors.transparent,
                            width: selected ? 2 : 1,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: gBlackColor.withAlpha(20),
                                    blurRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: isVideo(imageUrl)
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ThumbnailView(
                                      context: context,
                                      imageUrl:
                                          item.productThumbnailsUrls?.first ??
                                          '',
                                      fileName: item.productTitle ?? '',
                                      fit: BoxFit.contain,
                                      enablePreview: false,
                                    ),
                                    Container(color: Colors.black26),
                                    const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : ThumbnailView(
                                  context: context,
                                  imageUrl: imageUrl,
                                  fileName: item.productTitle ?? '',
                                  fit: BoxFit.contain,
                                  enablePreview: false,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildAmazonZoomWindow(Products item) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const zoomFactor = 3.0;

          final dx = (_mousePosition.dx / 450).clamp(0.0, 1.0);

          final dy = (_mousePosition.dy / 500).clamp(0.0, 1.0);

          return ClipRect(
            child: Transform.translate(
              offset: Offset(
                -(constraints.maxWidth * (zoomFactor - 1) * dx),
                -(constraints.maxHeight * (zoomFactor - 1) * dy),
              ),
              child: Transform.scale(
                scale: zoomFactor,
                alignment: Alignment.topLeft,
                child: SizedBox.expand(
                  child: ThumbnailView(
                    context: context,
                    key: ValueKey(item.productThumbnailsUrls![currentImage]),
                    imageUrl: item.productThumbnailsUrls![currentImage],
                    fileName: item.productTitle ?? '',
                    fit: BoxFit.contain,
                    enablePreview: false,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(Products item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: gWhiteColor,
        border: Border(top: BorderSide(color: borderColor)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonPriceWidget(
              actualPrice: item.actualPrice,
              discountPrice: item.discountPrice,
              discountPercentage: item.discountPercentage,
            ),
          ),
          const SizedBox(width: 12),
          ItemQuantity(item: widget.item),
        ],
      ),
    );
  }

  Widget _buildRightSection(Products item) {
    final availableTabs = getAvailableTabs(item);

    if (selectedTab >= availableTabs.length) {
      selectedTab = 0;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(item),
          // _buildBoughtTogether(item),

          _buildTabs(availableTabs),
          const CommonDivider(verticalMargin: 0),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: availableTabs.isEmpty
                  ? const Center(child: Text("No information available"))
                  : availableTabs[selectedTab].child,
            ),
          ),
          const CommonDivider(verticalMargin: 0),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonPriceWidget(
                actualPrice: item.actualPrice,
                discountPrice: item.discountPrice,
                discountPercentage: item.discountPercentage,
              ),
              ItemQuantity(item: widget.item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Products item) {
    final description = (widget.item.productDescription ?? '').replaceAll(
      RegExp(r'^\s+'),
      '',
    );

    final boughtCount =
        int.tryParse(widget.item.boughtByUsersCount?.trim() ?? '0') ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CommonCard(
                  elevation: 2,
                  backgroundColor: const Color(0xffFFF8F0),
                  borderClr: const Color(0xffE8DED1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  margin: EdgeInsets.zero,
                  borderRadius: 8,
                  child: Text(
                    item.category?.name?.toUpperCase() ?? '',
                    style: TextStyle(
                      fontSize: fontSize08,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      color: gBlackColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (widget.item.isNew == true) NewBadge(),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffD9CBB9)),
                ),
                child: Icon(Icons.close, size: 2.5.h),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              "${item.productTitle}  ",
              style: TextStyle(
                fontFamily: "Caveat",
                fontSize: fontSize22,
                fontWeight: FontWeight.w700,
                color: gPrimaryColor,
              ),
            ),
            ItemInfoBadge(
              orderQuantity: "${item.itemQty}${item.weightType?.unit}",
              orderServings: item.servings,
            ),
          ],
        ),
        SizedBox(height: 1.h),
        CommonRatingWidget(
          rating: item.productRating,
          userCount: item.productUsersCount,
          starSize: 16,
        ),
        SizedBox(height: 1.h),

        /// Description
        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: gBlackColor,
            fontSize: fontSize10,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),

        if (boughtCount > 0) ...[
          SizedBox(height: .5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$boughtCount+ bought ",
                  style: TextStyle(
                    color: gBlackColor,
                    fontSize: fontSize10,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: 'in past month',
                  style: TextStyle(
                    color: gBlackColor,
                    fontSize: fontSize10,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildBoughtTogether(Products currentItem) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        final products = provider.popularProducts
            .where((product) => product.productId != currentItem.productId)
            .take(3)
            .toList();

        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        // Select all 3 initially
        if (_selectedBoughtTogether.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            setState(() {
              _selectedBoughtTogether.addAll(
                List.generate(products.length, (index) => index),
              );
            });
          });
        }

        final total = _boughtTogetherTotal(products);

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0, end: 1),
          builder: (context, animation, child) {
            return Opacity(
              opacity: animation,
              child: Transform.translate(
                offset: Offset(0, 25 * (1 - animation)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xffFFF9F2),
                  Colors.white,
                  const Color(0xffFFFDF9),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xffE9D9C5)),
              boxShadow: [
                BoxShadow(
                  color: gBlackColor.withAlpha(12),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF0DC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xffB66A28),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Frequently Bought Together",
                            style: TextStyle(
                              fontFamily: fontBold,
                              fontSize: fontSize14,
                              color: gBlackColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Complete your order with these popular picks",
                            style: TextStyle(
                              fontFamily: fontBook,
                              fontSize: fontSize09,
                              color: gHintTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// PRODUCTS
                SizedBox(
                  height: 145,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      final isSelected = _selectedBoughtTogether.contains(
                        index,
                      );

                      return Row(
                        children: [
                          _buildBoughtTogetherProduct(
                            product: product,
                            index: index,
                            isSelected: isSelected,
                          ),

                          if (index != products.length - 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF5E8D8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 15,
                                  color: Color(0xff9A6940),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// DIVIDER
                Container(height: 1, color: const Color(0xffEDE2D5)),

                const SizedBox(height: 14),

                /// BOTTOM
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_selectedBoughtTogether.length} items selected",
                            style: TextStyle(
                              fontFamily: fontMedium,
                              fontSize: fontSize09,
                              color: gHintTextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Total  ",
                                  style: TextStyle(
                                    fontFamily: fontMedium,
                                    fontSize: fontSize10,
                                    color: gHintTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "₹${total.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontFamily: fontBold,
                                    fontSize: fontSize15,
                                    color: gPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    AnimatedScale(
                      scale: _selectedBoughtTogether.isEmpty ? 0.96 : 1,
                      duration: const Duration(milliseconds: 250),
                      child: ElevatedButton.icon(
                        onPressed: _selectedBoughtTogether.isEmpty
                            ? null
                            : () {
                                _addBoughtTogetherToCart(products);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gPrimaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                        label: Text(
                          "Add selected",
                          style: TextStyle(
                            fontFamily: fontBold,
                            fontSize: fontSize10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBoughtTogetherProduct({
    required Products product,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedBoughtTogether.remove(index);
          } else {
            _selectedBoughtTogether.add(index);
          }
        });
      },
      child: TweenAnimationBuilder<double>(
        duration: Duration(
          milliseconds: 300 + (index * 100),
        ),
        curve: Curves.easeOutBack,
        tween: Tween(begin: 0.85, end: 1),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 125,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? gPrimaryColor
                  : const Color(0xffE8E8E8),
              width: isSelected ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? gPrimaryColor.withAlpha(18)
                    : Colors.black.withAlpha(8),
                blurRadius: isSelected ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  /// IMAGE
                  SizedBox(
                    height: 68,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ThumbnailView(
                        context: context,
                        imageUrl:
                        product.productThumbnailsUrls?.first ??
                            '',
                        fileName:
                        product.productTitle ?? '',
                        fit: BoxFit.contain,
                        enablePreview: false,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  /// NAME
                  Text(
                    product.productTitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontMedium,
                      fontSize: fontSize09,
                      color: gBlackColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// PRICE
                  Text(
                    "₹${_productPrice(product).toStringAsFixed(0)}",
                    style: TextStyle(
                      fontFamily: fontBold,
                      fontSize: fontSize10,
                      color: gPrimaryColor,
                    ),
                  ),
                ],
              ),

              /// CHECK
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? gPrimaryColor
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? gPrimaryColor
                          : const Color(0xffD5D5D5),
                      width: 1.5,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration:
                    const Duration(milliseconds: 180),
                    child: isSelected
                        ? const Icon(
                      Icons.check,
                      key: ValueKey(true),
                      color: Colors.white,
                      size: 14,
                    )
                        : const SizedBox(
                      key: ValueKey(false),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addBoughtTogetherToCart(List<Products> products) {
    final selectedProducts = products
        .asMap()
        .entries
        .where(
          (entry) =>
          _selectedBoughtTogether.contains(entry.key),
    )
        .map((entry) => entry.value)
        .toList();

    if (selectedProducts.isEmpty) return;

    /*
     * IMPORTANT:
     * Put your EXISTING cart-add logic here.
     *
     * I have intentionally not changed your cart/provider logic
     * because that code is not part of this ProductDetailsDialog.
     *
     * Example:
     *
     * for (final product in selectedProducts) {
     *   yourCartProvider.addToCart(product);
     * }
     */

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Text(
          "${selectedProducts.length} products selected",
        ),
      ),
    );
  }

  Widget _buildTabs(List<ProductTabModel> tabs) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final selected = selectedTab == index;

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? gPrimaryColor : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: selected ? gPrimaryColor : newLightGreyColor,
                  fontSize: selected ? fontSize12 : fontSize11,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // final List<IngredientModel> ingredientList = [
  //   IngredientModel(
  //     name: "Almonds",
  //     image: "https://img.icons8.com/color/480/almond.png",
  //   ),
  //   IngredientModel(
  //     name: "Dates",
  //     image: "https://img.icons8.com/color/480/date-fruit.png",
  //   ),
  //   IngredientModel(
  //     name: "Pea Protein",
  //     image: "https://img.icons8.com/color/480/soy.png",
  //   ),
  //   IngredientModel(
  //     name: "Cocoa Solids",
  //     image: "https://img.icons8.com/color/480/chocolate-bar.png",
  //   ),
  //   IngredientModel(
  //     name: "Cocoa Butter",
  //     image: "https://img.icons8.com/color/480/butter.png",
  //   ),
  //   IngredientModel(
  //     name: "Coffee Powder",
  //     image: "https://img.icons8.com/color/480/coffee-beans.png",
  //   ),
  //   IngredientModel(
  //     name: "Ragi Crisps",
  //     image: "https://img.icons8.com/color/480/wheat.png",
  //   ),
  //   IngredientModel(
  //     name: "Bajra Crisps",
  //     image: "https://img.icons8.com/color/480/grains.png",
  //   ),
  // ];
  //
  // Widget _ingredientsTab(AdditionalProducts item) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //
  //       final itemWidth = (constraints.maxWidth - 60) / 6;
  //
  //       return Wrap(
  //         spacing: 20,
  //         runSpacing: 35,
  //         children: ingredientList.map((ingredient) {
  //
  //           return SizedBox(
  //             width: itemWidth,
  //             child: _ingredientItem(ingredient),
  //           );
  //
  //         }).toList(),
  //       );
  //     },
  //   );
  // }
  //
  // Widget _ingredientItem(IngredientModel ingredient) {
  //
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //
  //       ThumbnailView(
  //         context: context,
  //         imageUrl: ingredient.image,
  //         fit: BoxFit.contain,height: 3.w,width: 3.w,
  //       ),
  //
  //       const SizedBox(height: 12),
  //
  //       Text(
  //         ingredient.name,
  //         textAlign: TextAlign.center,
  //         maxLines: 2,
  //         overflow: TextOverflow.ellipsis,
  //         style: TextStyle(
  //           fontFamily: fontMedium,
  //           fontSize: fontSize10,
  //           color: Colors.grey.shade800,
  //           height: 1.4,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _flavorsTab(Products item) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading(LoadingType.productFlavors)) {
          return const LoadingIndicator();
        }

        final flavours = provider.flavours ?? [];

        if (flavours.isEmpty) {
          return const Center(child: Text("No flavours available"));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: flavours.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final flavour = flavours[index];

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 250 + (index * 120)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOut,
              builder: (_, value, child) {
                return Transform.translate(
                  offset: Offset(40 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xffE7E7E7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: ThumbnailView(
                              context: context,
                              imageUrl: flavour.thumbnail ?? "",
                              fileName: flavour.finalProductName ?? "",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// NAME
                              Row(
                                children: [
                                  Text(
                                    flavour.finalProductName ?? "",
                                    style: TextStyle(
                                      fontFamily: fontBold,
                                      fontSize: fontSize12,
                                      color: gPrimaryColor,
                                    ),
                                  ),
                                  if ((flavour.flavourName ?? "").isNotEmpty &&
                                      flavour.flavourName != "null") ...[
                                    const SizedBox(width: 10),
                                    CommonCard(
                                      elevation: 2,
                                      backgroundColor: const Color(0xffFFF8F0),
                                      borderClr: const Color(0xffE8DED1),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      margin: EdgeInsets.zero,
                                      borderRadius: 6,
                                      child: Text(
                                        flavour.flavourName ?? '',
                                        style: TextStyle(
                                          color: Colors.orange.shade900,
                                          fontSize: fontSize08,
                                          fontFamily: fontMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                flavour.description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: gHintTextColor,
                                  fontSize: fontSize10,
                                  height: 1.4,
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       "₹${flavour.discountedPrice}",
                              //       style: TextStyle(
                              //         color: gsecondaryColor,
                              //         fontFamily: fontBold,
                              //         fontSize: fontSize12,
                              //       ),
                              //     ),
                              //     const SizedBox(width: 8),
                              //     Text(
                              //       "₹${flavour.actualPrice}",
                              //       style: TextStyle(
                              //         decoration: TextDecoration.lineThrough,
                              //         color: Colors.grey,
                              //         fontSize: fontSize10,
                              //       ),
                              //     ),
                              //     const Spacer(),
                              //     if ((flavour.howToPrepare ?? "").isNotEmpty)
                              //       Container(
                              //         padding: const EdgeInsets.symmetric(
                              //           horizontal: 10,
                              //           vertical: 5,
                              //         ),
                              //         decoration: BoxDecoration(
                              //           color: const Color(0xffEEF8F1),
                              //           borderRadius: BorderRadius.circular(20),
                              //         ),
                              //         child: Row(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             const Icon(
                              //               Icons.restaurant_menu,
                              //               size: 14,
                              //               color: Colors.green,
                              //             ),
                              //             const SizedBox(width: 5),
                              //             Text(
                              //               "Recipe",
                              //               style: TextStyle(
                              //                 color: Colors.green,
                              //                 fontFamily: fontMedium,
                              //                 fontSize: fontSize08,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _testimonialTab(Products item) {
    final testimonials = item.productTestimonials ?? [];

    if (testimonials.isEmpty) {
      return const Center(child: Text("No testimonials available"));
    }

    return Column(
      children: testimonials.asMap().entries.map((entry) {
        final testimonial = entry.value;

        final rating = double.tryParse(testimonial.rating ?? "5") ?? 5.0;

        return CommonCard(
          elevation: 2,
          backgroundColor: gWhiteColor,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 12),
          borderRadius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xffA54848), Color(0xffC76A6A)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (testimonial.user ?? "U").substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: gWhiteColor,
                          fontSize: fontSize12,
                          fontFamily: fontBold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testimonial.user ?? '',
                          style: TextStyle(
                            color: gBlackColor,
                            fontSize: fontSize12,
                            fontFamily: fontBold,
                          ),
                        ),
                        Text(
                          DateFormat(
                            "dd MMM yyyy",
                          ).format(DateTime.parse(testimonial.date ?? '')),
                          style: TextStyle(
                            color: gHintTextColor,
                            fontSize: fontSize09,
                            fontFamily: fontBook,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommonCard(
                    elevation: 0,
                    backgroundColor: gBgColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.5.w,
                      vertical: 0.6.h,
                    ),
                    margin: EdgeInsets.zero,
                    borderRadius: 6,
                    child: Row(
                      children: [
                        RatingBarIndicator(
                          rating: rating,
                          itemBuilder: (_, __) => const Icon(
                            Icons.star_rounded,
                            color: Color(0xffF6B100),
                          ),
                          itemCount: 5,
                          itemSize: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontFamily: fontBold,
                            fontSize: fontSize10,
                            color: gBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              /// Review
              CommonCard(
                elevation: 1,
                backgroundColor: const Color(0xffFBF7F0),
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                borderClr: Colors.transparent,
                margin: EdgeInsets.zero,
                borderRadius: 12,
                child: Row(
                  children: [
                    Icon(Icons.format_quote, color: gPrimaryColor, size: 3.h),
                    SizedBox(width: 0.5.w),
                    Expanded(
                      child: Text(
                        testimonial.comment ?? '',
                        style: TextStyle(
                          fontSize: fontSize12,
                          color: gHintTextColor,
                          fontStyle: FontStyle.italic,
                          fontFamily: fontMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${d.inMinutes}:${twoDigits(d.inSeconds % 60)}";
  }

  Widget _recipeVideoTab(Products item) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black87,
          builder: (_) => VideoPopup(
            videoUrl: item.productRecipeVideo ?? '',
            title: item.productTitle ?? '',
          ),
        );
      },
      child: Container(
        height: 280,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gBlackColor.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// THUMBNAIL
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ThumbnailView(
                context: context,
                imageUrl: item.productThumbnailsUrls?[0] ?? '',
                fileName: item.productTitle ?? '',
                fit: BoxFit.cover,
                enablePreview: false,
              ),
            ),

            /// DARK OVERLAY
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gBlackColor.withAlpha(15),
                    gBlackColor.withAlpha(70),
                  ],
                ),
              ),
            ),

            /// TOP BADGE
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_fill, color: Colors.white, size: 14),
                    SizedBox(width: 5),
                    Text(
                      "RECIPE VIDEO",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// PLAY BUTTON
            Center(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: gWhiteColor.withAlpha(95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: gBlackColor.withAlpha(15), blurRadius: 15),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 6.h,
                  color: gPrimaryColor,
                ),
              ),
            ),

            /// BOTTOM DETAILS
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.productTitle ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.touch_app, size: 2.5.h, color: gWhiteColor),
                      const SizedBox(width: 5),
                      Text(
                        "Tap to watch full recipe",
                        style: TextStyle(
                          color: gWhiteColor,
                          fontSize: fontSize11,
                          fontFamily: fontBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabsDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyTabsDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabsDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}
