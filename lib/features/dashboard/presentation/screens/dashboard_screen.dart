import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../auth/domain/entities/driver.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = DummyData.currentDriver;
    final companyInfo = DummyData.getCurrentDriverCompanyInfo();
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            Text(
              driver.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(PhosphorIconsRegular.bell),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.errorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              driver.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatsCard(
                    icon: PhosphorIconsRegular.files,
                    title: 'Total Documents',
                    value: '12',
                    color: AppColors.primaryColor,
                    subtitle: '2 expiring soon',
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.3, end: 0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatsCard(
                    icon: PhosphorIconsRegular.briefcase,
                    title: 'Applications',
                    value: '3',
                    color: AppColors.secondaryColor,
                    subtitle: '1 pending review',
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.3, end: 0),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Company Information (only for company drivers)
            if (driver.isCompanyDriver && companyInfo != null) ...[
              _CompanyInfoCard(
                driver: driver,
                companyInfo: companyInfo,
              ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
            ],
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate responsive aspect ratio based on screen size
                final screenHeight = MediaQuery.of(context).size.height;
                final isSmallScreen = screenHeight < 700; // iPhone SE, iPhone 8 size
                final isMediumScreen = screenHeight < 850; // iPhone 14, 15, 16 Pro size
                
                // Dynamic aspect ratio: smaller screens need more height
                final aspectRatio = isSmallScreen ? 1.2 : (isMediumScreen ? 1.35 : 1.5);
                
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: aspectRatio,
                  children: [
                _QuickActionCard(
                  icon: PhosphorIconsRegular.camera,
                  title: 'Scan Document',
                  subtitle: 'Add new documents',
                  color: AppColors.primaryColor,
                  onTap: () => context.push('/documents/scanner'),
                ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms),
                _QuickActionCard(
                  icon: PhosphorIconsRegular.files,
                  title: 'My Documents',
                  subtitle: 'View all files',
                  color: AppColors.successColor,
                  onTap: () => context.go('/documents'),
                ).animate().fadeIn(delay: 500.ms).scale(delay: 500.ms),
                _QuickActionCard(
                  icon: PhosphorIconsRegular.plus,
                  title: 'New Application',
                  subtitle: 'Apply for jobs',
                  color: AppColors.secondaryColor,
                  onTap: () => context.push('/applications/new'),
                ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms),
                _QuickActionCard(
                  icon: PhosphorIconsRegular.user,
                  title: 'Profile',
                  subtitle: 'Update info',
                  color: AppColors.infoColor,
                  onTap: () => context.go('/profile'),
                ).animate().fadeIn(delay: 700.ms).scale(delay: 700.ms),
                  ],
                );
              },
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 24),
            
            // Recent Documents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Documents',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.go('/documents'),
                  child: const Text('View All'),
                ),
              ],
            ).animate().fadeIn(delay: 800.ms),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final documents = [
                  {
                    'title': 'Driver License',
                    'date': '2024-01-15',
                    'status': 'Active',
                    'expiry': '2026-03-20',
                    'type': 'license',
                  },
                  {
                    'title': 'Medical Certificate',
                    'date': '2024-01-10',
                    'status': 'Expiring Soon',
                    'expiry': '2024-12-15',
                    'type': 'medical',
                  },
                  {
                    'title': 'Insurance Card',
                    'date': '2024-01-08',
                    'status': 'Active',
                    'expiry': '2025-06-30',
                    'type': 'insurance',
                  },
                  {
                    'title': 'DOT Physical Report (PDF)',
                    'date': '2024-01-12',
                    'status': 'Active',
                    'expiry': '2025-01-12',
                    'type': 'medical',
                    'isPdf': true,
                    'pdfUrl': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                  },
                ];
                
                final doc = documents[index];
                return _DocumentCard(
                  title: doc['title'] as String,
                  date: doc['date'] as String,
                  status: doc['status'] as String,
                  expiry: doc['expiry'] as String,
                  type: doc['type'] as String,
                  isPdf: doc['isPdf'] as bool? ?? false,
                  pdfUrl: doc['pdfUrl'] as String?,
                  onTap: () async {
                    if (doc['isPdf'] == true && doc['pdfUrl'] != null) {
                      // Open PDF in browser/external app
                      final url = Uri.parse(doc['pdfUrl'] as String);
                      try {
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening PDF: ${doc['title']}'),
                                backgroundColor: AppColors.successColor,
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Cannot open PDF: ${doc['pdfUrl']}'),
                                backgroundColor: AppColors.errorColor,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error opening PDF: $e'),
                              backgroundColor: AppColors.errorColor,
                            ),
                          );
                        }
                      }
                    } else {
                      // TODO: Navigate to document detail
                    }
                  },
                ).animate().fadeIn(delay: (900 + index * 100).ms).slideX(begin: 0.3, end: 0);
              },
            ),
            const SizedBox(height: 24),
            
            // Expiring Documents Alert
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                border: Border.all(
                  color: AppColors.warningColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.warning,
                    color: AppColors.warningColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Documents Expiring Soon',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.warningColor,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your Medical Certificate expires in 25 days. Renew it to avoid any issues.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    PhosphorIconsRegular.arrowRight,
                    color: AppColors.warningColor,
                    size: 20,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}

