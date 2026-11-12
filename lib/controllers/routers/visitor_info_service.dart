import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/visitor_info_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/network_service.dart';

class VisitorInfoService {
  static const String visitorKey = 'visitor_info';

  static final String engagementApi = GwcApi.sendVisitorsDetailsApiUrl();

  static Future<VisitorInfoModel> collectVisitorInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final navigator = html.window.navigator;
    final screen = html.window.screen;

    final now = DateTime.now();
    final nowIso = now.toIso8601String();

    // Get previously saved visitor data
    VisitorInfoModel? oldData;

    final oldJson = prefs.getString(visitorKey);

    if (oldJson != null && oldJson.isNotEmpty) {
      try {
        oldData = VisitorInfoModel.fromJson(jsonDecode(oldJson));
      } catch (e) {
        debugPrint('Old visitor data error: $e');
      }
    }

    // Session
    final sessionId = oldData?.sessionId ?? _generateSessionId();

    // Browser / Device
    final userAgent = navigator.userAgent;

    final deviceType = _getDeviceType(userAgent);

    final os = _getOperatingSystem(userAgent);

    final osVersion = _getOSVersion(userAgent);

    final browser = _getBrowser(userAgent);

    final browserVersion = _getBrowserVersion(userAgent);

    // Screen
    final screenSize = '${screen?.width ?? 0} x ${screen?.height ?? 0}';

    // Touch
    final touchSupport = (navigator.maxTouchPoints ?? 0) > 0;

    // Pages
    final pagesVisited = (oldData?.pagesVisited ?? 0) + 1;

    // Time
    int timeSpent = 0;

    if (oldData?.lastVisit != null) {
      try {
        final previousVisit = DateTime.parse(oldData!.lastVisit!);

        timeSpent = now.difference(previousVisit).inSeconds;

        if (timeSpent < 0) {
          timeSpent = 0;
        }
      } catch (_) {
        timeSpent = 0;
      }
    }

    // Create visitor data
    final visitor = VisitorInfoModel(
      sessionId: sessionId,

      // These can be populated by backend/IP lookup
      ipAddress: oldData?.ipAddress,
      country: oldData?.country,
      stateRegion: oldData?.stateRegion,
      city: oldData?.city,
      isp: oldData?.isp,

      deviceType: deviceType,

      os: os,
      osVersion: osVersion,

      browser: browser,
      browserVersion: browserVersion,

      screenSize: screenSize,

      devicePixelRatio: html.window.devicePixelRatio.toDouble(),

      touchSupport: touchSupport,

      timezone: DateTime.now().timeZoneName,

      language: navigator.language,

      userAgent: userAgent,

      firstVisit: oldData?.firstVisit ?? nowIso,

      lastVisit: nowIso,

      referrer: html.document.referrer,

      landingPage: oldData?.landingPage ?? html.window.location.href,

      pagesVisited: pagesVisited,

      timeSpent: timeSpent,
    );

    // Save locally
    final visitorJson = jsonEncode(visitor.toJson());

    await prefs.setString(visitorKey, visitorJson);

    debugPrint('VISITOR INFORMATION: $visitorJson');

    // Send to API using common NetworkService
    try {
      final response = await NetworkService.post(
        engagementApi,
        visitor.toJson(),
        useToken: false,
      );

      debugPrint('VISITOR API RESPONSE: $response');
    } catch (e) {
      debugPrint('VISITOR API ERROR: $e');
    }

    return visitor;
  }

  static String _generateSessionId() {
    final random = Random();

    return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(999999)}';
  }

  static String _getDeviceType(String userAgent) {
    final ua = userAgent.toLowerCase();

    if (ua.contains('ipad') || ua.contains('tablet')) {
      return 'Tablet';
    }

    if (ua.contains('iphone') ||
        ua.contains('android') ||
        ua.contains('mobile')) {
      return 'Mobile';
    }

    return 'Desktop';
  }

  static String _getOperatingSystem(String userAgent) {
    final ua = userAgent.toLowerCase();

    if (ua.contains('iphone') || ua.contains('ipad')) {
      return 'iOS';
    }

    if (ua.contains('android')) {
      return 'Android';
    }

    if (ua.contains('windows')) {
      return 'Windows';
    }

    if (ua.contains('mac os') || ua.contains('macintosh')) {
      return 'macOS';
    }

    if (ua.contains('cros')) {
      return 'ChromeOS';
    }

    if (ua.contains('linux')) {
      return 'Linux';
    }

    return 'Unknown';
  }

  static String _getOSVersion(String userAgent) {
    final patterns = [
      RegExp(r'Android ([0-9._]+)'),
      RegExp(r'OS ([0-9_]+) like Mac OS X'),
      RegExp(r'Mac OS X ([0-9_]+)'),
      RegExp(r'Windows NT ([0-9.]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(userAgent);

      if (match != null) {
        return match.group(1)?.replaceAll('_', '.') ?? 'Unknown';
      }
    }

    return 'Unknown';
  }

  static String _getBrowser(String userAgent) {
    final ua = userAgent.toLowerCase();

    if (ua.contains('edg/')) {
      return 'Edge';
    }

    if (ua.contains('opr/') || ua.contains('opera')) {
      return 'Opera';
    }

    if (ua.contains('chrome') && !ua.contains('edg/')) {
      return 'Chrome';
    }

    if (ua.contains('firefox')) {
      return 'Firefox';
    }

    if (ua.contains('safari') && !ua.contains('chrome')) {
      return 'Safari';
    }

    return 'Unknown';
  }

  static String _getBrowserVersion(String userAgent) {
    final patterns = [
      RegExp(r'Edg/([0-9.]+)'),
      RegExp(r'OPR/([0-9.]+)'),
      RegExp(r'Chrome/([0-9.]+)'),
      RegExp(r'Firefox/([0-9.]+)'),
      RegExp(r'Version/([0-9.]+).*Safari'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(userAgent);

      if (match != null) {
        return match.group(1) ?? 'Unknown';
      }
    }

    return 'Unknown';
  }
}
