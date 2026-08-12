import 'package:gwc_shop/controllers/models/shop_models/products_by_category_model.dart';

import 'category_model.dart';

class GetClusterListModel {
  int? status;
  int? errorCode;
  String? key;
  List<ClusterList>? data;

  GetClusterListModel({this.status, this.errorCode, this.key, this.data});

  GetClusterListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'].toString();
    if (json['data'] != null) {
      data = <ClusterList>[];
      json['data'].forEach((v) {
        data!.add(ClusterList.fromJson(v));
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

class ClusterList {
  int? id;
  String? clusterName;
  String? clusterDescription;
  String? clusterThumbnail;
  String? clusterAbout;
  String? clusterAboutTitle;
  String? clusterComboName;
  String? comboDescription;
  String? comboThumbnail;
  String? comboActualPrice;
  String? comboDiscountedPrice;
  List<ImportantPoints>? clusterBenefitsUrls;
  List<int>? clusterProductIds;
  bool? isArchived;
  String? createdAt;
  String? updatedAt;
  String? clusterThumbnailUrl;
  String? comboThumbnailUrl;
  List<Products>? productsData;
  int? productCount;
  bool? hasValidProducts;

  ClusterList(
      {this.id,
        this.clusterName,
        this.clusterDescription,
        this.clusterThumbnail,
        this.clusterAbout,
        this.clusterAboutTitle,
        this.clusterComboName,
        this.comboDescription,
        this.comboThumbnail,
        this.comboActualPrice,
        this.comboDiscountedPrice,
        this.clusterBenefitsUrls,
        this.clusterProductIds,
        this.isArchived,
        this.createdAt,
        this.updatedAt,
        this.clusterThumbnailUrl,
        this.comboThumbnailUrl,
        this.productsData,
        this.productCount,
        this.hasValidProducts});

  ClusterList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clusterName = json['cluster_name'].toString();
    clusterDescription = json['cluster_description'].toString();
    clusterThumbnail = json['cluster_thumbnail'].toString();
    clusterAbout = json['cluster_about'].toString();
    clusterAboutTitle = json['cluster_about_title'].toString();
    clusterComboName = json['cluster_combo_name'].toString();
    comboDescription = json['combo_description'].toString();
    comboThumbnail = json['combo_thumbnail'].toString();
    comboActualPrice = json['combo_actual_price'].toString();
    comboDiscountedPrice = json['combo_discounted_price'].toString();

    if (json['cluster_benefits_urls'] != null) {
      clusterBenefitsUrls = <ImportantPoints>[];
      json['cluster_benefits_urls'].forEach((v) {
        clusterBenefitsUrls!.add(ImportantPoints.fromJson(v));
      });
    }

    clusterProductIds = json['cluster_product_ids'].cast<int>();
    isArchived = json['is_archived'];
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    clusterThumbnailUrl = json['cluster_thumbnail_url'].toString();
    comboThumbnailUrl = json['combo_thumbnail_url'].toString();
    if (json['products_data'] != null) {
      productsData = <Products>[];
      json['products_data'].forEach((v) {
        productsData!.add(Products.fromJson(v));
      });
    }
    productCount = json['product_count'];
    hasValidProducts = json['has_valid_products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cluster_name'] = clusterName;
    data['cluster_description'] = clusterDescription;
    data['cluster_thumbnail'] = clusterThumbnail;
    data['cluster_about'] = clusterAbout;
    data['cluster_about_title'] = clusterAboutTitle;
    data['cluster_combo_name'] = clusterComboName;
    data['combo_description'] = comboDescription;
    data['combo_thumbnail'] = comboThumbnail;
    data['combo_actual_price'] = comboActualPrice;
    data['combo_discounted_price'] = comboDiscountedPrice;

    if (clusterBenefitsUrls != null) {
      data['cluster_benefits_urls'] =
          clusterBenefitsUrls!.map((v) => v.toJson()).toList();
    }

    data['cluster_product_ids'] = clusterProductIds;
    data['is_archived'] = isArchived;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cluster_thumbnail_url'] = clusterThumbnailUrl;
    data['combo_thumbnail_url'] = comboThumbnailUrl;
    if (productsData != null) {
      data['products_data'] =
          productsData!.map((v) => v.toJson()).toList();
    }
    data['product_count'] = productCount;
    data['has_valid_products'] = hasValidProducts;
    return data;
  }
}