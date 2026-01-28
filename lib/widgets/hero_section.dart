import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../providers/scroll_provider.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final isTablet = size.width > 600;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          height: isDesktop ? 900 : 1100,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Stack(
            children: [
              // Animated Background Particles
              _buildAnimatedParticles(languageProvider),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    // Top Navigation Space
                    const SizedBox(height: 80),

                    // Main Hero Content
                    Expanded(
                      child: isDesktop
                          ? _buildDesktopLayout(languageProvider, size)
                          : _buildMobileLayout(languageProvider, size),
                    ),

                    // Scroll Indicator
                    _buildScrollIndicator(languageProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedParticles(LanguageProvider languageProvider) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final progress = (_particleController.value + (index * 0.1)) % 1.0;
            return Positioned(
              left: languageProvider.isArabic
                  ? null
                  : 50 + (index * 150) + (progress * 100),
              top: 100 + (index * 80) + (progress * 200),
              right: languageProvider.isArabic
                  ? 50 + (index * 150) + (progress * 100)
                  : null,
              child: Container(
                width: 20 + (index * 5),
                height: 20 + (index * 5),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildDesktopLayout(LanguageProvider languageProvider, Size size) {
    final isLargeDesktop = size.width > 1200;

    return Row(
      children: [
        // Left Content
        Expanded(
          // flex: isLargeDesktop ? 3 : 2,
          child: _buildHeroContent(languageProvider, size),
        ),

        SizedBox(width: isLargeDesktop ? 60 : 40),

        // Right Image
        Expanded(
          // flex: isLargeDesktop ? 2 : 1,
          child: _buildHeroImage(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(LanguageProvider languageProvider, Size size) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeroContent(languageProvider, size),
        const SizedBox(height: 40),
        _buildHeroImage(),
      ],
    );
  }

  Widget _buildHeroContent(LanguageProvider languageProvider, Size size) {
    final isDesktop = size.width > 768;
    final isTablet = size.width > 600;

    return Column(
      crossAxisAlignment: languageProvider.isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main Title with Animation
        AnimatedTextKit(
          key: ValueKey(languageProvider.isArabic),
          animatedTexts: [
            TypewriterAnimatedText(
              languageProvider.getString('hero_title'),
              textStyle: TextStyle(
                fontSize: isDesktop ? 48 : (isTablet ? 36 : 28),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),

        const SizedBox(height: 20),

        // Subtitle
        Text(
          languageProvider.getString('hero_subtitle'),
          style: TextStyle(
            fontSize: isDesktop ? 20 : (isTablet ? 18 : 16),
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
          textAlign:
              languageProvider.isArabic ? TextAlign.right : TextAlign.left,
        ).animate(delay: 1000.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3),

        const SizedBox(height: 30),

        // Description
        Text(
          languageProvider.getString('hero_description'),
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            color: Colors.white.withOpacity(0.8),
            height: 1.6,
          ),
          textAlign:
              languageProvider.isArabic ? TextAlign.right : TextAlign.left,
        ).animate(delay: 1500.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3),

        const SizedBox(height: 40),

        // CTA Button
        SizedBox(
          width: 300,
          child: Semantics(
            button: true,
            enabled: true,
            label: languageProvider.getString('hero_cta'),
            child: ElevatedButton(
              onPressed: () {
                final scrollProvider =
                    Provider.of<ScrollProvider>(context, listen: false);
                // Add delay to ensure the scroll provider is ready
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (scrollProvider.isControllerReady) {
                    scrollProvider.scrollToServices();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGold,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 20 : 10,
                  vertical: isDesktop ? 20 : 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
                shadowColor: AppColors.accentGold.withOpacity(0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageProvider.getString('hero_cta'),
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          )
              .animate(delay: 2000.ms)
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingController.value * 14),
          child: Container(
            height: 500,
            margin: const EdgeInsets.only(left: 40),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white38),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentGold.withOpacity(0.8),
                    AppColors.primaryBlue.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                  ),
                ],
                image: const DecorationImage(
                    image: AssetImage('assets/images/aboutus.jpg'),
                    fit: BoxFit.cover)),
          ),
        );
      },
    );
  }

  Widget _buildScrollIndicator(LanguageProvider languageProvider) {
    return InkWell(
      onTap: () {
        final scrollProvider =
            Provider.of<ScrollProvider>(context, listen: false);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollProvider.isControllerReady) {
            scrollProvider.scrollToAbout();
          }
        });
      },
      child: Column(
        children: [
          Text(
            languageProvider.getString('scroll_down'),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingController.value * 5),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 30,
                ),
              );
            },
          ),
        ],
      ).animate(delay: 2500.ms).fadeIn(duration: 800.ms),
    );
  }
}
