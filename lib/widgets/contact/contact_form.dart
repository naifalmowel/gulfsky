import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../services/email_service.dart';

class ContactForm extends StatefulWidget {
  final LanguageProvider languageProvider;
  final bool isDesktop;

  const ContactForm({
    super.key,
    required this.languageProvider,
    required this.isDesktop,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await EmailService().sendEmail(
        name: _nameController.text,
        email: _emailController.text,
        message: _messageController.text,
        subject: _subjectController.text,
        phone: _phoneController.text,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (success) {
          _showSnackBar(
              'Message sent successfully! We will contact you shortly.',
              Colors.green);
          _clearForm();
        } else {
          _showSnackBar('Failed to send message. Please try again.', Colors.red);
        }
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.languageProvider;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.getString('contact_form_send'),
              style: TextStyle(
                fontSize: widget.isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 30),
            if (widget.isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _nameController,
                      label: provider.getString('contact_form_name'),
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildFormField(
                      controller: _emailController,
                      label: provider.getString('contact_form_email'),
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !v!.contains('@') ? 'Invalid Email' : null,
                    ),
                  ),
                ],
              )
            else ...[
              _buildFormField(
                controller: _nameController,
                label: provider.getString('contact_form_name'),
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              _buildFormField(
                controller: _emailController,
                label: provider.getString('contact_form_email'),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => !v!.contains('@') ? 'Invalid Email' : null,
              ),
            ],
            const SizedBox(height: 20),
            if (widget.isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _phoneController,
                      label: provider.getString('contact_phone'),
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildFormField(
                      controller: _subjectController,
                      label: provider.getString('contact_sub'),
                      icon: Icons.subject,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              )
            else ...[
              _buildFormField(
                controller: _phoneController,
                label: provider.getString('contact_phone'),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildFormField(
                controller: _subjectController,
                label: provider.getString('contact_sub'),
                icon: Icons.subject,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 20),
            _buildFormField(
              controller: _messageController,
              label: provider.getString('contact_form_message'),
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.getString('contact_form_send'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.send_rounded, size: 20),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
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
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.accentGold, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
