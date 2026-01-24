import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../screens/service_detail_screen.dart';

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
      if (info.visibleFraction > 0.3 && !_isVisible) {
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
    final isTap = size.width < 1200 &&size.width>700;
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
                _buildServicesGrid(languageProvider, isDesktop , isTap),
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
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.3),
        
        const SizedBox(height: 10),
        
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            borderRadius: BorderRadius.circular(2),
          ),
        )
            .animate(delay: 300.ms)
            .scaleX(begin: 0, duration: 600.ms),
        
        const SizedBox(height: 20),
        
        Text(
          languageProvider.getString('services_subtitle'),
          style: TextStyle(
            fontSize: isDesktop ? 20 : 16,
            color: AppColors.accentGold,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: 500.ms)
            .fadeIn(duration: 800.ms),
        
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
        )
            .animate(delay: 700.ms)
            .fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildServicesGrid(LanguageProvider languageProvider, bool isDesktop , bool isTap) {
    final services = [
      {
        'title': languageProvider.getString('service_architectural_title'),
        'description': languageProvider.getString('service_architectural_desc'),
        'image': 'assets/images/arch.jpg',
        'icon': Icons.architecture,
        'color': AppColors.architecturalColor,
      },
      {
        'title': languageProvider.getString('service_construction_title'),
        'description': languageProvider.getString('service_construction_desc'),
        'image': 'assets/images/const.jpg',
        'icon': Icons.construction,
        'color': AppColors.constructionColor,
      },
      {
        'title': languageProvider.getString('service_consulting_title'),
        'description': languageProvider.getString('service_consulting_desc'),
        'image': 'assets/images/cosult.jpeg',
        'icon': Icons.engineering,
        'color': AppColors.consultingColor,
      },
      {
        'title': languageProvider.getString('service_approval_title'),
        'description': languageProvider.getString('service_approval_desc'),
        'image': 'assets/images/approval.jpg',
        'icon': Icons.approval,
        'color': AppColors.approvalColor,
      },
    ];
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth >= 1400) {
      crossAxisCount = 4;
      childAspectRatio = screenWidth*0.0005;
    } else if (screenWidth >= 950) {
      crossAxisCount = 3;
      childAspectRatio = screenWidth*0.00071;
    }  else if (screenWidth >= 750) {
      crossAxisCount = 2;
      childAspectRatio = screenWidth*0.0012;
    }else {
      crossAxisCount = 2;
      childAspectRatio = screenWidth*0.00085;
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
        return _buildServiceCard(
          service['title'].toString(),
          service['description'].toString(),
          service['image'].toString(),
          service['icon'] as IconData,
          service['color'] as Color,
          index,
          languageProvider
        );
      },
    );
  }

  Widget _buildServiceCard(
    String title,
    String description,
    String image,
    IconData icon,
    Color color,
    int index,
      LanguageProvider languageProvider
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final start = (index * 0.1).clamp(0.0, 1.0);
        final end = ((index * 0.1) + 0.6).clamp(0.0, 1.0);

        final opacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              start,
              end,
              curve: Curves.easeOut,
            ),
          ),
        );
        return AnimatedOpacity(
          opacity: opacity.value,
          duration: const Duration(milliseconds: 600),
          child: Container(
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
              children: [

                // المحتوى العلوي
                TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 2000 + (index * 200)),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -10 * (1 - value)),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: color, size: 35),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                    height: 1.5,
                  ),
                ),

                /// هذا هو المفتاح
                const Spacer(),

                // الزر دائماً بأسفل الكارد
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(
                          service: {
                            'title': title,
                            'description': description,
                            'type': title,
                            'icon': icon,
                            'color': color,
                            'image': image,
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          languageProvider.getString('Learn More'),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.arrow_forward, color: color, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      },
    );
  }
}
