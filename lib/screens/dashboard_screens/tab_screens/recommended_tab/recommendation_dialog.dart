import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constants.dart';

class MobileRecommendationDialog extends StatefulWidget {
  final Future<void> Function(String mobile)? onSubmit;

  const MobileRecommendationDialog({super.key, this.onSubmit});

  @override
  State<MobileRecommendationDialog> createState() =>
      _MobileRecommendationDialogState();
}

class _MobileRecommendationDialogState extends State<MobileRecommendationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _mobileController = TextEditingController();

  final FocusNode _mobileFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // MAIN POPUP ANIMATION
    // ============================================================

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _mobileController.dispose();
    _mobileFocusNode.dispose();
    super.dispose();
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final mobile = _mobileController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(mobile);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final width = size.width;
    final height = size.height;

    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 950;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildResponsiveDialog(
                  context,
                  width: width,
                  height: height,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveDialog(
    BuildContext context, {
    required double width,
    required double height,
    required bool isMobile,
    required bool isTablet,
  }) {
    if (isMobile) {
      return _buildMobileDialog(context);
    }

    if (isTablet) {
      return _buildTabletDialog(context);
    }

    return _buildDesktopDialog(context);
  }

  Widget _buildDesktopDialog(BuildContext context) {
    return Container(
      width: 780,
      height: 470,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 45,
            spreadRadius: 2,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Row(
            children: [
              // ==================================================
              // LEFT IMAGE
              // ==================================================
              Expanded(
                flex: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, top: 46, bottom: 46),
                  child: _buildMainImage(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // RIGHT FORM
              // ==================================================
              Expanded(flex: 50, child: _buildDesktopForm(context)),
            ],
          ),

          _buildCloseButton(top: 12, right: 12, size: 38),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP FORM
  // ============================================================

  Widget _buildDesktopForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 32, 30, 25),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLeaf(),

            const SizedBox(height: 8),

            _buildTitle(titleSize: 27),

            const SizedBox(height: 15),

            _buildDescription(fontSize: 13),

            const SizedBox(height: 20),

            _buildMobileField(height: 50, fontSize: 13),

            const SizedBox(height: 14),

            _buildSubmitButton(height: 48, fontSize: 13),

            const SizedBox(height: 15),

            _buildPrivacyText(fontSize: 10),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _buildTabletDialog(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final dialogWidth = (screenWidth - 40).clamp(430.0, 560.0);

    return Container(
      width: dialogWidth,
      constraints: const BoxConstraints(maxHeight: 620),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // IMAGE
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: SizedBox(
                    height: 185,
                    width: double.infinity,
                    child: _buildMainImage(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                // FORM
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 18, 35, 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildLeaf(),

                        const SizedBox(height: 7),

                        _buildTitle(titleSize: 23),

                        const SizedBox(height: 12),

                        _buildDescription(fontSize: 11.5),

                        const SizedBox(height: 16),

                        _buildMobileField(height: 46, fontSize: 12),

                        const SizedBox(height: 12),

                        _buildSubmitButton(height: 44, fontSize: 11.5),

                        const SizedBox(height: 13),

                        _buildPrivacyText(fontSize: 9),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildCloseButton(top: 10, right: 10, size: 34),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileDialog(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final dialogWidth = screenWidth - 28;

    return Container(
      width: dialogWidth,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // ==================================================
                // TOP IMAGE
                // ==================================================
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
                  child: SizedBox(
                    height: 145,
                    width: double.infinity,
                    child: _buildMainImage(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                // ==================================================
                // FORM
                // ==================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildLeaf(size: 26),

                        const SizedBox(height: 6),

                        _buildTitle(titleSize: 21),

                        const SizedBox(height: 10),

                        _buildDescription(fontSize: 10.2),

                        const SizedBox(height: 15),

                        _buildMobileField(height: 43, fontSize: 11),

                        const SizedBox(height: 11),

                        _buildSubmitButton(height: 43, fontSize: 10.5),

                        const SizedBox(height: 12),

                        _buildPrivacyText(fontSize: 8.5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildCloseButton(top: 9, right: 9, size: 32),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN IMAGE
  // ============================================================

  Widget _buildMainImage({required BorderRadius borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        "assets/images/recommented.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: const Color(0xFFF7E7C8),
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_outlined,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // LEAF
  // ============================================================

  Widget _buildLeaf({double size = 32}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -8 * (1 - value)),
          child: Transform.scale(
            scale: 0.7 + (0.3 * value),
            child: Opacity(opacity: value.clamp(0, 1), child: child),
          ),
        );
      },
      child: Image.asset(
        "assets/images/recommented_leaf.png",
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  // ============================================================
  // TITLE
  // ============================================================

  Widget _buildTitle({required double titleSize}) {
    return Column(
      children: [
        Text(
          "Recommendations",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Avenir",
            fontSize: titleSize,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF18232E),
          ),
        ),

        Text(
          "just for you",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Avenir",
            fontSize: titleSize,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: gPrimaryColor,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  Widget _buildDescription({required double fontSize}) {
    return Text(
      "Enter your mobile number to get\n"
      "personalised product recommendations\n"
      "based on your wellness goals.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Avenir",
        fontSize: fontSize,
        height: 1.45,
        color: const Color(0xFF686868),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ============================================================
  // MOBILE FIELD
  // ============================================================

  Widget _buildMobileField({required double height, required double fontSize}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
      ),
      child: Row(
        children: [
          // +91
          Container(
            width: height + 8,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFE4E4E4))),
            ),
            child: Text(
              "+91",
              style: TextStyle(
                fontFamily: "Avenir",
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF202020),
              ),
            ),
          ),

          // INPUT
          Expanded(
            child: TextFormField(
              controller: _mobileController,
              focusNode: _mobileFocusNode,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontFamily: "Avenir",
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF222222),
              ),
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 13),
                hintText: "Enter your mobile number",
                hintStyle: TextStyle(
                  fontFamily: "Avenir",
                  fontSize: fontSize - 0.5,
                  color: const Color(0xFF999999),
                ),
              ),
              validator: (value) {
                final number = value?.trim() ?? "";

                if (number.isEmpty) {
                  return "Mobile number is required";
                }

                if (number.length != 10) {
                  return "Enter a valid mobile number";
                }

                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(number)) {
                  return "Enter a valid mobile number";
                }

                return null;
              },
              onFieldSubmitted: (_) {
                _submit();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Widget _buildSubmitButton({
    required double height,
    required double fontSize,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: gPrimaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: gPrimaryColor.withValues(alpha: 0.65),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _isLoading
              ? const SizedBox(
                  key: ValueKey("loading"),
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  key: const ValueKey("button"),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Show My Recommendations",
                      style: TextStyle(
                        fontFamily: "Avenir",
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(Icons.arrow_forward_rounded, size: 17),
                  ],
                ),
        ),
      ),
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  Widget _buildPrivacyText({required double fontSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: fontSize + 6,
          color: const Color(0xFF555555),
        ),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            "Your number is safe with us and is only used\n"
            "to personalise your shopping experience.",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "Avenir",
              fontSize: fontSize,
              height: 1.35,
              color: const Color(0xFF777777),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CLOSE BUTTON
  // ============================================================

  Widget _buildCloseButton({
    required double top,
    required double right,
    required double size,
  }) {
    return Positioned(
      top: top,
      right: right,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: Material(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: size,
              height: size,
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Color(0xFF222222),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
