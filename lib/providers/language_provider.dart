import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class LanguageProvider with ChangeNotifier {
  bool _isArabic = false;
  
  bool get isArabic => _isArabic;
  
  String get currentLanguage => _isArabic ? 'ar' : 'en';
  
  TextDirection get textDirection => _isArabic ? TextDirection.rtl : TextDirection.ltr;
  
  Map<String, String> get strings => _isArabic ? AppStrings.ar : AppStrings.en;
  
  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }
  
  void setLanguage(bool isArabic) {
    if (_isArabic != isArabic) {
      _isArabic = isArabic;
      notifyListeners();
    }
  }
  
  String getString(String key) {
    return strings[key] ?? key;
  }
}
