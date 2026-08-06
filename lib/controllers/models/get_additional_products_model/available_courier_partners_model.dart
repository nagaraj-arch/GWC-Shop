class AvailableCourierPartnersModel {
  int? status;
  int? errorCode;
  String? message;
  GetServiceAbilityModelData? data;

  AvailableCourierPartnersModel({
    this.status,
    this.errorCode,
    this.message,
    this.data,
  });

  AvailableCourierPartnersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    message = json['message'].toString();
    data = json['data'] != null
        ? GetServiceAbilityModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errorCode'] = errorCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetServiceAbilityModelData {
  // bool? companyAutoShipmentInsuranceSetting;
  // CovidZones? covidZones;
  // String? currency;
  ServiceAbility? data;
  // int? dgCourier;
  // int? eligibleForInsurance;
  // bool? insuraceOptedAtOrderCreation;
  // bool? isAllowTemplatizedPricing;
  // int? isLatlong;
  // bool? isOldZoneOpted;
  // bool? isZoneFromMongo;
  // int? labelGenerateType;
  // int? onNewZone;
  // List<Null>? sellerAddress;
  String? message;
  String? status;
  // bool? userInsuranceManadatory;

  GetServiceAbilityModelData({
    // this.companyAutoShipmentInsuranceSetting,
    // this.covidZones,
    // this.currency,
    this.data,
    // this.dgCourier,
    // this.eligibleForInsurance,
    // this.insuraceOptedAtOrderCreation,
    // this.isAllowTemplatizedPricing,
    // this.isLatlong,
    // this.isOldZoneOpted,
    // this.isZoneFromMongo,
    // this.labelGenerateType,
    // this.onNewZone,
    // this.sellerAddress,
    this.message,
    this.status,
    // this.userInsuranceManadatory,
  });

  GetServiceAbilityModelData.fromJson(Map<String, dynamic> json) {
    // companyAutoShipmentInsuranceSetting =
    //     json['company_auto_shipment_insurance_setting'];
    // covidZones = json['covid_zones'] != null
    //     ? CovidZones.fromJson(json['covid_zones'])
    //     : null;
    // currency = json['currency'];
    data = json['data'] != null ? ServiceAbility.fromJson(json['data']) : null;
    // dgCourier = json['dg_courier'];
    // eligibleForInsurance = json['eligible_for_insurance'];
    // insuraceOptedAtOrderCreation = json['insurace_opted_at_order_creation'];
    // isAllowTemplatizedPricing = json['is_allow_templatized_pricing'];
    // isLatlong = json['is_latlong'];
    // isOldZoneOpted = json['is_old_zone_opted'];
    // isZoneFromMongo = json['is_zone_from_mongo'];
    // labelGenerateType = json['label_generate_type'];
    // onNewZone = json['on_new_zone'];
    // if (json['seller_address'] != null) {
    //   sellerAddress = <Null>[];
    //   json['seller_address'].forEach((v) {
    //     sellerAddress!.add(Null.fromJson(v));
    //   });
    // }
    message = json['message'].toString();
    status = json['status'].toString();
    // userInsuranceManadatory = json['user_insurance_manadatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['company_auto_shipment_insurance_setting'] =
    //     this.companyAutoShipmentInsuranceSetting;
    // if (this.covidZones != null) {
    //   data['covid_zones'] = this.covidZones!.toJson();
    // }
    // data['currency'] = this.currency;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // data['dg_courier'] = this.dgCourier;
    // data['eligible_for_insurance'] = this.eligibleForInsurance;
    // data['insurace_opted_at_order_creation'] =
    //     this.insuraceOptedAtOrderCreation;
    // data['is_allow_templatized_pricing'] = this.isAllowTemplatizedPricing;
    // data['is_latlong'] = this.isLatlong;
    // data['is_old_zone_opted'] = this.isOldZoneOpted;
    // data['is_zone_from_mongo'] = this.isZoneFromMongo;
    // data['label_generate_type'] = this.labelGenerateType;
    // data['on_new_zone'] = this.onNewZone;
    // if (this.sellerAddress != null) {
    //   data['seller_address'] =
    //       this.sellerAddress!.map((v) => v.toJson()).toList();
    // }
    data['message'] = message;
    data['status'] = status;
    // data['user_insurance_manadatory'] = this.userInsuranceManadatory;
    return data;
  }
}

