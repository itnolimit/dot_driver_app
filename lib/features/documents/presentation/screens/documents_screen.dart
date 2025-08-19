import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/dummy_data.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedFilter = 'All';
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'title': 'Driver License',
      'type': 'License',
      'issueDate': '2022-03-20',
      'expiryDate': '2026-03-20',
      'status': 'Active',
      'fileSize': '2.4 MB',
      'lastModified': '2024-01-15',
    },
    {
      'id': '2',
      'title': 'Medical Certificate',
      'type': 'Medical',
      'issueDate': '2023-12-15',
      'expiryDate': '2024-12-15',
      'status': 'Expiring Soon',
      'fileSize': '1.8 MB',
      'lastModified': '2024-01-10',
    },
    {
      'id': '3',
      'title': 'Insurance Card',
      'type': 'Insurance',
      'issueDate': '2024-01-01',
      'expiryDate': '2025-06-30',
      'status': 'Active',
      'fileSize': '1.2 MB',
      'lastModified': '2024-01-08',
    },
    {
      'id': '4',
      'title': 'Vehicle Registration',
      'type': 'Registration',
      'issueDate': '2023-07-15',
      'expiryDate': '2025-07-15',
      'status': 'Active',
      'fileSize': '900 KB',
      'lastModified': '2024-01-05',
    },
    {
      'id': '5',
      'title': 'DOT Physical',
      'type': 'Medical',
      'issueDate': '2023-11-20',
      'expiryDate': '2025-11-20',
      'status': 'Active',
      'fileSize': '2.1 MB',
      'lastModified': '2024-01-03',
    },
  ];

  List<Map<String, dynamic>> get _filteredDocuments {
    List<Map<String, dynamic>> filtered = _documents;
    
    if (_selectedFilter != 'All') {
      filtered = filtered.where((doc) => doc['type'] == _selectedFilter).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((doc) => 
        doc['title'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? PhosphorIconsRegular.list : PhosphorIconsRegular.gridFour),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(PhosphorIconsRegular.funnel),
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search documents...',
                prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(PhosphorIconsRegular.x),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
          ),
          
          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              children: [
                'All',
                'License',
                'Medical',
                'Insurance',
                'Registration',
                'Certification',
              ].map((filter) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),
              )).toList(),
            ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.3, end: 0),
          ),
          
          const SizedBox(height: 16),
          
          // Documents List/Grid
          Expanded(
            child: _filteredDocuments.isEmpty
                ? _buildEmptyState()
                : _isGridView
                    ? _buildGridView()
                    : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddDocumentOptions();
        },
        icon: Icon(PhosphorIconsRegular.plus),
        label: const Text('Add Document'),
      ).animate().fadeIn(delay: 300.ms).scale(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.files,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'No documents found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first document to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/documents/scanner'),
            icon: Icon(PhosphorIconsRegular.camera),
            label: const Text('Scan Document'),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _filteredDocuments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = _filteredDocuments[index];
        return _DocumentListTile(
          document: doc,
          onTap: () => context.push('/documents/detail/${doc['id']}'),
          onShare: () => _shareDocument(doc),
          onMoreOptions: () => _showDocumentOptions(doc),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredDocuments.length,
      itemBuilder: (context, index) {
        final doc = _filteredDocuments[index];
        return _DocumentGridTile(
          document: doc,
          onTap: () => context.push('/documents/detail/${doc['id']}'),
          onShare: () => _shareDocument(doc),
          onMoreOptions: () => _showDocumentOptions(doc),
        ).animate().fadeIn(delay: (index * 100).ms).scale();
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter & Sort',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sort by',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Date Added',
                'Expiry Date',
                'Name',
                'Type',
              ].map((sort) => FilterChip(
                label: Text(sort),
                selected: false,
                onSelected: (selected) {
                  // TODO: Implement sorting
                },
              )).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Active',
                'Expiring Soon',
                'Expired',
              ].map((status) => FilterChip(
                label: Text(status),
                selected: false,
                onSelected: (selected) {
                  // TODO: Implement status filtering
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDocumentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Document',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(PhosphorIconsRegular.camera),
              title: const Text('Scan with Camera'),
              subtitle: const Text('Take a photo of your document'),
              onTap: () {
                Navigator.pop(context);
                context.push('/documents/scanner');
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.files),
              title: const Text('Upload from Gallery'),
              subtitle: const Text('Choose from your photo library'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery picker
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.file),
              title: const Text('Import PDF'),
              subtitle: const Text('Upload an existing PDF file'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement file picker
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareDocument(Map<String, dynamic> document) {
    final currentDriver = DummyData.currentDriver;
    
    if (currentDriver.isCompanyDriver) {
      _showCompanySharing(document);
    } else {
      _showIndependentSharing(document);
    }
  }

  void _showCompanySharing(Map<String, dynamic> document) {
    final currentDriver = DummyData.currentDriver;
    final companyInfo = DummyData.getCurrentDriverCompanyInfo();
    
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
            mainAxisSize: MainAxisSize.min,
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
                'Share Document',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share "${document['title']}" with others',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 24),
              
              // Company Sharing Section
              if (companyInfo != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                    border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            PhosphorIconsRegular.buildings,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Share with Company',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        companyInfo.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'DOT: ${companyInfo.dotNumber}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _shareWithCompany(document),
                          icon: Icon(PhosphorIconsRegular.shareNetwork),
                          label: Text(currentDriver.companyAssociation!.documentsSharedWithCompany 
                              ? 'Update Shared Document' 
                              : 'Share with Company'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Other Sharing Options
              Text(
                'Other Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _ShareOptionTile(
                      icon: PhosphorIconsRegular.envelope,
                      title: 'Email',
                      subtitle: 'Send via email',
                      onTap: () => _shareViaEmail(document),
                    ),
                    _ShareOptionTile(
                      icon: PhosphorIconsRegular.export,
                      title: 'Export PDF',
                      subtitle: 'Save to device storage',
                      onTap: () => _exportDocument(document),
                    ),
                    _ShareOptionTile(
                      icon: PhosphorIconsRegular.link,
                      title: 'Generate Link',
                      subtitle: 'Create shareable link',
                      onTap: () => _generateShareLink(document),
                    ),
                    _ShareOptionTile(
                      icon: PhosphorIconsRegular.qrCode,
                      title: 'QR Code',
                      subtitle: 'Generate QR code for quick sharing',
                      onTap: () => _generateQRCode(document),
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

  void _showIndependentSharing(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Document',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share "${document['title']}" with others',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            
            _ShareOptionTile(
              icon: PhosphorIconsRegular.envelope,
              title: 'Email',
              subtitle: 'Send via email',
              onTap: () => _shareViaEmail(document),
            ),
            _ShareOptionTile(
              icon: PhosphorIconsRegular.export,
              title: 'Export PDF',
              subtitle: 'Save to device storage',
              onTap: () => _exportDocument(document),
            ),
            _ShareOptionTile(
              icon: PhosphorIconsRegular.link,
              title: 'Generate Link',
              subtitle: 'Create shareable link',
              onTap: () => _generateShareLink(document),
            ),
            _ShareOptionTile(
              icon: PhosphorIconsRegular.qrCode,
              title: 'QR Code',
              subtitle: 'Generate QR code for quick sharing',
              onTap: () => _generateQRCode(document),
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentOptions(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document['title'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${document['type']} • ${document['fileSize']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            
            ListTile(
              leading: Icon(PhosphorIconsRegular.eye),
              title: const Text('View Document'),
              onTap: () {
                Navigator.pop(context);
                context.push('/documents/detail/${document['id']}');
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.shareNetwork),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareDocument(document);
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.pencil),
              title: const Text('Edit Details'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Edit functionality coming in Phase 2');
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(context);
                _exportDocument(document);
              },
            ),
            ListTile(
              leading: Icon(PhosphorIconsRegular.trash, color: AppColors.errorColor),
              title: Text('Delete', style: TextStyle(color: AppColors.errorColor)),
              onTap: () {
                Navigator.pop(context);
                _deleteDocument(document);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareWithCompany(Map<String, dynamic> document) {
    Navigator.pop(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share with Company'),
        content: Text('Share "${document['title']}" with your company? This will allow your supervisor to view this document.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar('Document shared with company successfully');
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _shareViaEmail(Map<String, dynamic> document) {
    Navigator.pop(context);
    _showSuccessSnackBar('Email sharing functionality coming in Phase 2');
  }

  void _exportDocument(Map<String, dynamic> document) {
    Navigator.pop(context);
    _showSuccessSnackBar('Document export functionality coming in Phase 2');
  }

  void _generateShareLink(Map<String, dynamic> document) {
    Navigator.pop(context);
    _showSuccessSnackBar('Link generation functionality coming in Phase 2');
  }

  void _generateQRCode(Map<String, dynamic> document) {
    Navigator.pop(context);
    _showSuccessSnackBar('QR code generation functionality coming in Phase 2');
  }

  void _deleteDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _documents.removeWhere((doc) => doc['id'] == document['id']);
              });
              _showSuccessSnackBar('Document deleted successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
      ),
    );
  }
}

class _ShareOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareOptionTile({
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

class _DocumentListTile extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onMoreOptions;

  const _DocumentListTile({
    required this.document,
    required this.onTap,
    required this.onShare,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(document['status']);
    
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
                  color: AppColors.getDocumentTypeColor(document['type']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getDocumentIcon(document['type']),
                  color: AppColors.getDocumentTypeColor(document['type']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document['title'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expires: ${document['expiryDate']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    Text(
                      document['fileSize'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textHint,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      document['status'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onShare,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            PhosphorIconsRegular.shareNetwork,
                            color: AppColors.textHint,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onMoreOptions,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            PhosphorIconsRegular.dotsThreeVertical,
                            color: AppColors.textHint,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
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
      case 'Active':
        return AppColors.successColor;
      case 'Expiring Soon':
        return AppColors.warningColor;
      case 'Expired':
        return AppColors.errorColor;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'License':
        return PhosphorIconsRegular.identificationCard;
      case 'Medical':
        return PhosphorIconsRegular.heartbeat;
      case 'Insurance':
        return PhosphorIconsRegular.shield;
      case 'Registration':
        return PhosphorIconsRegular.car;
      case 'Certification':
        return PhosphorIconsRegular.certificate;
      default:
        return PhosphorIconsRegular.file;
    }
  }
}

class _DocumentGridTile extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onMoreOptions;

  const _DocumentGridTile({
    required this.document,
    required this.onTap,
    required this.onShare,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(document['status']);
    
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
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.getDocumentTypeColor(document['type']).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getDocumentIcon(document['type']),
                      color: AppColors.getDocumentTypeColor(document['type']),
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onShare,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            PhosphorIconsRegular.shareNetwork,
                            color: AppColors.textHint,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: onMoreOptions,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            PhosphorIconsRegular.dotsThreeVertical,
                            color: AppColors.textHint,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                document['title'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                document['type'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        document['status'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
      case 'Active':
        return AppColors.successColor;
      case 'Expiring Soon':
        return AppColors.warningColor;
      case 'Expired':
        return AppColors.errorColor;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'License':
        return PhosphorIconsRegular.identificationCard;
      case 'Medical':
        return PhosphorIconsRegular.heartbeat;
      case 'Insurance':
        return PhosphorIconsRegular.shield;
      case 'Registration':
        return PhosphorIconsRegular.car;
      case 'Certification':
        return PhosphorIconsRegular.certificate;
      default:
        return PhosphorIconsRegular.file;
    }
  }
}