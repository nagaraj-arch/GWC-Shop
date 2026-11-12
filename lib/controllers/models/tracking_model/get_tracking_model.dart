import 'dart:convert';

class GetTrackingModel {
  int? status;
  int? errorCode;
  List<GetTracking>? data;

  GetTrackingModel({
    this.status,
    this.errorCode,
    this.data,
  });

  factory GetTrackingModel.fromJson(Map<String, dynamic> json) {
    return GetTrackingModel(
      status: json["status"],
      errorCode: json["errorCode"],
      data: json["data"] != null
          ? List<GetTracking>.from(
        json["data"].map((x) => GetTracking.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class GetTracking {
  int? id;
  String? phone;
  String? name;
  String? email;
  String? houseNo;
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;

  List<OrderedItems>? productDetails;

  String? employeeAmount;
  String? paymentId;
  String? razorpayOrderId;
  String? cfOrderId;
  String? paymentStatus;
  String? totalAmount;
  String? packageImage;
  String? notes;
  String? packageImageUrl;

  DateTime? createdAt;
  DateTime? updatedAt;

  AdditionalOrderDetails? additionalOrderDetails;

  GetTracking({
    this.id,
    this.phone,
    this.name,
    this.email,
    this.houseNo,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.productDetails,
    this.employeeAmount,
    this.paymentId,
    this.razorpayOrderId,
    this.cfOrderId,
    this.paymentStatus,
    this.totalAmount,
    this.packageImage,
    this.notes,
    this.packageImageUrl,
    this.createdAt,
    this.updatedAt,
    this.additionalOrderDetails,
  });

  factory GetTracking.fromJson(Map<String, dynamic> json) {
    return GetTracking(
      id: json["id"],
      phone: json["phone"]?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      houseNo: json["house_no"]?.toString(),
      address: json["address"]?.toString(),
      city: json["city"]?.toString(),
      state: json["state"]?.toString(),
      country: json["country"]?.toString(),
      pincode: json["pincode"]?.toString(),

      // product_details comes as JSON string
      productDetails: _parseProductDetails(json["product_details"]),

      employeeAmount: json["employee_amount"]?.toString(),
      paymentId: json["payment_id"]?.toString(),
      razorpayOrderId: json["razorpay_order_id"]?.toString(),
      cfOrderId: json["cf_order_id"]?.toString(),
      paymentStatus: json["payment_status"]?.toString(),
      totalAmount: json["total_amount"]?.toString(),
      packageImage: json["package_image"]?.toString(),
      notes: json["notes"]?.toString(),
      packageImageUrl: json["package_image_url"]?.toString(),

      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"].toString())
          : null,

      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"].toString())
          : null,

      additionalOrderDetails:
      json["additional_order_details"] != null
          ? AdditionalOrderDetails.fromJson(
        json["additional_order_details"],
      )
          : null,
    );
  }

  static List<OrderedItems> _parseProductDetails(dynamic value) {
    if (value == null) return [];

    try {
      if (value is String) {
        final decoded = jsonDecode(value);

        if (decoded is List) {
          return decoded
              .map(
                (item) => OrderedItems.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList();
        }
      }

      if (value is List) {
        return value
            .map(
              (item) => OrderedItems.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();
      }
    } catch (e) {
      return [];
    }

    return [];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "name": name,
    "email": email,
    "house_no": houseNo,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "pincode": pincode,
    "product_details":
    jsonEncode(productDetails?.map((e) => e.toJson()).toList()),
    "employee_amount": employeeAmount,
    "payment_id": paymentId,
    "razorpay_order_id": razorpayOrderId,
    "cf_order_id": cfOrderId,
    "payment_status": paymentStatus,
    "total_amount": totalAmount,
    "package_image": packageImage,
    "notes": notes,
    "package_image_url": packageImageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "additional_order_details":
    additionalOrderDetails?.toJson(),
  };
}


// ============================================================
// ORDERED ITEMS
// ============================================================

class OrderedItems {
  String? itemId;
  String? itemName;
  String? itemQty;
  String? itemPrice;
  String? itemWeight;

  String? itemUnitId;
  String? itemUnit;
  String? itemServings;
  String? flavorName;

  OrderedItems({
    this.itemId,
    this.itemName,
    this.itemQty,
    this.itemPrice,
    this.itemWeight,
    this.itemUnitId,
    this.itemUnit,
    this.itemServings,
    this.flavorName,
  });

  factory OrderedItems.fromJson(Map<String, dynamic> json) {
    return OrderedItems(
      itemId: json["item_id"]?.toString(),
      itemName: json["item_name"]?.toString(),
      itemQty: json["item_qty"]?.toString(),
      itemPrice: json["item_price"]?.toString(),
      itemWeight: json["item_weight"]?.toString(),

      itemUnitId: json["item_unit_id"]?.toString(),
      itemUnit: json["item_unit"]?.toString(),
      itemServings: json["item_servings"]?.toString(),
      flavorName: json["flavor_name"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_name": itemName,
    "item_qty": itemQty,
    "item_price": itemPrice,
    "item_weight": itemWeight,
    "item_unit_id": itemUnitId,
    "item_unit": itemUnit,
    "item_servings": itemServings,
    "flavor_name": flavorName,
  };
}


// ============================================================
// ADDITIONAL ORDER DETAILS
// ============================================================

class AdditionalOrderDetails {
  int? id;
  int? additionalRazorpayId;
  String? orderId;
  String? shippingId;
  String? awbCode;
  String? courierName;
  String? courierCompanyId;
  String? assignedDateTime;
  String? labelUrl;
  String? manifestUrl;
  String? pickupTokenNumber;
  String? routingCode;
  String? pickupScheduledDate;
  String? etd;
  String? weight;
  String? dimension;
  String? status;
  String? createdAt;
  String? updatedAt;

  AdditionalOrderDetails({
    this.id,
    this.additionalRazorpayId,
    this.orderId,
    this.shippingId,
    this.awbCode,
    this.courierName,
    this.courierCompanyId,
    this.assignedDateTime,
    this.labelUrl,
    this.manifestUrl,
    this.pickupTokenNumber,
    this.routingCode,
    this.pickupScheduledDate,
    this.etd,
    this.weight,
    this.dimension,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AdditionalOrderDetails.fromJson(Map<String, dynamic> json) {
    return AdditionalOrderDetails(
      id: json["id"],
      additionalRazorpayId: json["additional_razorpay_id"],
      orderId: json["order_id"]?.toString(),
      shippingId: json["shipping_id"]?.toString(),
      awbCode: json["awb_code"]?.toString(),
      courierName: json["courier_name"]?.toString(),
      courierCompanyId: json["courier_company_id"]?.toString(),
      assignedDateTime: json["assigned_date_time"]?.toString(),
      labelUrl: json["label_url"]?.toString(),
      manifestUrl: json["manifest_url"]?.toString(),
      pickupTokenNumber: json["pickup_token_number"]?.toString(),
      routingCode: json["routing_code"]?.toString(),
      pickupScheduledDate: json["pickup_scheduled_date"]?.toString(),
      etd: json["etd"]?.toString(),
      weight: json["weight"]?.toString(),
      dimension: json["dimension"]?.toString(),
      status: json["status"]?.toString(),
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "additional_razorpay_id": additionalRazorpayId,
    "order_id": orderId,
    "shipping_id": shippingId,
    "awb_code": awbCode,
    "courier_name": courierName,
    "courier_company_id": courierCompanyId,
    "assigned_date_time": assignedDateTime,
    "label_url": labelUrl,
    "manifest_url": manifestUrl,
    "pickup_token_number": pickupTokenNumber,
    "routing_code": routingCode,
    "pickup_scheduled_date": pickupScheduledDate,
    "etd": etd,
    "weight": weight,
    "dimension": dimension,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}