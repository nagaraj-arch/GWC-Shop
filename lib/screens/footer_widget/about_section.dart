import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/app_bar_widgets/common_scaffold.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../../../widgets/container_widgets/common_divider.dart';

class AboutSection extends StatefulWidget {
  final String title;
  const AboutSection({super.key, required this.title});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> sectionKeys = {
    "SHIPPING POLICY": GlobalKey(),
    "RETURN & REFUND POLICY": GlobalKey(),
    "PRIVACY POLICY": GlobalKey(),
    "TERMS OF SERVICE": GlobalKey(),
    "ADDRESS": GlobalKey(),
    "CONTACT": GlobalKey(),
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSection(widget.title);
    });
  }

  final Map<String, String> titleMap = {
    "Terms & Conditions": "TERMS OF SERVICE",
    "Refunds & Cancellations": "RETURN & REFUND POLICY",
    "Contact Us": "CONTACT",
  };

  void scrollToSection(String title) {
    final mappedTitle = titleMap[title] ?? title.toUpperCase();

    final key = sectionKeys[mappedTitle];

    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper(context).isDesktop;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: gBgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductsHeader(
              onBack: () {
                context.go('/');
              },
              showVersion: true,
            ),
            Expanded(
              child: buildMain(isDesktop),
            ),
          ],
        ),
      ),
    );
  }

  buildMain(bool isDesktop) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.only(
          top: 4.h, left: isDesktop ? 9.w : 3.w, right: isDesktop ? 9.w : 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          policySection("SHIPPING POLICY", shippingPolicyContent(),
              sectionKeys["SHIPPING POLICY"]),
          policySection("RETURN & REFUND POLICY", returnPolicyContent(),
              sectionKeys["RETURN & REFUND POLICY"]),
          policySection("PRIVACY POLICY", privacyPolicyContent(),
              sectionKeys["PRIVACY POLICY"]),
          policySection("TERMS OF SERVICE", termsOfServiceContent(),
              sectionKeys["TERMS OF SERVICE"]),
          policySection("ADDRESS", addressContent(), sectionKeys["ADDRESS"]),
          policySection("CONTACT", contactContent(), sectionKeys["CONTACT"]),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: socialMediaButtons(),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: ButtonWidget(
                text: "Shop Now",
                onPressed: () async {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/'); // or any fallback route
                  }
                },
                isLoading: false,
                radius: 8,
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget policySection(String title, Widget content, GlobalKey? key) {
    return Container(
      key: key, // 🔥 IMPORTANT
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize13,
                color: gBlackColor,
                fontFamily: fontBold,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          content,
          const CommonDivider(opacity: 0.2, verticalMargin: 2),
        ],
      ),
    );
  }

  Widget shippingPolicyContent() {
    return Text(
      "Shipping Time:\n"
          "• We ship orders within 4-7 business days anywhere in India.\n\n"
          "Order Processing:\n"
          "• Orders are processed and shipped on business days (Monday to Friday, excluding public holidays).\n"
          "• Once your order is processed and shipped, you will receive a confirmation email with tracking information.\n\n"
          "Shipping Charges:\n"
          "• Shipping charges, if any, will be calculated at checkout based on your delivery location.\n\n"
          "Delivery:\n"
          "• Please ensure that the shipping address provided at checkout is accurate to avoid delays.\n"
          "• Our delivery partners will make every effort to deliver your order within the specified time frame. However, delivery times may vary due to unforeseen circumstances.\n\n"
          "Tracking Your Order:\n"
          "• You can track your order using the tracking number provided in the confirmation email.\n\n"
          "Customer Support:\n"
          "• If you have any questions or concerns regarding your order, please contact us at successteam@gutwellnessclub.com.\n\n"
          "We appreciate your business and look forward to serving you.",
      style: TextStyle(
        fontSize: fontSize11,
        color: gBlackColor,
        fontFamily: kFontBook,
      ),
    );
  }

  Widget returnPolicyContent() {
    return Text(
      "Please note that due to the consumable nature of our products, we do not offer refunds.\n\n"
          "Exceptions:\n"
          "• If you receive a damaged or defective item, please contact us within 7 days of receipt to initiate a review process. We will require a photo of the damaged product and a detailed description of the issue. If accepted, we will issue a replacement.\n"
          "• In cases of incorrect items being delivered, please notify us within 7 days of receipt for a replacement.\n\n"
          "How to Request a Review:\n"
          "1. Email us at successteam@gutwellnessclub.com with your order number, photos of the damaged or incorrect item, and a description of the issue.\n"
          "2. Our team will review your request and respond within 3 business days.\n\n"
          "We appreciate your understanding and are committed to ensuring your satisfaction with our products.",
      style: TextStyle(
        fontSize: fontSize11,
        color: gBlackColor,
        fontFamily: kFontBook,
      ),
    );
  }

  Widget privacyPolicyContent() {
    return Text(
      "Effective Date: July 24, 2024\n\n"
          "Gut Wellness Club (\"we,\" \"us,\" \"our\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you visit our website www.gutwellnessclub.shop.\n\n"
          "Information We Collect:\n"
          "1. Personal Information: We may collect personal information such as your name, email address, shipping address, phone number, and payment information when you place an order or create an account.\n"
          "2. Non-Personal Information: We may collect non-personal information such as browser type, device information, and browsing behavior through cookies and similar technologies.\n\n"
          "How We Use Your Information:\n"
          "• To process and fulfill your orders.\n"
          "• To communicate with you about your order status and provide customer support.\n"
          "• To improve our website, products, and services.\n"
          "• To send you promotional offers and updates (you can opt-out at any time).\n\n"
          "How We Protect Your Information: We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.\n\n"
          "Sharing Your Information: We do not sell or rent your personal information to third parties. We may share your information with service providers who assist us in operating our website and fulfilling orders, subject to confidentiality agreements.\n\n"
          "Your Rights: You have the right to access, correct, or delete your personal information. You can update your account information through our website or contact us directly for assistance.\n\n"
          "Contact Us: If you have any questions or concerns about this Privacy Policy, please contact us at successteam@gutwellnessclub.com.",
      style: TextStyle(
        fontSize: fontSize11,
        color: gBlackColor,
        fontFamily: kFontBook,
      ),
    );
  }

  Widget termsOfServiceContent() {
    return Text(
      "Effective Date: July 24, 2024\n\n"
          "Welcome to Gut Wellness Club. By accessing or using our website www.gutwellnessclub.shop (the \"Site\"), you agree to comply with and be bound by these Terms of Service (\"Terms\"). Please read them carefully.\n\n"
          "1. Use of the Site: You may use the Site for lawful purposes and in accordance with these Terms. You agree not to use the Site:\n"
          "• In any way that violates any applicable laws or regulations.\n"
          "• To engage in any activity that exploits or harms minors.\n"
          "• To transmit, or procure the sending of, any advertising or promotional material without our prior written consent.\n\n"
          "2. Account Creation: To access certain features of the Site, you may need to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.\n\n"
          "Contact Us: If you have any questions about these Terms, please contact us at successteam@gutwellnessclub.com.",
      style: TextStyle(
        fontSize: fontSize11,
        color: gBlackColor,
        fontFamily: kFontBook,
      ),
    );
  }

  Widget addressContent() {
    return Center(
      child: Text(
        "32, Kruthi Arcade, 5th Main Rd,\n"
            "Tatanagar, Devinagar, Bengaluru,\n"
            "Karnataka 560092",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize11,
          color: gBlackColor,
          fontFamily: kFontBook,
        ),
      ),
    );
  }

  Widget contactContent() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "080-61915555",
            style: TextStyle(
              fontSize: fontSize11,
              color: gBlackColor,
              fontFamily: kFontBook,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "support@gutwellnessclub.com",
            style: TextStyle(
              fontSize: fontSize11,
              color: gBlackColor,
              fontFamily: kFontBook,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "www.gutwellnessclub.shop",
            style: TextStyle(
              fontSize: fontSize11,
              color: gBlackColor,
              fontFamily: kFontBook,
            ),
          ),
        ],
      ),
    );
  }

  Widget socialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(
            'assets/images/facebook.png',
            height: 3.h,
          ),
          onPressed: () async {
            String url =
                "https://www.facebook.com/profile.php?id=100088839889561&mibextid=ZbWKwL";

            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            } else {
              throw Exception('Could not launch $url');
            }
          },
        ),
        IconButton(
          icon: Image.asset(
            'assets/images/instagram.png',
            height: 3.h,
          ),
          onPressed: () async {
            String url =
                "https://www.instagram.com/gutwellnessclub?igsh=MTAwZ3pqZXl3Z3NkMw%3D%3D";

            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            } else {
              throw Exception('Could not launch $url');
            }
          },
        ),
        IconButton(
          icon: Image.asset(
            'assets/images/youtube.png',
            height: 3.h,
          ),
          onPressed: () async {
            String url = "https://www.youtube.com/@gutwellnessclub3789";

            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            } else {
              throw Exception('Could not launch $url');
            }
          },
        ),
      ],
    );
  }
}
