import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class PurchaseOfferAnnouncementBar extends StatefulWidget {
  const PurchaseOfferAnnouncementBar({super.key});

  @override
  State<PurchaseOfferAnnouncementBar> createState() =>
      _PurchaseOfferAnnouncementBarState();
}

class _PurchaseOfferAnnouncementBarState
    extends State<PurchaseOfferAnnouncementBar>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1000;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 28,
        vertical: isMobile ? 7 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF1),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE7D9B5).withValues(alpha: .45),
          ),
          bottom: BorderSide(
            color: const Color(0xFFE7D9B5).withValues(alpha: .65),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMobile) ...[
            _buildHeading(isTablet),
            const SizedBox(height: 7),
          ],

          if (isMobile)
            _buildMobileOffers()
          else
            _buildDesktopOffers(isTablet),
        ],
      ),
    );
  }

  // ============================================================
  // HEADING
  // ============================================================

  Widget _buildHeading(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _smallLine(),
        const SizedBox(width: 10),

        Icon(
          Icons.auto_awesome_rounded,
          size: isTablet ? 12 : 14,
          color: gPrimaryColor,
        ),

        const SizedBox(width: 5),

        Text(
          'SPECIAL SHOPPING BENEFITS',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: isTablet ? 9 : 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
            color: const Color(0xFF333333),
          ),
        ),

        const SizedBox(width: 5),

        Icon(
          Icons.auto_awesome_rounded,
          size: isTablet ? 12 : 14,
          color: gPrimaryColor,
        ),

        const SizedBox(width: 10),
        _smallLine(),
      ],
    );
  }

  Widget _smallLine() {
    return Container(
      width: 38,
      height: 1,
      color: gPrimaryColor.withValues(alpha: .25),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopOffers(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _offerCard(
          icon: Icons.local_offer_rounded,
          amount: '₹2,000+',
          description: 'Get a special discount',
          isTablet: isTablet,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            width: 1,
            height: 32,
            color: const Color(0xFFD8CBAA),
          ),
        ),

        _offerCard(
          icon: Icons.card_giftcard_rounded,
          amount: '₹5,000+',
          description: 'Get a surprise gift',
          isGift: true,
          isTablet: isTablet,
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileOffers() {
    return Row(
      children: [
        Expanded(
          child: _mobileOffer(
            icon: Icons.local_offer_rounded,
            amount: '₹2,000+',
            text: 'Special discount',
          ),
        ),

        Container(
          height: 30,
          width: 1,
          color: const Color(0xFFD8CBAA),
        ),

        Expanded(
          child: _mobileOffer(
            icon: Icons.card_giftcard_rounded,
            amount: '₹5,000+',
            text: 'Surprise gift',
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DESKTOP OFFER CARD
  // ============================================================

  Widget _offerCard({
    required IconData icon,
    required String amount,
    required String description,
    required bool isTablet,
    bool isGift = false,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final offset = (_floatController.value * 2) - 1;

        return Transform.translate(
          offset: Offset(0, offset * 1.2),
          child: child,
        );
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: isTablet ? 210 : 250,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE9DEC4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .045),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _animatedIcon(icon),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: isTablet ? 12 : 13,
                    fontWeight: FontWeight.w800,
                    color: gPrimaryColor,
                  ),
                ),

                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: isTablet ? 9 : 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),

            if (isGift) ...[
              const SizedBox(width: 8),
              _sparkle(),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE OFFER
  // ============================================================

  Widget _mobileOffer({
    required IconData icon,
    required String amount,
    required String text,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            ((_floatController.value * 2) - 1) * .8,
          ),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _animatedIcon(icon, size: 26),

          const SizedBox(width: 7),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: gPrimaryColor,
                  ),
                ),
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
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
  // ICON
  // ============================================================

  Widget _animatedIcon(
      IconData icon, {
        double size = 32,
      }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.rotate(
          angle: (_floatController.value - .5) * .08,
          child: child,
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gPrimaryColor.withValues(alpha: .08),
          border: Border.all(
            color: gPrimaryColor.withValues(alpha: .16),
          ),
        ),
        child: Icon(
          icon,
          size: size * .48,
          color: gPrimaryColor,
        ),
      ),
    );
  }

  // ============================================================
  // SPARKLE
  // ============================================================

  Widget _sparkle() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.85 + (_shimmerController.value * .2),
          child: Opacity(
            opacity: .45 + (_shimmerController.value * .55),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.auto_awesome,
        size: 14,
        color: Color(0xFFD59A20),
      ),
    );
  }
}