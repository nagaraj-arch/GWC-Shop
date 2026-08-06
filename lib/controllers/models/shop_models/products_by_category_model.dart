import '../get_additional_products_model/get_additional_products_model.dart';

class ProductsByCategoryModel {
  int? status;
  int? errorCode;
  String? key;
  List<Products>? data;

  ProductsByCategoryModel({this.status, this.errorCode, this.key, this.data});

  ProductsByCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key']?.toString();
    if (json['data'] != null) {
      data = <Products>[];
      json['data'].forEach((v) {
        data!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errorCode'] = errorCode;
    data['key'] = key;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? productId;
  String? productTitle;
  String? productDescription;
  List<String>? productThumbnails;
  String? productRating;
  String? productUsersCount;
  String? actualPrice;
  String? discountPrice;
  String? discountPercentage;
  String? itemQty;
  String? servings;
  String? orderBy;
  String? hasFlavours;
  String? productSpecialTag;
  bool? isProductPopular;
  bool? isNew;
  String? boughtByUsersCount;
  String? productIngredients;
  String? productRecipeContent;
  String? productRecipeVideo;
  List<ProductTestimonials>? productTestimonials;
  List<FAQ>? faq;
  String? productCategoryId;
  String? productWeightTypeId;
  String? isArchived;
  String? createdAt;
  String? updatedAt;
  List<String>? mealTimings;
  List<String>? productThumbnailsUrls;
  List<String>? productImages; // NEW FIELD - same as productThumbnailsUrls
  Product? product;
  Category? category;
  WeightType? weightType;

  Products({
    this.id,
    this.productId,
    this.productTitle,
    this.productDescription,
    this.productThumbnails,
    this.productRating,
    this.productUsersCount,
    this.actualPrice,
    this.discountPrice,
    this.discountPercentage,
    this.itemQty,
    this.servings,
    this.orderBy,
    this.productSpecialTag,
    this.isProductPopular,
    this.isNew,
    this.hasFlavours,
    this.boughtByUsersCount,
    this.productIngredients,
    this.productRecipeContent,
    this.productRecipeVideo,
    this.productTestimonials,
    this.faq,
    this.productCategoryId,
    this.productWeightTypeId,
    this.isArchived,
    this.createdAt,
    this.updatedAt,
    this.mealTimings,
    this.productThumbnailsUrls,
    this.productImages, // NEW FIELD
    this.product,
    this.category,
    this.weightType,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productTitle = json['product_title']?.toString();
    productDescription = json['product_description']?.toString();
    productThumbnails = json['product_thumbnails'] != null
        ? (json['product_thumbnails'] as List).map((e) => e.toString()).toList()
        : <String>[];
    productRating = json['product_rating']?.toString();
    productUsersCount = json['product_users_count']?.toString();
    actualPrice = json['actual_price']?.toString();
    discountPrice = json['discount_price']?.toString();
    discountPercentage = json['discount_percentage']?.toString();
    itemQty = json['item_qty']?.toString();
    servings = json['servings']?.toString();
    orderBy = json['order_by']?.toString();
    productSpecialTag = json['product_special_tag']?.toString();
    isProductPopular = json['is_product_popular'];
    isNew = json['is_new'];
    hasFlavours = json['has_flavours']?.toString();
    boughtByUsersCount = json['bought_by_users_count']?.toString();
    productIngredients = json['product_ingredients']?.toString();
    productRecipeContent = json['product_recipe_content']?.toString();
    productRecipeVideo = json['product_recipe_video']?.toString();

    mealTimings = json['meal_timings'] != null
        ? (json['meal_timings'] as List).map((e) => e.toString()).toList()
        : <String>[];

    if (json['product_testimonials'] != null) {
      productTestimonials = (json['product_testimonials'] as List)
          .map((e) => ProductTestimonials.fromJson(e))
          .toList();
    } else {
      productTestimonials = [];
    }

    if (json['faq'] != null) {
      faq = (json['faq'] as List).map((e) => FAQ.fromJson(e)).toList();
    } else {
      faq = [];
    }

    productCategoryId = json['product_category_id']?.toString();
    productWeightTypeId = json['product_weight_type_id']?.toString();
    isArchived = json['is_archived']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();

    // FIXED: Added null safety for productThumbnailsUrls
    productThumbnailsUrls = json['product_thumbnails_urls'] != null
        ? (json['product_thumbnails_urls'] as List).map((e) => e.toString()).toList()
        : <String>[];

    // NEW FIELD: productImages with same null safety pattern
    productImages = json['product_images'] != null
        ? (json['product_images'] as List).map((e) => e.toString()).toList()
        : <String>[];

    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    weightType = json['weight_type'] != null ? WeightType.fromJson(json['weight_type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['product_title'] = productTitle;
    data['product_description'] = productDescription;
    data['product_thumbnails'] = productThumbnails;
    data['product_rating'] = productRating;
    data['product_users_count'] = productUsersCount;
    data['actual_price'] = actualPrice;
    data['discount_price'] = discountPrice;
    data['discount_percentage'] = discountPercentage;
    data['item_qty'] = itemQty;
    data['servings'] = servings;
    data['order_by'] = orderBy;
    data['has_flavours'] = hasFlavours;
    data['product_special_tag'] = productSpecialTag;
    data['is_product_popular'] = isProductPopular;
    data['is_new'] = isNew;
    data['bought_by_users_count'] = boughtByUsersCount;
    data['product_ingredients'] = productIngredients;
    data['product_recipe_content'] = productRecipeContent;
    data['product_recipe_video'] = productRecipeVideo;

    if (productTestimonials != null) {
      data['product_testimonials'] = productTestimonials!.map((v) => v.toJson()).toList();
    }
    if (faq != null) {
      data['faq'] = faq!.map((v) => v.toJson()).toList();
    }

    data['product_category_id'] = productCategoryId;
    data['product_weight_type_id'] = productWeightTypeId;
    data['is_archived'] = isArchived;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_thumbnails_urls'] = productThumbnailsUrls;
    data['product_images'] = productImages; // NEW FIELD
    data['meal_timings'] = mealTimings;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (weightType != null) {
      data['weight_type'] = weightType!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? masterMealId;
  String? mealId;
  String? name;
  String? mealTypeName;
  String? categoryId;
  String? mealCategoryId;
  String? weight;
  String? weightTypeId;
  String? minQty;
  String? maxWeight;
  String? maxQtyUnit;
  String? mealType;
  String? isQtyEditable;
  String? isJain;
  String? isOldProduct;
  String? processCost;
  String? price;
  String? orderName;
  String? orderDescription;
  String? orderThumbnail;
  String? orderQty;
  String? orderServings;
  String? isOrderArchieved;
  String? itemPhoto;
  String? recipeVideoUrl;
  String? thresholdQty;
  String? currentStock;
  String? currentStockUnitId;
  String? flavours;
  String? ingredient;
  String? variation;
  String? benefits;
  String? faq;
  String? howToStore;
  String? howToPrepare;
  String? cookingTime;
  String? subtitle;
  String? recipeId;
  String? mealTimingId;
  String? explanationPdf;
  String? explanationVideo;
  String? availablePhases;
  String? isProtected;
  String? addedBy;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    this.masterMealId,
    this.mealId,
    this.name,
    this.mealTypeName,
    this.categoryId,
    this.mealCategoryId,
    this.weight,
    this.weightTypeId,
    this.minQty,
    this.maxWeight,
    this.maxQtyUnit,
    this.mealType,
    this.isQtyEditable,
    this.isJain,
    this.isOldProduct,
    this.processCost,
    this.price,
    this.orderName,
    this.orderDescription,
    this.orderThumbnail,
    this.orderQty,
    this.orderServings,
    this.isOrderArchieved,
    this.itemPhoto,
    this.recipeVideoUrl,
    this.thresholdQty,
    this.currentStock,
    this.currentStockUnitId,
    this.flavours,
    this.ingredient,
    this.variation,
    this.benefits,
    this.faq,
    this.howToStore,
    this.howToPrepare,
    this.cookingTime,
    this.subtitle,
    this.recipeId,
    this.mealTimingId,
    this.explanationPdf,
    this.explanationVideo,
    this.availablePhases,
    this.isProtected,
    this.addedBy,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    masterMealId = json['master_meal_id']?.toString();
    mealId = json['meal_Id']?.toString();
    name = json['name']?.toString();
    mealTypeName = json['meal_type_name']?.toString();
    categoryId = json['category_id']?.toString();
    mealCategoryId = json['meal_category_id']?.toString();
    weight = json['weight']?.toString();
    weightTypeId = json['weight_type_id']?.toString();
    minQty = json['min_qty']?.toString();
    maxWeight = json['max_weight']?.toString();
    maxQtyUnit = json['max_qty_unit']?.toString();
    mealType = json['meal_type']?.toString();
    isQtyEditable = json['is_qty_editable']?.toString();
    isJain = json['is_jain']?.toString();
    isOldProduct = json['is_old_product']?.toString();
    processCost = json['process_cost']?.toString();
    price = json['price']?.toString();
    orderName = json['order_name']?.toString();
    orderDescription = json['order_description']?.toString();
    orderThumbnail = json['order_thumbnail']?.toString();
    orderQty = json['order_qty']?.toString();
    orderServings = json['order_servings']?.toString();
    isOrderArchieved = json['is_order_archieved']?.toString();
    itemPhoto = json['item_photo']?.toString();
    recipeVideoUrl = json['recipe_video_url']?.toString();
    thresholdQty = json['threshold_qty']?.toString();
    currentStock = json['current_stock']?.toString();
    currentStockUnitId = json['current_stock_unit_id']?.toString();
    flavours = json['flavours']?.toString();
    ingredient = json['ingredient']?.toString();
    variation = json['variation']?.toString();
    benefits = json['benefits']?.toString();
    faq = json['faq']?.toString();
    howToStore = json['how_to_store']?.toString();
    howToPrepare = json['how_to_prepare']?.toString();
    cookingTime = json['cooking_time']?.toString();
    subtitle = json['subtitle']?.toString();
    recipeId = json['recipe_id']?.toString();
    mealTimingId = json['meal_timing_id']?.toString();
    explanationPdf = json['explanation_pdf']?.toString();
    explanationVideo = json['explanation_video']?.toString();
    availablePhases = json['available_phases']?.toString();
    isProtected = json['is_protected']?.toString();
    addedBy = json['added_by']?.toString();
    isArchieved = json['is_archieved']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['master_meal_id'] = masterMealId;
    data['meal_Id'] = mealId;
    data['name'] = name;
    data['meal_type_name'] = mealTypeName;
    data['category_id'] = categoryId;
    data['meal_category_id'] = mealCategoryId;
    data['weight'] = weight;
    data['weight_type_id'] = weightTypeId;
    data['min_qty'] = minQty;
    data['max_weight'] = maxWeight;
    data['max_qty_unit'] = maxQtyUnit;
    data['meal_type'] = mealType;
    data['is_qty_editable'] = isQtyEditable;
    data['is_jain'] = isJain;
    data['is_old_product'] = isOldProduct;
    data['process_cost'] = processCost;
    data['price'] = price;
    data['order_name'] = orderName;
    data['order_description'] = orderDescription;
    data['order_thumbnail'] = orderThumbnail;
    data['order_qty'] = orderQty;
    data['order_servings'] = orderServings;
    data['is_order_archieved'] = isOrderArchieved;
    data['item_photo'] = itemPhoto;
    data['recipe_video_url'] = recipeVideoUrl;
    data['threshold_qty'] = thresholdQty;
    data['current_stock'] = currentStock;
    data['current_stock_unit_id'] = currentStockUnitId;
    data['flavours'] = flavours;
    data['ingredient'] = ingredient;
    data['variation'] = variation;
    data['benefits'] = benefits;
    data['faq'] = faq;
    data['how_to_store'] = howToStore;
    data['how_to_prepare'] = howToPrepare;
    data['cooking_time'] = cookingTime;
    data['subtitle'] = subtitle;
    data['recipe_id'] = recipeId;
    data['meal_timing_id'] = mealTimingId;
    data['explanation_pdf'] = explanationPdf;
    data['explanation_video'] = explanationVideo;
    data['available_phases'] = availablePhases;
    data['is_protected'] = isProtected;
    data['added_by'] = addedBy;
    data['is_archieved'] = isArchieved;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? thumbnail;
  String? hasAdditional;
  String? subText;
  String? description;
  String? bannerSmall;
  String? bannerBig;
  String? subTextHeading;
  String? subTextDescription;
  String? subTextHighlight;
  String? subTextThubnail;
  String? coverImage;
  String? coverTitle;
  String? coverDescription;
  String? importantPoints;
  String? footerTitle;
  String? footerDescription;
  String? footerThumnail;
  String? footerHighlightText;
  String? maxAllowed;
  String? createdAt;
  String? updatedAt;

  Category({
    this.id,
    this.name,
    this.thumbnail,
    this.hasAdditional,
    this.subText,
    this.description,
    this.bannerSmall,
    this.bannerBig,
    this.subTextHeading,
    this.subTextDescription,
    this.subTextHighlight,
    this.subTextThubnail,
    this.coverImage,
    this.coverTitle,
    this.coverDescription,
    this.importantPoints,
    this.footerTitle,
    this.footerDescription,
    this.footerThumnail,
    this.footerHighlightText,
    this.maxAllowed,
    this.createdAt,
    this.updatedAt,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    thumbnail = json['thumbnail']?.toString();
    hasAdditional = json['has_additional']?.toString();
    subText = json['sub_text']?.toString();
    description = json['description']?.toString();
    bannerSmall = json['banner_small']?.toString();
    bannerBig = json['banner_big']?.toString();
    subTextHeading = json['sub_text_heading']?.toString();
    subTextDescription = json['sub_text_description']?.toString();
    subTextHighlight = json['sub_text_highlight']?.toString();
    subTextThubnail = json['sub_text_thubnail']?.toString();
    coverImage = json['cover_image']?.toString();
    coverTitle = json['cover_title']?.toString();
    coverDescription = json['cover_description']?.toString();
    importantPoints = json['important_points']?.toString();
    footerTitle = json['footer_title']?.toString();
    footerDescription = json['footer_description']?.toString();
    footerThumnail = json['footer_thumnail']?.toString();
    footerHighlightText = json['footer_highlight_text']?.toString();
    maxAllowed = json['max_allowed']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnail'] = thumbnail;
    data['has_additional'] = hasAdditional;
    data['sub_text'] = subText;
    data['description'] = description;
    data['banner_small'] = bannerSmall;
    data['banner_big'] = bannerBig;
    data['sub_text_heading'] = subTextHeading;
    data['sub_text_description'] = subTextDescription;
    data['sub_text_highlight'] = subTextHighlight;
    data['sub_text_thubnail'] = subTextThubnail;
    data['cover_image'] = coverImage;
    data['cover_title'] = coverTitle;
    data['cover_description'] = coverDescription;
    data['important_points'] = importantPoints;
    data['footer_title'] = footerTitle;
    data['footer_description'] = footerDescription;
    data['footer_thumnail'] = footerThumnail;
    data['footer_highlight_text'] = footerHighlightText;
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

  WeightType({
    this.id,
    this.unit,
    this.unitType,
    this.conversionFactor,
    this.createdAt,
    this.updatedAt,
  });

  WeightType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit']?.toString();
    unitType = json['unit_type']?.toString();
    conversionFactor = json['conversion_factor']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
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