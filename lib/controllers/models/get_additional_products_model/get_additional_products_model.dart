import 'package:gwc_shop/controllers/models/shop_models/products_by_category_model.dart';

class GetAdditionalProductsModel {
  bool? success;
  int? status;
  String? message;
  List<Products>? data;

  GetAdditionalProductsModel(
      {this.success, this.status, this.message, this.data});

  GetAdditionalProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <Products>[];
      json['data'].forEach((v) {
        data!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class AdditionalProducts {
//   // static const String thumbnailBaseUrl =
//   //     'https://gutandhealth.com/storage/uploads/users/thumbnail/';
//
//   int? id;
//   int? productId;
//   String? productTitle;
//   String? productDescription;
//   List<String>? productThumbnails;
//   String? primaryThumbnailUrl;
//   String? productRating;
//   String? productUsersCount;
//   String? actualPrice;
//   String? discountPrice;
//   String? discountPercentage;
//   String? itemQty;
//   String? productSpecialTag;
//   bool? isProductPopular;
//   String? boughtByUsersCount;
//   String? servings;
//   int? orderBy;
//   bool? isNew;
//   String? hasFlavours;
//   String? productIngredients;
//   String? productRecipeContent;
//   String? productRecipeVideo;
//   List<ProductTestimonials>? productTestimonials;
//   String? productCategoryId;
//   String? productWeightTypeId;
//   bool? isArchived;
//   String? createdAt;
//   String? updatedAt;
//   Category? category;
//   WeightType? weightType;
//   List<FAQ>? faq;
//
//   AdditionalProducts({
//     this.id,
//     this.productId,
//     this.productTitle,
//     this.productDescription,
//     this.productThumbnails,
//     this.primaryThumbnailUrl,
//     this.productRating,
//     this.productUsersCount,
//     this.actualPrice,
//     this.discountPrice,
//     this.discountPercentage,
//     this.itemQty,
//     this.productSpecialTag,
//     this.isProductPopular,
//     this.boughtByUsersCount,
//     this.servings,
//     this.orderBy,
//     this.hasFlavours,
//     this.isNew,
//     this.productIngredients,
//     this.productRecipeContent,
//     this.productRecipeVideo,
//     this.productTestimonials,
//     this.productCategoryId,
//     this.productWeightTypeId,
//     this.isArchived,
//     this.createdAt,
//     this.updatedAt,
//     this.category,
//     this.weightType,
//     this.faq,
//   });
//
//   AdditionalProducts.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     productTitle = json['product_title'].toString();
//     productDescription = json['product_description'].toString();
//     productThumbnails = json['product_thumbnails_urls'] != null
//         ? List<String>.from(json['product_thumbnails_urls'])
//         : [];
//     primaryThumbnailUrl = json['primary_thumbnail_url'].toString();
//     // if (json['product_thumbnails'] != null) {
//     //   productThumbnails = List<String>.from(
//     //     json['product_thumbnails']
//     //         .map((e) => '$thumbnailBaseUrl$e'),
//     //   );
//     // }
//     productRating = json['product_rating'].toString();
//     productUsersCount = json['product_users_count'].toString();
//     actualPrice = json['actual_price'].toString();
//     discountPrice = json['discount_price'].toString();
//     discountPercentage = json['discount_percentage'].toString();
//     itemQty = json['item_qty'].toString();
//     productSpecialTag = json['product_special_tag'].toString();
//     isProductPopular = json['is_product_popular'];
//     boughtByUsersCount = json['bought_by_users_count'].toString();
//     servings = json['servings'].toString();
//     orderBy = json['order_by'];
//     isNew = json['is_new'];
//     hasFlavours = json['has_flavours'].toString();
//     productIngredients = json['product_ingredients'].toString();
//     productRecipeContent = json['product_recipe_content'].toString();
//     productRecipeVideo = json['product_recipe_video_url'].toString();
//     if (json['product_testimonials'] != null) {
//       productTestimonials = (json['product_testimonials'] as List)
//           .map((e) => ProductTestimonials.fromJson(e))
//           .toList();
//     } else {
//       productTestimonials = [];
//     }
//
//     if (json['faq'] != null) {
//       faq = (json['faq'] as List).map((e) => FAQ.fromJson(e)).toList();
//     } else {
//       faq = [];
//     }
//     productCategoryId = json['product_category_id'].toString();
//     productWeightTypeId = json['product_weight_type_id'].toString();
//     isArchived = json['is_archived'];
//     createdAt = json['created_at'].toString();
//     updatedAt = json['updated_at'].toString();
//     category =
//         json['category'] != null ? Category.fromJson(json['category']) : null;
//     weightType = json['weight_type'] != null
//         ? WeightType.fromJson(json['weight_type'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['product_title'] = productTitle;
//     data['product_description'] = productDescription;
//     data['product_thumbnails_urls'] = productThumbnails;
//     data['primary_thumbnail_url'] = primaryThumbnailUrl;
//     data['product_rating'] = productRating;
//     data['product_users_count'] = productUsersCount;
//     data['actual_price'] = actualPrice;
//     data['discount_price'] = discountPrice;
//     data['discount_percentage'] = discountPercentage;
//     data['item_qty'] = itemQty;
//     data['product_special_tag'] = productSpecialTag;
//     data['is_product_popular'] = isProductPopular;
//     data['bought_by_users_count'] = boughtByUsersCount;
//     data['servings'] = servings;
//     data['order_by'] = orderBy;
//     data['is_new'] = isNew;
//     data['has_flavours'] = hasFlavours;
//     data['product_ingredients'] = productIngredients;
//     data['product_recipe_content'] = productRecipeContent;
//     data['product_recipe_video_url'] = productRecipeVideo;
//     if (productTestimonials != null) {
//       data['product_testimonials'] =
//           productTestimonials!.map((v) => v.toJson()).toList();
//     }
//     if (faq != null) {
//       data['faq'] = faq!.map((v) => v.toJson()).toList();
//     }
//     data['product_category_id'] = productCategoryId;
//     data['product_weight_type_id'] = productWeightTypeId;
//     data['is_archived'] = isArchived;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     if (weightType != null) {
//       data['weight_type'] = weightType!.toJson();
//     }
//     return data;
//   }
// }

class ProductTestimonials {
  String? user;
  String? rating;
  String? comment;
  String? date;

  ProductTestimonials({this.user, this.rating, this.comment, this.date});

  ProductTestimonials.fromJson(Map<String, dynamic> json) {
    user = json['user'].toString();
    rating = json['rating'].toString();
    comment = json['comment'].toString();
    date = json['date'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['rating'] = rating;
    data['comment'] = comment;
    data['date'] = date;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? maxAllowed;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id, this.name, this.maxAllowed, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    maxAllowed = json['max_allowed'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['max_allowed'] = maxAllowed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class WeightType {
  int? id;
  String? unit;
  String? unitType;
  String? conversionFactor;
  String? createdAt;
  String? updatedAt;

  WeightType(
      {this.id,
      this.unit,
      this.unitType,
      this.conversionFactor,
      this.createdAt,
      this.updatedAt});

  WeightType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit'].toString();
    unitType = json['unit_type'].toString();
    conversionFactor = json['conversion_factor'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit'] = unit;
    data['unit_type'] = unitType;
    data['conversion_factor'] = conversionFactor;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class IngredientModel {
  final String name;
  final String image;

  IngredientModel({
    required this.name,
    required this.image,
  });
}

class FAQ {
  String? qus;
  String? ans;

  FAQ({this.qus, this.ans});

  FAQ.fromJson(Map<String, dynamic> json) {
    qus = json['question']?.toString();
    ans = json['answer']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'question': qus,
      'answer': ans,
    };
  }
}
