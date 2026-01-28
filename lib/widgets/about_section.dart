import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
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
          key: const Key('about-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 20,
              vertical: 100,
            ),
            decoration:  const BoxDecoration(
              gradient: AppColors.lightGradient,
              image: DecorationImage(image: AssetImage('assets/images/aboutus.jpg') , fit: BoxFit.cover)
            ),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(languageProvider, isDesktop),
                
                const SizedBox(height: 60),
                
                // Content
                if (isDesktop)
                  _buildDesktopContent(languageProvider)
                else
                  _buildMobileContent(languageProvider),
                
                const SizedBox(height: 60),
                
                // Statistics
                _buildStatistics(languageProvider, isDesktop),
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
          languageProvider.getString('about_title'),
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
          languageProvider.getString('about_subtitle'),
          style: TextStyle(
            fontSize: isDesktop ? 20 : 16,
            color: AppColors.accentGold,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: 500.ms)
            .fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildDesktopContent(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildVisualElement(),
        const SizedBox(height: 20),
        // Left Content
        Row(
          crossAxisAlignment: languageProvider.isArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: _buildContentCard(
                languageProvider.getString('about_description'),
                Icons.business,
                AppColors.primaryBlue,
                0,
              ),
            ),
            const Expanded(   flex: 1,child: SizedBox(height: 30)),
            Expanded(   flex: 10,
              child: _buildContentCard(
                languageProvider.getString('about_values'),
                Icons.family_restroom,
                AppColors.accentGold,
                200,
              ),
            ),
          ],
        ),
        

        
        // Right Image/Visual

      ],
    );
  }

  Widget _buildMobileContent(LanguageProvider languageProvider) {
    return Column(
      children: [
        // _buildVisualElement(),
        const SizedBox(height: 20),
        _buildContentCard(
          languageProvider.getString('about_description'),
          Icons.business,
          AppColors.primaryBlue,
          0,
        ),
        const SizedBox(height: 30),
        _buildContentCard(
          languageProvider.getString('about_values'),
          Icons.family_restroom,
          AppColors.accentGold,
          200,
        ),
      ],
    );
  }

  Widget _buildContentCard(String text, IconData icon, Color color, int delay) {
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
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkGray,
              height: 1.6,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3);
  }


  Widget _buildStatistics(LanguageProvider languageProvider, bool isDesktop) {
    final stats = [
      {'number': 17, 'suffix': '+', 'label': languageProvider.getString('years_experience')},
      {'number': 500, 'suffix': '+', 'label': languageProvider.getString('projects_completed')},
      {'number': 50, 'suffix': '+', 'label': languageProvider.getString('expert_team')},
      {'number': 100, 'suffix': '%', 'label': languageProvider.getString('client_satisfaction')},
    ];

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          double aspectRatio;
          double spacing;

          if (constraints.maxWidth >= 1200) {
            // Desktop
            crossAxisCount = 4;
            aspectRatio = 3.5;
            spacing = 10;
          } else if (constraints.maxWidth >= 600) {
            // Tablet
            crossAxisCount = 4;
            aspectRatio = 1.4;
            spacing = 10;
          } else {
            // Mobile
            crossAxisCount = 2;
            aspectRatio = 1.4;
            spacing = 10;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return _StatisticItem(
                targetValue: stat['number']  as int,
                suffix: stat['suffix'] as String,
                label: stat['label'] as String,
                delay: Duration(milliseconds: 600 + (index * 150)),
              );
            },
          );
        },
      ),
    )
        .animate(delay: 800.ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3);
  }
}

class _StatisticItem extends StatefulWidget {
  final int targetValue;
  final String suffix;
  final String label;
  final Duration delay;

  const _StatisticItem({
    required this.targetValue,
    required this.suffix,
    required this.label,
    required this.delay,
  });

  @override
  State<_StatisticItem> createState() => _StatisticItemState();
}

class _StatisticItemState extends State<_StatisticItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentValue = 0;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _animation.addListener(() {
      setState(() {
        _currentValue = _animation.value.round();
      });
    });
  }

  void _startAnimation() {
    if (!_hasStarted && mounted) {
      _hasStarted = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.label),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) {
          // يبدأ العد عندما يظهر نصف الودجت على الشاشة
          _startAnimation();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_currentValue${widget.suffix}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.accentGold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
            .animate(delay: widget.delay)
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.5, 0.5)),
      ),
    );
  }
}

