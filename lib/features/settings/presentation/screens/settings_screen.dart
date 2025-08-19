import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/services/offline_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  bool _autoBackupEnabled = true;
  
  final OfflineService _offlineService = OfflineService();
  String _cacheSize = 'Calculating...';
  int _pendingSyncCount = 0;
  DateTime? _lastSyncTime;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    try {
      final cacheSize = await _offlineService.getCacheSize();
      final pendingSync = await _offlineService.getPendingSyncCount();
      final lastSync = await _offlineService.getLastSyncTime();
      final online = await _offlineService.isOnline();
      
      if (mounted) {
        setState(() {
          _cacheSize = cacheSize;
          _pendingSyncCount = pendingSync;
          _lastSyncTime = lastSync;
          _isOnline = online;
        });
      }
    } catch (e) {
      print('Error loading storage info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _SettingsSection(
              title: 'Account',
              items: [
                _SettingsItem(
                  icon: PhosphorIconsRegular.user,
                  title: 'Profile Information',
                  subtitle: 'Update your personal details',
                  onTap: () {
                    // TODO: Navigate to profile edit
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.lock,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {
                    // TODO: Navigate to change password
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.shield,
                  title: 'Privacy Settings',
                  subtitle: 'Manage your privacy preferences',
                  onTap: () {
                    // TODO: Navigate to privacy settings
                  },
                ),
              ],
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Security Section
            _SettingsSection(
              title: 'Security',
              items: [
                _SettingsToggleItem(
                  icon: PhosphorIconsRegular.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint or face ID to sign in',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.deviceMobile,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add an extra layer of security',
                  onTap: () {
                    // TODO: Navigate to 2FA setup
                  },
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _SettingsSection(
              title: 'Notifications',
              items: [
                _SettingsToggleItem(
                  icon: PhosphorIconsRegular.bell,
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.warning,
                  title: 'Document Expiry Alerts',
                  subtitle: 'Get notified when documents expire',
                  onTap: () {
                    // TODO: Navigate to notification preferences
                  },
                ),
              ],
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // App Preferences Section
            _SettingsSection(
              title: 'App Preferences',
              items: [
                _SettingsToggleItem(
                  icon: PhosphorIconsRegular.moon,
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.globe,
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () {
                    // TODO: Navigate to language selection
                  },
                ),
                _SettingsToggleItem(
                  icon: PhosphorIconsRegular.cloudArrowUp,
                  title: 'Auto Backup',
                  subtitle: 'Automatically backup your data',
                  value: _autoBackupEnabled,
                  onChanged: (value) {
                    setState(() {
                      _autoBackupEnabled = value;
                    });
                  },
                ),
              ],
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Support Section
            _SettingsSection(
              title: 'Support',
              items: [
                _SettingsItem(
                  icon: PhosphorIconsRegular.question,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    // TODO: Navigate to help center
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.chatCircle,
                  title: 'Contact Support',
                  subtitle: 'Reach out to our support team',
                  onTap: () {
                    // TODO: Navigate to contact support
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.star,
                  title: 'Rate the App',
                  subtitle: 'Share your feedback',
                  onTap: () {
                    // TODO: Open app store rating
                  },
                ),
              ],
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // About Section
            _SettingsSection(
              title: 'About',
              items: [
                _SettingsItem(
                  icon: PhosphorIconsRegular.info,
                  title: 'About DOT Driver Files',
                  subtitle: 'Version ${AppConstants.appVersion}',
                  onTap: () {
                    // TODO: Show about dialog
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.fileText,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () {
                    // TODO: Open terms of service
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.shield,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    // TODO: Open privacy policy
                  },
                ),
              ],
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Storage & Data Section
            _SettingsSection(
              title: 'Storage & Data',
              items: [
                _SettingsItem(
                  icon: PhosphorIconsRegular.database,
                  title: 'Local Storage',
                  subtitle: 'Used: $_cacheSize',
                  onTap: () => _showStorageDetails(),
                ),
                _SettingsItem(
                  icon: _isOnline ? PhosphorIconsRegular.wifiHigh : PhosphorIconsRegular.wifiSlash,
                  title: 'Sync Status',
                  subtitle: _isOnline 
                      ? 'Online • $_pendingSyncCount pending'
                      : 'Offline • $_pendingSyncCount pending',
                  onTap: () => _showSyncDetails(),
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.cloudArrowUp,
                  title: 'Backup & Restore',
                  subtitle: 'Manage your data backups',
                  onTap: () => _showBackupOptions(),
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.broom,
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  onTap: () => _clearCache(),
                ),
              ],
            ).animate().fadeIn(delay: 650.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Developer Section (for testing)
            _SettingsSection(
              title: 'Developer (Testing)',
              items: [
                _SettingsItem(
                  icon: PhosphorIconsRegular.userSwitch,
                  title: 'Switch to Independent Driver',
                  subtitle: 'Test independent driver features',
                  onTap: () {
                    DummyData.switchToIndependentDriver();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switched to Independent Driver')),
                    );
                    setState(() {});
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.buildings,
                  title: 'Switch to Company Driver',
                  subtitle: 'Test company-employed driver features',
                  onTap: () {
                    DummyData.switchToCompanyDriver();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switched to Company Driver')),
                    );
                    setState(() {});
                  },
                ),
                _SettingsItem(
                  icon: PhosphorIconsRegular.truck,
                  title: 'Switch to Another Company Driver',
                  subtitle: 'Test different company association',
                  onTap: () {
                    DummyData.switchToAnotherCompanyDriver();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switched to Another Company Driver')),
                    );
                    setState(() {});
                  },
                ),
              ],
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showStorageDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Storage Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(PhosphorIconsRegular.database, color: AppColors.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Total Storage Used',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Text(
                          _cacheSize,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Breakdown',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _StorageItem(
                      icon: PhosphorIconsRegular.files,
                      title: 'Documents',
                      description: 'Scanned documents and PDFs',
                      size: '85% of total',
                    ),
                    _StorageItem(
                      icon: PhosphorIconsRegular.database,
                      title: 'Database',
                      description: 'Driver data and settings',
                      size: '10% of total',
                    ),
                    _StorageItem(
                      icon: PhosphorIconsRegular.image,
                      title: 'Cache & Thumbnails',
                      description: 'Temporary files and previews',
                      size: '5% of total',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSyncDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _isOnline ? PhosphorIconsRegular.wifiHigh : PhosphorIconsRegular.wifiSlash,
              color: _isOnline ? AppColors.successColor : AppColors.errorColor,
            ),
            const SizedBox(width: 12),
            Text(_isOnline ? 'Online' : 'Offline'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection Status: ${_isOnline ? "Connected" : "Disconnected"}'),
            const SizedBox(height: 8),
            Text('Pending Sync Items: $_pendingSyncCount'),
            const SizedBox(height: 8),
            Text('Last Sync: ${_lastSyncTime != null ? _formatDateTime(_lastSyncTime!) : "Never"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (_isOnline && _pendingSyncCount > 0)
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performSync();
              },
              child: const Text('Sync Now'),
            ),
        ],
      ),
    );
  }

  void _showBackupOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backup & Restore',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            
            ListTile(
              leading: Icon(PhosphorIconsRegular.downloadSimple),
              title: const Text('Create Backup'),
              subtitle: const Text('Export all your data'),
              onTap: () {
                Navigator.pop(context);
                _createBackup();
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.uploadSimple),
              title: const Text('Restore from Backup'),
              subtitle: const Text('Import previously saved data'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Restore functionality coming in Phase 2');
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.gear),
              title: const Text('Auto-Backup Settings'),
              subtitle: const Text('Configure automatic backups'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Auto-backup settings coming in Phase 2');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove temporary files and thumbnails. Your documents and data will not be affected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningColor,
            ),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _offlineService.clearCache();
        await _loadStorageInfo(); // Refresh storage info
        _showSuccessSnackBar('Cache cleared successfully');
      } catch (e) {
        _showErrorSnackBar('Error clearing cache: $e');
      }
    }
  }

  Future<void> _createBackup() async {
    try {
      _showSuccessSnackBar('Creating backup...');
      final backupPath = await _offlineService.createBackup();
      _showSuccessSnackBar('Backup created successfully at: $backupPath');
    } catch (e) {
      _showErrorSnackBar('Error creating backup: $e');
    }
  }

  Future<void> _performSync() async {
    try {
      _showSuccessSnackBar('Syncing data...');
      await _offlineService.performSync();
      await _loadStorageInfo(); // Refresh sync info
      _showSuccessSnackBar('Sync completed successfully');
    } catch (e) {
      _showErrorSnackBar('Sync failed: $e');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }
}

class _StorageItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String size;

  const _StorageItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Text(
            size,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: items.map((item) {
              final index = items.indexOf(item);
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(
        PhosphorIconsRegular.caretRight,
        color: AppColors.textHint,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}