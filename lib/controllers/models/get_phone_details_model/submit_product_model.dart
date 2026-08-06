class SubmitProductModel {
  int? status;
  String? message;
  SubmitModel? data;

  SubmitProductModel({
     this.status,
     this.message,
     this.data,
  });

  factory SubmitProductModel.fromJson(Map<String, dynamic> json) => SubmitProductModel(
    status: json["status"],
    message: json["message"].toString(),
    data: SubmitModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class SubmitModel {
  int? id;
  String? phone;
  String? name;
  String? houseNo;
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;
  List<ProductDetail>? productDetails;
  String? totalAmount;
  CashFreeResponse? cashFreeResponse;

  SubmitModel({
     this.id,
     this.phone,
     this.name,
     this.houseNo,
     this.address,
     this.city,
     this.state,
     this.country,
     this.pincode,
     this.productDetails,
     this.totalAmount,
    this.cashFreeResponse,
  });

  factory SubmitModel.fromJson(Map<String, dynamic> json) => SubmitModel(
    id: json["id"],
    phone: json["phone"].toString(),
    name: json["name"].toString(),
    houseNo: json["house_no"].toString(),
    address: json["address"].toString(),
    city: json["city"].toString(),
    state: json["state"].toString(),
    country: json["country"].toString(),
    pincode: json["pincode"].toString(),
    productDetails: List<ProductDetail>.from(json["product_details"].map((x) => ProductDetail.fromJson(x))),
    totalAmount: json["total_amount"].toString(),
    cashFreeResponse: CashFreeResponse.fromJson(json["cash_free_response"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "name": name,
    "house_no": houseNo,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "pincode": pincode,
    "product_details": List<dynamic>.from(productDetails!.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "cash_free_response": cashFreeResponse?.toJson(),
  };
}

class ProductDetail {
  int? itemId;
  String? itemName;
  int? itemQty;
  double? itemPrice;

  ProductDetail({
     this.itemId,
     this.itemName,
     this.itemQty,
     this.itemPrice,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    itemId: json["item_id"],
    itemName: json["item_name"].toString(),
    itemQty: json["item_qty"],
    itemPrice: json["item_price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_name": itemName,
    "item_qty": itemQty,
    "item_price": itemPrice,
  };
}

class CashFreeResponse {
  String? paymentSessionId;
  String? cfOrderId;

  CashFreeResponse({
     this.paymentSessionId,
     this.cfOrderId,
  });

  factory CashFreeResponse.fromJson(Map<String, dynamic> json) => CashFreeResponse(
    paymentSessionId: json["payment_session_id"].toString(),
    cfOrderId: json["cf_order_id"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "payment_session_id": paymentSessionId,
    "cf_order_id": cfOrderId,
  };
}
