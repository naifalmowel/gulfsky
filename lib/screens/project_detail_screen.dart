import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../widgets/animated_navbar.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BackButton(color: Colors.black,onPressed: (){Navigator.of(context).pop();},),
                        )),
                    _buildProjectHeader(context),
                    _buildProjectGallery(context),
                    _buildProjectInfo(context),
                    _buildProjectDetails(context),
                    _buildProjectSpecs(context),
                    _buildRelatedProjects(context),
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

  Widget _buildProjectHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Container(
      height: isDesktop ? 400 : 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.project['color'].withOpacity(0.9),
            widget.project['color'].withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            top: 50,
            right: 50,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Project Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      widget.project['icon'],
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0.5, 0.5), duration: 800.ms)
                      .fadeIn(duration: 600.ms),
                  
                  const SizedBox(height: 30),
                  
                  // Project Title
                  Text(
                    widget.project['title'],
                    style: TextStyle(
                      fontSize: isDesktop ? 42 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.3),
                  
                  const SizedBox(height: 20),
                  
                  // Project Location & Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, color: Colors.white, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              widget.project['location'],
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.project['type'],
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectGallery(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final images = _getProjectImages(widget.project['title']);
    
    return Container(
      height: isDesktop ? 500 : 300,
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Image Gallery
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.project['color'].withOpacity(0.8),
                        widget.project['color'].withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          images[index]['icon'],
                          size: isDesktop ? 120 : 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          images[index]['title'],
                          style: TextStyle(
                            fontSize: isDesktop ? 24 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          images[index]['description'],
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Navigation Arrows
            if (isDesktop) ...[
              Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _currentImageIndex > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _currentImageIndex < images.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ],
            
            // Page Indicators
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3);
  }

  Widget _buildProjectInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Overview',
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 800.ms),
          
          const SizedBox(height: 30),
          
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: widget.project['color'],
              borderRadius: BorderRadius.circular(2),
            ),
          )
              .animate(delay: 400.ms)
              .scaleX(begin: 0, duration: 600.ms),
          
          const SizedBox(height: 40),
          
          Text(
            widget.project['description'],
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppColors.darkGray,
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
          )
              .animate(delay: 600.ms)
              .fadeIn(duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildProjectDetails(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final details = _getProjectDetails(widget.project);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.lightGradient,
      ),
      child: Column(
        children: [
          Text(
            'Project Details',
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 800.ms),
          
          const SizedBox(height: 50),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 3 : 1,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: isDesktop ? size.width*0.001 : size.width*0.003,
            children: details.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> detail = entry.value;
              
              return Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: widget.project['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        detail['icon'],
                        color: widget.project['color'],
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      detail['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detail['value'],
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.project['color'],
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: 400 + (index * 100)))
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSpecs(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final specs = _getProjectSpecs(widget.project);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Technical Specifications',
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 800.ms),
          
          const SizedBox(height: 50),
          
          ...specs.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> spec = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.project['color'].withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      spec['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      spec['value'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
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
      ),
    );
  }

  Widget _buildRelatedProjects(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.project['color'].withOpacity(0.1),
            widget.project['color'].withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Explore More Projects',
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 800.ms),
          
          const SizedBox(height: 40),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/projects');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.project['color'],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 30,
                    vertical: isDesktop ? 20 : 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.work, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'View All Projects',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.project['color'],
                  side: BorderSide(color: widget.project['color'], width: 2),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 30,
                    vertical: isDesktop ? 20 : 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getProjectImages(String projectTitle) {
    // Mock images data - in real app, these would be actual image URLs
    return [
      {
        'icon': Icons.architecture,
        'title': 'Exterior View',
        'description': 'Modern architectural design with sustainable features',
      },
      {
        'icon': Icons.home,
        'title': 'Interior Design',
        'description': 'Spacious and functional interior layouts',
      },
      {
        'icon': Icons.landscape,
        'title': 'Landscape',
        'description': 'Beautiful landscaping and outdoor spaces',
      },
      {
        'icon': Icons.construction,
        'title': 'Construction Progress',
        'description': 'High-quality construction and attention to detail',
      },
    ];
  }

  List<Map<String, dynamic>> _getProjectDetails(Map<String, dynamic> project) {
    return [
      {
        'icon': Icons.calendar_today,
        'title': 'Completion Year',
        'value': project['year'].toString(),
      },
      {
        'icon': Icons.square_foot,
        'title': 'Total Area',
        'value': project['area'],
      },
      {
        'icon': Icons.location_city,
        'title': 'Location',
        'value': project['location'],
      },
    ];
  }

  List<Map<String, dynamic>> _getProjectSpecs(Map<String, dynamic> project) {
    // Mock specifications based on project type
    switch (project['type']) {
      case 'Residential':
        return [
          {'title': 'Building Type', 'value': 'Multi-story Residential Complex'},
          {'title': 'Number of Units', 'value': '120 Apartments'},
          {'title': 'Parking Spaces', 'value': '150 Covered Parking'},
          {'title': 'Amenities', 'value': 'Swimming Pool, Gym, Garden'},
          {'title': 'Construction Type', 'value': 'Reinforced Concrete'},
          {'title': 'Energy Rating', 'value': 'LEED Gold Certified'},
        ];
      case 'Commercial':
        return [
          {'title': 'Building Type', 'value': 'Mixed-Use Commercial Complex'},
          {'title': 'Office Floors', 'value': '15 Floors'},
          {'title': 'Retail Space', 'value': '5,000 sqm Ground Floor'},
          {'title': 'Parking', 'value': '300 Underground Spaces'},
          {'title': 'Elevators', 'value': '6 High-Speed Elevators'},
          {'title': 'HVAC System', 'value': 'Central Air Conditioning'},
        ];
      case 'Mixed-Use':
        return [
          {'title': 'Building Type', 'value': 'Mixed-Use Development'},
          {'title': 'Residential Units', 'value': '80 Luxury Apartments'},
          {'title': 'Commercial Space', 'value': '3,000 sqm Retail'},
          {'title': 'Office Space', 'value': '2,000 sqm Office'},
          {'title': 'Parking', 'value': '200 Multi-level Parking'},
          {'title': 'Green Features', 'value': 'Solar Panels, Rainwater Harvesting'},
        ];
      default:
        return [
          {'title': 'Project Type', 'value': project['type']},
          {'title': 'Total Area', 'value': project['area']},
          {'title': 'Location', 'value': project['location']},
          {'title': 'Completion', 'value': project['year'].toString()},
        ];
    }
  }
}
