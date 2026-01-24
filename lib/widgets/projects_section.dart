import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gulfsky_complete_website/widgets/reload_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  bool _isVisible = false;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
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
    final isDesktop = size.width > 1200;
    final isTab = size.width > 500 && size.width < 850;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return VisibilityDetector(
          key: const Key('projects-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 20,
              vertical: 100,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.darkGradient,
            ),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(languageProvider, isDesktop),
                
                const SizedBox(height: 60),
                
                // Projects Grid
                _buildProjectsGrid(languageProvider, isDesktop , isTab),
                
                const SizedBox(height: 50),
                
                // View All Projects Button
                _buildViewAllButton(languageProvider),
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
          languageProvider.getString('projects_title'),
          style: TextStyle(
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
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
          languageProvider.getString('projects_subtitle'),
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
            languageProvider.getString('projects_description'),
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppColors.darkGray,
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

  Widget _buildProjectsGrid(LanguageProvider languageProvider, bool isDesktop , bool isTab) {
    const url = 'https://cdn.jsdelivr.net/gh/naifizo/gulfsky-images/projects';
    final projects = [
      {
        'title': 'G + 6P + 33TYP + H.C',
        'location': 'Al Khan - Sharjah',
        'type': 'Residential',
        'area': '50,000 sqm',
        'year': '2023',
        'color': AppColors.architecturalColor,
        'image' : '$url/Tower/GS19.jpg'
      },
      {
        'title': ' G + 5P + H.C + 25TYP + 1Tec + H.P',
        'location': 'Al Khan - Sharjah',
        'type': 'Commercial',
        'area': '25,000 sqm',
        'year': '2022',
        'color': AppColors.constructionColor,
        'image' : '$url/Tower/GS105.jpg'
      },
      {
        'title': 'G + 3P + H.C + SERV. + 15TYP',
        'location': 'Al Khan - Sharjah',
        'type': 'Hotel',
        'area': '75,000 sqm',
        'year': '2024',
        'color': AppColors.consultingColor,
        'image' : '$url/Hotels/GS48.jpg'
      },
      {
        'title': '8 VILLAS G + 1 FLOOR',
        'location': 'Al Maqtaa - Umm Al Quwain',
        'type': 'Villa',
        'area': '30,000 sqm',
        'year': '2023',
        'color': AppColors.approvalColor,
        'image' : '$url/Villas/GS2221.jpg'
      },
      {
        'title': 'G ONLY',
        'location': 'Al Homa - Sharjah',
        'type': 'EDUCATION',
        'area': '40,000 sqm',
        'year': '2022',
        'color': AppColors.primaryBlue,
        'image' : '$url/Education/GS100.jpg'
      },
      {
        'title': 'G + 3P + SERV. + REST. + H.C + 15TYP + S.P',
        'location': 'Al Nahda - Sharjah',
        'type': 'INTERIOR DESIGN',
        'area': '35,000 sqm',
        'year': '2024',
        'color': AppColors.accentGold,
        'image' : '$url/Interior/Flat%2007%20a.jpg'
      },
    ];
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth >= 1300) {
      crossAxisCount = 4;
      childAspectRatio = 0.7;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
      childAspectRatio = 0.55;
    }  else if (screenWidth >= 600) {
      crossAxisCount = 2;
      childAspectRatio = 0.7;
    }else {
      crossAxisCount = 2;
      childAspectRatio = 0.38;
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
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index] as Map<String, dynamic>;
        return _buildProjectCard(project, index, screenWidth >= 1200);
      },
    );
  }

  Widget _buildProjectCard(
      Map<String, dynamic> project,
      int index,
      bool isDesktop,
      ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final cardAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.08,
              (index * 0.08) + 0.6,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        final bool isHovered = _hoveredIndex == index;

        return Transform.scale(
          scale: cardAnimation.value,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            child: GestureDetector(
              onTap: () {
                _showProjectImageDialog(context, project);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..scale(isHovered ? 1.03 : 1.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isHovered ? 0.18 : 0.08),
                      blurRadius: isHovered ? 35 : 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// ================= IMAGE SECTION =================
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// الصورة الرئيسية – قص ذكي بدون تشويه
                            Image.network(
                              project['image'],
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
              
                            /// تدرج خفيف لإخفاء أي قص قاسي
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              
                    /// ================= DETAILS SECTION =================
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TITLE
                            Text(
                              project['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBlue,
                              ),
                            ),
              
                            const SizedBox(height: 6),
              
                            /// LOCATION
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: AppColors.mediumGray,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    project['location'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.mediumGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
              
                            const Spacer(),
              
                            /// TYPE BADGE – Elegant / Minimal
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: project['color'].withOpacity(0.45),
                                ),
                              ),
                              child: Text(
                                project['type'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: project['color'],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProjectImageDialog(
      BuildContext context,
      Map<String, dynamic> project,
      ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              /// IMAGE CONTAINER
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    project['image'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              /// CLOSE BUTTON
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  IconData _getProjectIcon(String type) {
    switch (type) {
      case 'Residential':
        return Icons.home;
      case 'Commercial':
        return Icons.business;
      case 'Mixed Use':
        return Icons.apartment;
      case 'Hospitality':
        return Icons.hotel;
      default:
        return Icons.architecture;
    }
  }

  Widget _buildViewAllButton(LanguageProvider languageProvider) {
    return ElevatedButton(
      onPressed: () {
Navigator.of(context).pushNamed('/projects');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 10,
        shadowColor: AppColors.accentGold.withOpacity(0.3),
      ),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            languageProvider.getString('view_projects'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    )
        .animate(delay: 1000.ms)
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
