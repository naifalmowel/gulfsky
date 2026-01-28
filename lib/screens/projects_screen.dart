import 'package:flutter/material.dart';
import 'package:gulfsky_complete_website/widgets/reload_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selectedType = 'All';
  String selectedLocation = 'All';
  bool _isFilterEnabled = true; // New state for filter toggle

  // Project Types with Colors (from user's provided file)
  final Map<String, Color> projectTypes = {
    'All': Colors.blueAccent,
    'Residential': AppColors.architecturalColor,
    'Hotel': AppColors.consultingColor,
    'Villa': AppColors.approvalColor,
    'EDUCATION': AppColors.primaryBlue,
    'INTERIOR DESIGN': AppColors.accentGold.withOpacity(0.5),
    'Other': AppColors.darkGray,
  };

  // UAE Locations (from user's provided file)
  final List<String> locations = [
    'All',
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ajman',
    'Ras Al Khaimah',
    'Fujairah',
    'Umm Al Quwain'
  ];

  // All Projects Data (from user's provided file)
  final url = 'https://cdn.jsdelivr.net/gh/naifizo/gulfsky-images/projects';

  late final projects = [
    {
      'title': 'G + 6P + 33TYP + H.C',
      'location': 'Al Khan - Sharjah',
      'type': 'Residential',
      'area': '1',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS19.jpg'
    },
    {
      'title': 'G + 5P + H.C + 25TYP + 1Tec + H.P',
      'location': 'Al Khan - Sharjah',
      'type': 'Residential',
      'area': '2',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS105.jpg'
    },
    {
      'title': 'G + 5P + 30TYP',
      'location': 'Al Mamzar - Dubai',
      'type': 'Residential',
      'area': '3',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS308.jpg'
    },
    {
      'title': 'G + 7P + 30TYP + PentHouse + H.P',
      'location': 'Al Khan - Sharjah',
      'type': 'Residential',
      'area': '4',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS27.jpg'
    },
    {
      'title': 'G + 5P + 15TYP',
      'location': 'Al Khan - Sharjah',
      'type': 'Residential',
      'area': '6',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS264.jpg'
    },
    {
      'title': ' B + G + 5P + 20TYP + S.P + H.P (3 Towers)',
      'location': 'Aleppo - Syria',
      'type': 'Residential',
      'area': '7',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS35.jpg'
    },
    {
      'title': 'G + 5P + 15TYP + H.P',
      'location': 'Al Majaz 2 - Sharjah',
      'type': 'Residential',
      'area': '8',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS121.jpg'
    },
    {
      'title': 'G + 5P + 15TYP',
      'location': 'Al Nahda - Sharjah',
      'type': 'Residential',
      'area': '9',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS235.jpg'
    },
    {
      'title': 'G + 3P + 15TYP + Penthouse + H.P',
      'location': 'Al Qasmia - Sharjah',
      'type': 'Residential',
      'area': '10',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS28.jpg'
    },
    {
      'title': ' G + 4P + 15TYP',
      'location': 'Abu Shagara - Sharjah',
      'type': 'Residential',
      'area': '11',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS239.jpg'
    },
    {
      'title': ' G + 3P + 10TYP',
      'location': 'Al Salama 5 - Umm Al Quwain',
      'type': 'Residential',
      'area': '12',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS83.jpg'
    },
    {
      'title': ' G + 3P + 11TYP',
      'location': 'Abu Shagara - Sharjah',
      'type': 'Residential',
      'area': '13',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS165.jpg'
    },
    {
      'title': 'G + 11TYP',
      'location': 'Abu Shagara - Sharjah',
      'type': 'Residential',
      'area': '14',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS161.jpg'
    },
    {
      'title': 'G + 5P + 12TYP',
      'location': 'Al Majaz 3 - Sharjah',
      'type': 'Residential',
      'area': '15',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS792.jpg'
    },
    {
      'title': 'G + 2P + 9TYP + P.H',
      'location': 'Al Nahda - Sharjah',
      'type': 'Residential',
      'area': '16',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS214.jpg'
    },
    {
      'title': ' G + 2P + 8TYP + H.C',
      'location': 'Al Majaz - Sharjah',
      'type': 'Residential',
      'area': '17',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS7.jpg'
    },
    {
      'title': 'G + 7TYP',
      'location': 'Warsan Fourth - Dubai',
      'type': 'Residential',
      'area': '20',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS245.jpg'
    },
    {
      'title': ' G + 6TYP + H.C',
      'location': 'Al Warqaa - Dubai',
      'type': 'Residential',
      'area': '22',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS118.jpg'
    },
    {
      'title': 'G + 1P + 5TYP',
      'location': 'Al Muwaileh - Sharjah',
      'type': 'Residential',
      'area': '23',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS200.jpg'
    },
    {
      'title': 'G + 1P + 5TYP',
      'location': 'Al Muwaileh - Sharjah',
      'type': 'Residential',
      'area': '24',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS139.jpg'
    },
    {
      'title': ' G + 1P + 5TYP',
      'location': 'Al Muwaileh - Sharjah',
      'type': 'Residential',
      'area': '28',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS172.jpg'
    },
    {
      'title': 'G + 4TYP',
      'location': 'Al Muwaileh - Sharjah',
      'type': 'Residential',
      'area': '29',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS302.jpg'
    },
    {
      'title': 'G + 4TYP',
      'location': 'Al Muwaileh - Sharjah',
      'type': 'Residential',
      'area': '30',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS289.jpg'
    },
    {
      'title': 'G + 2P + 8TYP',
      'location': 'Al Raudah - Umm Al Quwain',
      'type': 'Residential',
      'area': '31',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS232.jpg'
    },
    {
      'title': 'G + 3, G + 2 & SHED + MEZZ',
      'location': 'Inds. 15 - Sharjah',
      'type': 'Residential',
      'area': '32',
      'year': '2023',
      'color': AppColors.architecturalColor,
      'image': '$url/Residential/GS167.jpg'
    },
    {
      'title': ' G + 5P + H.C + 25TYP + 1Tec + H.P',
      'location': 'Al Khan - Sharjah',
      'type': 'Residential',
      'area': '25,000 sqm',
      'year': '2022',
      'color': AppColors.architecturalColor,
      'image': '$url/Tower/GS105.jpg'
    },
    {
      'title': 'G + 3P + H.C + SERV. + 15TYP',
      'location': 'Al Khan - Sharjah',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '33',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS48.jpg'
    },
    {
      'title': 'G + 3P + H.C + SERV. + 15TYP',
      'location': 'Al Nahda - Sharjah',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '34',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS59.jpg'
    },
    {
      'title': 'G + 4P + RES. + H.C + 14TYP+ S.P. + TOP ROOF',
      'location': 'Majaz 2 - Sharjah',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '35',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS120.jpg'
    },
    {
      'title': 'B + G + SERV. + 11TYP',
      'location': 'Al Butaina - Sharjah',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '36',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS34.jpg'
    },
    {
      'title': '2B + G + MEZZ + SERV. +12TYP + HC + ROOF',
      'location': 'Bu Daneg - Sharjah',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '37',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS60.jpg'
    },
    {
      'title': 'G + M + 7P + 20TYP',
      'location': 'Al Noaemiah 1 - Ajman',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '39',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS300.jpg'
    },
    {
      'title': 'G + 5 FLOORS',
      'location': 'Al Buraimi - Oman',
      'type': 'Hotel',
      'area': '75,000 sqm',
      'year': '40',
      'color': AppColors.consultingColor,
      'image': '$url/Hotels/GS50.jpg'
    },
    {
      'title': '8 VILLAS G + 1 FLOOR',
      'location': 'Al Maqtaa - Umm Al Quwain',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '41',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS2221.jpg'
    },
    {
      'title': 'G + 1 FLOOR + MAJLIS',
      'location': 'Al Rahmaniah - Sharjah',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '43',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS124.jpg'
    },
    {
      'title': 'G + 1 FLOOR',
      'location': 'Al Barsha - Dubai',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '44',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS70.jpg'
    },
    {
      'title': 'G + 1 FLOOR',
      'location': 'Sharkan - Sharjah',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '45',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS184.jpg'
    },
    {
      'title': 'TWIN VILLA G + 1 FLOOR',
      'location': 'Al Quze - Sharjah',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '46',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS49.jpg'
    },
    {
      'title': 'G + 1 FLOOR',
      'location': 'Muhaisnah 3 - Dubai',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '47',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS69.jpg'
    },
    {
      'title': 'THREE BLOCKS TWIN VILLA G + 1 FLOOR',
      'location': 'Al Riyadh - KSA',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '48',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS92.jpg'
    },
    {
      'title': 'B + G + 1 FLOOR + 1 C.W',
      'location': 'Al Khalidiah - Sharjah',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '49',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS157.jpg'
    },
    {
      'title': 'G + 1 FLOOR',
      'location': 'Al Rahmaniah - Sharjah',
      'type': 'Villa',
      'area': '30,000 sqm',
      'year': '50',
      'color': AppColors.approvalColor,
      'image': '$url/Villas/GS113.jpg'
    },
    {
      'title': 'G ONLY',
      'location': 'Al Homa - Sharjah',
      'type': 'EDUCATION',
      'area': '40,000 sqm',
      'year': '51',
      'color': AppColors.primaryBlue,
      'image': '$url/Education/GS100.jpg'
    },
    {
      'title': 'G + 1 FLOOR + 3 SERV',
      'location': 'Al A’zraa - Sharjah',
      'type': 'EDUCATION',
      'area': '40,000 sqm',
      'year': '52',
      'color': AppColors.primaryBlue,
      'image': '$url/Education/GS123.jpg'
    },
    {
      'title': 'G + 1 FLOOR + 4SERV',
      'location': 'Al A’zraa - Sharjah',
      'type': 'EDUCATION',
      'area': '40,000 sqm',
      'year': '53',
      'color': AppColors.primaryBlue,
      'image': '$url/Education/GS62.jpg'
    },
    {
      'title': ' G + 1 FLOOR',
      'location': 'Qadisiya - Khorfakkan',
      'type': 'EDUCATION',
      'area': '40,000 sqm',
      'year': '54',
      'color': AppColors.primaryBlue,
      'image': '$url/Education/GS166.jpg'
    },
    {
      'title': 'G + 3P + SERV. + REST. + H.C + 15TYP + S.P',
      'location': 'Al Nahda - Sharjah',
      'type': 'INTERIOR DESIGN',
      'area': '35,000 sqm',
      'year': '2024',
      'color': AppColors.accentGold,
      'image': '$url/Interior/Flat%2007%20a.jpg'
    },
    {
      'title': 'G + 1 FLOOR',
      'location': 'Hooshi - Sharjah',
      'type': 'INTERIOR DESIGN',
      'area': '35,000 sqm',
      'year': '2024',
      'color': AppColors.accentGold,
      'image': '$url/Interior/1-1.jpg'
    },
    {
      'title': 'G + 3P + SERV. + REST. + H.C + 15TYP + S.P',
      'location': 'Al Nahda - Sharjah',
      'type': 'Other',
      'area': '35,000 sqm',
      'year': '55',
      'color': AppColors.darkGray,
      'image': '$url/Others/GS%2020.jpg'
    },
    {
      'title': ' CIVIL DEFENCE',
      'location': 'Al Butaina - Sharjah',
      'type': 'Other',
      'area': '35,000 sqm',
      'year': '56',
      'color': AppColors.darkGray,
      'image': '$url/Others/GS%20111.jpg'
    },
    {
      'title': 'G + MEZZ',
      'location': 'Al Buraimi - Oman',
      'type': 'Other',
      'area': '35,000 sqm',
      'year': '57',
      'color': AppColors.darkGray,
      'image': '$url/Others/GS%2054.jpg'
    },
  ];
  int _projectsToShow = 6;
  final int _projectsStep = 6;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BackButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    _buildProjectsHeader(languageProvider, context),
                    _buildFilterSection(context), // Updated filter section
                    _buildProjectsGrid(languageProvider, context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectsHeader(
      LanguageProvider languageProvider, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          Text(
            languageProvider.getString('projects_title'),
            style: TextStyle(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate(delay: 300.ms).scaleX(begin: 0, duration: 600.ms),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 0),
            child: Text(
              languageProvider.getString('projects_screen_des'),
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate(delay: 500.ms).fadeIn(duration: 800.ms),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProjects() {
    if (!_isFilterEnabled) {
      return projects; // Return all projects if filter is disabled
    }
    return projects.where((project) {
      final typeMatch =
          selectedType == 'All' || project['type'] == selectedType;
      final locationMatch = selectedLocation == 'All' ||
          project['location'].toString().contains(selectedLocation);
      return typeMatch && locationMatch;
    }).toList();
  }

  int _getProjectCount(String filter, String filterType) {
    if (filter == 'All') {
      return projects.length;
    }

    return projects.where((project) {
      if (filterType == 'type') {
        return project['type'] == filter;
      } else {
        return project['location'].toString().contains(filter);
      }
    }).length;
  }

  Widget _buildProjectsGrid(
      LanguageProvider languageProvider, BuildContext context) {
    final size = MediaQuery.of(context).size;

    final filteredProjects = _getFilteredProjects();
    final displayedProjects = filteredProjects.take(_projectsToShow).toList();
    var screenWidth = size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth >= 1300) {
      crossAxisCount = 4;
      childAspectRatio = 0.7;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
      childAspectRatio = 0.55;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
      childAspectRatio = 0.7;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 1.0;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth >= 1300 ? 80 : 20,
        vertical: 60,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${languageProvider.getString('showing_projects')} (${filteredProjects.length})',
                style: TextStyle(
                  fontSize: screenWidth >= 1300 ? 20 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
              if (selectedType != 'All' || selectedLocation != 'All')
                TextButton.icon(
                  onPressed: () => setState(() {
                    selectedType = 'All';
                    selectedLocation = 'All';
                    _isFilterEnabled = true; // Disable filter when clearing
                  }),
                  icon: const Icon(Icons.clear, size: 18),
                  label: Text(languageProvider.getString('clear_filters')),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accentGold,
                  ),
                ),
            ],
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 30),
          if (filteredProjects.isEmpty)
            SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 80,
                    color: AppColors.mediumGray,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    languageProvider.getString('no_projects_found'),
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms)
          else
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: childAspectRatio,
              children: displayedProjects.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> project = entry.value;
                return _buildProjectCard(project, index, context);
              }).toList(),
            ),
          if (_projectsToShow < filteredProjects.length)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _projectsToShow += _projectsStep;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Load More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
      Map<String, dynamic> project, int index, BuildContext context) {
    return StatefulBuilder(builder: (context1, setState1) {
      return GestureDetector(
        onTap: () {
          // Add missing keys if they don't exist before navigating
          final fullProject = Map<String, dynamic>.from(project);
          fullProject['icon'] = _getProjectIcon(project['type'] ?? 'Other');
          fullProject['description'] = project['description'] ??
              'Professional engineering project featuring innovative solutions and high-quality construction standards.';

          Navigator.of(context).pushNamed(
            '/project-detail',
            arguments: fullProject,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Project Image/Visual
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ReloadableImage(
                    key: ValueKey(
                        '${project['image']}_${project['title']}_$index'),
                    imageUrl: project['image'],
                    fit: BoxFit.contain,
                    color: project['color'],
                  ),
                ),
              ),

              // Project Details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        project['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: project['color'],
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              project['location'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Spacer(),
                      // Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: project['color'],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          project['type'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: index * 100))
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.3),
      );
    });
  }

  IconData _getProjectIcon(String type) {
    switch (type) {
      case 'Residential':
        return Icons.home;
      case 'Commercial':
        return Icons.business;
      case 'Mixed Use':
        return Icons.apartment;
      case 'Hospitality':
        return Icons.hotel;
      case 'Industrial':
        return Icons.factory;
      case 'EDUCATION':
        return Icons.school;
      case 'Healthcare':
        return Icons.local_hospital;
      case 'Villa':
        return Icons.villa;
      case 'INTERIOR DESIGN':
        return Icons.design_services;
      default:
        return Icons.architecture;
    }
  }

  Widget _buildFilterSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 40,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.lightGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Projects',
                style: TextStyle(
                  fontSize: isDesktop ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
              Row(
                children: [
                  Text(
                    'Enable Filter',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Switch(
                    value: _isFilterEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isFilterEnabled = value;
                        if (!value) {
                          selectedType = 'All';
                          selectedLocation = 'All';
                        }
                      });
                    },
                    activeThumbColor: AppColors.accentGold,
                  ),
                ],
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: 0.3),
            ],
          ),
          const SizedBox(height: 30),
          if (_isFilterEnabled) // Only show dropdowns if filter is enabled
            isDesktop
                ? Row(
                    children: [
                      Expanded(
                        child: _buildTypeDropdown(context),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLocationDropdown(context),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildTypeDropdown(context),
                      const SizedBox(height: 20),
                      _buildLocationDropdown(context),
                    ],
                  ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Type',
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: projectTypes[selectedType]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: projectTypes[selectedType]!.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedType,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: projectTypes[selectedType]!,
                size: 28,
              ),
              style: TextStyle(
                color: projectTypes[selectedType]!,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(15),
              elevation: 8,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedType = newValue;
                  });
                }
              },
              items: projectTypes.entries.map((entry) {
                final type = entry.key;
                final color = entry.value;
                final count = _getProjectCount(type, 'type');

                return DropdownMenuItem<String>(
                  value: type,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getProjectIcon(type),
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            type,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (count > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    ).animate(delay: 300.ms).fadeIn(duration: 600.ms).slideX(begin: -0.3);
  }

  Widget _buildLocationDropdown(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.accentGold,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGold.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLocation,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.accentGold,
                size: 28,
              ),
              style: const TextStyle(
                color: AppColors.accentGold,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(15),
              elevation: 8,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                }
              },
              items: locations.map((location) {
                final count = _getProjectCount(location, 'location');

                return DropdownMenuItem<String>(
                  value: location,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            location == 'All'
                                ? Icons.public
                                : Icons.location_on,
                            color: AppColors.accentGold,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (count > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    ).animate(delay: 500.ms).fadeIn(duration: 600.ms).slideX(begin: 0.3);
  }
}
