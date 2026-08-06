import 'dart:convert';

class GetEvaluationDataModel {
  String? status;
  String? errorCode;
  String? key;
  ChildGetEvaluationDataModel? data;

  GetEvaluationDataModel({this.status, this.errorCode, this.key, this.data});

  GetEvaluationDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'].toString();
    data = json['data'] != null ? ChildGetEvaluationDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errorCode'] = errorCode;
    data['key'] = key;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ChildGetEvaluationDataModel {
  int? id;
  String? patientId;
  String? weight;
  String? height;
  String? healthProblem;
  String? listProblems;
  String? listProblemsOther;
  String? listBodyIssues;
  String? tongueCoating;
  String? tongueCoatingOther;
  String? anyUrinationIssue;
  String? urineColor;
  String? urineColorOther;
  String? urineSmell;
  String? urineSmellOther;
  String? urineLookLike;
  String? urineLookLikeOther;
  String? closestStoolType;
  String? anyMedicalIntervationDoneBefore;
  String? anyMedicalIntervationDoneBeforeOther;
  String? anyMedicationConsumeAtMoment;
  String? anyTherapiesHaveDoneBefore;
  String? medicalReport;
  String? vegNonVegVegan;
  String? vegNonVegVeganOther;
  String? earlyMorning;
  String? breakfast;
  String? midDay;
  String? lunch;
  String? evening;
  String? dinner;
  String? postDinner;
  String? mentionIfAnyFoodAffectsYourDigesion;
  String? anySpecialDiet;
  String? anyFoodAllergy;
  String? anyIntolerance;
  String? anySevereFoodCravings;
  String? anyDislikeFood;
  String? noGalssesDay;
  String? anyHabbitOrAddiction;
  String? anyHabbitOrAddictionOther;
  String? afterMealPreference;
  String? afterMealPreferenceOther;
  String? hungerPattern;
  String? hungerPatternOther;
  String? bowelPattern;
  String? bowelPatternOther;
  String? createdAt;
  String? updatedAt;
  ChildEvalPatient? patient;

  ChildGetEvaluationDataModel(
      {this.id,
        this.patientId,
        this.weight,
        this.height,
        this.healthProblem,
        this.listProblems,
        this.listProblemsOther,
        this.listBodyIssues,
        this.tongueCoating,
        this.tongueCoatingOther,
        this.anyUrinationIssue,
        this.urineColor,
        this.urineColorOther,
        this.urineSmell,
        this.urineSmellOther,
        this.urineLookLike,
        this.urineLookLikeOther,
        this.closestStoolType,
        this.anyMedicalIntervationDoneBefore,
        this.anyMedicalIntervationDoneBeforeOther,
        this.anyMedicationConsumeAtMoment,
        this.anyTherapiesHaveDoneBefore,
        this.medicalReport,
        this.vegNonVegVegan,
        this.vegNonVegVeganOther,
        this.earlyMorning,
        this.breakfast,
        this.midDay,
        this.lunch,
        this.evening,
        this.dinner,
        this.postDinner,
        this.mentionIfAnyFoodAffectsYourDigesion,
        this.anySpecialDiet,
        this.anyFoodAllergy,
        this.anyIntolerance,
        this.anySevereFoodCravings,
        this.anyDislikeFood,
        this.noGalssesDay,
        this.anyHabbitOrAddiction,
        this.anyHabbitOrAddictionOther,
        this.afterMealPreference,
        this.afterMealPreferenceOther,
        this.hungerPattern,
        this.hungerPatternOther,
        this.bowelPattern,
        this.bowelPatternOther,
        this.createdAt,
        this.updatedAt,
        this.patient});

  ChildGetEvaluationDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'].toString();
    weight = json['weight'].toString();
    height = json['height'].toString();
    healthProblem = json['health_problem'].toString();
    listProblems = json['list_problems'].toString();
    listProblemsOther = json['list_problems_other'].toString();
    listBodyIssues = json['list_body_issues'].toString();
    tongueCoating = json['tongue_coating'].toString();
    tongueCoatingOther = json['tongue_coating_other'].toString();
    anyUrinationIssue = json['any_urination_issue'].toString();
    urineColor = json['urine_color'].toString();
    urineColorOther = json['urine_color_other'].toString();
    urineSmell = json['urine_smell'].toString();
    urineSmellOther = json['urine_smell_other'].toString();
    urineLookLike = json['urine_look_like'].toString();
    urineLookLikeOther = json['urine_look_like_other'].toString();
    closestStoolType = json['closest_stool_type'].toString();
    anyMedicalIntervationDoneBefore =
        json['any_medical_intervation_done_before'].toString();
    anyMedicalIntervationDoneBeforeOther =
        json['any_medical_intervation_done_before_other'].toString();
    anyMedicationConsumeAtMoment =
        json['any_medication_consume_at_moment'].toString();
    anyTherapiesHaveDoneBefore =
        json['any_therapies_have_done_before'].toString();
    medicalReport = json['medical_report'].toString();

    vegNonVegVegan = json['veg_nonveg_vegan'].toString();
    print("vegNonVegVegan: $vegNonVegVegan");
    vegNonVegVeganOther = json['veg_nonveg_vegan_other'].toString();

    earlyMorning = json['early_morning'].toString();
    breakfast = json['breakfast'].toString();
    midDay = json['mid_day'].toString();
    lunch = json['lunch'].toString();
    evening = json['evening'].toString();
    dinner = json['dinner'].toString();
    postDinner = json['post_dinner'].toString();

    mentionIfAnyFoodAffectsYourDigesion =
        json['mention_if_any_food_affects_your_digesion'].toString();
    anySpecialDiet = json['any_special_diet'].toString();
    anyFoodAllergy = json['any_food_allergy'].toString();
    anyIntolerance = json['any_intolerance'].toString();
    anySevereFoodCravings = json['any_severe_food_cravings'].toString();
    anyDislikeFood = json['any_dislike_food'].toString();
    noGalssesDay = json['no_galsses_day'].toString();
    anyHabbitOrAddiction = json['any_habbit_or_addiction'].toString();
    anyHabbitOrAddictionOther =
        json['any_habbit_or_addiction_other'].toString();
    afterMealPreference = json['after_meal_preference'].toString();
    afterMealPreferenceOther = json['after_meal_preference_other'].toString();
    hungerPattern = json['hunger_pattern'].toString();
    hungerPatternOther = json['hunger_pattern_other'].toString();
    bowelPattern = json['bowel_pattern'].toString();
    bowelPatternOther = json['bowel_pattern_other'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    patient = json['patient'] != null
        ? ChildEvalPatient.fromJson(json['patient'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['weight'] = weight;
    data['height'] = height;
    data['health_problem'] = healthProblem;
    data['list_problems'] = listProblems;
    data['list_problems_other'] = listProblemsOther;
    data['list_body_issues'] = listBodyIssues;
    data['tongue_coating'] = tongueCoating;
    data['tongue_coating_other'] = tongueCoatingOther;
    data['any_urination_issue'] = anyUrinationIssue;
    data['urine_color'] = urineColor;
    data['urine_color_other'] = urineColorOther;
    data['urine_smell'] = urineSmell;
    data['urine_smell_other'] = urineSmellOther;
    data['urine_look_like'] = urineLookLike;
    data['urine_look_like_other'] = urineLookLikeOther;
    data['closest_stool_type'] = closestStoolType;
    data['any_medical_intervation_done_before'] =
        anyMedicalIntervationDoneBefore;
    data['any_medical_intervation_done_before_other'] =
        anyMedicalIntervationDoneBeforeOther;
    data['any_medication_consume_at_moment'] = anyMedicationConsumeAtMoment;
    data['any_therapies_have_done_before'] = anyTherapiesHaveDoneBefore;
    data['medical_report'] = medicalReport;

    data['veg_nonveg_vegan'] = vegNonVegVegan;
    data['veg_nonveg_vegan_other'] = vegNonVegVeganOther;

    data['early_morning'] = earlyMorning;
    data['breakfast'] = breakfast;
    data['mid_day'] = midDay;
    data['lunch'] = lunch;
    data['evening'] = evening;
    data['dinner'] = dinner;
    data['post_dinner'] = postDinner;

    data['mention_if_any_food_affects_your_digesion'] =
        mentionIfAnyFoodAffectsYourDigesion;
    data['any_special_diet'] = anySpecialDiet;
    data['any_food_allergy'] = anyFoodAllergy;
    data['any_intolerance'] = anyIntolerance;
    data['any_severe_food_cravings'] = anySevereFoodCravings;
    data['any_dislike_food'] = anyDislikeFood;
    data['no_galsses_day'] = noGalssesDay;
    data['any_habbit_or_addiction'] = anyHabbitOrAddiction;
    data['any_habbit_or_addiction_other'] = anyHabbitOrAddictionOther;
    data['after_meal_preference'] = afterMealPreference;
    data['after_meal_preference_other'] = afterMealPreferenceOther;
    data['hunger_pattern'] = hungerPattern;
    data['hunger_pattern_other'] = hungerPatternOther;
    data['bowel_pattern'] = bowelPattern;
    data['bowel_pattern_other'] = bowelPatternOther;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    return data;
  }

  convertToList(String str) {
    List<String> list = jsonDecode(str);
    return list;
  }
}

class ChildEvalPatient {
  int? id;
  String? userId;
  String? maritalStatus;
  String? pincode;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? status;
  String? weight;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  ChildEvalUser? user;

  ChildEvalPatient(
      {this.id,
        this.userId,
        this.maritalStatus,
        this.pincode,
        this.address2,
        this.city,
        this.state,
        this.country,
        this.weight,
        this.status,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.user});

  ChildEvalPatient.fromJson(Map<String, dynamic> json) {
    print("patjson $json");
    json.forEach((key, value) => print(value.runtimeType));
    id = json['id'];
    userId = json['user_id'].toString();
    maritalStatus = json['marital_status'].toString();
    pincode = json['pincode'].toString();
    address2 = json['address2'].toString();
    city = json['city'].toString();
    state = json['state'].toString();
    country = json['country'].toString();
    weight = json['weight'].toString();
    status = json['status'].toString();
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    user = json['user'] != null ? ChildEvalUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['marital_status'] = maritalStatus;
    data['pincode'] = pincode;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['weight'] = weight;
    data['status'] = status;
    data['is_archieved'] = isArchieved;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class ChildEvalUser {
  int? id;
  String? roleId;
  String? name;
  String? fname;
  String? lname;
  String? email;
  String? emailVerifiedAt;
  String? countryCode;
  String? phone;
  String? gender;
  String? profession;
  String? profile;
  String? address;
  String? otp;
  String? deviceToken;
  String? deviceType;
  String? deviceId;
  String? age;
  String? pincode;
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? signupDate;

  ChildEvalUser(
      {this.id,
        this.roleId,
        this.name,
        this.fname,
        this.lname,
        this.email,
        this.emailVerifiedAt,
        this.countryCode,
        this.phone,
        this.gender,
        this.profession,
        this.profile,
        this.address,
        this.otp,
        this.deviceToken,
        this.deviceType,
        this.deviceId,
        this.age,
        this.pincode,
        this.isActive,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.signupDate});

  ChildEvalUser.fromJson(Map<String, dynamic> json) {
    print("userjson: $json");
    id = json['id'];
    roleId = json['role_id'].toString();
    name = json['name'].toString();
    fname = json['fname'].toString();
    lname = json['lname'].toString();
    email = json['email'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    countryCode = json['country_code'].toString();
    phone = json['phone'].toString();
    gender = json['gender'].toString();
    profession = json['profession'].toString();
    profile = json['profile'].toString();
    address = json['address'].toString();
    otp = json['otp'].toString();
    deviceToken = json['device_token'].toString();
    deviceType = json['device_type'].toString();
    deviceId = json['device_id'].toString();
    age = json['age'].toString();
    pincode = json['pincode'].toString();
    isActive = json['is_active'].toString();
    addedBy = json['added_by'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    signupDate = json['signup_date'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_id'] = roleId;
    data['name'] = name;
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['gender'] = gender;
    data['profession'] = profession;
    data['profile'] = profile;
    data['address'] = address;
    data['otp'] = otp;
    data['device_token'] = deviceToken;
    data['device_type'] = deviceType;
    data['device_id'] = deviceId;
    data['age'] = age;
    data['pincode'] = pincode;
    data['is_active'] = isActive;
    data['added_by'] = addedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['signup_date'] = signupDate;
    return data;
  }
}