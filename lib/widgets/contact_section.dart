import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'map_location.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _formController;
  bool _isVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _formController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _formController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
      _formController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return VisibilityDetector(
          key: const Key('contact-section'),
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



                // Content
                if (isDesktop)
                  _buildDesktopLayout(languageProvider)
                else
                  _buildMobileLayout(languageProvider),
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
          languageProvider.getString('contact_title'),
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
      ],
    );
  }

  Widget _buildDesktopLayout(LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildContactForm(languageProvider),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left - Contact Info
            Expanded(
              flex: 1,
              child: _buildContactInfo(languageProvider),
            ),

            const SizedBox(width: 60),

            // Right - Map
            Expanded(
              flex: 1,
              child:_buildMapSection(context,languageProvider),
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildMobileLayout(LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildContactForm(languageProvider),
        const SizedBox(height: 40),
        _buildContactInfo(languageProvider),

        const SizedBox(height: 40),
        _buildMapSection(context,languageProvider),
      ],
    );
  }

  Widget _buildContactInfo(LanguageProvider languageProvider) {
    final contactItems = [
      {
        'icon': Icons.location_on,
        'title': languageProvider.getString('contact_address'),
        'value':
        languageProvider.getString('address'),
        'color': AppColors.accentGold,
      },
      {
        'icon': Icons.phone,
        'title': languageProvider.getString('contact_phone'),
        'value': '+971 6 55 41 680',
        'color': AppColors.constructionColor,
      },
      {
        'icon': Icons.email,
        'title': languageProvider.getString('contact_email'),
        'value': 'info@gulfskygroup.com',
        'color': AppColors.consultingColor,
      },
      {
        'icon': Icons.access_time,
        'title': languageProvider.getString('working_hours_title'),
        'value': languageProvider.getString('working_hours'),
        'color': AppColors.approvalColor,
      },
    ];

    return Column(
      crossAxisAlignment: languageProvider.isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.getString('contact_subtitle'),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideX(begin: languageProvider.isArabic ? 0.3 : -0.3),
        const SizedBox(height: 30),
        ...contactItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;

          return _buildContactItem(
            item['icon'],
            item['title'],
            item['value'],
            item['color'],
            index,
            languageProvider.isArabic,
          );
        }),
      ],
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String value,
    Color color,
    int index,
    bool isArabic,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final itemAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.2,
              (index * 0.1) + 0.6,
              curve: Curves.easeOut,
            ),
          ),
        );

        return Transform.translate(
          offset: Offset(
            (1 - itemAnimation.value) * (isArabic ? 50 : -50),
            0,
          ),
          child: Opacity(
            opacity: itemAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (!isArabic) ...[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(icon, color: color, size: 25),
                    ),
                    const SizedBox(width: 20),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          value,
                          textDirection: isArabic ? TextDirection.ltr : null,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isArabic) ...[
                    const SizedBox(width: 20),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(icon, color: color, size: 25),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapSection(BuildContext context , LanguageProvider languageProvider) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: isDesktop ? size.width / 3 : size.width,

        height: 550,
        margin: EdgeInsets.only(
          top: isDesktop?80:0,
        ) ,
        decoration:  BoxDecoration(
          border: Border.all(color: AppColors.secondaryBlue),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          gradient: AppColors.lightGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            const Expanded(
              child: Center(
                child: ContactMap(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                languageProvider.getString('map_title'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10 ,color: AppColors.secondaryBlue),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildContactForm(LanguageProvider languageProvider) {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        final formAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _formController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

        return Transform.scale(
          scale: 0.8 + (0.2 * formAnimation.value),
          child: Opacity(
            opacity: formAnimation.value,
            child: Column(
              children: [
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(40),
                  width: 1000,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          languageProvider.getString('contact_form_send'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Name Field
                        _buildFormField(
                          controller: _nameController,
                          label:
                              languageProvider.getString('contact_form_name'),
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Email Field
                        _buildFormField(
                          controller: _emailController,
                          label:
                              languageProvider.getString('contact_form_email'),
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Message Field
                        _buildFormField(
                          controller: _messageController,
                          label: languageProvider
                              .getString('contact_form_message'),
                          icon: Icons.message,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGold,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  languageProvider
                                      .getString('contact_form_send'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.send, size: 18),
                              ],
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
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accentGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accentGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sendEmail(
          name: _nameController.text,
          email: _emailController.text,
          message: _messageController.text);
    }
  }

  Future<void> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    const serviceId = 'service_nftblpr';
    const templateId = 'template_398o9'; //b9
    const publicKey = 'xcKlcq275OeQg_1'; //Ej

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_message': message,
        },
      }),
    );

   if(mounted){
     if (response.statusCode == 200) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Message sent successfully!'),
           backgroundColor: AppColors.constructionColor,
         ),
       );
       _nameController.clear();
       _emailController.clear();
       _messageController.clear();
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('❌ Failed to send email'),
           backgroundColor: Colors.red,
         ),
       );
     }
   }
  }
}
