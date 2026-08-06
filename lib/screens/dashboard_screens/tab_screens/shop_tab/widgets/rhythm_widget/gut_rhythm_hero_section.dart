// gut_rhythm_hero_section.dart
//
// Responsive "Your gut follows a rhythm" hero section for Flutter Web.
//
// SETUP
// -----
// 1. Add to pubspec.yaml:
//
//    dependencies:
//      flutter:
//        sdk: flutter
//      google_fonts: ^6.2.1
//
// 2. Drop a product image at: assets/images/flavours.jpg
//    and register it in pubspec.yaml:
//
//    flutter:
//      assets:
//        - assets/images/flavours.jpg
//
// 3. Use it anywhere:
//
//    import 'gut_rhythm_hero_section.dart';
//    ...
//    GutRhythmHeroSection()
//
// BREAKPOINTS
// -----------
// >= 1100 : desktop  -> text and card side by side
// >= 700  : tablet   -> text and card side by side, tighter spacing
// <  700  : mobile   -> stacked, centered text, full-width card

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GutRhythmHeroSection extends StatefulWidget {
  const GutRhythmHeroSection({
    super.key,
    this.categories = const [
      FeaturedCategory(
        eyebrow: 'Featured Product Category Wise',
        title: 'FLAVOURS',
        subtitle: 'ADD TO ENHANCE YOUR MEALS',
        ctaLabel: 'Explore Khichdi Category',
        ctaSubtitle: 'Warm, fibre-rich and ready in five.',
        imageProvider: AssetImage('assets/images/flavours.jpg'),
      ),
    ],
  });

  final List<FeaturedCategory> categories;

  @override
  State<GutRhythmHeroSection> createState() => _GutRhythmHeroSectionState();
}

class _GutRhythmHeroSectionState extends State<GutRhythmHeroSection> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int delta) {
    final count = widget.categories.length;
    if (count <= 1) return;
    final next = (_currentIndex + delta).clamp(0, count - 1);
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;
        final horizontalPadding = isMobile ? 20.0 : (isTablet ? 40.0 : 80.0);
        final verticalPadding = isMobile ? 32.0 : 56.0;

        final textColumn = _TextColumn(isMobile: isMobile);
        final cardColumn = _FeaturedCard(
          categories: widget.categories,
          pageController: _pageController,
          currentIndex: _currentIndex,
          onIndexChanged: (i) => setState(() => _currentIndex = i),
          onPrev: () => _goTo(-1),
          onNext: () => _goTo(1),
          isMobile: isMobile,
        );

        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textColumn,
                    const SizedBox(height: 32),
                    cardColumn,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: isTablet ? 5 : 6, child: textColumn),
                    SizedBox(width: isTablet ? 24 : 48),
                    Expanded(flex: isTablet ? 5 : 5, child: cardColumn),
                  ],
                ),
        );
      },
    );
  }
}

/// Left-hand headline / copy block.
class _TextColumn extends StatelessWidget {
  const _TextColumn({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final headlineSize = isMobile ? 34.0 : 48.0;
    final scriptSize = isMobile ? 26.0 : 34.0;
    final bodySize = isMobile ? 14.0 : 15.0;

    final headline = RichText(
      textAlign: isMobile ? TextAlign.center : TextAlign.left,
      text: TextSpan(
        style: GoogleFonts.archivoBlack(
          fontSize: headlineSize,
          height: 1.05,
          color: const Color(0xFF171717),
        ),
        children: const [
          TextSpan(text: 'Your gut follows\na '),
          TextSpan(
            text: 'rhythm.',
            style: TextStyle(color: Color(0xFFB3261E)),
          ),
        ],
      ),
    );

    final script = Text(
      'Your food should too.',
      textAlign: isMobile ? TextAlign.center : TextAlign.left,
      style: GoogleFonts.caveat(
        fontSize: scriptSize,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFB98900),
      ),
    );

    final body = Text(
      'Food-only products designed for the unique intervals your gut '
      'needs care — from morning active nourishment to a warm, '
      'comforting bowl at night.',
      textAlign: isMobile ? TextAlign.center : TextAlign.left,
      style: GoogleFonts.dmSans(
        fontSize: bodySize,
        height: 1.6,
        color: const Color(0xFF6B6B6B),
      ),
    );

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        headline,
        const SizedBox(height: 6),
        script,
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 480 : 420),
          child: body,
        ),
      ],
    );
  }
}

/// Right-hand featured-category carousel card with side nav arrows.
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.categories,
    required this.pageController,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onPrev,
    required this.onNext,
    required this.isMobile,
  });

  final List<FeaturedCategory> categories;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final cardHeight = isMobile ? 220.0 : 260.0;
    final canGoPrev = currentIndex > 0;
    final canGoNext = currentIndex < categories.length - 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavArrow(
          icon: Icons.arrow_back,
          enabled: canGoPrev,
          onTap: canGoPrev ? onPrev : null,
        ),
        SizedBox(width: isMobile ? 10 : 16),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: SizedBox(
              height: cardHeight,
              child: PageView.builder(
                controller: pageController,
                itemCount: categories.length,
                onPageChanged: onIndexChanged,
                itemBuilder: (context, index) {
                  return _CategoryCard(category: categories[index]);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: isMobile ? 10 : 16),
        _NavArrow(
          icon: Icons.arrow_forward,
          enabled: canGoNext,
          onTap: canGoNext ? onNext : null,
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final FeaturedCategory category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image(image: category.imageProvider, fit: BoxFit.cover),
          // Dark gradient for text legibility
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.black54],
              ),
            ),
          ),
          // Top eyebrow + title + subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.eyebrow,
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFFE05A4E),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  category.title,
                  style: GoogleFonts.archivoBlack(
                    color: Colors.white,
                    fontSize: 26,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.subtitle,
                  style: GoogleFonts.dmSans(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Bottom CTA bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              color: const Color(0xFF14213D).withOpacity(0.92),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.ctaLabel,
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category.ctaSubtitle,
                          style: GoogleFonts.dmSans(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, required this.enabled, this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled ? const Color(0xFFB3261E) : Colors.black12,
              width: 1.2,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: enabled ? const Color(0xFFB3261E) : Colors.black26,
          ),
        ),
      ),
    );
  }
}

/// Data model for a single featured-category card in the carousel.
class FeaturedCategory {
  const FeaturedCategory({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.ctaSubtitle,
    required this.imageProvider,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String ctaSubtitle;
  final ImageProvider imageProvider;
}
