import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/products_providers.dart';
import '../../../utils/app_config.dart';
import '../../../utils/constants.dart';
import '../../../widgets/button_widgets/button_widget.dart';
import '../../../widgets/text_field_widgets/custom_date_text_field.dart';
import '../../../widgets/text_field_widgets/text_field_title.dart';
import '../../../widgets/text_field_widgets/validation_utils.dart';
import '../../product_screens/widgets/cart_button.dart';

class DoctorCallAndCartButtons extends StatelessWidget {
  final int selectedTab;

  const DoctorCallAndCartButtons({super.key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GlobalCartButtonVisibility.visible,
      builder: (context, cartVisible, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (selectedTab == 1) ...[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: const RequestDoctorCallButton(),
                ),
              ),
            ],
            if (cartVisible) ...[
              const SizedBox(height: 10),
              const GlobalCartButton(),
            ],
          ],
        );
      },
    );
  }
}

class RequestDoctorCallButton extends StatefulWidget {
  const RequestDoctorCallButton({super.key});

  @override
  State<RequestDoctorCallButton> createState() =>
      _RequestDoctorCallButtonState();
}

class _RequestDoctorCallButtonState extends State<RequestDoctorCallButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  static const Color _red = gPrimaryColor;
  static const Color _darkRed = gPrimaryColor;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _openSheet(BuildContext context) {
    _pulseController.stop();

    GlobalCartButtonVisibility.visible.value = false;

    showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Doctor Guidance',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Align(
          alignment: Alignment.bottomCenter,
          child: DoctorCallSheet(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    ).whenComplete(() {
      GlobalCartButtonVisibility.visible.value = true;

      if (mounted) {
        setState(() {
          _isExpanded = false;
        });

        _pulseController.repeat(reverse: true);
      }
    });
  }

  Widget _buildIconButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpand,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_red, _darkRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _red.withValues(alpha: 0.30),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              // Icons.help_center_rounded,
              Icons.support_agent_rounded,
              // Icons.live_help_rounded,
              // Icons.contact_support_rounded,
              color: gWhiteColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCard() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 205,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _red.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: _red.withValues(alpha: 0.16),
              blurRadius: 22,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top header.
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_red, _darkRed]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 9),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DOCTOR GUIDANCE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: Color(0xFF82766F),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Personalised Care',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF302824),
                        ),
                      ),
                    ],
                  ),
                ),

                // Collapse button.
                InkWell(
                  onTap: _toggleExpand,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close_rounded,
                      color: Color(0xFF82766F),
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Gut Goals? Let Our\nDoctor Guide You!',
              style: TextStyle(
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: _darkRed,
              ),
            ),

            const SizedBox(height: 11),

            // Call to action.
            Material(
              color: _red,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                onTap: () => _openSheet(context),
                borderRadius: BorderRadius.circular(9),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Get Personalised Advice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(15 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.centerRight,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                alignment: Alignment.centerRight,
                child: child,
              ),
            );
          },
          child: _isExpanded
              ? SizedBox(
                  key: const ValueKey('expanded'),
                  width: 205,
                  child: _buildExpandedCard(),
                )
              : SizedBox(
                  key: const ValueKey('collapsed'),
                  width: 54,
                  height: 54,
                  child: _buildIconButton(),
                ),
        ),
      ),
    );
  }
}

class DoctorCallSheet extends StatefulWidget {
  const DoctorCallSheet({super.key});

  @override
  State<DoctorCallSheet> createState() => _DoctorCallSheetState();
}

