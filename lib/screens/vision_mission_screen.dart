import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class VisionMissionScreen extends StatefulWidget {
  const VisionMissionScreen({super.key});

  @override
  State<VisionMissionScreen> createState() => _VisionMissionScreenState();
}

class _VisionMissionScreenState extends State<VisionMissionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                _buildHeader(languageProvider, context),

                // Vision & Mission Content
                _buildVisionMissionContent(languageProvider, context),

                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(LanguageProvider languageProvider, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 100,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          Text(
            languageProvider.getString('vision_title'),
            style: TextStyle(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate(delay: 300.ms).scaleX(begin: 0, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildVisionMissionContent(
      LanguageProvider languageProvider, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      child: Column(
        children: [
          // Vision Card
          _buildSectionCard(
            languageProvider.getString('vision_heading'),
            languageProvider.getString('vision_content'),
            Icons.visibility,
            AppColors.primaryBlue,
            0,
            isDesktop,
          ),
          const SizedBox(height: 30),

          // Mission Card
          _buildSectionCard(
            languageProvider.getString('mission_heading'),
            languageProvider.getString('mission_content'),
            Icons.flag,
            AppColors.accentGold,
            200,
            isDesktop,
          ),
          const SizedBox(height: 30),

          // Values Card
          _buildSectionCard(
            languageProvider.getString('values_heading'),
            languageProvider.getString('values_content'),
            Icons.star,
            AppColors.constructionColor,
            400,
            isDesktop,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon,
      Color color, int delay, bool isDesktop) {
    return VisibilityDetector(
      key: Key('vision-mission-card-$title'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 40 : 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Icon(icon, color: color, size: 35),
            ),
            const SizedBox(width: 25),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGray,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: delay))
          .fadeIn(duration: 800.ms)
          .slideY(begin: 0.3),
    );
  }
}
