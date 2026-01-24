import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/map_location.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white54,
          body: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Column(
                  children: [ Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BackButton(color: Colors.black,onPressed: (){Navigator.of(context).pop();},),
                      )),
                    _buildContactHeader(languageProvider, context),
                    _buildContactContent(languageProvider, context),
                    _buildMapSection(context , languageProvider),
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

  Widget _buildContactHeader(LanguageProvider languageProvider, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,

      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          Text(
            languageProvider.getString('contact_title'),
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
          
          const SizedBox(height: 20),
          
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
          
          const SizedBox(height: 30),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 0),
            child: Text(
              languageProvider.getString('contact_des'),
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
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

  Widget _buildContactContent(LanguageProvider languageProvider, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 80,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildContactInfo(languageProvider, context),
                ),
                const SizedBox(width: 60),
                Expanded(
                  flex: 1,
                  child: _buildContactForm(languageProvider, context),
                ),
              ],
            )
          : Column(
              children: [
                _buildContactInfo(languageProvider, context),
                const SizedBox(height: 40),
                _buildContactForm(languageProvider, context),
              ],
            ),
    );
  }

  Widget _buildContactInfo(LanguageProvider languageProvider, BuildContext context) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.getString('contact_information'),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 768 ? 32 : 24,
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
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: item['color'].withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 16,
                          color: item['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['value'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGray,
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
              .slideX(begin: -0.3);
        }).toList(),
      ],
    );
  }

  Widget _buildContactForm(LanguageProvider languageProvider, BuildContext context) {
    return Column(
      children: [
        Text(
          '',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 768 ? 32 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideX(begin: -0.3),

        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(40),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  languageProvider.getString('contact_form_send'),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),

                const SizedBox(height: 30),

                // Name and Email Row
                if (MediaQuery.of(context).size.width > 768)
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          controller: _nameController,
                          label:  languageProvider.getString('contact_form_name'),
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildFormField(
                          controller: _emailController,
                          label:  languageProvider.getString('contact_form_email'),
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildFormField(
                    controller: _nameController,
                    label:  languageProvider.getString('contact_form_name'),
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildFormField(
                    controller: _emailController,
                    label: languageProvider.getString('contact_form_email'),
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 20),

                // Phone and Subject Row
                if (MediaQuery.of(context).size.width > 768)
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          controller: _phoneController,
                          label: languageProvider.getString('contact_phone'),
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildFormField(
                          controller: _subjectController,
                          label: languageProvider.getString('contact_sub'),
                          icon: Icons.subject,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a subject';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildFormField(
                    controller: _phoneController,
                    label: languageProvider.getString('contact_phone'),
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildFormField(
                    controller: _subjectController,
                    label:  languageProvider.getString('contact_sub'),
                    icon: Icons.subject,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 20),

                // Message Field
                _buildFormField(
                  controller: _messageController,
                  label:  languageProvider.getString('contact_form_message'),
                  icon: Icons.message,
                  maxLines: 5,
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
                    child:  Row(
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
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 800.ms)
            .slideX(begin: 0.3),
      ],
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

  Widget _buildMapSection(BuildContext context , LanguageProvider languageProvider) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 600,
        height: 500,
        decoration: const BoxDecoration(
          gradient: AppColors.lightGradient,
        ),
        child:  Column(
          children: [
            const Expanded(
              child: Center(
                child: ContactMap(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                languageProvider.getString('map_title'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10 , color: AppColors.darkBlue),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    )
        .animate(delay: 600.ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3);
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sendEmail(name: _nameController.text, email: _emailController.text, message: _messageController.text);
    }
  }


  Future<void> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async
  {
    const serviceId = 'service_nftblpr';
    const templateId = 'template_398o9b9';
    const publicKey = 'xcKlcq275OeQg_1Ej';

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
