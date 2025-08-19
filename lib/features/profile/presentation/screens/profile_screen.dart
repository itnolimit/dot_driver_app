import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/dummy_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = DummyData.currentDriver;
    final companyInfo = DummyData.getCurrentDriverCompanyInfo();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.gear),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            // Profile Header
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryColor,
                          child: Text(
                            driver.initials,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              PhosphorIconsRegular.camera,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      driver.fullName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Professional Driver',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Verified Driver',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: PhosphorIconsRegular.files,
                    value: '12',
                    label: 'Documents',
                    color: AppColors.primaryColor,
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3, end: 0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: PhosphorIconsRegular.clock,
                    value: '5 Years',
                    label: 'Experience',
                    color: AppColors.secondaryColor,
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3, end: 0),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Profile Sections
            _ProfileSection(
              title: 'Personal Information',
              items: [
                _ProfileItem(
                  icon: PhosphorIconsRegular.envelope,
                  label: 'Email',
                  value: driver.email,
                ),
                _ProfileItem(
                  icon: PhosphorIconsRegular.phone,
                  label: 'Phone',
                  value: driver.phone,
                ),
                if (driver.address != null)
                  _ProfileItem(
                    icon: PhosphorIconsRegular.mapPin,
                    label: 'Address',
                    value: '${driver.address}, ${driver.city}, ${driver.state} ${driver.zipCode}',
                  ),
                if (driver.dateOfBirth != null)
                  _ProfileItem(
                    icon: PhosphorIconsRegular.calendar,
                    label: 'Date of Birth',
                    value: '${driver.dateOfBirth!.month}/${driver.dateOfBirth!.day}/${driver.dateOfBirth!.year}',
                  ),
              ],
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 16),
            
            _ProfileSection(
              title: 'Driver Information',
              items: [
                if (driver.cdlNumber != null)
                  _ProfileItem(
                    icon: PhosphorIconsRegular.identificationCard,
                    label: 'CDL Number',
                    value: driver.cdlNumber!,
                  ),
                _ProfileItem(
                  icon: PhosphorIconsRegular.car,
                  label: 'License Class',
                  value: 'Class A',
                ),
                _ProfileItem(
                  icon: PhosphorIconsRegular.shield,
                  label: 'Endorsements',
                  value: 'Hazmat, Passenger',
                ),
              ],
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 16),
            
            // Company Information (only for company drivers)
            if (driver.isCompanyDriver && companyInfo != null) ...[
              _ProfileSection(
                title: 'Employment Information',
                items: [
                  _ProfileItem(
                    icon: PhosphorIconsRegular.buildings,
                    label: 'Company',
                    value: companyInfo.name,
                  ),
                  _ProfileItem(
                    icon: PhosphorIconsRegular.hash,
                    label: 'DOT Number',
                    value: companyInfo.dotNumber,
                  ),
                  _ProfileItem(
                    icon: PhosphorIconsRegular.briefcase,
                    label: 'Position',
                    value: driver.companyAssociation!.position,
                  ),
                  _ProfileItem(
                    icon: PhosphorIconsRegular.calendar,
                    label: 'Hire Date',
                    value: '${driver.companyAssociation!.hireDate.month}/${driver.companyAssociation!.hireDate.day}/${driver.companyAssociation!.hireDate.year}',
                  ),
                  if (driver.companyAssociation!.supervisorName != null)
                    _ProfileItem(
                      icon: PhosphorIconsRegular.user,
                      label: 'Supervisor',
                      value: driver.companyAssociation!.supervisorName!,
                    ),
                ],
              ).animate().fadeIn(delay: 525.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 16),
            ],
            
            _ProfileSection(
              title: 'Emergency Contact',
              items: [
                if (driver.emergencyContactName != null)
                  _ProfileItem(
                    icon: PhosphorIconsRegular.user,
                    label: 'Name',
                    value: driver.emergencyContactName!,
                  ),
                if (driver.emergencyContactPhone != null)
                  _ProfileItem(
                    icon: PhosphorIconsRegular.phone,
                    label: 'Phone',
                    value: driver.emergencyContactPhone!,
                  ),
                _ProfileItem(
                  icon: PhosphorIconsRegular.heart,
                  label: 'Relationship',
                  value: 'Spouse',
                ),
              ],
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to edit profile
                },
                icon: Icon(PhosphorIconsRegular.pencil),
                label: const Text('Edit Profile'),
              ),
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Show logout confirmation
                },
                icon: Icon(PhosphorIconsRegular.signOut),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorColor,
                  side: const BorderSide(color: AppColors.errorColor),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: item,
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}