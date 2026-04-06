import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../providers/language_provider.dart';

class ContactInfo extends StatelessWidget {
  final LanguageProvider languageProvider;
  final bool isDesktop;

  const ContactInfo({
    super.key,
    required this.languageProvider,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final contactItems = [
      {
        'icon': Icons.location_on_rounded,
        'title': languageProvider.getString('contact_address'),
        'value': languageProvider.getString('address'),
        'color': AppColors.accentGold,
      },
      {
        'icon': Icons.phone_rounded,
        'title': languageProvider.getString('contact_phone'),
        'value': '+971 6 55 41 680',
        'color': AppColors.constructionColor,
      },
      {
        'icon': Icons.email_rounded,
        'title': languageProvider.getString('contact_email'),
        'value': 'info@gulfskygroup.com',
        'color': AppColors.consultingColor,
      },
      {
        'icon': Icons.access_time_filled_rounded,
        'title': languageProvider.getString('working_hours_title'),
        'value': languageProvider.getString('working_hours'),
        'color': AppColors.approvalColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.getString('contact_information'),
          style: TextStyle(
            fontSize: isDesktop ? 28 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideX(begin: -0.3),
        const SizedBox(height: 30),
        ...contactItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (item['color'] as Color).withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['value'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate(delay: Duration(milliseconds: 300 + (index * 100)))
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.2);
        }),
      ],
    );
  }
}
