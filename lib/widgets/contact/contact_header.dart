import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../providers/language_provider.dart';

class ContactHeader extends StatelessWidget {
  final LanguageProvider languageProvider;
  final bool isDesktop;

  const ContactHeader({
    super.key,
    required this.languageProvider,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            Color(0xFF1E3A8A), // Slightly darker blue
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            languageProvider.getString('contact_title'),
            style: TextStyle(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.3, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          )
              .animate(delay: 300.ms)
              .scaleX(begin: 0, duration: 600.ms, curve: Curves.easeInOut),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 150 : 0),
            child: Text(
              languageProvider.getString('contact_des'),
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
                fontFamily: 'Inter', // Suggesting a clean fon
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate(delay: 500.ms)
              .fadeIn(duration: 800.ms),
        ],
      ),
    );
  }
}
