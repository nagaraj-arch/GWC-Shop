import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../utils/opacity_to_alpha.dart';
import '../../../utils/responsive_helper.dart';
import '../../controllers/models/tracking_model/get_tracking_model.dart';
import '../../controllers/providers/track_my_order_provider.dart';
import '../../utils/common_utils.dart';
import '../../widgets/app_bar_widgets/common_scaffold.dart';
import '../../widgets/button_widgets/button_widget.dart';
import '../../widgets/container_widgets/common_card.dart';
import '../../widgets/container_widgets/common_divider.dart';
import '../../widgets/loading_widgets/loading_indicator.dart';
import '../../widgets/text_field_widgets/common_search_bar.dart';
import '../../widgets/text_field_widgets/custom_date_text_field.dart';
import '../../widgets/text_field_widgets/validation_utils.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  final mobileFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final provider = context.read<TrackMyOrderProvider>();
    provider.phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final provider = context.watch<TrackMyOrderProvider>();

    final isValid = provider.phoneController.text.length == 10;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: gBgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductsHeader(onBack: () => context.go('/')),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isDesktop ? 20.w : 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: gWhiteColor,
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      shadowColor:
                          gBlackColor.withAlpha(AlphaHelper.fromOpacity(0.8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: borderColor, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: provider.phoneController,
                                hintText: "Enter Phone Number",
                                borderType: TextFieldBorderType.full,
                                fillColor: gBgColor,
                                borderClr: borderColor,
                                radius: 8,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onFieldSubmitted: (value) {
                                  provider.getTrackOrder(context);
                                },
                                textInputAction: TextInputAction.next,
                                align: TextAlign.start,
                                keyboardType: TextInputType.phone,
                                prefixIcon: Icons.phone_android_outlined,
                                validator: ValidationUtils().phoneValidator,
                                contentHeight: 2,
                              ),
                            ),
                            SizedBox(width: isDesktop ? 1.w : 2.w),
                            ButtonWidget(
                              text: "Search Orders",
                              onPressed: (!isValid ||
                                      provider
                                          .isLoading(LoadingType.trackOrder))
                                  ? null // 🔥 THIS disables button
                                  : () async {
                                      await provider.getTrackOrder(context);
                                    },
                              isLoading:
                                  provider.isLoading(LoadingType.trackOrder),
                              radius: 8,
                              color: isValid
                                  ? gBlackColor
                                  : Colors.grey.shade400, // 🔥 grey disabled
                              textColor: gWhiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: provider.isLoading(LoadingType.trackOrder)
                            ? const Center(child: LoadingIndicator())
                            : provider.trackList.isEmpty
                                ? Center(child: emptyView())
                                : mainView(provider, isDesktop)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  emptyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// ICON CIRCLE
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.phone_android,
            color: Colors.grey,
            size: 30,
          ),
        ),

        SizedBox(height: 2.h),

        /// TEXT
        const Text(
          "ENTER PHONE NUMBER TO\nVIEW ORDER HISTORY",
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  final TextEditingController orderSearchController = TextEditingController();

  bool isExpanded = false;
  int expandedIndex = 0; // ✅ first item open by default

  mainView(TrackMyOrderProvider provider, bool isDesktop) {
    final searchText = orderSearchController.text.toLowerCase();

    final filteredList = provider.trackList.where((order) {
      final orderId =
          (order.cfOrderId ?? order.razorpayOrderId ?? "").toLowerCase();

      return orderId.contains(searchText);
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: fontSize11,
                  fontFamily: fontMedium,
                  color: gHintTextColor,
                ),
                children: [
                  const TextSpan(
                    text: "• DISPLAYING RESULTS FOR ",
                  ),
                  TextSpan(
                    text: provider.phoneController.text,
                    style: TextStyle(
                      fontFamily: fontBold,
                      color: gPrimaryColor,
                      fontSize: fontSize12,
                    ),
                  ),
                ],
              ),
            ),
            CommonSearchBar(
              controller: orderSearchController,
              hintText: "Search by Order ID",
              width: isDesktop ? 20 : 40,
              fillColor: gWhiteColor,
              borderColor: gBlackColor,
              onChanged: (value) {
                setState(() {});
              },
              onClear: () {
                orderSearchController.clear();
                setState(() {});
              },
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var item = filteredList[index];

              return OrderCard(
                order: item,
                isExpanded: expandedIndex == index,
                onTap: () {
                  setState(() {
                    expandedIndex = expandedIndex == index ? -1 : index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class OrderCard extends StatefulWidget {
  final GetTracking order;
  final bool isExpanded;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isHovered = false;
  bool isTrackHovered = false;

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("dd MMM, hh:mm a").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;

    final status = widget.order.additionalOrderDetails?.status?.trim();

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        scale: isHovered ? 1.01 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: gBlackColor.withAlpha(isHovered ? 20 : 10),
                blurRadius: isHovered ? 28 : 18,
                offset: Offset(0, isHovered ? 12 : 6),
              ),
            ],
          ),
          child: Column(
            children: [
              /// 🔴 HEADER (CLICKABLE)
              InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(16),
                  bottom: widget.isExpanded
                      ? Radius.zero
                      : const Radius.circular(16),
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: widget.order.additionalOrderDetails?.status !=
                            "DELIVERED"
                        ? gPrimaryColor
                        : gBlackColor,
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(12),
                      bottom: Radius.zero,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.inventory, size: 2.5.h, color: gWhiteColor),
                      SizedBox(width: 1.w),

                      /// ORDER ID
                      Expanded(
                        child: Text(
                          SafeString.value(widget.order.cfOrderId ?? ''),
                          style: TextStyle(
                            color: gWhiteColor,
                            fontFamily: fontMedium,
                            fontSize: fontSize13,
                          ),
                        ),
                      ),

                      /// STATUS

                      if (status != null &&
                          status.isNotEmpty &&
                          status.toLowerCase() != "null")
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: gWhiteColor.withAlpha(120),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.order.additionalOrderDetails?.status ?? "",
                            style: TextStyle(
                              color: gWhiteColor,
                              fontSize: fontSize07,
                              fontFamily: fontMedium,
                            ),
                          ),
                        ),

                      SizedBox(width: 1.w),

                      /// 🔽 ICON
                      Icon(
                        widget.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: gWhiteColor,
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔥 EXPAND CONTENT
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: widget.isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,

                /// EXPANDED
                firstChild: Column(
                  children: [
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 1.5.w : 3.w),
                      child: isDesktop
                          ? IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                          height: double.infinity,
                                          child: SizedBox.expand(
                                              child: _buildProductsCard()))),
                                  const SizedBox(width: 18),
                                  Expanded(
                                      child: SizedBox(
                                          height: double.infinity,
                                          child: SizedBox.expand(
                                              child: _buildAddressCard()))),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                _buildProductsCard(),
                                const SizedBox(height: 16),
                                _buildAddressCard(),
                              ],
                            ),
                    ),
                    SizedBox(height: 2.h),
                    CommonDivider(verticalMargin: 0, opacity: 0.2),
                    CommonCard(
                      margin: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 1.5.w : 2.w, vertical: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// CREATED
                          Column(
                            children: [
                              Text(
                                "CREATED",
                                style: TextStyle(
                                  color: gGreyColor,
                                  fontSize: fontSize07,
                                  fontFamily: fontBook,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat("dd MMM, hh:mm a")
                                    .format(widget.order.createdAt!),
                                style: TextStyle(
                                  color: gBlackColor,
                                  fontSize: fontSize12,
                                  fontFamily: fontBold,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          SizedBox(
                            height: 55,
                            child: VerticalDivider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Spacer(),

                          /// TOTSpacer(),AL
                          Column(
                            children: [
                              Text(
                                "TOTAL PAID",
                                style: TextStyle(
                                  color: gGreyColor,
                                  fontSize: fontSize07,
                                  fontFamily: fontBook,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "₹${widget.order.totalAmount ?? "0"}",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: fontSize13,
                                  fontFamily: fontBold,
                                ),
                              ),
                            ],
                          ),

                          if (widget.order.additionalOrderDetails != null) ...[
                            Spacer(),

                            SizedBox(
                              height: 55,
                              child: VerticalDivider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Spacer(),

                            /// TRACK
                            Column(
                              children: [
                                Text(
                                  widget.order.additionalOrderDetails
                                          ?.courierName ??
                                      "-",
                                  style: TextStyle(
                                    color: gBlackColor,
                                    fontSize: fontSize10,
                                    fontFamily: fontMedium,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => isTrackHovered = true),
                                  onExit: (_) =>
                                      setState(() => isTrackHovered = false),
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final url =
                                          "https://shiprocket.co/tracking/${widget.order.additionalOrderDetails?.awbCode ?? ''}";

                                      final uri = Uri.parse(url);

                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(
                                          uri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        AppConfig().showSnackBar(
                                          context,
                                          "Could not open tracking page.",
                                          isError: true,
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedRotation(
                                          turns: isTrackHovered ? .05 : 0,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: Icon(
                                            Icons.local_shipping_outlined,
                                            color: isTrackHovered
                                                ? gMainColor
                                                : gPrimaryColor,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Track Shipment",
                                          style: TextStyle(
                                            color: isTrackHovered
                                                ? gMainColor
                                                : gPrimaryColor,
                                            fontFamily: fontBold,
                                            fontSize: fontSize11,
                                            letterSpacing: .3,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        AnimatedSlide(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          offset: isTrackHovered
                                              ? const Offset(.15, 0)
                                              : Offset.zero,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: isTrackHovered
                                                ? gMainColor
                                                : gPrimaryColor,
                                            size: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                /// COLLAPSED
                secondChild: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.order.productDetails?.length ?? 0} items",
                          style: TextStyle(color: gGreyColor),
                        ),
                      ),
                      Text(
                        "₹${widget.order.totalAmount}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: gBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsCard() {
    return CommonCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: gsecondaryColor,
                size: 2.5.h,
              ),
              const SizedBox(width: 8),
              Text(
                "Products",
                style: TextStyle(
                  fontFamily: fontBold,
                  color: gBlackColor,
                  fontSize: fontSize12,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ...List.generate(
            widget.order.productDetails!.length,
            (index) {
              final item = widget.order.productDetails![index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ItemTile(
                  title: "${item.itemName} | ${item.itemWeight ?? ""}",
                  subtitle: "Qty ${item.itemQty} • ₹${item.itemPrice}",
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return CommonCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: gsecondaryColor,
                size: 2.5.h,
              ),
              const SizedBox(width: 5),
              Text(
                "Delivery Address",
                style: TextStyle(
                  fontFamily: fontBold,
                  color: gBlackColor,
                  fontSize: fontSize13,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            widget.order.name ?? "",
            style: TextStyle(
              fontFamily: fontBold,
              fontSize: fontSize12,
              color: gPrimaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${widget.order.houseNo}, ${widget.order.address}, ${widget.order.city}, ${widget.order.state} - ${widget.order.pincode}",
            style: TextStyle(
              color: gHintTextColor,
              fontSize: fontSize11,
              fontFamily: fontMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// class OrderCard extends StatelessWidget {
//   final GetTracking order;
//   const OrderCard({super.key, required this.order});
//
//   String formatDate(DateTime? date) {
//     if (date == null) return "-";
//     return "${date.day.toString().padLeft(2, '0')}-"
//         "${date.month.toString().padLeft(2, '0')}-"
//         "${date.year}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1.5.h),
//             decoration: BoxDecoration(
//               color: order.additionalOrderDetails?.status != "DELIVERED"
//                   ? gsecondaryColor
//                   : gBlackColor,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.inventory, size: 2.5.h, color: gWhiteColor),
//                     SizedBox(width: 0.5.w),
//                     Text(
//                       SafeString.value(order.cfOrderId ?? ''),
//                       style: TextStyle(
//                           color: gWhiteColor,
//                           fontFamily: fontMedium,
//                           fontSize: fontSize13),
//                     ),
//                   ],
//                 ),
//
//                 /// STATUS
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: gWhiteColor.withAlpha(AlphaHelper.fromOpacity(0.6)),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     order.additionalOrderDetails?.status ?? "",
//                     style: TextStyle(
//                       color: gWhiteColor,
//                       fontSize: fontSize07,
//                       fontFamily: fontMedium,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(height: 2.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 1.5.w),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// 🟢 LEFT - ORDER ITEMS
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: order.productDetails != null &&
//                               order.productDetails!.isNotEmpty
//                           ? List.generate(order.productDetails!.length,
//                               (index) {
//                               final item = order.productDetails![index];
//
//                               return Column(
//                                 children: [
//                                   ItemTile(
//                                     title: (() {
//                                       String name = item.itemName.toString();
//                                       String servings =
//                                           item.itemWeight?.toString() ?? '';
//                                       List<String> parts = [
//                                         name,
//                                         if (servings.isNotEmpty) servings
//                                       ];
//                                       return parts.join(' | ');
//                                     })(),
//                                     subtitle:
//                                         "${item.itemQty ?? 0} unit • ₹${item.itemPrice ?? 0}",
//                                   ),
//
//                                   /// 🔥 Divider (not for last item)
//                                   if (index != order.productDetails!.length - 1)
//                                     const CommonDivider(
//                                         verticalMargin: 2, opacity: 0.3)
//                                 ],
//                               );
//                             })
//                           : [
//                               const Text("No items"),
//                             ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 20),
//
//                 /// 🔵 RIGHT SIDE
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// 📍 ADDRESS
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.location_on_outlined,
//                                     color: gsecondaryColor, size: 2.h),
//                                 SizedBox(width: 0.5.w),
//                                 Text(
//                                   "SENT TO",
//                                   style: TextStyle(
//                                     fontSize: fontSize08,
//                                     color: gGreyColor,
//                                     fontFamily: fontBook,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               "${order.name}, ${order.houseNo}, ${order.address}, ${order.city}, ${order.state}, ${order.country} - ${order.pincode}.",
//                               style: TextStyle(
//                                 fontSize: fontSize11,
//                                 color: gBlackColor,
//                                 fontFamily: fontMedium,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       /// 💰 TOTAL + DATE
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0B1B33),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "CREATED",
//                                   style: TextStyle(
//                                     color: gWhiteColor.withAlpha(
//                                         AlphaHelper.fromOpacity(0.6)),
//                                     fontSize: fontSize07,
//                                     fontFamily: fontBook,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   DateFormat("dd MMM, hh:mm a")
//                                       .format(order.createdAt!),
//                                   style: TextStyle(
//                                     color: gWhiteColor,
//                                     fontSize: fontSize12,
//                                     fontFamily: fontBold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "TOTAL PAID",
//                                   style: TextStyle(
//                                     color: gWhiteColor.withAlpha(
//                                         AlphaHelper.fromOpacity(0.6)),
//                                     fontSize: fontSize07,
//                                     fontFamily: fontBook,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "₹${order.totalAmount ?? "0"}",
//                                   style: TextStyle(
//                                     color: gWhiteColor,
//                                     fontSize: fontSize12,
//                                     fontFamily: fontBold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(height: 1.h),
//           order.additionalOrderDetails == null
//               ? const SizedBox()
//               : Padding(
//                   padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.h),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         order.additionalOrderDetails?.courierName ?? '',
//                         style: TextStyle(
//                           fontFamily: kFontMedium,
//                           fontSize: 14.dp,
//                           color: gBlackColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5.h,
//                         child: FloatingActionButton.extended(
//                           onPressed: () async {
//                             String googleMapUrl =
//                                 "https://shiprocket.co/tracking/${order.additionalOrderDetails?.awbCode ?? ''}";
//                             Uri uri = Uri.parse(googleMapUrl);
//
//                             if (await canLaunchUrl(uri)) {
//                               await launchUrl(uri,
//                                   mode: LaunchMode.externalApplication);
//                             } else {
//                               AppConfig().showSnackbar(
//                                   context, "Could not open Google Maps.",
//                                   isError: true);
//                             }
//                           },
//                           backgroundColor: gBlackColor,
//                           icon: Icon(
//                             Icons.location_on_outlined,
//                             color: gWhiteColor,
//                             size: 2.5.h,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 10), // Reduce border radius
//                           ),
//                           label: Text(
//                             "Track Order",
//                             style: TextStyle(
//                               fontSize: fontSize12,
//                               fontFamily: kFontMedium,
//                               color: gWhiteColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

class ItemTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const ItemTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: newLightGreyColor.withAlpha(30),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 2.h,
            color: gPrimaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize12,
                  fontFamily: kFontMedium,
                  color: gBlackColor,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: fontSize10,
                  fontFamily: kFontMedium,
                  color: gGreyColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
