import 'package:flutter/material.dart';
import 'package:gwc_shop/utils/responsive_helper.dart';
import 'package:intl/intl.dart';

class SafeString {
  /// Returns empty string if value is null
  static String value(dynamic data) {
    if (data == null) return '-';
    if (data.toString().toLowerCase() == 'null') return '-';
    return data.toString();
  }

  String capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String toTitleCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map(
          (word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}',
    )
        .join(' ');
  }

  String formatProdDate(String? date) {
    if (date == null || date == "null" || date.trim().isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return '';
    }
  }
}

class CommonDateUtils {
  CommonDateUtils._(); // prevent instance

  // ──────────────────────────────────────────────
  /// Parse API date WITHOUT timezone conversion
  /// Supported formats:
  /// 1) 2026-01-04T19:44:17.000000Z
  /// 2) 2026-03-03
  /// 3) 22-Oct-2025 10:26 AM
  /// 4) 31/01/2026
  /// 5) 31/01/2026 18:30
  static DateTime? parseApiDate(String? value) {
    if (value == null || value.trim().isEmpty || value == "null") {
      return null;
    }

    final v = value.trim();

    // 🔹 ISO FORMAT (2026-01-04T19:44:17.000000Z)
    try {
      return DateTime.parse(v);
    } catch (_) {}

    // 🔹 yyyy-MM-dd (2026-03-03)
    try {
      return DateFormat('yyyy-MM-dd').parse(v);
    } catch (_) {}

    // 🔹 dd-MMM-yyyy hh:mm a
    try {
      return DateFormat('dd-MMM-yyyy hh:mm a').parse(v);
    } catch (_) {}

    // 🔹 dd/MM/yyyy HH:mm
    try {
      return DateFormat('dd/MM/yyyy HH:mm').parse(v);
    } catch (_) {}

    // 🔹 dd/MM/yyyy
    try {
      return DateFormat('dd/MM/yyyy').parse(v);
    } catch (_) {}

    return null;
  }

  // ──────────────────────────────────────────────
  static String formatApiDate(String? value) {
    final date = parseApiDate(value);
    if (date == null) return 'PENDING';

    final v = value ?? "";

    // If only date → show date only
    if (!v.contains(':')) {
      return DateFormat('dd MMM yyyy').format(date);
    }

    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  // ──────────────────────────────────────────────
  static String formatToApi(DateTime? date) {
    if (date == null) return "";
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

class StatusUtils{
  /// API -> UI
  String formatStatusForUI(String? apiStatus) {
    if (apiStatus == null || apiStatus.isEmpty) return "";

    return apiStatus
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }

  /// UI -> API
  String formatStatusForApi(String? uiStatus) {
    if (uiStatus == null || uiStatus.isEmpty) return "";

    return uiStatus.toLowerCase().replaceAll(' ', '_');
  }
}