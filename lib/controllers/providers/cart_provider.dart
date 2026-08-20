import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

import '../../screens/product_screens/widgets/common_success_dialog.dart';
import '../../screens/success_screens/success_screen.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_config.dart';
import '../../utils/network_service.dart';
import '../../widgets/loading_widgets/address_loader.dart';
import '../models/get_additional_products_model/available_courier_partners_model.dart';
import '../models/get_additional_products_model/employee_by_model.dart';
import '../models/get_phone_details_model/get_evaluationdata_model.dart';
import '../models/get_phone_details_model/pincode_model.dart';
import '../models/get_phone_details_model/submit_product_model.dart';
import '../models/get_phone_details_model/update_product_model.dart';

enum CartLoadingType {
  phone,
  pinCode,
  employee,
  emailOtp,
  submitItems,
  employeeSubmitItems
}

class Item {
  final int id;
  final String? name;
  final String? specialTag;
  final double? price;
  final String? description;
  int quantity;
  final String? weight;
  final String? unitId;
  final String? unitName;
  final String? servings;
  final String? category;
  final String? thumbnail;

  final String? flavorName;
  final double? flavorPrice;
  final int? flavorId;

  Item({
    required this.id,
    this.name,
    this.price,
    this.specialTag,
    this.description,
    this.quantity = 0,
    this.weight,
    this.unitId,
    this.unitName,
    this.servings,
    this.category,
    this.thumbnail,
    this.flavorName,
    this.flavorPrice,
    this.flavorId,
  });

  // Convert item to JSON for storing
  Map<String, dynamic> toJson() => {
    'item_id': id,
    'item_name': name,
    'item_price': price,
    'item_qty': quantity,
    'description': description,
    'special_tag': specialTag,
    'item_weight': weight,
    'item_unit_id': unitId,
    'item_unit': unitName,
    'item_servings': servings,
    'category': category,
    'thumbnail': thumbnail,
    'flavor_name': flavorName,
    'flavor_price': flavorPrice,
    'flavor_id': flavorId,
  };
}

class CartProvider with ChangeNotifier {
  /// ================= LOADING STATE =================
  final Set<CartLoadingType> _loadingTypes = {};

  bool isLoading(CartLoadingType type) => _loadingTypes.contains(type);

  void setLoading(CartLoadingType type, bool value) {
    value ? _loadingTypes.add(type) : _loadingTypes.remove(type);
    notifyListeners();
  }

  ///ADDRESS
  TextEditingController couponController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  Future<void> fetchPhoneDetails(BuildContext context, String phone) async {
    setLoading(CartLoadingType.phone, true);

    try {
      final data = await NetworkService.post(
        "$getEvaluationDataUrl$phone",
        {},
      );

      if (data["status"] == 200) {
        final model = GetEvaluationDataModel.fromJson(data);
        final getUserAddress = model.data;

        nameController.text =
            getUserAddress?.patient?.user?.name ?? '';

        phoneController.text =
            getUserAddress?.patient?.user?.phone ?? '';

        emailController.text =
            getUserAddress?.patient?.user?.email ?? '';

        address1Controller.text =
        "No.${getUserAddress?.patient?.user?.address?.split('.').last}";

        address2Controller.text =
            getUserAddress?.patient?.address2 ?? '';

        // 🔥 Get pincode from phone API
        final fetchedPinCode =
            getUserAddress?.patient?.user?.pincode?.trim() ?? '';

        pinCodeController.text = fetchedPinCode;

        cityController.text =
            getUserAddress?.patient?.city ?? '';

        stateController.text =
            getUserAddress?.patient?.state ?? '';

        countryController.text =
            getUserAddress?.patient?.country ?? '';

        // 🔥 IMPORTANT:
        // Phone API success -> automatically hit Pincode API
        if (fetchedPinCode.length == 6) {
          pinCodeList.clear();
          partners.clear();
          deliveryFee = 0;
          calculateBill();

          await fetchPinCode(context, fetchedPinCode);
        }
      }
    } catch (e) {
      debugPrint("Phone API Error: $e");
    } finally {
      setLoading(CartLoadingType.phone, false);
    }
  }

  List<PostOffice> pinCodeList = [];

