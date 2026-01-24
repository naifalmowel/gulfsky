import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../constants/app_colors.dart';
import '../providers/scroll_provider.dart';
import '../widgets/animated_navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/services_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> sections;

  @override
  void initState() {
    super.initState();
    // Initialize sections list
    sections = [
      const HeroSection(),
      const AboutSection(),
      const ServicesSection(),
      const ProjectsSection(),
      const ContactSection(),
      const FooterSection(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (context, scrollProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Main Content with ScrollablePositionedList
              Positioned.fill(
                child: ScrollablePositionedList.separated(
                  itemScrollController: scrollProvider.itemScrollController,
                  itemPositionsListener: scrollProvider.itemPositionsListener,
                  itemCount: sections.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      key: ValueKey('section_$index'),
                      child: sections[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox.shrink(); // No separator needed
                  },
                ),
              ),

              // Always visible Navbar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const AnimatedNavbar(),
                ),
              ),
            ],
          ),
            floatingActionButton: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
              child: scrollProvider.isAtTop
                  ? const SizedBox(key: ValueKey('empty'), width: 56, height: 56)
                  : FloatingActionButton(
                key: const ValueKey('fab'),
                backgroundColor: AppColors.secondaryBlue.withOpacity(0.8),

                child: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () => scrollProvider.scrollToTop(),
              ),
            ),
        );
      },
    );
  }
}
