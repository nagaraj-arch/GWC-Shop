import 'app_config.dart';

var validPhoneUrl = "${AppConfig().baseUrl}postData/getUserDetails";

var getEvaluationDataUrl =
    "${AppConfig().baseUrl}postData/offlineGetEvaluation?phone=";

var getEmployeeUrl =
    "${AppConfig().baseUrl}postData/get_employee_by_email?email=";

var getEmailOtpUrl = "${AppConfig().baseUrl}postData/send_employee_otp?email=";

var getEmployeeBalanceUrl =
    "${AppConfig().baseUrl}postData/deduct_employee_balance";

var getEmployeeProgramUrl =
    "${AppConfig().baseUrl}postData/deduct_employee_program";

var getPinCodeFormApiUrl = "${AppConfig().baseUrl}getPincode";

var fetchCourierPartnersApiUrl =
    "${AppConfig().baseUrl}getShiprocketCourierServiceability";

var sendUserAddressApiUrl =
    "${AppConfig().baseUrl}submitForm/postEditUserAddress";

var getGwcProductsUrl = "${AppConfig().baseUrl}list/getProductList";

var getAdditionalProductsUrl =
    "${AppConfig().baseUrl}list/getAdditionalOrderListing";

var getProductFlavorsUrl =
    "${AppConfig().baseUrl}list/getProductFlavours?product_id=";

var submitGwcProductsUrl = "${AppConfig().baseUrl}postData/postRazorPayOrder";

var submitEmployeeProgramApiUrl =
    "${AppConfig().baseUrl}postData/PostRazorPayOrderEmployee";

var updateGwcProductsUrl =
    "${AppConfig().baseUrl}postData/postUpdateRazorPayOrder";

var getTrackUrl =
    "${AppConfig().baseUrl}postData/getAdditionalPackedOrders?phone=";


class GwcApi {

  static String baseUrl = "https://gutandhealth.com";

  ///Shop Api's
  static String getCategoryListApiUrl() =>
      "$baseUrl/api/list/getIngredientCategory";

  static String getProductsByCategoryApiUrl(String categoryId) =>
      "$baseUrl/api/list/getProductListByCategory/$categoryId";

  static String getClusterListApiUrl() =>
      "$baseUrl/api/list/getAdditionalClusterListings";

}