  Future<void> fetchPinCode(BuildContext context, String pinCode) async {
    setLoading(CartLoadingType.pinCode, true);

    try {
      final data = await NetworkService.get(
        "$getPinCodeFormApiUrl/$pinCode",
        useToken: false,
      );

      if (data["status"] == 200) {
        final model = PinCodeModel.fromJson(data);
        pinCodeList = model.response?.postOffice ?? [];

        if (pinCodeList.isNotEmpty) {
          final first = pinCodeList.first;

          stateController.text = first.state ?? '';
          cityController.text = first.district ?? '';
          countryController.text = first.country ?? '';

          await fetchCourier(context, pinCode);
        } else {
          stateController.clear();
          cityController.clear();
          countryController.clear();
          partners.clear();
          deliveryFee = 99;
          calculateBill();

          AppConfig().showSnackBar(context, "Invalid Pincode", isError: true);
        }
      } else {
        stateController.clear();
        cityController.clear();
        countryController.clear();
        partners.clear();
        deliveryFee = 99;
        calculateBill();

        AppConfig().showSnackBar(context, data["message"], isError: true);
      }
    } catch (e) {
      stateController.clear();
      cityController.clear();
      countryController.clear();
      partners.clear();
      deliveryFee = 99;
      calculateBill();

      AppConfig().showSnackBar(context, "Error $e", isError: true);
    } finally {
      setLoading(CartLoadingType.pinCode, false);
      notifyListeners();
    }
  }

  List<AvailableCourierCompany> partners = [];

  Future<void> fetchCourier(BuildContext context, String pinCode) async {
    if (totalPrice >= 799) {
      deliveryFee = 0;
      calculateBill();
      return;
    }

    setLoading(CartLoadingType.pinCode, true);

    try {
      final body = {
        "pickup_postcode": "560092",
        "delivery_postcode": pinCode,
        "weight": "0.6",
        "cod": "0"
      };

      final data = await NetworkService.post(fetchCourierPartnersApiUrl, body);

      final model = AvailableCourierPartnersModel.fromJson(data);
      partners = model.data?.data?.availableCourierCompanies ?? [];

      final validPartners = partners.where((partner) {
        final name = (partner.courierName ?? "").toLowerCase();
        return name.isNotEmpty && !name.contains("air");
      }).toList();

      if (validPartners.isEmpty) {
        deliveryFee = 99;
        calculateBill();
        return;
      }

      double totalFreight = 0;
      for (final partner in validPartners) {
        totalFreight += double.tryParse(partner.freightCharge.toString()) ?? 0;
        debugPrint("Delivery Charges : ${partner.freightCharge.toString()}");
      }
      debugPrint("Delivery Charges : ${validPartners.length}");
      final avgFreight = totalFreight / validPartners.length;
      deliveryFee = avgFreight > 0 ? avgFreight : 99;

      debugPrint("Delivery Charges : $deliveryFee");
      calculateBill();
    } catch (e) {
      debugPrint("Error fetching courier: $e");
      partners = [];
      deliveryFee = 99;
      calculateBill();
    } finally {
      setLoading(CartLoadingType.pinCode, false);
    }
  }

  Future<void> refreshDeliveryCharge(BuildContext context) async {
    if (totalPrice >= 799) {
      deliveryFee = 0;
      partners.clear();
      calculateBill();
      return;
    }

    if (pinCodeController.text.length != 6) {
      deliveryFee = 0;
      calculateBill();
      return;
    }

    await fetchCourier(context, pinCodeController.text);
  }

  EmployeeData? employeeData;
  String availableBalance = '';

  Future<void> fetchEmployeeDetails(BuildContext context, String email) async {
    setLoading(CartLoadingType.employee, true);

    try {
      final data = await NetworkService.post("$getEmployeeUrl$email", {});

      if (data["status"] == 200) {
        final model = EmployeeModel.fromJson(data);
        employeeData = model.data;
        availableBalance = employeeData?.availableBalance ?? '';

        availableCredits =
            double.tryParse(employeeData?.availableBalance ?? "0") ?? 0.0;

        calculateBill();
      }
      // else {
      //   AppConfig().showSnackBar(context, data["message"], isError: true);
      // }
    } catch (e) {
      // AppConfig().showSnackBar(context, "Error $e", isError: true);
    } finally {
      setLoading(CartLoadingType.employee, false);
    }
  }

  String otp = "";

