import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Based on Gulf Sky Brochure
  static const Color primaryBlue = Color(0xFF1e2a5e);
  static const Color secondaryBlue = Color(0xFF2d4a8e);
  static const Color accentGold = Color(0xFFf4a261);
  static const Color darkBlue = Color(0xFF0f1a3e);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF666666);
  static const Color darkGray = Color(0xFF333333);

  // Service Colors (mapped to specific services)
  static const Color architecturalColor = Color(0xFFf4a261); // Gold
  static const Color constructionColor = Color(0xFF4CAF50); // Green
  static const Color consultingColor = Color(0xFF2196F3); // Blue
  static const Color approvalColor = Color(0xFF9C27B0); // Purple

  // Interactive Colors (for hover effects and interactions)
  static const Color hoverGold = Color(0xFFf5b074);
  static const Color hoverBlue = Color(0xFF3a5aae);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryBlue],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, lightGray],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGray, white],
  );
}
