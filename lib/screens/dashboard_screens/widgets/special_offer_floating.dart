import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class SpecialOfferFloatingCard extends StatefulWidget {
  final VoidCallback? onClose;

  const SpecialOfferFloatingCard({super.key, this.onClose});

  @override
  State<SpecialOfferFloatingCard> createState() =>
      _SpecialOfferFloatingCardState();
}

class _SpecialOfferFloatingCardState extends State<SpecialOfferFloatingCard>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pulseController;
  late AnimationController _offerController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isVisible = true;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // MAIN CARD ENTRY ANIMATION
    // ============================================================

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0.18, 0.12),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );

    // ============================================================
    // SMALL FLOATING / PULSE ANIMATION
    // ============================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // ============================================================
    // OFFER TILE ANIMATION
    // ============================================================

    _offerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;

      _entryController.forward();

      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          _offerController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    _offerController.dispose();
    super.dispose();
  }

  // ============================================================
  // CLOSE
  // ============================================================

  Future<void> _closeCard() async {
    if (_isClosing) return;

    _isClosing = true;

    await _entryController.reverse();

    if (!mounted) return;

    widget.onClose?.call();
  }

  // ============================================================
  // RESPONSIVE SIZE
  // ============================================================

  double _getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // MOBILE
    if (screenWidth < 600) {
      return math.min(screenWidth - 32, 285);
    }

    // TABLET
    if (screenWidth < 1000) {
      return math.min(screenWidth - 40, 400);
    }

    // DESKTOP
    if (screenWidth < 1400) {
      return 420;
    }

    // LARGE DESKTOP
    return 450;
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= 600 && width < 1000;
  }

  // ============================================================
  // BUILD
  //
  // IMPORTANT:
  // DO NOT USE Positioned HERE.
  //
  // DashboardScreen already places this widget inside:
  //
  // Stack
  //   -> Positioned
  //       -> SpecialOfferFloatingCard
  //
  // Using another Positioned here causes:
  //
  // Incorrect use of ParentDataWidget
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final cardWidth = _getCardWidth(context);
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.bottomRight,
          child: _buildOfferCard(context, cardWidth, isMobile, isTablet),
        ),
      ),
    );
  }

  // ============================================================
  // MAIN CARD
  // ============================================================

  Widget _buildOfferCard(
    BuildContext context,
    double width,
    bool isMobile,
    bool isTablet,
  ) {
    final radius = isMobile ? 20.0 : 24.0;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        width: width,
        constraints: BoxConstraints(maxWidth: width),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: gPrimaryColor.withValues(alpha: 0.10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 32,
              spreadRadius: 1,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: gPrimaryColor.withValues(alpha: 0.06),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              // ==================================================
              // DECORATIVE BACKGROUND
              // ==================================================
              Positioned(
                right: -55,
                top: -60,
                child: _buildGlowCircle(
                  150,
                  gPrimaryColor.withValues(alpha: 0.055),
                ),
              ),

              Positioned(
                left: -55,
                bottom: -65,
                child: _buildGlowCircle(
                  150,
                  const Color(0xFFFFB36B).withValues(alpha: 0.07),
                ),
              ),

              // ==================================================
              // CONTENT
              // ==================================================
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 16 : 20,
                  isMobile ? 16 : 20,
                  isMobile ? 16 : 20,
                  isMobile ? 16 : 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(isMobile),

                    SizedBox(height: isMobile ? 13 : 16),

                    _buildOffers(isMobile, isTablet),

                    SizedBox(height: isMobile ? 12 : 15),

                    _buildBottomMessage(isMobile),
                  ],
                ),
              ),

              // ==================================================
              // CLOSE BUTTON
              // ==================================================
              Positioned(
                top: isMobile ? 8 : 10,
                right: isMobile ? 8 : 10,
                child: _buildCloseButton(isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 28 : 34),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ======================================================
          // ANIMATED GIFT ICON
          // ======================================================
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final value = _pulseController.value;

              return Transform.translate(
                offset: Offset(0, math.sin(value * math.pi * 2) * 1.5),
                child: child,
              );
            },
            child: Container(
              width: isMobile ? 44 : 50,
              height: isMobile ? 44 : 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gPrimaryColor,
                    gPrimaryColor.withValues(alpha: 0.72),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: gPrimaryColor.withValues(alpha: 0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.card_giftcard_rounded,
                color: Colors.white,
                size: isMobile ? 21 : 24,
              ),
            ),
          ),

          SizedBox(width: isMobile ? 11 : 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "A little something for you",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: isMobile ? 11 : 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 3),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Exclusive ",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: isMobile ? 16 : 19,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: "Rewards",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: isMobile ? 16 : 19,
                          fontWeight: FontWeight.w800,
                          color: gPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OFFERS
  // ============================================================

  Widget _buildOffers(bool isMobile, bool isTablet) {
    final offers = [
      (
        icon: Icons.local_shipping_outlined,
        title: "Free shipping on ₹799+",
        subtitle: "Enjoy free delivery on your order",
      ),
      (
        icon: Icons.sell_outlined,
        title: "Spend ₹2,000+",
        subtitle: "Get a special discount",
      ),
      (
        icon: Icons.card_giftcard_outlined,
        title: "Spend ₹5,000+",
        subtitle: "Get a surprise gift",
      ),
    ];

    if (isMobile) {
      return Column(
        children: List.generate(offers.length, (index) {
          final offer = offers[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == offers.length - 1 ? 0 : 9,
            ),
            child: _buildAnimatedOfferTile(
              index: index,
              icon: offer.icon,
              title: offer.title,
              subtitle: offer.subtitle,
              isMobile: true,
            ),
          );
        }),
      );
    }

    // Desktop / Tablet
    return Column(
      children: List.generate(offers.length, (index) {
        final offer = offers[index];

        return Padding(
          padding: EdgeInsets.only(bottom: index == offers.length - 1 ? 0 : 9),
          child: _buildAnimatedOfferTile(
            index: index,
            icon: offer.icon,
            title: offer.title,
            subtitle: offer.subtitle,
            isMobile: false,
          ),
        );
      }),
    );
  }

  // ============================================================
  // ANIMATED OFFER TILE
  // ============================================================

  Widget _buildAnimatedOfferTile({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isMobile,
  }) {
    return AnimatedBuilder(
      animation: _offerController,
      builder: (context, child) {
        final start = index * 0.18;
        final end = (start + 0.55).clamp(0.0, 1.0);

        final rawValue = ((_offerController.value - start) / (end - start))
            .clamp(0.0, 1.0);

        final value = Curves.easeOutBack.transform(rawValue);

        return Opacity(
          opacity: rawValue,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: Transform.scale(scale: 0.92 + (0.08 * value), child: child),
          ),
        );
      },
      child: _buildOfferTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        isMobile: isMobile,
      ),
    );
  }

  // ============================================================
  // OFFER TILE UI
  // ============================================================

  Widget _buildOfferTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 9,
        vertical: isMobile ? 12 : 9,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBF8), Colors.white],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 15 : 13),
        border: Border.all(color: gPrimaryColor.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          // ======================================================
          // ICON
          // ======================================================
          Container(
            width: isMobile ? 38 : 36,
            height: isMobile ? 38 : 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: gPrimaryColor.withValues(alpha: 0.07)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: gPrimaryColor, size: isMobile ? 18 : 17),
          ),

          const SizedBox(width: 9),

          // ======================================================
          // TEXT
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: isMobile ? 12.5 : 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: isMobile ? 10 : 9.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM MESSAGE
  // ============================================================

  Widget _buildBottomMessage(bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final opacity = 0.65 + (_pulseController.value * 0.35);

        return Opacity(opacity: opacity, child: child);
      },
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: isMobile ? 15 : 17,
            color: gPrimaryColor,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              "More you shop, more you unlock.",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: isMobile ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CLOSE BUTTON
  // ============================================================

  Widget _buildCloseButton(bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _closeCard,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: isMobile ? 30 : 32,
          height: isMobile ? 30 : 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.close_rounded,
            size: isMobile ? 16 : 17,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GLOW
  // ============================================================

  Widget _buildGlowCircle(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