class _DoctorCallSheetState extends State<DoctorCallSheet>
    with TickerProviderStateMixin {
  static const String _submittedKey = 'doctor_call_request_submitted';

  late final PageController _pageController;
  int currentPage = 0;

  static const Color _red = Color(0xFFB91F24);
  static const Color _green = Color(0xFF62934A);
  static const Color _muted = Color(0xFF756E67);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _concernController = TextEditingController();
  String? _existingCustomer;

  late final AnimationController _contentController;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _loadSavedRequest();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.08, 1, curve: Curves.easeOut),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.09), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.0, 1, curve: Curves.easeOutCubic),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _contentController.forward();
    });
  }

  Future<void> _loadSavedRequest() async {
    final prefs = AppConfig().preferences;
    final submitted = prefs?.getBool(_submittedKey) ?? false;

    if (!mounted || !submitted) return;

    setState(() {
      currentPage = 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _pageController.hasClients) {
        _pageController.jumpToPage(1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _concernController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_isSubmitting) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final body = <String, String>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _phoneController.text.trim(),
        'notes': _concernController.text.trim(),

        // Confirm this field name with your backend.
        'is_existing_customer': _existingCustomer == 'Yes' ? "1" : "0",
      };

      final provider = context.read<ProductsProvider>();

      final success = await provider.submitDoctorCallApi(context, body);

      if (!mounted || !success) return;

      final prefs = AppConfig().preferences;
      await prefs?.setBool(_submittedKey, true);

      if (!mounted) return;

      setState(() {
        currentPage = 1;
      });

      await _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to submit. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isDesktop = mediaQuery.size.width >= 700;

    final availableHeight = (screenHeight - keyboardHeight).clamp(
      0.0,
      screenHeight,
    );

    return Material(
      color: Colors.transparent,
      child: Padding(
        // Move the sheet above the mobile keyboard.
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: isDesktop ? 540 : double.infinity,
              height: availableHeight * (isDesktop ? 0.90 : 0.99),
              decoration: const BoxDecoration(
                color: gPrimaryLight5,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  const Positioned.fill(child: _LeafDecoration()),
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6BDB4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              switchInCurve: Curves.easeOutCubic,
                              child: index == 0
                                  ? _buildFormPage()
                                  : _buildSuccessPage(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final screenHeight = MediaQuery.sizeOf(context).height;
  //   final screenWidth = MediaQuery.sizeOf(context).width;
  //   final isDesktop = screenWidth >= 700;
  //
  //   return Material(
  //     color: Colors.transparent,
  //     child: SafeArea(
  //       top: false,
  //       child: Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Container(
  //           width: isDesktop ? 540 : double.infinity,
  //           height: screenHeight * (isDesktop ? 0.90 : 0.99),
  //           decoration: BoxDecoration(
  //             color: gPrimaryLight5,
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(34),
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withValues(alpha: 0.15),
  //                 blurRadius: 30,
  //                 offset: const Offset(0, -6),
  //               ),
  //             ],
  //           ),
  //           clipBehavior: Clip.antiAlias,
  //           child: Stack(
  //             children: [
  //               const Positioned.fill(child: _LeafDecoration()),
  //               Column(
  //                 children: [
  //                   const SizedBox(height: 12),
  //                   Container(
  //                     width: 60,
  //                     height: 6,
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFFC6BDB4),
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: PageView.builder(
  //                       controller: _pageController,
  //                       itemCount: 2,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemBuilder: (context, index) {
  //                         return AnimatedSwitcher(
  //                           duration: const Duration(milliseconds: 350),
  //                           switchInCurve: Curves.easeOutCubic,
  //                           child: index == 0
  //                               ? _buildFormPage()
  //                               : _buildSuccessPage(),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFormPage() {
    return SingleChildScrollView(
      key: const ValueKey('doctor_form'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
      child: FadeTransition(
        opacity: _contentFade,
        child: SlideTransition(
          position: _contentSlide,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 2.h),

                _buildField(
                  label: 'Name',
                  hint: 'Enter your name',
                  icon: Icons.person_outline_rounded,
                  controller: _nameController,
                  validator: ValidationUtils().nameValidator,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 2.h),

                _buildField(
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.mail_outline_rounded,
                  controller: _emailController,
                  validator: ValidationUtils().emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 2.h),

                _buildField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.call_outlined,
                  controller: _phoneController,
                  validator: ValidationUtils().phoneValidator,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: 2.h),

                _existingCustomerField(),
                SizedBox(height: 2.h),

                _buildField(
                  label: 'What would you like guidance on?',
                  hint:
                      'Choosing the right products, customization, '
                      'suitability, or any other queries.',
                  icon: Icons.article_outlined,
                  controller: _concernController,
                  validator: (value) => ValidationUtils().textValidator(
                    value,
                    'your guidance requirements',
                  ),
                  maxLength: 4,
                ),
                SizedBox(height: 3.h),

                _buildSubmitButton(),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/Gut welness logo.png', height: 8.h),
            IconButton(
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                size: 3.5.h,
                color: gPrimaryColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need Guidance\nChoosing?',
                    style: GoogleFonts.playfairDisplay(
                      color: const Color(0xFFAC2925),
                      fontSize: fontSize30,
                      height: 1.05,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    "Request a Doctor's Advice",
                    style: TextStyle(
                      fontFamily: fontMedium,
                      fontSize: fontSize14,
                      color: const Color(0xFF443A34),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    "Not sure what's right for you? Share your needs, preferences or questions, and our Success Team will connect you with our doctor within 30 minutes.",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: fontSize12,
                      height: 1.4,
                      color: const Color(0xFF443A34),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10),

            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: _buildDoctorImage(),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _existingCustomerField() {
    return FormField<String>(
      validator: (_) {
        if (_existingCustomer == null) {
          return 'Please select Yes or No';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelWidget(
              text: 'Are you an existing Gut Wellness Club customer?',
              isRequired: true,
              child: const SizedBox.shrink(),
            ),

            SizedBox(height: 1.h),

            Row(
              children: [
                _customerOption('Yes'),
                SizedBox(width: 3.w),
                _customerOption('No'),
              ],
            ),

            if (field.errorText != null)
              Padding(
                padding: EdgeInsets.only(top: 0.5.h, left: 1.w),
                child: Text(
                  field.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: fontSize10),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _customerOption(String value) {
    final selected = _existingCustomer == value;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _existingCustomer = value;
          });

          _formKey.currentState?.validate();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 3.w),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFE9E5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFFAC2925)
                  : const Color(0xFFDCD5D1),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: fontMedium,
                fontSize: fontSize12,
                color: const Color(0xFF443A34),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorImage() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.75, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        height: 160,
        decoration: const BoxDecoration(
          color: Color(0xFFFFE9C9),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Center(
            child: Icon(
              Icons.medical_services_rounded,
              size: 90,
              color: Color(0xFFB92B2A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLength = 1,
  }) {
    return LabelWidget(
      text: label,
      isRequired: true,
      child: CustomTextField(
        controller: controller,
        hintText: hint,
        prefixIcon: icon,
        borderType: TextFieldBorderType.full,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ButtonWidget(
        text: 'Submit',
        onPressed: _submit,
        isLoading: _isSubmitting,
      ),
    );
  }

  Widget _buildSuccessPage() {
    return SingleChildScrollView(
      key: const ValueKey('doctor_success'),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/Gut welness logo.png', height: 8.h),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Color(0xFF443A34)),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.4, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F3D5),
                border: Border.all(color: const Color(0xFFD7E8B7), width: 8),
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.12),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, size: 85, color: _green),
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            "You're all set!",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: _red,
              fontSize: fontSize30,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 1.5.h),

          Text(
            'Our Success Team will call you within 10–15 minutes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontMedium,
              fontSize: fontSize14,
              color: const Color(0xFF443A34),
              height: 1.5,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'During working hours: 9 AM – 8 PM',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontBook,
              fontSize: fontSize12,
              color: _muted,
            ),
          ),

          SizedBox(height: 3.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What happens next?',
              style: TextStyle(
                fontFamily: fontMedium,
                fontSize: fontSize16,
                color: _red,
              ),
            ),
          ),

          SizedBox(height: 1.5.h),

          _nextStep(
            number: '1',
            title: "Let's Get to Know Your Needs",
            description:
                "Our Success Team will call you to understand what you're looking for and answer your questions.",
          ),

          SizedBox(height: 2.h),

          _nextStep(
            number: '2',
            title: "Let's Connect You with a Doctor",
            description:
                "We'll help arrange a doctor consultation within 30 minutes.",
          ),

          SizedBox(height: 2.h),

          _nextStep(
            number: '3',
            title: "Find What's Right for You",
            description:
                "Get personalised guidance to choose the right products or customise them to suit your needs.",
          ),

          SizedBox(height: 3.h),
          Center(
            child: ButtonWidget(
              text: 'Back to Products',
              onPressed: () => Navigator.of(context).pop(),
              isLoading: false,
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _nextStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE9E5),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            number,
            style: const TextStyle(color: _red, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: fontMedium,
                  fontSize: fontSize13,
                  color: const Color(0xFF443A34),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontFamily: fontBook,
                  fontSize: fontSize12,
                  height: 1.5,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeafDecoration extends StatelessWidget {
  const _LeafDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: 190,
            child: Icon(Icons.eco_rounded, size: 115, color: gPrimaryLight4),
          ),
          Positioned(
            left: -30,
            bottom: -12,
            child: Icon(Icons.spa_rounded, size: 125, color: gPrimaryLight4),
          ),
          Positioned(
            right: -24,
            bottom: -28,
            child: Icon(Icons.eco_rounded, size: 100, color: gPrimaryLight4),
          ),
        ],
      ),
    );
  }
}