  Future<void> fetchEmailOtp(BuildContext context, String email) async {
    setLoading(CartLoadingType.emailOtp, true);

    try {
      final data = await NetworkService.post("$getEmailOtpUrl$email", {});

      if (data["status"] == 200) {
        otp = data['otp'];
      } else {
        AppConfig().showSnackBar(context, data["message"], isError: true);
      }
    } catch (e) {
      AppConfig().showSnackBar(context, "Error $e", isError: true);
    } finally {
      setLoading(CartLoadingType.emailOtp, false);
    }
  }

  Future<void> saveAddress() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> addressData = {
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "address1": address1Controller.text,
      "address2": address2Controller.text,
      "city": cityController.text,
      "state": stateController.text,
      "country": countryController.text,
      "pincode": pinCodeController.text,
    };

    prefs.setString("address", jsonEncode(addressData));
  }

  Future<void> loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("address");

    if (data != null) {
      final decoded = jsonDecode(data);

      nameController.text = decoded["name"] ?? "";
      phoneController.text = decoded["phone"] ?? "";
      emailController.text = decoded["email"] ?? "";
      address1Controller.text = decoded["address1"] ?? "";
      address2Controller.text = decoded["address2"] ?? "";
      cityController.text = decoded["city"] ?? "";
      stateController.text = decoded["state"] ?? "";
      countryController.text = decoded["country"] ?? "";
      pinCodeController.text = decoded["pincode"] ?? "";
    }

    calculateBill(); // ✅ IMPORTANT (recalculate with credits)

    notifyListeners();
  }

  String get fullAddress =>
      "${nameController.text},\n${phoneController.text},\n${emailController.text},\n${address1Controller.text}, ${address2Controller.text},\n${cityController.text}, ${stateController.text}, ${countryController.text} - ${pinCodeController.text}";

  /// CART
  List<Item> _items = [];

  List<Item> get items => _items;

  // Load items from SharedPreferences
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      _items = List<Map<String, dynamic>>.from(jsonDecode(cartData))
          .map((itemData) => Item(
        id: itemData['item_id'],
        name: itemData['item_name'],
        price: (itemData['item_price'] as num).toDouble(),
        quantity: itemData['item_qty'],
        description: itemData['description'],
        specialTag: itemData['special_tag'],
        weight: itemData['item_weight'],
        unitId: itemData['item_unit_id'],
        unitName: itemData['item_unit'],
        servings: itemData['item_servings'],
        category: itemData['category'],
        thumbnail: itemData['thumbnail'],
        flavorName: itemData['flavor_name'],
        flavorPrice: (itemData['flavor_price'] ?? 0).toDouble(),
        flavorId: itemData['flavor_id'],
      ))
          .toList();
    }

    calculateBill(); // ✅ VERY IMPORTANT
  }

  // Save items to SharedPreferences
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(_items.map((e) => e.toJson()).toList()));

    print("LIST : ${prefs.getString('cart')}");
  }

  void addItem(BuildContext context, Item item) async {
    // int index = _items.indexWhere((existingItem) => existingItem.id == item.id);

    int index = _items.indexWhere(
          (existingItem) =>
      existingItem.id == item.id &&
          existingItem.flavorName == item.flavorName,
    );

    if (index != -1) {
      _items[index].quantity++;
    } else {
      item.quantity = 1;
      _items.add(item);
    }

    _saveCart();
    calculateBill();
    await refreshDeliveryCharge(context);
    notifyListeners();
  }

  void removeItem(BuildContext context, int itemId, String? flavorName) async {
    int index = _items.indexWhere(
            (item) => item.id == itemId && item.flavorName == flavorName);

    // int index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }

    _saveCart();
    calculateBill();
    await refreshDeliveryCharge(context);
    notifyListeners();
  }

  void removeProductCompletely(int itemId, String? flavorName) {
    _items.removeWhere(
            (item) => item.id == itemId && item.flavorName == flavorName);
    // _items.removeWhere((item) => item.id == itemId);

    _saveCart();
    calculateBill();

    notifyListeners();
  }

  void updateItemQuantity(BuildContext context, int itemId, String? flavorName,
      int quantity) async {
    int index = _items.indexWhere(
            (item) => item.id == itemId && item.flavorName == flavorName);
    // int index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].quantity = quantity;

      _saveCart();
      calculateBill();
      await refreshDeliveryCharge(context);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  double totalPrice = 0.0;
  double discount = 0.0;
  double deliveryFee = 0.0;
  double grandTotal = 0.0;
  double availableCredits = 0.0;
  double subtotal = 0.0;
  double usedCredits = 0.0;

  bool get isCompanyCoupon =>
      couponController.text.trim().toLowerCase().endsWith("@fembuddy.com");

  // Calculate total price of items in the cart
  void calculateBill() {
    totalPrice = items.fold(
      0.0,
          (sum, item) =>
      sum + ((item.price! + (item.flavorPrice ?? 0)) * item.quantity),
    );

    if (isCompanyCoupon && employeeData != null) {
      availableCredits =
          double.tryParse(employeeData?.availableBalance ?? "0") ?? 0;

      usedCredits =
      totalPrice < availableCredits ? totalPrice : availableCredits;

      subtotal = totalPrice - usedCredits;

      if (subtotal < 0) {
        subtotal = 0;
      }

      /// 50% discount after applying credits
      discount = subtotal * 0.5;
    } else {
      availableCredits = 0;
      usedCredits = 0;
      subtotal = totalPrice;
      discount = 0;
    }

    /// Step 4
    grandTotal = subtotal - discount + deliveryFee;

    notifyListeners();
  }

  // Total items count for badge
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  int roundToWhole(double value) {
    return value.round();
  }

  Future<bool> submitProgramApi(BuildContext context) async {
    setLoading(CartLoadingType.submitItems, true);

    try {
      final List<Map<String, dynamic>> itemsToPost = items.map((item) {
        return {
          "item_id": item.id,
          "item_name": item.name,
          "item_qty": item.quantity,
          "item_weight": item.weight,
          "item_unit_id": item.unitId,
          "item_unit": item.unitName,
          "item_servings": "${item.servings} Servings",

          /// Flavor Name
          "flavor_name": item.flavorName ?? "",

          /// Base Price + Flavor Price
          "item_price": item.price! + (item.flavorPrice ?? 0),
        };
      }).toList();

      Map<String, dynamic> body = {
        'name': nameController.text,
        "phone": phoneController.text,
        'email': emailController.text,
        'house_no': address1Controller.text,
        'address': address2Controller.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
        'pincode': pinCodeController.text,
        'product_details': itemsToPost,
        // 'total_amount': 1,
        'total_amount': roundToWhole(grandTotal),
      };

      debugPrint("🔥 Program API Body: $body");

      final res = await NetworkService.post(submitGwcProductsUrl, body);

      debugPrint("🔥 API RESPONSE: $res");

      /// ✅ SUCCESS
      if (res["status"] == 200) {
        final model = SubmitProductModel.fromJson(res);

        if (model.data != null) {
          final data = model.data!;

          String orderId = data.cashFreeResponse?.cfOrderId ?? "";
          String sessionId = data.cashFreeResponse?.paymentSessionId ?? "";

          await webCheckout(
            context,
            data.id.toString(),
            orderId,
            sessionId,
          );

          return true;
        } else {
          /// ❌ EDGE CASE FIX
          AppConfig().showSnackBar(
              context, model.message ?? "Invalid response from server",
              isError: true);
          return false;
        }
      }

      /// ❌ HANDLE 409 / OTHER ERRORS
      else {
        String message =
            res["errorMsg"] ?? res["message"] ?? "Something went wrong";

        AppConfig().showSnackBar(context, message, isError: true);
        return false;
      }
    } catch (e) {
      AppConfig().showSnackBar(context, "Error $e", isError: true);
      return false;
    } finally {
      setLoading(CartLoadingType.submitItems, false);
    }
  }

  Future<bool> submitEmployeeProgramApi(BuildContext context) async {
    setLoading(CartLoadingType.employeeSubmitItems, true);

    try {
      final List<Map<String, dynamic>> itemsToPost = items.map((item) {
        return {
          "item_id": item.id,
          "item_name": item.name,
          "item_qty": item.quantity,
          "item_weight": item.weight,
          "item_unit_id": item.unitId,
          "item_unit": item.unitName,
          "item_servings": "${item.servings} Servings",

          /// Flavor Name
          "flavor_name": item.flavorName ?? "",

          /// Base Price + Flavor Price
          "item_price": item.price! + (item.flavorPrice ?? 0),
        };
      }).toList();

      Map<String, dynamic> body = {
        'name': nameController.text,
        "phone": phoneController.text,
        'email': emailController.text,
        'house_no': address1Controller.text,
        'address': address2Controller.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
        'pincode': pinCodeController.text,
        'product_details': itemsToPost,
        'total_amount': roundToWhole(grandTotal),
        'employee_amount': roundToWhole(usedCredits),
      };

      debugPrint("🔥 Program API Body: $body");

      final res = await NetworkService.post(submitEmployeeProgramApiUrl, body);

      debugPrint("🔥 API RESPONSE: $res");

      /// ✅ SUCCESS
      if (res["status"] == 200) {
        final model = SubmitProductModel.fromJson(res);

        if (model.data != null) {
          final data = model.data!;

          String orderId = data.cashFreeResponse?.cfOrderId ?? "";
          String sessionId = data.cashFreeResponse?.paymentSessionId ?? "";

          await webCheckout(context, data.id.toString(), orderId, sessionId);

          return true;
        } else {
          /// ❌ EDGE CASE FIX
          AppConfig().showSnackBar(
              context, model.message ?? "Invalid response from server",
              isError: true);
          return false;
        }
      }

      /// ❌ HANDLE 409 / OTHER ERRORS
      else {
        String message =
            res["errorMsg"] ?? res["message"] ?? "Something went wrong";

        AppConfig().showSnackBar(context, message, isError: true);
        return false;
      }
    } catch (e) {
      AppConfig().showSnackBar(context, "Error $e", isError: true);
      return false;
    } finally {
      setLoading(CartLoadingType.employeeSubmitItems, false);
    }
  }

  var cfPaymentGatewayService = CFPaymentGatewayService();

  Future<void> webCheckout(
      BuildContext context, String id, String orderId, String sessionId) async {
    try {
      debugPrint("ID : $id\nORDER ID : $orderId\nSESSION ID : $sessionId");
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.PRODUCTION)
          .setOrderId(orderId)
          .setPaymentSessionId(sessionId)
          .build();

      cfPaymentGatewayService.setCallback(
            (String transactionId) {
          debugPrint("✅ Payment Success: $transactionId");

          updatePayment(
            context,
            id: id,
            paymentId: transactionId,
            status: "SUCCESS",
          );

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
            (CFErrorResponse errorResponse, String errorMessage) {
          debugPrint("❌ Payment Failed: $errorMessage");

          updatePayment(
            context,
            status: "FAILURE",
          );

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );

      var cfWebCheckout =
      CFWebCheckoutPaymentBuilder().setSession(session).build();

      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } catch (e) {
      debugPrint("❌ Payment Exception: $e");
    }
  }

  Future<void> updatePayment(
      BuildContext context, {
        String? id,
        String? paymentId,
        String? status,
      }) async {
    try {
      AppLoader.show(context);

      final body = {
        'id': id,
        'payment_id': paymentId,
        'payment_status': status,
        'razorpay_order_id': paymentId,
        'total_amount': roundToWhole(grandTotal),
      };

      final res = await NetworkService.post(
        updateGwcProductsUrl,
        body,
      );

      AppLoader.hide(context);

      /// ✅ SUCCESS
      if (res["status"] == 200 && status == "SUCCESS") {
        final response = UpdateProductModel.fromJson(res);

        /// 🔥 STEP 2: CLEAR DATA AFTER SUCCESS
        await clearAllData();

        /// 🔥 STEP 3: NAVIGATE
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SuccessScreen(model: response.data),
          ),
        );
      }

      /// ❌ FAILURE CASE
      else {
        CommonSuccessDialog.show(context, status: "Payment Failed");
      }
    } catch (e) {
      AppLoader.hide(context);

      debugPrint("❌ Update Payment Error: $e");

      CommonSuccessDialog.show(context, status: "Error");
    }
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();

    // clear cart
    _items.clear();
    await prefs.remove('cart');

    // clear address
    await prefs.remove('address');

    // clear controllers
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    address1Controller.clear();
    address2Controller.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pinCodeController.clear();

    // reset bill values
    discount = 0;
    deliveryFee = 0;
    grandTotal = 0;

    notifyListeners();
  }
}