class ServiceAbility {
  List<AvailableCourierCompany> availableCourierCompanies;
  // dynamic childCourierId;
  // int isRecommendationEnabled;
  // int recommendationAdvanceRule;
  // RecommendedBy recommendedBy;
  // int recommendedCourierCompanyId;
  // int shiprocketRecommendedCourierId;

  ServiceAbility({
    required this.availableCourierCompanies,
    // required this.childCourierId,
    // required this.isRecommendationEnabled,
    // required this.recommendationAdvanceRule,
    // required this.recommendedBy,
    // required this.recommendedCourierCompanyId,
    // required this.shiprocketRecommendedCourierId,
  });

  factory ServiceAbility.fromJson(Map<String, dynamic> json) => ServiceAbility(
    availableCourierCompanies: List<AvailableCourierCompany>.from(
        json["available_courier_companies"]
            .map((x) => AvailableCourierCompany.fromJson(x))),
    // childCourierId: json["child_courier_id"],
    // isRecommendationEnabled: json["is_recommendation_enabled"],
    // recommendationAdvanceRule: json["recommendation_advance_rule"],
    // recommendedBy: RecommendedBy.fromJson(json["recommended_by"]),
    // recommendedCourierCompanyId: json["recommended_courier_company_id"],
    // shiprocketRecommendedCourierId: json["shiprocket_recommended_courier_id"],
  );

  Map<String, dynamic> toJson() => {
    "available_courier_companies": List<dynamic>.from(
        availableCourierCompanies.map((x) => x.toJson())),
    // "child_courier_id": childCourierId,
    // "is_recommendation_enabled": isRecommendationEnabled,
    // "recommendation_advance_rule": recommendationAdvanceRule,
    // "recommended_by": recommendedBy.toJson(),
    // "recommended_courier_company_id": recommendedCourierCompanyId,
    // "shiprocket_recommended_courier_id": shiprocketRecommendedCourierId,
  };
}

class AvailableCourierCompany {
  // String airMaxWeight;
  // int assuredAmount;
  // dynamic baseCourierId;
  // String baseWeight;
  // int blocked;
  // CallBeforeDelivery callBeforeDelivery;
  // int chargeWeight;
  // String city;
  // int cod;
  // int codCharges;
  // int codMultiplier;
  // String cost;
  String? courierCompanyId;
  String? courierName;
  // String courierType;
  // int coverageCharges;
  // CutoffTime cutoffTime;
  // CallBeforeDelivery deliveryBoyContact;
  // double deliveryPerformance;
  // String description;
  // String edd;
  // int entryTax;
  String? estimatedDeliveryDays;
  String? etd;
  // int etdHours;
  double freightCharge;
  // int id;
  // int isCustomRate;
  // bool isHyperlocal;
  // int isInternational;
  // bool isRtoAddressAvailable;
  // bool isSurface;
  // int localRegion;
  // int metro;
  // double minWeight;
  // int mode;
  // int newEdd;
  // bool odablock;
  // int otherCharges;
  // String others;
  // String pickupAvailability;
  // double pickupPerformance;
  // String pickupPriority;
  // int pickupSupressHours;
  // PodAvailable podAvailable;
  // String postcode;
  // int qcCourier;
  // String rank;
  // double rate;
  // double rating;
  // RealtimeTracking realtimeTracking;
  // int region;
  // double rtoCharges;
  // double rtoPerformance;
  // int secondsLeftForPickup;
  // bool secureShipmentDisabled;
  // int shipType;
  // State state;
  // dynamic suppressDate;
  // String suppressText;
  // SuppressionDates? suppressionDates;
  // String surfaceMaxWeight;
  // double trackingPerformance;
  // int? volumetricMaxWeight;
  // double weightCases;
  // Zone zone;

