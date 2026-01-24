import 'package:flutter/material.dart';
import 'package:gulfsky_complete_website/screens/project_detail_screen.dart';
import 'package:gulfsky_complete_website/screens/service_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/language_provider.dart';
import 'providers/scroll_provider.dart';
import 'screens/home_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const GulfSkyWebsite());
}

class GulfSkyWebsite extends StatelessWidget {
  const GulfSkyWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ScrollProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: languageProvider.getString('app_title'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: AppColors.primaryBlue,
              fontFamily: GoogleFonts.poppins().fontFamily,
              textTheme: GoogleFonts.poppinsTextTheme(),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: AppColors.accentGold.withOpacity(0.3),
                ),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => Directionality(
                textDirection: languageProvider.textDirection,
                child: const HomeScreen(),
              ),
              '/projects': (context) => const ProjectsScreen(),
              '/contact': (context) => const ContactScreen(),
              '/service-detail': (context) => const ServiceDetailScreen(service: {}),
              '/project-detail': (context) => const ProjectDetailScreen(project: {}),
            },
          );
        },
      ),
    );
  }
}
