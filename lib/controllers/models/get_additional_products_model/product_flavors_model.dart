class ProductFlavorsModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  ProductFlavorsModel({this.success, this.status, this.message, this.data});

  ProductFlavorsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'].toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? productId;
  String? productName;
  String? hasFlavours;
  String? totalFlavours;
  List<Flavours>? flavours;

  Data(
      {this.productId,
        this.productName,
        this.hasFlavours,
        this.totalFlavours,
        this.flavours});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'].toString();
    hasFlavours = json['has_flavours'].toString();
    totalFlavours = json['total_flavours'].toString();
    if (json['flavours'] != null) {
      flavours = <Flavours>[];
      json['flavours'].forEach((v) {
        flavours!.add(Flavours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['has_flavours'] = hasFlavours;
    data['total_flavours'] = totalFlavours;
    if (flavours != null) {
      data['flavours'] = flavours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Flavours {
  int? id;
  String? flavourName;
  String? finalProductName;
  String? thumbnail;
  String? thumbnailUrl;
  String? recipeVideo;
  String? recipeVideoUrl;
  String? howToPrepare;
  String? finalMealName;
  String? description;
  String? actualPrice;
  String? discountedPrice;
  String? productTag;
  String? isActive;

  Flavours(
      {this.id,
        this.flavourName,
        this.finalProductName,
        this.thumbnail,
        this.thumbnailUrl,
        this.recipeVideo,
        this.recipeVideoUrl,
        this.howToPrepare,this.description,this.actualPrice,this.discountedPrice,this.productTag,
        this.finalMealName,
        this.isActive});

  Flavours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flavourName = json['flavour_name'].toString();
    finalProductName = json['final_product_name'].toString();
    thumbnail = json['thumbnail'].toString();
    thumbnailUrl = json['thumbnail_url'].toString();
    recipeVideo = json['recipe_video'].toString();
    recipeVideoUrl = json['recipe_video_url'].toString();
    howToPrepare = json['how_to_prepare'].toString();
    description = json['description'].toString();
    finalMealName = json['final_meal_name'].toString();
    actualPrice = json['actual_price'].toString();
    discountedPrice = json['discounted_price'].toString();
    productTag = json['product_tag'].toString();
    isActive = json['is_active'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['flavour_name'] = flavourName;
    data['final_product_name'] = finalProductName;
    data['thumbnail'] = thumbnail;
    data['thumbnail_url'] = thumbnailUrl;
    data['recipe_video'] = recipeVideo;
    data['recipe_video_url'] = recipeVideoUrl;
    data['how_to_prepare'] = howToPrepare;
    data['description'] = description;
    data['final_meal_name'] = finalMealName;
    data['actual_price'] = actualPrice;
    data['discounted_price'] = discountedPrice;
    data['product_tag'] = productTag;
    data['is_active'] = isActive;
    return data;
  }
}
