import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class EmploymentApplicationsScreen extends StatelessWidget {
  const EmploymentApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applications = [
      {
        'id': '1',
        'companyName': 'Swift Transportation',
        'position': 'OTR Driver',
        'status': 'Under Review',
        'submittedDate': '2024-01-15',
        'salary': '\$65,000/year',
        'location': 'Phoenix, AZ',
      },
      {
        'id': '2',
        'companyName': 'Schneider National',
        'position': 'Regional Driver',
        'status': 'Approved',
        'submittedDate': '2024-01-10',
        'salary': '\$60,000/year',
        'location': 'Green Bay, WI',
      },
      {
        'id': '3',
        'companyName': 'J.B. Hunt',
        'position': 'Local Driver',
        'status': 'Rejected',
        'submittedDate': '2024-01-08',
        'salary': '\$55,000/year',
        'location': 'Lowell, AR',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applications'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.funnel),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: applications.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: applications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final application = applications[index];
                return _ApplicationCard(
                  application: application,
                  onTap: () {
                    // TODO: Navigate to application details
                  },
                ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.3, end: 0);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/applications/new'),
        icon: Icon(PhosphorIconsRegular.plus),
        label: const Text('New Application'),
      ).animate().fadeIn(delay: 300.ms).scale(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.briefcase,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'No Applications Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start applying for jobs to track your applications here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textHint,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/applications/new'),
            icon: Icon(PhosphorIconsRegular.plus),
            label: const Text('New Application'),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }
}

class _ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final VoidCallback onTap;

  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(application['status']);
    final statusIcon = _getStatusIcon(application['status']);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      PhosphorIconsRegular.briefcase,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application['companyName'],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          application['position'],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          application['status'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.mapPin,
                    color: AppColors.textHint,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    application['location'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    PhosphorIconsRegular.currencyDollar,
                    color: AppColors.textHint,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    application['salary'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.calendar,
                    color: AppColors.textHint,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Submitted: ${application['submittedDate']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                  const Spacer(),
                  Icon(
                    PhosphorIconsRegular.arrowRight,
                    color: AppColors.textHint,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppColors.successColor;
      case 'Under Review':
        return AppColors.warningColor;
      case 'Rejected':
        return AppColors.errorColor;
      case 'Draft':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Approved':
        return PhosphorIconsRegular.checkCircle;
      case 'Under Review':
        return PhosphorIconsRegular.clock;
      case 'Rejected':
        return PhosphorIconsRegular.xCircle;
      case 'Draft':
        return PhosphorIconsRegular.file;
      default:
        return PhosphorIconsRegular.circle;
    }
  }
}