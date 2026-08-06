class UpdateProductModel {
  int? status;
  String? message;
  UpdateModel? data;

  UpdateProductModel({
     this.status,
     this.message,
     this.data,
  });

  factory UpdateProductModel.fromJson(Map<String, dynamic> json) => UpdateProductModel(
    status: json["status"],
    message: json["message"].toString(),
    data: UpdateModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class UpdateModel {
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
  String? productDetails;
  String? paymentId;
  String? razorpayOrderId;
  String? paymentStatus;
  String? totalAmount;
  String? createdAt;
  String? updatedAt;

  UpdateModel({
     this.id,
     this.phone,
     this.name,
     this.houseNo,
     this.address,
     this.city,
    this.email,
     this.state,
     this.country,
     this.pincode,
     this.productDetails,
     this.paymentId,
     this.razorpayOrderId,
     this.paymentStatus,
     this.totalAmount,
     this.createdAt,
     this.updatedAt,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
    id: json["id"],
    phone: json["phone"].toString(),
    name: json["name"].toString(),
    houseNo: json["house_no"].toString(),
    address: json["address"].toString(),
    city: json["city"].toString(),
    state: json["state"].toString(),
    email: json['email'].toString(),
    country: json["country"].toString(),
    pincode: json["pincode"].toString(),
    productDetails: json["product_details"].toString(),
    paymentId: json["payment_id"].toString(),
    razorpayOrderId: json["razorpay_order_id"].toString(),
    paymentStatus: json["payment_status"].toString(),
    totalAmount: json["total_amount"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
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
    'email':email,
    "pincode": pincode,
    "product_details": productDetails,
    "payment_id": paymentId,
    "razorpay_order_id": razorpayOrderId,
    "payment_status": paymentStatus,
    "total_amount": totalAmount,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