  AvailableCourierCompany({
    // required this.airMaxWeight,
    // required this.assuredAmount,
    // required this.baseCourierId,
    // required this.baseWeight,
    // required this.blocked,
    // required this.callBeforeDelivery,
    // required this.chargeWeight,
    // required this.city,
    // required this.cod,
    // required this.codCharges,
    // required this.codMultiplier,
    // required this.cost,
    this.courierCompanyId,
    this.courierName,
    // required this.courierType,
    // required this.coverageCharges,
    // required this.cutoffTime,
    // required this.deliveryBoyContact,
    // required this.deliveryPerformance,
    // required this.description,
    // required this.edd,
    // required this.entryTax,
    this.estimatedDeliveryDays,
    this.etd,
    // required this.etdHours,
    required this.freightCharge,
    // required this.id,
    // required this.isCustomRate,
    // required this.isHyperlocal,
    // required this.isInternational,
    // required this.isRtoAddressAvailable,
    // required this.isSurface,
    // required this.localRegion,
    // required this.metro,
    // required this.minWeight,
    // required this.mode,
    // required this.newEdd,
    // required this.odablock,
    // required this.otherCharges,
    // required this.others,
    // required this.pickupAvailability,
    // required this.pickupPerformance,
    // required this.pickupPriority,
    // required this.pickupSupressHours,
    // required this.podAvailable,
    // required this.postcode,
    // required this.qcCourier,
    // required this.rank,
    // required this.rate,
    // required this.rating,
    // required this.realtimeTracking,
    // required this.region,
    // required this.rtoCharges,
    // required this.rtoPerformance,
    // required this.secondsLeftForPickup,
    // required this.secureShipmentDisabled,
    // required this.shipType,
    // required this.state,
    // required this.suppressDate,
    // required this.suppressText,
    // required this.suppressionDates,
    // required this.surfaceMaxWeight,
    // required this.trackingPerformance,
    // required this.volumetricMaxWeight,
    // required this.weightCases,
    // required this.zone,
  });

  factory AvailableCourierCompany.fromJson(Map<String, dynamic> json) =>
      AvailableCourierCompany(
        // airMaxWeight: json["air_max_weight"],
        // assuredAmount: json["assured_amount"],
        // baseCourierId: json["base_courier_id"],
        // baseWeight: json["base_weight"],
        // blocked: json["blocked"],
        // callBeforeDelivery: callBeforeDeliveryValues.map[json["call_before_delivery"]]!,
        // chargeWeight: json["charge_weight"],
        // city: json["city"],
        // cod: json["cod"],
        // codCharges: json["cod_charges"],
        // codMultiplier: json["cod_multiplier"],
        // cost: json["cost"],
        courierCompanyId: json["courier_company_id"].toString(),
        courierName: json["courier_name"].toString(),
        // courierType: json["courier_type"],
        // coverageCharges: json["coverage_charges"],
        // cutoffTime: cutoffTimeValues.map[json["cutoff_time"]]!,
        // deliveryBoyContact: callBeforeDeliveryValues.map[json["delivery_boy_contact"]]!,
        // deliveryPerformance: json["delivery_performance"]?.toDouble(),
        // description: json["description"],
        // edd: json["edd"],
        // entryTax: json["entry_tax"],
        estimatedDeliveryDays: json["estimated_delivery_days"].toString(),
        etd: json["etd"].toString(),
        // etdHours: json["etd_hours"],
        freightCharge: json["freight_charge"]?.toDouble(),
        // id: json["id"],
        // isCustomRate: json["is_custom_rate"],
        // isHyperlocal: json["is_hyperlocal"],
        // isInternational: json["is_international"],
        // isRtoAddressAvailable: json["is_rto_address_available"],
        // isSurface: json["is_surface"],
        // localRegion: json["local_region"],
        // metro: json["metro"],
        // minWeight: json["min_weight"]?.toDouble(),
        // mode: json["mode"],
        // newEdd: json["new_edd"],
        // odablock: json["odablock"],
        // otherCharges: json["other_charges"],
        // others: json["others"],
        // pickupAvailability: json["pickup_availability"],
        // pickupPerformance: json["pickup_performance"]?.toDouble(),
        // pickupPriority: json["pickup_priority"],
        // pickupSupressHours: json["pickup_supress_hours"],
        // podAvailable: podAvailableValues.map[json["pod_available"]]!,
        // postcode: json["postcode"],
        // qcCourier: json["qc_courier"],
        // rank: json["rank"],
        // rate: json["rate"]?.toDouble(),
        // rating: json["rating"]?.toDouble(),
        // realtimeTracking: realtimeTrackingValues.map[json["realtime_tracking"]]!,
        // region: json["region"],
        // rtoCharges: json["rto_charges"]?.toDouble(),
        // rtoPerformance: json["rto_performance"]?.toDouble(),
        // secondsLeftForPickup: json["seconds_left_for_pickup"],
        // secureShipmentDisabled: json["secure_shipment_disabled"],
        // shipType: json["ship_type"],
        // state: stateValues.map[json["state"]]!,
        // suppressDate: json["suppress_date"],
        // suppressText: json["suppress_text"],
        // suppressionDates: json["suppression_dates"] == null ? null : SuppressionDates.fromJson(json["suppression_dates"]),
        // surfaceMaxWeight: json["surface_max_weight"],
        // trackingPerformance: json["tracking_performance"]?.toDouble(),
        // volumetricMaxWeight: json["volumetric_max_weight"],
        // weightCases: json["weight_cases"]?.toDouble(),
        // zone: zoneValues.map[json["zone"]]!,
      );

