import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  WebViewController? _webViewController;
  String? _pdfViewerUrl;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      // Create PDF viewer URL based on platform
      if (kIsWeb) {
        // For web, use Google Docs Viewer or PDF.js
        _pdfViewerUrl = 'https://docs.google.com/gview?url=${Uri.encodeComponent(widget.pdfUrl)}&embedded=true';
      } else {
        // For mobile, use Google Docs Viewer in WebView
        _pdfViewerUrl = 'https://docs.google.com/gview?url=${Uri.encodeComponent(widget.pdfUrl)}&embedded=true';
        
        // Initialize WebView controller
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                if (mounted) {
                  setState(() {
                    _isLoading = true;
                  });
                }
              },
              onPageFinished: (String url) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              onWebResourceError: (WebResourceError error) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(_pdfViewerUrl!));
      }
      
      // Simulate initial loading time
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.shareNetwork),
            onPressed: _sharePdf,
          ),
          IconButton(
            icon: Icon(PhosphorIconsRegular.download),
            onPressed: _downloadPdf,
          ),
          PopupMenuButton<String>(
            icon: Icon(PhosphorIconsRegular.dotsThreeVertical),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'open_external',
                child: Row(
                  children: [
                    Icon(PhosphorIconsRegular.arrowSquareOut),
                    SizedBox(width: 12),
                    Text('Open in Browser'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(PhosphorIconsRegular.printer),
                    SizedBox(width: 12),
                    Text('Print'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(PhosphorIconsRegular.info),
                    SizedBox(width: 12),
                    Text('Document Info'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_hasError) {
      return _buildErrorView();
    }

    return _buildPdfView();
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  PhosphorIconsRegular.filePdf,
                  size: 60,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ),
          ).animate().scale(delay: 200.ms),
          
          const SizedBox(height: 32),
          
          Text(
            'Loading PDF...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(delay: 400.ms),
          
          const SizedBox(height: 8),
          
          Text(
            'Please wait while we prepare your document',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                PhosphorIconsRegular.warning,
                size: 60,
                color: AppColors.errorColor,
              ),
            ).animate().scale(delay: 200.ms),
            
            const SizedBox(height: 32),
            
            Text(
              'Unable to Load PDF',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorColor,
                  ),
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 16),
            
            Text(
              'There was an error loading this document. Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 500.ms),
            
            const SizedBox(height: 32),
            
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _retryLoad,
                    icon: Icon(PhosphorIconsRegular.arrowClockwise),
                    label: const Text('Retry'),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openInBrowser,
                    icon: Icon(PhosphorIconsRegular.arrowSquareOut),
                    label: const Text('Open in Browser'),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfView() {
    return Column(
      children: [
        // PDF Info Card
        Container(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      PhosphorIconsRegular.filePdf,
                      color: AppColors.errorColor,
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
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PDF Document • Viewing in-app',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
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
                      'Live',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),
        ),
        
        // PDF Viewer
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              child: _buildPdfViewerWidget(),
            ),
          ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms),
        ),
        
        // Action Buttons
        Container(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _sharePdf,
                  icon: Icon(PhosphorIconsRegular.shareNetwork),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _downloadPdf,
                  icon: Icon(PhosphorIconsRegular.download),
                  label: const Text('Download'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openInBrowser,
                  icon: Icon(PhosphorIconsRegular.arrowSquareOut),
                  label: const Text('External'),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
        ),
      ],
    );
  }

  Widget _buildPdfViewerWidget() {
    if (kIsWeb) {
      // For web, use iframe through HTML
      return _buildWebPdfViewer();
    } else {
      // For mobile platforms, use WebView
      return _buildMobilePdfViewer();
    }
  }

  Widget _buildWebPdfViewer() {
    if (_pdfViewerUrl == null) {
      return _buildPdfViewerPlaceholder();
    }

    // For web, show a preview with link to open PDF
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              PhosphorIconsRegular.filePdf,
              size: 60,
              color: AppColors.errorColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PDF Ready to View',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Click below to open the PDF in a new tab',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final url = Uri.parse(_pdfViewerUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                      _showSuccessSnackBar('PDF opened in new tab');
                    }
                  } catch (e) {
                    _showErrorSnackBar('Error opening PDF: $e');
                  }
                },
                icon: Icon(PhosphorIconsRegular.arrowSquareOut),
                label: const Text('Open PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final url = Uri.parse(widget.pdfUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                      _showSuccessSnackBar('Direct PDF link opened');
                    }
                  } catch (e) {
                    _showErrorSnackBar('Error opening direct PDF: $e');
                  }
                },
                icon: Icon(PhosphorIconsRegular.link),
                label: const Text('Direct Link'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePdfViewer() {
    if (_webViewController == null) {
      return _buildPdfViewerPlaceholder();
    }

    return WebViewWidget(controller: _webViewController!);
  }

  Widget _buildPdfViewerPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.filePdf,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'PDF Viewer',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'In-app PDF viewing is now available!${kIsWeb ? '\nTap "External" to open in browser if needed.' : ''}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
          ),
          if (_pdfViewerUrl != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _loadPdf();
              },
              icon: Icon(PhosphorIconsRegular.arrowClockwise),
              label: const Text('Reload PDF'),
            ),
          ],
        ],
      ),
    );
  }

  void _retryLoad() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _loadPdf();
  }

  Future<void> _openInBrowser() async {
    try {
      final url = Uri.parse(widget.pdfUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        if (mounted) {
          _showSuccessSnackBar('Opening PDF in browser');
        }
      } else {
        if (mounted) {
          _showErrorSnackBar('Cannot open PDF URL');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error opening PDF: $e');
      }
    }
  }

  void _sharePdf() {
    // TODO: Implement PDF sharing
    _showSuccessSnackBar('Share functionality coming in Phase 2');
  }

  void _downloadPdf() {
    // TODO: Implement PDF download
    _showSuccessSnackBar('Download functionality coming in Phase 2');
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'open_external':
        _openInBrowser();
        break;
      case 'print':
        _showSuccessSnackBar('Print functionality coming in Phase 2');
        break;
      case 'info':
        _showDocumentInfo();
        break;
    }
  }

  void _showDocumentInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Title', widget.title),
            _buildInfoRow('Type', 'PDF Document'),
            _buildInfoRow('URL', widget.pdfUrl),
            _buildInfoRow('Status', 'Ready to View'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }
}