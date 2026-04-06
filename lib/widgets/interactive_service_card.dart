import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/language_provider.dart';

class InteractiveServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;
  final LanguageProvider languageProvider;
  final VoidCallback onTap;
  final int index;

  const InteractiveServiceCard({
    super.key,
    required this.service,
    required this.languageProvider,
    required this.onTap,
    required this.index,
  });

  @override
  State<InteractiveServiceCard> createState() => _InteractiveServiceCardState();
}

class _InteractiveServiceCardState extends State<InteractiveServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: AppConstants.shortAnimationDuration),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    setState(() => _isHovered = true);
    _scaleController.forward();
  }

  void _onExit(PointerEvent details) {
    setState(() => _isHovered = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                  boxShadow: [
                    BoxShadow(
                      color: (_isHovered
                              ? widget.service['color'] as Color
                              : Colors.black)
                          .withOpacity(_isHovered ? 0.3 : 0.1),
                      blurRadius: _isHovered ? 25 : 15,
                      offset: Offset(0, _isHovered ? 12 : 8),
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                  child: Stack(
                    children: [
                      // Background Image with Parallax Effect
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  AppConstants.shortAnimationDuration),
                          transform: Matrix4.identity()
                            ..scale(_isHovered ? 1.1 : 1.0),
                          child: Image.asset(
                            widget.service['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.mediumGray,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: AppColors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Gradient Overlay
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  AppConstants.shortAnimationDuration),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black
                                    .withOpacity(_isHovered ? 0.3 : 0.5),
                                Colors.black
                                    .withOpacity(_isHovered ? 0.7 : 0.9),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding:
                              const EdgeInsets.all(AppConstants.mediumSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon with Glow Effect
                              AnimatedContainer(
                                duration: Duration(
                                    milliseconds:
                                        AppConstants.shortAnimationDuration),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (widget.service['color'] as Color)
                                      .withOpacity(_isHovered ? 0.3 : 0.2),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.mediumRadius),
                                  border: Border.all(
                                    color: widget.service['color'] as Color,
                                    width: _isHovered ? 2 : 1,
                                  ),
                                  boxShadow: _isHovered
                                      ? [
                                          BoxShadow(
                                            color: (widget.service['color']
                                                    as Color)
                                                .withOpacity(0.5),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  widget.service['icon'],
                                  color: widget.service['color'],
                                  size: _isHovered ? 32 : 28,
                                ),
                              ),

                              const SizedBox(
                                  height: AppConstants.mediumSpacing),

                              // Title
                              Text(
                                widget.service['title'],
                                style: TextStyle(
                                  fontSize: AppConstants.h4FontSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  shadows: _isHovered
                                      ? [
                                          Shadow(
                                            color: widget.service['color']
                                                as Color,
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : [],
                                ),
                              ),

                              const SizedBox(height: AppConstants.smallSpacing),

                              // Description
                              Text(
                                widget.service['description'],
                                style: TextStyle(
                                  fontSize: AppConstants.smallFontSize,
                                  color: AppColors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(
                                  height: AppConstants.mediumSpacing),

                              // Learn More Button with Animation
                              AnimatedContainer(
                                duration: Duration(
                                    milliseconds:
                                        AppConstants.shortAnimationDuration),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _isHovered
                                      ? widget.service['color'] as Color
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.extraLargeRadius),
                                  border: Border.all(
                                    color: widget.service['color'] as Color,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.languageProvider
                                          .getString('Learn More'),
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppConstants.smallFontSize,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AnimatedRotation(
                                      turns: _isHovered ? 0.5 : 0,
                                      duration: Duration(
                                          milliseconds: AppConstants
                                              .shortAnimationDuration),
                                      child: Icon(
                                        widget.languageProvider.isArabic
                                            ? Icons.arrow_back
                                            : Icons.arrow_forward,
                                        color: AppColors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Ripple Effect on Tap
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onTap,
                            splashColor: (widget.service['color'] as Color)
                                .withOpacity(0.3),
                            highlightColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
          .animate(delay: Duration(milliseconds: 100 * widget.index))
          .fadeIn(
              duration:
                  Duration(milliseconds: AppConstants.mediumAnimationDuration))
          .slideY(begin: 0.3),
    );
  }
}
