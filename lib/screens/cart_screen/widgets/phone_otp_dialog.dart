
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../controllers/providers/cart_provider.dart';
import '../../../utils/constants.dart';

class PhoneOtpDialog extends StatefulWidget {
  final String phone;
  final CartProvider provider;

  const PhoneOtpDialog({
    super.key,
    required this.phone,
    required this.provider,
  });

  @override
  State<PhoneOtpDialog> createState() => _PhoneOtpDialogState();
}

class _PhoneOtpDialogState extends State<PhoneOtpDialog>
    with TickerProviderStateMixin {
  final TextEditingController _otpController =
  TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  late final AnimationController _iconController;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool _isVerifying = false;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: -9),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -9, end: 9),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 9, end: -5),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -5, end: 0),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.easeInOut,
      ),
    );

    _otpController.addListener(() {
      if (_errorMessage != null) {
        setState(() => _errorMessage = null);
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _iconController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits.';
      });
      _shakeController.forward(from: 0);
      return;
    }

    if (!widget.provider.verifyPhoneOtpLocally(otp)) {
      setState(() {
        _errorMessage = 'Incorrect OTP. Please try again.';
      });
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      await widget.provider.fetchPhoneDetails(
        context,
        widget.phone,
      );

      if (!mounted) return;

      setState(() {
        _isVerifying = false;
        _isSuccess = true;
      });

      // Let the success animation finish before closing.
      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      widget.provider.phoneOtp = '';
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Phone details error: $e');

      if (!mounted) return;

      setState(() {
        _isVerifying = false;
        _errorMessage =
        'Unable to load your details. Please try again.';
      });
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = screenWidth > 500 ? 420.0 : screenWidth * 0.90;

    return Material(
      type: MaterialType.transparency,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 35,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24, 25, 24, 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isSuccess
                            ? 'Phone Verified!'
                            : 'Verify your phone',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172033),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _isSuccess
                            ? 'Your phone number has been verified successfully.'
                            : 'Enter the 6-digit verification code for',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xFF778197),
                        ),
                      ),
                      if (!_isSuccess) ...[
                        const SizedBox(height: 5),
                        Text(
                          '+91 ${widget.phone}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26364D),
                          ),
                        ),
                        const SizedBox(height: 25),
                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                _shakeAnimation.value,
                                0,
                              ),
                              child: child,
                            );
                          },
                          child: _buildOtpBoxes(),
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _errorMessage != null
                              ? Text(
                            _errorMessage!,
                            key: ValueKey(_errorMessage),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFD14343),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              : const Text(
                            'The code contains 6 digits.',
                            key: ValueKey('otp-hint'),
                            style: TextStyle(
                              color: Color(0xFF929BAD),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                            _isVerifying ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gPrimaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration:
                              const Duration(milliseconds: 200),
                              child: _isVerifying
                                  ? const SizedBox(
                                key: ValueKey('loading'),
                                height: 22,
                                width: 22,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                                  : const Row(
                                key: ValueKey('verify'),
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Verify & Continue',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _isVerifying
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancel verification',
                            style: TextStyle(
                              color: Color(0xFF778197),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 22),
                        const Text(
                          'You can continue with your checkout.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF778197),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gPrimaryColor,
            Color.lerp(gPrimaryColor, Colors.black, 0.18)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _iconController,
            builder: (context, child) {
              final scale = _isSuccess
                  ? 1.0
                  : 1 + (_iconController.value * 0.06);

              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1.5,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  _isSuccess
                      ? Icons.check_rounded
                      : Icons.phonelink_lock_rounded,
                  key: ValueKey(_isSuccess),
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _isSuccess ? 'VERIFICATION COMPLETE' : 'SECURE CHECKOUT',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _isSuccess
                ? 'Thank you for verifying'
                : 'One quick step to continue',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBoxes() {
    final otp = _otpController.text;

    return GestureDetector(
      onTap: () => _otpFocusNode.requestFocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final hasDigit = index < otp.length;
              final isCurrent = index == otp.length && otp.length < 6;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hasDigit
                      ? gPrimaryColor.withValues(alpha: 0.07)
                      : const Color(0xFFF8F9FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _errorMessage != null
                        ? const Color(0xFFD14343)
                        : isCurrent
                        ? gPrimaryColor
                        : const Color(0xFFE2E6EE),
                    width: isCurrent ? 1.8 : 1.2,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Text(
                    hasDigit ? otp[index] : '',
                    key: ValueKey('$index-${hasDigit ? otp[index] : ''}'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: gPrimaryColor,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Transparent input captures typing and pasted OTP.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _otpController,
                focusNode: _otpFocusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onSubmitted: (_) {
                  if (_otpController.text.length == 6 &&
                      !_isVerifying) {
                    _verifyOtp();
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
