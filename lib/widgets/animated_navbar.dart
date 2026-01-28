import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/language_provider.dart';
import '../providers/scroll_provider.dart';

class AnimatedNavbar extends StatelessWidget {
  const AnimatedNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Consumer2<LanguageProvider, ScrollProvider>(
        builder: (context, languageProvider, scrollProvider, child) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryBlue.withOpacity(0.95),
                  AppColors.primaryBlue.withOpacity(0.85),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Logo and Company Name
                    _buildLogo(),

                    const Spacer(),

                    // Navigation Items (Desktop)
                    if (MediaQuery.of(context).size.width > 768) ...[
                      _buildNavItem(
                        languageProvider.getString('nav_home'),
                        () => _scrollToSection(context, 0),
                        isActive: scrollProvider.isInitialized &&
                            scrollProvider.currentSectionIndex == 0,
                      ),
                      _buildNavItem(
                        languageProvider.getString('nav_about'),
                        () => _scrollToSection(context, 1),
                        isActive: scrollProvider.isInitialized &&
                            scrollProvider.currentSectionIndex == 1,
                      ),
                      _buildNavItem(
                        languageProvider.getString('nav_services'),
                        () => _scrollToSection(context, 2),
                        isActive: scrollProvider.isInitialized &&
                            scrollProvider.currentSectionIndex == 2,
                      ),
                      _buildNavItem(
                        languageProvider.getString('nav_projects'),
                        () => _scrollToSection(context, 3),
                        isActive: scrollProvider.isInitialized &&
                            scrollProvider.currentSectionIndex == 3,
                      ),
                      _buildNavItem(
                        languageProvider.getString('nav_contact'),
                        () => _scrollToSection(context, 4),
                        isActive: scrollProvider.isInitialized &&
                            scrollProvider.currentSectionIndex == 4,
                      ),
                      const SizedBox(width: 20),
                    ],
                    const Spacer(),
                    // Language Toggle
                    _buildLanguageToggle(languageProvider),

                    // Mobile Menu Button
                    if (MediaQuery.of(context).size.width <= 768)
                      _buildMobileMenuButton(
                          context, languageProvider, scrollProvider),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: -1.0);
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: AppColors.accentGold,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          image: const DecorationImage(
              image: AssetImage('assets/images/LOGO.jpg'))),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap,
      {bool isActive = false}) {
    return _AnimatedNavItem(
      title: title,
      onTap: onTap,
      isActive: isActive,
    );
  }

  Widget _buildLanguageToggle(LanguageProvider languageProvider) {
    return InkWell(
      onTap: languageProvider.toggleLanguage,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accentGold),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          languageProvider.getString('nav_language'),
          style: const TextStyle(
            color: AppColors.accentGold,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context,
      LanguageProvider languageProvider, ScrollProvider scrollProvider) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.menu, color: Colors.white),
      color: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: _buildMobileMenuItem(
              languageProvider.getString('nav_home'), Icons.home),
        ),
        PopupMenuItem(
          value: 1,
          child: _buildMobileMenuItem(
              languageProvider.getString('nav_about'), Icons.info),
        ),
        PopupMenuItem(
          value: 2,
          child: _buildMobileMenuItem(
              languageProvider.getString('nav_services'), Icons.build),
        ),
        PopupMenuItem(
          value: 3,
          child: _buildMobileMenuItem(
              languageProvider.getString('nav_projects'), Icons.work),
        ),
        PopupMenuItem(
          value: 4,
          child: _buildMobileMenuItem(
              languageProvider.getString('nav_contact'), Icons.contact_mail),
        ),
      ],
      onSelected: (value) {
        _scrollToSection(context, value);
      },
    );
  }

  Widget _buildMobileMenuItem(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentGold, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _scrollToSection(BuildContext context, int sectionIndex) {
    final scrollProvider = Provider.of<ScrollProvider>(context, listen: false);

    if (ModalRoute.of(context)?.settings.name == '/') {
      if (scrollProvider.isControllerReady) {
        scrollProvider.scrollToSection(sectionIndex);
      } else {
        Future.delayed(
            Duration(milliseconds: AppConstants.routeNavigationDelay), () {
          if (scrollProvider.isControllerReady) {
            scrollProvider.scrollToSection(sectionIndex);
          }
        });
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/').then((_) {
        Future.delayed(
            Duration(milliseconds: AppConstants.routeNavigationDelay), () {
          if (scrollProvider.isControllerReady) {
            scrollProvider.scrollToSection(sectionIndex);
          }
        });
      });
    }
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _AnimatedNavItem({
    required this.title,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          child: AnimatedContainer(
            duration:
                Duration(milliseconds: AppConstants.shortAnimationDuration),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.accentGold.withOpacity(0.2)
                  : (_isHovered
                      ? AppColors.white.withOpacity(0.1)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              border: widget.isActive
                  ? Border.all(color: AppColors.accentGold.withOpacity(0.5))
                  : null,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentGold.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                color: widget.isActive
                    ? AppColors.accentGold
                    : (_isHovered ? AppColors.accentGold : Colors.white),
                fontSize: AppConstants.bodyFontSize,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
