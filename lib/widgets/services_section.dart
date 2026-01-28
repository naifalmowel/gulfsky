import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/language_provider.dart';
import 'interactive_service_card.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (info.visibleFraction > AppConstants.visibilityThreshold &&
          !_isVisible) {
        setState(() {
          _isVisible = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTap = size.width < 1200 && size.width > 700;
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return VisibilityDetector(
          key: const Key('services-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 20,
              vertical: 100,
            ),
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(languageProvider, isDesktop),

                const SizedBox(height: 60),

                // Services Grid
                _buildServicesGrid(languageProvider, isDesktop, isTap),
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
          languageProvider.getString('services_title'),
          style: TextStyle(
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        const SizedBox(height: 20),
        Text(
          languageProvider.getString('services_subtitle'),
          style: TextStyle(
            fontSize: isDesktop ? 20 : 16,
            color: AppColors.accentGold,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 500.ms).fadeIn(duration: 800.ms),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 0),
          child: Text(
            languageProvider.getString('services_description'),
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ).animate(delay: 700.ms).fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildServicesGrid(
      LanguageProvider languageProvider, bool isDesktop, bool isTap) {
    final services = [
      {
        'title': languageProvider.getString('service_architectural_title'),
        'description': languageProvider.getString('service_architectural_desc'),
        'image': 'assets/images/arch.jpg',
        'icon': Icons.architecture,
        'color': AppColors.architecturalColor,
        'type': 'Architectural Design',
      },
      {
        'title': languageProvider.getString('service_construction_title'),
        'description': languageProvider.getString('service_construction_desc'),
        'image': 'assets/images/const.jpg',
        'icon': Icons.construction,
        'color': AppColors.constructionColor,
        'type': 'Construction Management',
      },
      {
        'title': languageProvider.getString('service_consulting_title'),
        'description': languageProvider.getString('service_consulting_desc'),
        'image': 'assets/images/cosult.jpeg',
        'icon': Icons.engineering,
        'color': AppColors.consultingColor,
        'type': 'Engineering Consultants',
      },
      {
        'title': languageProvider.getString('service_approval_title'),
        'description': languageProvider.getString('service_approval_desc'),
        'image': 'assets/images/approval.jpg',
        'icon': Icons.approval,
        'color': AppColors.approvalColor,
        'type': 'Approvals & Permits',
      },
    ];
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth >= AppConstants.largeDesktopBreakpoint) {
      crossAxisCount = 4;
      childAspectRatio = screenWidth * AppConstants.largeDesktopAspectRatio;
    } else if (screenWidth >= 950) {
      crossAxisCount = 3;
      childAspectRatio = screenWidth * AppConstants.desktopAspectRatio;
    } else if (screenWidth >= 750) {
      crossAxisCount = 2;
      childAspectRatio = screenWidth * AppConstants.tabletAspectRatio;
    } else {
      crossAxisCount = 2;
      childAspectRatio = screenWidth * AppConstants.mobileAspectRatio;
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return InteractiveServiceCard(
          service: service,
          languageProvider: languageProvider,
          index: index,
          onTap: () {
            Navigator.of(context).pushNamed(
              '/service-detail',
              arguments: service,
            );
          },
        );
      },
    );
  }
}
