import 'dart:ui';

class CategoryModel {
  bool? status;
  List<CategoryList>? data;

  CategoryModel({this.status, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = <CategoryList>[];
      json['data'].forEach((v) {
        data!.add(CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  int? id;
  String? name;
  String? colorCode;
  String? orderBy;
  String? maxAllowed;
  String? thumbnail;
  bool? hasAdditional;
  String? subText;
  String? description;
  List<ImportantPoints>? bannerThumbnails;
  String? bannerSmall;
  String? bannerTab;
  String? bannerLaptop;
  String? bannerDesktop;
  String? bannerBig;
  String? subTextHeading;
  String? subTextDescription;
  String? subTextHighlight;
  String? subTextThubnail;
  String? coverImage;
  String? coverImageMobile;
  String? coverImageLaptop;
  String? coverImageTab;
  String? coverImageDesktop;
  String? coverTitle;
  String? coverDescription;
  List<ImportantPoints>? importantPoints;
  String? footerTitle;
  String? footerDescription;
  String? footerThumnail;
  String? footerThumnailMobile;
  String? footerThumnailLaptop;
  String? footerThumnailTab;
  String? footerThumnailDesktop;
  String? footerHighlightText;
  String? isArchived;

  CategoryList({
    this.id,
    this.name,
    this.colorCode,this.orderBy,
    this.maxAllowed,
    this.thumbnail,
    this.hasAdditional,
    this.subText,
    this.description,
    this.bannerThumbnails,
    this.bannerSmall,
    this.bannerTab,
    this.bannerLaptop,
    this.bannerDesktop,
    this.bannerBig,
    this.subTextHeading,
    this.subTextDescription,
    this.subTextHighlight,
    this.subTextThubnail,
    this.coverImage,
    this.coverImageMobile,
    this.coverImageLaptop,
    this.coverImageTab,
    this.coverImageDesktop,
    this.coverTitle,
    this.coverDescription,
    this.importantPoints,
    this.footerTitle,
    this.footerDescription,
    this.footerThumnail,
    this.footerThumnailMobile,
    this.footerThumnailLaptop,
    this.footerThumnailTab,
    this.footerThumnailDesktop,

    this.footerHighlightText,
    this.isArchived,
  });

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    colorCode = json['color_code'].toString();
    orderBy = json['order_by'].toString();
    maxAllowed = json['max_allowed']?.toString();
    thumbnail = json['thumbnail']?.toString();
    hasAdditional = json['has_additional'];
    subText = json['sub_text']?.toString();
    description = json['description']?.toString();

    if (json['banner_thumbnails'] != null) {
      bannerThumbnails = <ImportantPoints>[];
      json['banner_thumbnails'].forEach((v) {
        bannerThumbnails!.add(ImportantPoints.fromJson(v));
      });
    }

    bannerSmall = json['banner_small']?.toString();
    bannerTab = json['banner_tab']?.toString();
    bannerLaptop = json['banner_laptop']?.toString();
    bannerDesktop = json['banner_desktop']?.toString();
    bannerBig = json['banner_big']?.toString();
    subTextHeading = json['sub_text_heading']?.toString();
    subTextDescription = json['sub_text_description']?.toString();
    subTextHighlight = json['sub_text_highlight']?.toString();
    subTextThubnail = json['sub_text_thubnail']?.toString();
    coverImage = json['cover_image']?.toString();
    coverImageMobile = json['cover_image_mobile']?.toString();
    coverImageLaptop = json['cover_image_laptop']?.toString();
    coverImageTab = json['cover_image_tab']?.toString();
    coverImageDesktop = json['cover_image_desktop']?.toString();
    coverTitle = json['cover_title']?.toString();
    coverDescription = json['cover_description']?.toString();

    if (json['important_points'] != null) {
      importantPoints = <ImportantPoints>[];
      json['important_points'].forEach((v) {
        importantPoints!.add(ImportantPoints.fromJson(v));
      });
    }

    footerTitle = json['footer_title']?.toString();
    footerDescription = json['footer_description']?.toString();

    footerThumnail = json['footer_thumnail']?.toString();
    footerThumnailMobile = json['footer_thumnail_mobile']?.toString();
    footerThumnailLaptop = json['footer_thumnail_laptop']?.toString();
    footerThumnailTab = json['footer_thumnail_tab']?.toString();
    footerThumnailDesktop = json['footer_thumnail_desktop']?.toString();

    footerHighlightText = json['footer_highlight_text']?.toString();
    isArchived = json['is_archived'].toString();
  }

  Color get color {
    try {
      if (colorCode == null ||
          colorCode!.isEmpty ||
          colorCode == "null") {
        return const Color(0xff3B2415);
      }

      return Color(
        int.parse(colorCode!.replaceFirst('#', '0xff')),
      );
    } catch (e) {
      return const Color(0xff3B2415);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color_code'] = colorCode;
    data['order_by'] = orderBy;
    data['max_allowed'] = maxAllowed;
    data['thumbnail'] = thumbnail;
    data['has_additional'] = hasAdditional;
    data['sub_text'] = subText;
    data['description'] = description;

    if (bannerThumbnails != null) {
      data['banner_thumbnails'] =
          bannerThumbnails!.map((v) => v.toJson()).toList();
    }

    data['banner_small'] = bannerSmall;
    data['banner_tab'] = bannerTab;
    data['banner_laptop'] = bannerLaptop;
    data['banner_desktop'] = bannerDesktop;
    data['banner_big'] = bannerBig;
    data['sub_text_heading'] = subTextHeading;
    data['sub_text_description'] = subTextDescription;
    data['sub_text_highlight'] = subTextHighlight;
    data['sub_text_thubnail'] = subTextThubnail;
    data['cover_image'] = coverImage;
    data['cover_image_mobile'] = coverImageMobile;
    data['cover_image_laptop'] = coverImageLaptop;
    data['cover_image_tab'] = coverImageTab;
    data['cover_image_desktop'] = coverImageDesktop;
    data['cover_title'] = coverTitle;
    data['cover_description'] = coverDescription;
    if (importantPoints != null) {
      data['important_points'] =
          importantPoints!.map((v) => v.toJson()).toList();
    }
    data['footer_title'] = footerTitle;
    data['footer_description'] = footerDescription;

    data['footer_thumnail'] = footerThumnail;
    data['footer_thumnail_mobile'] = footerThumnailMobile;
    data['footer_thumnail_laptop'] = footerThumnailLaptop;
    data['footer_thumnail_tab'] = footerThumnailTab;
    data['footer_thumnail_desktop'] = footerThumnailDesktop;

    data['footer_highlight_text'] = footerHighlightText;
    data['is_archived'] = isArchived;
    return data;
  }
}

class ImportantPoints {
  String? title;
  String? description;
  String? thumbnail;

  ImportantPoints({this.title, this.description, this.thumbnail});

  ImportantPoints.fromJson(Map<String, dynamic> json) {
    title = json['title'].toString();
    description = json['description'].toString();
    thumbnail = json['thumbnail'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    return data;
  }
}