  Map<String, dynamic> toJson() => {
    // "air_max_weight": airMaxWeight,
    // "assured_amount": assuredAmount,
    // "base_courier_id": baseCourierId,
    // "base_weight": baseWeight,
    // "blocked": blocked,
    // "call_before_delivery": callBeforeDeliveryValues.reverse[callBeforeDelivery],
    // "charge_weight": chargeWeight,
    // "city": city,
    // "cod": cod,
    // "cod_charges": codCharges,
    // "cod_multiplier": codMultiplier,
    // "cost": cost,
    "courier_company_id": courierCompanyId,
    "courier_name": courierName,
    // "courier_type": courierType,
    // "coverage_charges": coverageCharges,
    // "cutoff_time": cutoffTimeValues.reverse[cutoffTime],
    // "delivery_boy_contact": callBeforeDeliveryValues.reverse[deliveryBoyContact],
    // "delivery_performance": deliveryPerformance,
    // "description": description,
    // "edd": edd,
    // "entry_tax": entryTax,
    "estimated_delivery_days": estimatedDeliveryDays,
    "etd": etd,
    // "etd_hours": etdHours,
    "freight_charge": freightCharge,
    // "id": id,
    // "is_custom_rate": isCustomRate,
    // "is_hyperlocal": isHyperlocal,
    // "is_international": isInternational,
    // "is_rto_address_available": isRtoAddressAvailable,
    // "is_surface": isSurface,
    // "local_region": localRegion,
    // "metro": metro,
    // "min_weight": minWeight,
    // "mode": mode,
    // "new_edd": newEdd,
    // "odablock": odablock,
    // "other_charges": otherCharges,
    // "others": others,
    // "pickup_availability": pickupAvailability,
    // "pickup_performance": pickupPerformance,
    // "pickup_priority": pickupPriority,
    // "pickup_supress_hours": pickupSupressHours,
    // "pod_available": podAvailableValues.reverse[podAvailable],
    // "postcode": postcode,
    // "qc_courier": qcCourier,
    // "rank": rank,
    // "rate": rate,
    // "rating": rating,
    // "realtime_tracking": realtimeTrackingValues.reverse[realtimeTracking],
    // "region": region,
    // "rto_charges": rtoCharges,
    // "rto_performance": rtoPerformance,
    // "seconds_left_for_pickup": secondsLeftForPickup,
    // "secure_shipment_disabled": secureShipmentDisabled,
    // "ship_type": shipType,
    // "state": stateValues.reverse[state],
    // "suppress_date": suppressDate,
    // "suppress_text": suppressText,
    // "suppression_dates": suppressionDates?.toJson(),
    // "surface_max_weight": surfaceMaxWeight,
    // "tracking_performance": trackingPerformance,
    // "volumetric_max_weight": volumetricMaxWeight,
    // "weight_cases": weightCases,
    // "zone": zoneValues.reverse[zone],
  };
}
