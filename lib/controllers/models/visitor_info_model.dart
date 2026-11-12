class VisitorInfoModel {
  String? sessionId;

  String? ipAddress;
  String? country;
  String? stateRegion;
  String? city;
  String? isp;

  String? deviceType;
  String? os;
  String? osVersion;

  String? browser;
  String? browserVersion;

  String? screenSize;
  double? devicePixelRatio;

  bool? touchSupport;

  String? timezone;
  String? language;

  String? userAgent;

  String? firstVisit;
  String? lastVisit;

  String? referrer;
  String? landingPage;

  int? pagesVisited;
  int? timeSpent;

  VisitorInfoModel({
    this.sessionId,
    this.ipAddress,
    this.country,
    this.stateRegion,
    this.city,
    this.isp,
    this.deviceType,
    this.os,
    this.osVersion,
    this.browser,
    this.browserVersion,
    this.screenSize,
    this.devicePixelRatio,
    this.touchSupport,
    this.timezone,
    this.language,
    this.userAgent,
    this.firstVisit,
    this.lastVisit,
    this.referrer,
    this.landingPage,
    this.pagesVisited,
    this.timeSpent,
  });

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'ip_address': ipAddress,
      'country': country,
      'state_region': stateRegion,
      'city': city,
      'isp': isp,
      'device_type': deviceType,
      'os': os,
      'os_version': osVersion,
      'browser': browser,
      'browser_version': browserVersion,
      'screen_size': screenSize,
      'device_pixel_ratio': devicePixelRatio,
      'touch_support': touchSupport,
      'timezone': timezone,
      'language': language,
      'user_agent': userAgent,
      'first_visit': firstVisit,
      'last_visit': lastVisit,
      'referrer': referrer,
      'landing_page': landingPage,
      'pages_visited': pagesVisited,
      'time_spent': timeSpent,
    };
  }

  factory VisitorInfoModel.fromJson(Map<String, dynamic> json) {
    return VisitorInfoModel(
      sessionId: json['session_id']?.toString(),

      ipAddress: json['ip_address']?.toString(),
      country: json['country']?.toString(),
      stateRegion: json['state_region']?.toString(),
      city: json['city']?.toString(),
      isp: json['isp']?.toString(),

      deviceType: json['device_type']?.toString(),
      os: json['os']?.toString(),
      osVersion: json['os_version']?.toString(),

      browser: json['browser']?.toString(),
      browserVersion: json['browser_version']?.toString(),

      screenSize: json['screen_size']?.toString(),
      devicePixelRatio:
      json['device_pixel_ratio'] == null
          ? null
          : double.tryParse(
        json['device_pixel_ratio'].toString(),
      ),

      touchSupport: json['touch_support'] == true ||
          json['touch_support']?.toString() == 'true',

      timezone: json['timezone']?.toString(),
      language: json['language']?.toString(),

      userAgent: json['user_agent']?.toString(),

      firstVisit: json['first_visit']?.toString(),
      lastVisit: json['last_visit']?.toString(),

      referrer: json['referrer']?.toString(),
      landingPage: json['landing_page']?.toString(),

      pagesVisited: json['pages_visited'] == null
          ? null
          : int.tryParse(json['pages_visited'].toString()),

      timeSpent: json['time_spent'] == null
          ? null
          : int.tryParse(json['time_spent'].toString()),
    );
  }
}