import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/api_urls.dart';
import '../../utils/network_service.dart';
import '../models/tracking_model/get_tracking_model.dart';

enum LoadingType { trackOrder }

class TrackMyOrderProvider extends ChangeNotifier {
  /// ================= LOADING =================
  final Set<LoadingType> _loadingTypes = {};

  bool isLoading(LoadingType type) => _loadingTypes.contains(type);

  void setLoading(LoadingType type, bool value) {
    value ? _loadingTypes.add(type) : _loadingTypes.remove(type);
    notifyListeners();
  }

  /// ================= CONTROLLERS =================
  TextEditingController phoneController = TextEditingController(text: kDebugMode ? "7012357253"
      "" : "");

  /// ================= DATA =================
  List<GetTracking> trackList = [];

  String phoneMessage = "";

  /// ================= VALIDATION =================
  bool isPhone(String input) {
    return RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);
  }

  /// ================= API CALL =================
  Future<void> getTrackOrder(BuildContext context) async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter phone number")),
      );
      return;
    }

    setLoading(LoadingType.trackOrder, true);

    try {
      final response =
          await NetworkService.post("$getTrackUrl${phoneController.text}", {});

      if (response != null) {
        GetTrackingModel model = GetTrackingModel.fromJson(response);

        trackList = model.data ?? [];
      } else {
        trackList = [];
      }
    } catch (e) {
      debugPrint("Track Order Error: $e");
    } finally {
      setLoading(LoadingType.trackOrder, false);
    }
  }

  /// ================= CLEAR =================
  void clearPhone() {
    phoneController.clear();
    notifyListeners();
  }
}
