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

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Creating a new future just in case .env is missing or fails to load, so app doesn't crash on start
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Could not load .env file: $e");
  }
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
            onGenerateRoute: (settings) {
              // Handle routes with parameters properly
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => Directionality(
                      textDirection: languageProvider.textDirection,
                      child: const HomeScreen(),
                    ),
                  );
                case '/projects':
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => const ProjectsScreen(),
                  );
                case '/contact':
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => const ContactScreen(),
                  );
                case '/service-detail':
                  final service = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => ServiceDetailScreen(
                      service: service ?? {},
                    ),
                  );
                case '/project-detail':
                  final project = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => ProjectDetailScreen(
                      project: project ?? {},
                    ),
                  );
                default:
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => Directionality(
                      textDirection: languageProvider.textDirection,
                      child: const HomeScreen(),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
