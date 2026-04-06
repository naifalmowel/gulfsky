import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

// Separate widget to handle expandable text state
class ExpandableText extends StatefulWidget {
  final String content;
  final bool isArabic;

  const ExpandableText({
    super.key,
    required this.content,
    required this.isArabic,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.content,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkGray,
              height: 2.0,
            ),
          ),
          textAlign: TextAlign.justify,
          textDirection:
              widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        // Calculate if text exceeds 10 lines
        final lineHeight = textPainter.preferredLineHeight;
        const maxLines = 10;
        final maxHeight = lineHeight * maxLines;
        final shouldTruncate = textPainter.height > maxHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: _isExpanded ? double.infinity : maxHeight,
                  ),
                  child: Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGray,
                      height: 2.0,
                    ),
                    textAlign: TextAlign.justify,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    maxLines: _isExpanded ? null : maxLines,
                  ),
                );
              },
            ),
            if (shouldTruncate) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: _toggleExpand,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded
                          ? (widget.isArabic ? 'عرض أقل' : 'Show Less')
                          : (widget.isArabic ? 'اعرض المزيد' : 'Read More'),
                      style: const TextStyle(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class FounderSection extends StatefulWidget {
  const FounderSection({super.key});

  @override
  State<FounderSection> createState() => _FounderSectionState();
}

class _FounderSectionState extends State<FounderSection>
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
    final isDesktop = size.width > 1050;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return VisibilityDetector(
          key: const Key('founder-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 20,
              vertical: 100,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.lightGradient,
            ),
            child: Column(
              children: [
                // Section Title
                _buildSectionTitle(languageProvider, isDesktop),

                const SizedBox(height: 60),

                // Founder Content - Two Columns
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
          languageProvider.getString('founder_title'),
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
        const SizedBox(height: 20),
        Text(
          languageProvider.getString('founder_name'),
          style: TextStyle(
            fontSize: isDesktop ? 28 : 22,
            fontWeight: FontWeight.bold,
            color: AppColors.accentGold,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 500.ms).fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildDesktopContent(LanguageProvider languageProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side - Founder Image
        Expanded(
          flex: 5,
          child: _buildFounderImage(),
        ),

        const SizedBox(width: 40),

        // Right Side - Founder Description
        Expanded(
          flex: 5,
          child: _buildFounderDescription(languageProvider),
        ),
      ],
    );
  }

  Widget _buildMobileContent(LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildFounderImage(),
        const SizedBox(height: 40),
        _buildFounderDescription(languageProvider),
      ],
    );
  }

  Widget _buildFounderImage() {
    return VisibilityDetector(
      key: const Key('founder-image'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('assets/images/founder.jpg'),
                  fit: BoxFit.cover),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue.withOpacity(0.1),
                  AppColors.accentGold.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ).animate(delay: 200.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3),
    );
  }

  Widget _buildFounderDescription(LanguageProvider languageProvider) {
    return VisibilityDetector(
      key: const Key('founder-description'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        padding: const EdgeInsets.all(40),
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
        child: ExpandableText(
          content: languageProvider.getString('founder_content'),
          isArabic: languageProvider.isArabic,
        ),
      ).animate(delay: 400.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3),
    );
  }
}
