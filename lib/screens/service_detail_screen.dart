import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailScreen({super.key, required this.service});

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
                          child: BackButton(
                            color: Colors.black,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )), // Space for navbar
                    _buildServiceHeader(context),
                    _buildServiceContent(context, languageProvider),
                    _buildServiceFeatures(context, languageProvider),
                    _buildServiceProcess(context, languageProvider),
                    _buildContactSection(context, languageProvider),
                    const SizedBox(height: 60),
                  ],
                ),
              ),

              // Navbar
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Container(
      height: isDesktop ? 400 : 300,
      decoration: BoxDecoration(
        image: service['image'] != null
            ? DecorationImage(
                image: AssetImage(service['image']), fit: BoxFit.cover)
            : null,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (service['color'] as Color? ?? AppColors.primaryBlue)
                .withOpacity(0.9),
            (service['color'] as Color? ?? AppColors.primaryBlue)
                .withOpacity(0.7),
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
                  // Service Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      service['icon'] as IconData? ?? Icons.engineering,
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0.5, 0.5), duration: 800.ms)
                      .fadeIn(duration: 600.ms),

                  const SizedBox(height: 30),

                  Text(
                    service['title'] ?? '',
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

                  Text(
                    service['description'] ?? '',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
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

  Widget _buildServiceContent(
      BuildContext context, LanguageProvider languageProvider) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 80,
      ),
      child: Column(
        children: [
          // Detailed Description
          Text(
            languageProvider.getString('detailed_overview'),
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 800.ms).slideY(begin: 0.3),

          const SizedBox(height: 30),

          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: service['color'] as Color? ?? AppColors.accentGold,
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate(delay: 400.ms).scaleX(begin: 0, duration: 600.ms),

          const SizedBox(height: 40),

          Text(
            _getDetailedDescription(
                service['type'] ?? service['title'] ?? '', languageProvider),
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppColors.darkGray,
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
          ).animate(delay: 600.ms).fadeIn(duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildServiceFeatures(
      BuildContext context, LanguageProvider languageProvider) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTap = size.width > 800;
    final features = _getServiceFeatures(service['type'], languageProvider);

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
            languageProvider.getString('key_features'),
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 800.ms),
          const SizedBox(height: 50),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop
                ? 2
                : isTap
                    ? 2
                    : 1,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: isDesktop
                ? 3.2
                : isTap
                    ? size.width * 0.002
                    : 2.1,
            children: features.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> feature = entry.value;

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
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: service['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        feature['icon'],
                        color: service['color'],
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              feature['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              feature['description'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.darkGray,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: 400 + (index * 100)))
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: index.isEven ? -0.3 : 0.3);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceProcess(
      BuildContext context, LanguageProvider languageProvider) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final steps = _getServiceProcess(service['type'], languageProvider);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            languageProvider.getString('our_process'),
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 800.ms),
          const SizedBox(height: 50),
          ...steps.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> step = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Number
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: service['color'],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Step Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          step['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGray,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: Duration(milliseconds: 300 + (index * 150)))
                .fadeIn(duration: 800.ms)
                .slideX(begin: -0.3);
          }),
        ],
      ),
    );
  }

  Widget _buildContactSection(
      BuildContext context, LanguageProvider languageProvider) {
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
            service['color'].withOpacity(0.1),
            service['color'].withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            languageProvider.getString('ready'),
            style: TextStyle(
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(duration: 800.ms),
          const SizedBox(height: 20),
          Text(
            languageProvider.getString('contact_des'),
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppColors.darkGray,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/contact');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: service['color'],
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
                    const Icon(Icons.contact_mail, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      languageProvider.getString('contact_title'),
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
                  foregroundColor: service['color'],
                  side: BorderSide(color: service['color'], width: 2),
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
                      languageProvider.getString('Back_to_Services'),
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
              .animate(delay: 600.ms)
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  String _getDetailedDescription(
      String serviceType, LanguageProvider languageProvider) {
    switch (serviceType) {
      case 'Architectural Design' || 'التصميم المعماري':
        return languageProvider.getString('service_architectural_details');
      case 'Construction Management' || 'إدارة الإنشاءات':
        return languageProvider.getString('service_construction_details');
      case 'Engineering Consultants' || 'المهندسون الاستشاريون':
        return languageProvider.getString('service_consulting_details');
      case 'Approvals & Permits' || 'الحصول على التراخيص':
        return languageProvider.getString('service_approval_details');
      default:
        return languageProvider.getString('service_approval_details');
    }
  }

  List<Map<String, dynamic>> _getServiceFeatures(
      String serviceType, LanguageProvider languageProvider) {
    switch (serviceType) {
      case 'Architectural Design' || 'التصميم المعماري':
        return [
          {
            'icon': Icons.design_services,
            'title': languageProvider.getString('creative_design'),
            'description': languageProvider.getString('creative_design_desc'),
          },
          {
            'icon': Icons.eco,
            'title': languageProvider.getString('sustainable_solutions'),
            'description':
                languageProvider.getString('sustainable_solutions_desc'),
          },
          {
            'icon': Icons.computer,
            'title': languageProvider.getString('3d_visualization'),
            'description': languageProvider.getString('3d_visualization_desc'),
          },
          {
            'icon': Icons.rule,
            'title': languageProvider.getString('code_compliance'),
            'description': languageProvider.getString('code_compliance_desc'),
          },
        ];
      case 'Construction Management' || 'إدارة الإنشاءات':
        return [
          {
            'icon': Icons.schedule,
            'title': languageProvider.getString('project_scheduling'),
            'description':
                languageProvider.getString('project_scheduling_desc'),
          },
          {
            'icon': Icons.security,
            'title': languageProvider.getString('safety_management'),
            'description': languageProvider.getString('safety_management_desc'),
          },
          {
            'icon': Icons.attach_money,
            'title': languageProvider.getString('budget_control'),
            'description': languageProvider.getString('budget_control_desc'),
          },
          {
            'icon': Icons.group,
            'title': languageProvider.getString('team_coordination'),
            'description': languageProvider.getString('team_coordination_desc'),
          },
        ];
      case 'Engineering Consultants' || 'المهندسون الاستشاريون':
        return [
          {
            'icon': Icons.engineering,
            'title': languageProvider.getString('technical_expertise'),
            'description':
                languageProvider.getString('technical_expertise_desc'),
          },
          {
            'icon': Icons.analytics,
            'title': languageProvider.getString('analysis_optimization'),
            'description':
                languageProvider.getString('analysis_optimization_desc'),
          },
          {
            'icon': Icons.support,
            'title': languageProvider.getString('ongoing_support'),
            'description': languageProvider.getString('ongoing_support_desc'),
          },
          {
            'icon': Icons.verified,
            'title': languageProvider.getString('quality_assurance'),
            'description': languageProvider.getString('quality_assurance_desc'),
          },
        ];
      case 'Approvals & Permits' || 'الحصول على التراخيص':
        return [
          {
            'icon': Icons.description,
            'title': languageProvider.getString('documentation'),
            'description': languageProvider.getString('documentation_desc'),
          },
          {
            'icon': Icons.account_balance,
            'title': languageProvider.getString('authority_liaison'),
            'description': languageProvider.getString('authority_liaison_desc'),
          },
          {
            'icon': Icons.speed,
            'title': languageProvider.getString('fast_processing'),
            'description': languageProvider.getString('fast_processing_desc'),
          },
          {
            'icon': Icons.check_circle,
            'title': languageProvider.getString('compliance_guarantee'),
            'description':
                languageProvider.getString('compliance_guarantee_desc'),
          },
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getServiceProcess(
      String serviceType, LanguageProvider languageProvider) {
    switch (serviceType) {
      case 'Architectural Design' || 'التصميم المعماري':
        return [
          {
            'title': languageProvider.getString('initial_consultation'),
            'description':
                languageProvider.getString('initial_consultation_desc'),
          },
          {
            'title': languageProvider.getString('concept_development'),
            'description':
                languageProvider.getString('concept_development_desc'),
          },
          {
            'title': languageProvider.getString('design_development'),
            'description':
                languageProvider.getString('design_development_desc'),
          },
          {
            'title': languageProvider.getString('final_documentation'),
            'description':
                languageProvider.getString('final_documentation_desc'),
          },
        ];
      case 'Construction Management' || 'إدارة الإنشاءات':
        return [
          {
            'title': languageProvider.getString('project_planning'),
            'description': languageProvider.getString('project_planning_desc'),
          },
          {
            'title': languageProvider.getString('team_assembly'),
            'description': languageProvider.getString('team_assembly_desc'),
          },
          {
            'title': languageProvider.getString('construction_oversight'),
            'description':
                languageProvider.getString('construction_oversight_desc'),
          },
          {
            'title': languageProvider.getString('project_completion'),
            'description':
                languageProvider.getString('project_completion_desc'),
          },
        ];
      case 'Engineering Consultants' || 'المهندسون الاستشاريون':
        return [
          {
            'title': languageProvider.getString('problem_assessment'),
            'description':
                languageProvider.getString('problem_assessment_desc'),
          },
          {
            'title': languageProvider.getString('solution_development'),
            'description':
                languageProvider.getString('solution_development_desc'),
          },
          {
            'title': languageProvider.getString('implementation_support'),
            'description':
                languageProvider.getString('implementation_support_desc'),
          },
          {
            'title': languageProvider.getString('performance_evaluation'),
            'description':
                languageProvider.getString('performance_evaluation_desc'),
          },
        ];
      case 'Approvals & Permits' || 'الحصول على التراخيص':
        return [
          {
            'title': languageProvider.getString('document_review'),
            'description': languageProvider.getString('document_review_desc'),
          },
          {
            'title': languageProvider.getString('application_preparation'),
            'description':
                languageProvider.getString('application_preparation_desc'),
          },
          {
            'title': languageProvider.getString('authority_coordination'),
            'description':
                languageProvider.getString('authority_coordination_desc'),
          },
          {
            'title': languageProvider.getString('permit_issuance'),
            'description': languageProvider.getString('permit_issuance_desc'),
          },
        ];
      default:
        return [];
    }
  }
}
