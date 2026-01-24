import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gulfsky_complete_website/constants/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../providers/scroll_provider.dart';
import '../screens/service_detail_screen.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 20,
              vertical: 60,
            ),
            decoration: const BoxDecoration(color: AppColors.darkBlue),
            child: Column(
              children: [
                // Main Footer Content
                if (isDesktop)
                  _buildDesktopFooter(languageProvider , context)
                else
                  _buildMobileFooter(languageProvider, context),

                const SizedBox(height: 40),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.2),
                ),

                const SizedBox(height: 30),

                // Bottom Section
                _buildBottomSection(languageProvider, isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopFooter(LanguageProvider languageProvider , BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Info
        Expanded(
          flex: 2,
          child: _buildCompanyInfo(languageProvider),
        ),
        
        // Quick Links
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildQuickLinks(languageProvider , context),
          ),
        ),
        
        // Services
        Expanded(
          flex: 1,
          child: _buildServicesLinks(languageProvider , context ),
        ),
        
        // Contact Info
        Expanded(
          flex: 1,
          child: _buildContactInfo(languageProvider),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(LanguageProvider languageProvider , BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyInfo(languageProvider),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(child: _buildQuickLinks(languageProvider , context)),
            const SizedBox(width: 30),
            Expanded(child: _buildServicesLinks(languageProvider,context)),
          ],
        ),
        const SizedBox(height: 40),
        _buildContactInfo(languageProvider),
      ],
    );
  }

  Widget _buildCompanyInfo(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: languageProvider.isArabic 
          ? CrossAxisAlignment.end 
          : CrossAxisAlignment.start,
      children: [
        // Logo and Company Name
        Row(
          mainAxisAlignment: languageProvider.isArabic 
              ? MainAxisAlignment.end 
              : MainAxisAlignment.start,
          children: [
            if (!languageProvider.isArabic) ...[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/LOGO.jpg')),
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
            ],
            Flexible(
              child: Text(
                languageProvider.getString('company_name'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: languageProvider.isArabic 
                    ? TextAlign.right 
                    : TextAlign.left,
              ),
            ),
            if (languageProvider.isArabic) ...[
              const SizedBox(width: 15),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  image: DecorationImage(image: AssetImage('assets/images/LOGO.jpg')),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),

              ),
            ],
          ],
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.3),
        
        const SizedBox(height: 20),
        
        // Description
        Text(
          languageProvider.getString('footer_description'),
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            height: 1.6,
          ),
          textAlign: languageProvider.isArabic 
              ? TextAlign.right 
              : TextAlign.left,
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 800.ms),
        
        const SizedBox(height: 20),
        
        // Social Media Icons
        Row(
          mainAxisAlignment: languageProvider.isArabic 
              ? MainAxisAlignment.end 
              : MainAxisAlignment.start,
          children: [
            _buildSocialIcon(Icons.facebook, 'Facebook' , ()async{
              if (!await launchUrl(
              Uri.parse('https://www.facebook.com/GULFSKYENGINEERINGCONSULTANTS/'),
              mode: LaunchMode.externalApplication,
              )) {
              throw Exception('Could not launch ${Uri.parse('https://www.facebook.com/GULFSKYENGINEERINGCONSULTANTS/')}');
              }
            }),
            const SizedBox(width: 15),
            _buildSocialIcon(FontAwesomeIcons.linkedin, 'LinkedIn' , ()async{
              if (!await launchUrl(
                Uri.parse('https://ae.linkedin.com/company/gulf-sky-group/'),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch ${Uri.parse('https://ae.linkedin.com/company/gulf-sky-group/')}');
              }
            }),
            const SizedBox(width: 15),
            _buildSocialIcon(FontAwesomeIcons.whatsapp, 'WhatsApp' , ()async{
              if (!await launchUrl(
                Uri.parse('https://wa.me/971544839559?text=مرحبًا،%20أود%20الاستفسار%20عن%20خدماتكم.'),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch ${Uri.parse('https://wa.me/971544839559')}');
              }
            }),
            const SizedBox(width: 15),
            _buildSocialIcon(FontAwesomeIcons.globe, 'Website' , ()async{
              if (!await launchUrl(
                Uri.parse('https://www.gulfskygroup.com'),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch ${Uri.parse('https://www.gulfskygroup.com')}');
              }
            }),
          ],
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 800.ms)
            .slideX(begin: languageProvider.isArabic ? 0.3 : -0.3),
      ],
    );
  }
  Widget _buildSocialIcon(IconData icon, String platform ,Function()? onTap) {
    return InkWell(
      onTap:onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildQuickLinks(LanguageProvider languageProvider , BuildContext context) {
    final links = [
      languageProvider.getString('nav_home'),
      languageProvider.getString('nav_about'),
      languageProvider.getString('nav_services'),
      languageProvider.getString('nav_projects'),
      languageProvider.getString('nav_contact'),
    ];

    return Column(
      crossAxisAlignment: languageProvider.isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.getString('footer_quick_links'),
          style: const TextStyle(
            color: AppColors.accentGold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 300.ms),

        const SizedBox(height: 20),

        ...links.asMap().entries.map((entry) {
          int index = entry.key;
          String link = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                _scrollToSection(context, index);
              },
              child: Text(
                link,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ),
          )
              .animate(delay: Duration(milliseconds: 400 + (index * 100)))
              .fadeIn(duration: 600.ms)
              .slideX(begin: languageProvider.isArabic ? 0.3 : -0.3);
        }).toList(),
      ],
    );
  }
  void _scrollToSection(BuildContext context, int sectionIndex) {
    final scrollProvider = Provider.of<ScrollProvider>(context, listen: false);

    // Check if we're on the home page
    if (ModalRoute.of(context)?.settings.name == '/') {
      // Only scroll if the controller is ready
      if (scrollProvider.isControllerReady) {
        scrollProvider.scrollToSection(sectionIndex);
      } else {
        // Wait for controller to be ready
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scrollProvider.isControllerReady) {
            scrollProvider.scrollToSection(sectionIndex);
          }
        });
      }
    } else {
      // Navigate to home page first, then scroll
      Navigator.of(context).pushReplacementNamed('/').then((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (scrollProvider.isControllerReady) {
            scrollProvider.scrollToSection(sectionIndex);
          }
        });
      });
    }
  }
  Widget _buildServicesLinks(LanguageProvider languageProvider, BuildContext context) {

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
    return Column(
      crossAxisAlignment: languageProvider.isArabic 
          ? CrossAxisAlignment.end 
          : CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.getString('footer_services_links'),
          style: const TextStyle(
            color: AppColors.accentGold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 400.ms),
        
        const SizedBox(height: 20),
        ...services.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, Object> service = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailScreen(
                      service: {
                        'title': service['title'].toString(), // مثل: 'Architectural Design'
                        'description': service['description'].toString(),
                        'type': service['title'].toString(), // مثل: 'Architectural Design'
                        'icon': service['icon'] as IconData, // أيقونة الخدمة
                        'color': service['color'] as Color, // لون الخدمة
                        'image': service['image'].toString(), // لون الخدمة
                      },
                    ),
                  ),
                );
              },
              child: Text(
                service['title'].toString(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ),
          )
              .animate(delay: Duration(milliseconds: 500 + (index * 100)))
              .fadeIn(duration: 600.ms)
              .slideX(begin: languageProvider.isArabic ? 0.3 : -0.3);
        }).toList(),
      ],
    );
  }

  Widget _buildContactInfo(LanguageProvider languageProvider) {
    final contactItems = [
      {
        'icon': Icons.location_on,
        'text': languageProvider.getString('address'),
      },
      {
        'icon': Icons.phone,
        'text': '+971 6 554 1680',
      },
      {
        'icon': Icons.email,
        'text': 'info@gulfskygroup.com',
      },
      {
        'icon': Icons.access_time,
        'text': languageProvider.getString('working_hours'),
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: languageProvider.isArabic
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            languageProvider.getString('footer_contact_info'),
            style: const TextStyle(
              color: AppColors.accentGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 500.ms),

          const SizedBox(height: 20),

          ...contactItems.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!languageProvider.isArabic) ...[
                    Icon(
                      item['icon'],
                      color: AppColors.accentGold,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      item['text'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (languageProvider.isArabic) ...[
                    const SizedBox(width: 10),
                    Icon(
                      item['icon'],
                      color: AppColors.accentGold,
                      size: 16,
                    ),
                  ],
                ],
              ),
            )
                .animate(delay: Duration(milliseconds: 600 + (index * 100)))
                .fadeIn(duration: 600.ms)
                .slideX(begin: languageProvider.isArabic ? 0.3 : -0.3);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomSection(LanguageProvider languageProvider, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            languageProvider.getString('footer_rights'),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ),
        ),
      ],
    )
        .animate(delay: 800.ms)
        .fadeIn(duration: 800.ms);
  }
}
