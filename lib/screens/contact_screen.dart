import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../widgets/contact/contact_header.dart';
import '../widgets/contact/contact_form.dart';
import '../widgets/contact/contact_info.dart';
import '../widgets/map_location.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final size = MediaQuery.of(context).size;
        final isDesktop = size.width > 900; // Increased breakpoint for better layout

        return Scaffold(
          backgroundColor: Colors.grey[50], // Slightly off-white background
          body: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BackButton(
                          color: AppColors.primaryBlue,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    ContactHeader(
                      languageProvider: languageProvider,
                      isDesktop: isDesktop,
                    ),
                    _buildContentSection(
                        context, languageProvider, isDesktop),
                    _buildMapSection(context, languageProvider),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection(
      BuildContext context, LanguageProvider languageProvider, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      constraints: const BoxConstraints(maxWidth: 1400),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: ContactInfo(
                    languageProvider: languageProvider,
                    isDesktop: isDesktop,
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  flex: 5,
                  child: ContactForm(
                      languageProvider: languageProvider,
                      isDesktop: isDesktop),
                ),
              ],
            )
          : Column(
              children: [
                ContactInfo(
                  languageProvider: languageProvider,
                  isDesktop: isDesktop,
                ),
                const SizedBox(height: 40),
                ContactForm(
                    languageProvider: languageProvider, isDesktop: isDesktop),
              ],
            ),
    );
  }

  Widget _buildMapSection(
      BuildContext context, LanguageProvider languageProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 500,
        constraints: const BoxConstraints(maxWidth: 1200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            const Expanded(
              child: ContactMap(),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              color: Colors.white,
              child: Text(
                languageProvider.getString('map_title'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primaryBlue,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    )
        .animate(delay: 600.ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.2);
  }
}
