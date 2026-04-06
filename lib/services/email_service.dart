import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailService {
  static final String _serviceId = dotenv.env['EMAILJS_SERVICE_ID'] ?? '';
  static final String _templateId = dotenv.env['EMAILJS_TEMPLATE_ID'] ?? '';
  static final String _publicKey = dotenv.env['EMAILJS_PUBLIC_KEY'] ?? '';
  static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  Future<bool> sendEmail({
    required String name,
    required String email,
    required String message,
    String? subject,
    String? phone,
  }) async {
    if (_serviceId.isEmpty || _templateId.isEmpty || _publicKey.isEmpty) {
      print('EmailJS keys are missing from .env');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost', // Sometimes needed for CORS
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_message': message,
            'user_subject': subject ?? 'No Subject',
            'user_phone': phone ?? '',
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
