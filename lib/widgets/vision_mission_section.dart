import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class VisionMissionSection extends StatefulWidget {
  const VisionMissionSection({super.key});

  @override
  State<VisionMissionSection> createState() => _VisionMissionSectionState();
}

class _VisionMissionSectionState extends State<VisionMissionSection>
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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return VisibilityDetector(
          key: const Key('vision-mission-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 20,
              vertical: 100,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/vision.png'),fit: BoxFit.cover),
              gradient: AppColors.lightGradient,
            ),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(languageProvider, isDesktop),

                const SizedBox(height: 60),

                // Content Cards
                if (isDesktop)
                  _buildDesktopContent(languageProvider)
                else
                  _buildMobileContent(languageProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(LanguageProvider languageProvider, bool isDesktop) {
    return Column(
      children: [
        Text(
          languageProvider.getString('vision_title'),
          style: TextStyle(
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            borderRadius: BorderRadius.circular(2),
          ),
        ).animate(delay: 300.ms).scaleX(begin: 0, duration: 600.ms),
      ],
    );
  }

  Widget _buildDesktopContent(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 10,
                child: _buildContentCard(
                  languageProvider.getString('vision_heading'),
                  languageProvider.getString('vision_content'),
                  Icons.visibility,
                  AppColors.primaryBlue,
                  0,
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 10,
                child: _buildContentCard(
                  languageProvider.getString('mission_heading'),
                  languageProvider.getString('mission_content'),
                  Icons.flag,
                  AppColors.accentGold,
                  200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildContentCard(
          languageProvider.getString('values_heading'),
          languageProvider.getString('values_content'),
          Icons.star,
          AppColors.constructionColor,
          400,
        ),
      ],
    );
  }

  Widget _buildMobileContent(LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildContentCard(
          languageProvider.getString('vision_heading'),
          languageProvider.getString('vision_content'),
          Icons.visibility,
          AppColors.primaryBlue,
          0,
        ),
        const SizedBox(height: 30),
        _buildContentCard(
          languageProvider.getString('mission_heading'),
          languageProvider.getString('mission_content'),
          Icons.flag,
          AppColors.accentGold,
          200,
        ),
        const SizedBox(height: 30),
        _buildContentCard(
          languageProvider.getString('values_heading'),
          languageProvider.getString('values_content'),
          Icons.star,
          AppColors.constructionColor,
          400,
        ),
      ],
    );
  }

  Widget _buildContentCard(
      String title, String content, IconData icon, Color color, int delay) {
    return Container(
      padding: const EdgeInsets.all(30),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 15),
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darkGray,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3);
  }
}
