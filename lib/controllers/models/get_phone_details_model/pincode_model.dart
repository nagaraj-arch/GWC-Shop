class PinCodeModel {
  int? status;
  int? errorCode;
  Response? response;

  PinCodeModel({this.status, this.errorCode, this.response});

  PinCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errorCode'] = errorCode;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? message;
  String? status;
  List<PostOffice>? postOffice;

  Response({this.message, this.status, this.postOffice});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['Message'].toString();
    status = json['Status'].toString();
    if (json['PostOffice'] != null) {
      postOffice = <PostOffice>[];
      json['PostOffice'].forEach((v) {
        postOffice!.add(PostOffice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['Status'] = status;
    if (postOffice != null) {
      data['PostOffice'] = postOffice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostOffice {
  String? name;
  String? description;
  String? branchType;
  String? deliveryStatus;
  String? taluk;
  String? circle;
  String? district;
  String? division;
  String? region;
  String? state;
  String? country;

  PostOffice(
      {this.name,
        this.description,
        this.branchType,
        this.deliveryStatus,
        this.taluk,
        this.circle,
        this.district,
        this.division,
        this.region,
        this.state,
        this.country});

  PostOffice.fromJson(Map<String, dynamic> json) {
    name = json['Name'].toString();
    description = json['Description'].toString();
    branchType = json['BranchType'].toString();
    deliveryStatus = json['DeliveryStatus'].toString();
    taluk = json['Taluk'].toString();
    circle = json['Circle'].toString();
    district = json['District'].toString();
    division = json['Division'].toString();
    region = json['Region'].toString();
    state = json['State'].toString();
    country = json['Country'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Description'] = description;
    data['BranchType'] = branchType;
    data['DeliveryStatus'] = deliveryStatus;
    data['Taluk'] = taluk;
    data['Circle'] = circle;
    data['District'] = district;
    data['Division'] = division;
    data['Region'] = region;
    data['State'] = state;
    data['Country'] = country;
    return data;
  }
}