class _CompanyInfoCard extends StatelessWidget {
  final Driver driver;
  final CompanyInfo companyInfo;

  const _CompanyInfoCard({
    required this.driver,
    required this.companyInfo,
  });

  @override
  Widget build(BuildContext context) {
    final association = driver.companyAssociation!;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.05),
              AppColors.secondaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    PhosphorIconsRegular.buildings,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Current Employer',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        companyInfo.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'DOT: ${companyInfo.dotNumber}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textHint,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Active',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _CompanyStatItem(
                    icon: PhosphorIconsRegular.briefcase,
                    label: 'Position',
                    value: association.position,
                  ),
                ),
                Expanded(
                  child: _CompanyStatItem(
                    icon: PhosphorIconsRegular.calendar,
                    label: 'Service',
                    value: '${association.monthsOfService} months',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CompanyStatItem(
                    icon: PhosphorIconsRegular.shareNetwork,
                    label: 'Docs Shared',
                    value: association.documentsSharedWithCompany ? 'Yes' : 'No',
                    valueColor: association.documentsSharedWithCompany 
                        ? AppColors.successColor 
                        : AppColors.warningColor,
                  ),
                ),
                Expanded(
                  child: _CompanyStatItem(
                    icon: PhosphorIconsRegular.user,
                    label: 'Supervisor',
                    value: association.supervisorName ?? 'Not assigned',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _CompanyStatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatsCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive padding and sizing
        final isCompact = constraints.maxWidth < 150;
        final padding = isCompact ? 12.0 : 16.0;
        final iconSize = isCompact ? 20.0 : 24.0;
        final spacing = isCompact ? 6.0 : 8.0;
        
        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: iconSize),
              SizedBox(height: spacing),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: isCompact ? 24 : null,
                      ),
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: isCompact ? 12 : null,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textHint,
                      fontSize: isCompact ? 10 : null,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate responsive sizes based on available space
            final isCompact = constraints.maxHeight < 120;
            final iconSize = isCompact ? 32.0 : 40.0;
            final iconContainerSize = isCompact ? 18.0 : 20.0;
            final spacing = isCompact ? 8.0 : 12.0;
            final horizontalPadding = isCompact ? 12.0 : 16.0;
            final verticalPadding = isCompact ? 12.0 : 16.0;
            
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: iconContainerSize),
                  ),
                  SizedBox(height: spacing),
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isCompact ? 14 : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isCompact ? 11 : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final String expiry;
  final String type;
  final bool isPdf;
  final String? pdfUrl;
  final VoidCallback onTap;

  const _DocumentCard({
    required this.title,
    required this.date,
    required this.status,
    required this.expiry,
    required this.type,
    this.isPdf = false,
    this.pdfUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'Active' 
        ? AppColors.successColor 
        : status == 'Expiring Soon'
            ? AppColors.warningColor
            : AppColors.errorColor;

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
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.getDocumentTypeColor(type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      _getDocumentIcon(type),
                      color: AppColors.getDocumentTypeColor(type),
                      size: 24,
                    ),
                    if (isPdf)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: const Icon(
                            PhosphorIconsRegular.filePdf,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expires: $expiry',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'license':
        return PhosphorIconsRegular.identificationCard;
      case 'medical':
        return PhosphorIconsRegular.heartbeat;
      case 'insurance':
        return PhosphorIconsRegular.shield;
      default:
        return PhosphorIconsRegular.file;
    }
  }
}