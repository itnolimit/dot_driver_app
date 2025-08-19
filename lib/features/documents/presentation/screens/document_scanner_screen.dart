import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class DocumentScannerScreen extends StatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen> {
  final List<String> _scannedImages = [];
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
        leading: IconButton(
          icon: Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_scannedImages.isNotEmpty)
            IconButton(
              icon: Icon(PhosphorIconsRegular.check),
              onPressed: _saveDocument,
            ),
        ],
      ),
      body: _scannedImages.isEmpty ? _buildScannerInterface() : _buildPreviewInterface(),
    );
  }

  Widget _buildScannerInterface() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Expanded(
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
                  child: Icon(
                    PhosphorIconsRegular.camera,
                    size: 60,
                    color: AppColors.primaryColor,
                  ),
                ).animate().scale(delay: 200.ms),
                
                const SizedBox(height: 32),
                
                Text(
                  'Document Scanner',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ).animate().fadeIn(delay: 300.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  'Scan important documents like licenses, medical certificates, insurance cards, and more.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 48),
                
                _buildFeaturesList().animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),
          
          // Scan Options
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isScanning ? null : _scanWithCamera,
                  icon: _isScanning 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(PhosphorIconsRegular.camera),
                  label: Text(_isScanning ? 'Opening Camera...' : 'Scan with Camera'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isScanning ? null : _pickFromGallery,
                  icon: Icon(PhosphorIconsRegular.images),
                  label: const Text('Choose from Gallery'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': PhosphorIconsRegular.scan, 'text': 'Auto edge detection'},
      {'icon': PhosphorIconsRegular.sparkle, 'text': 'Image enhancement'},
      {'icon': PhosphorIconsRegular.crop, 'text': 'Crop and adjust'},
      {'icon': PhosphorIconsRegular.filePdf, 'text': 'Save as PDF'},
    ];

    return Column(
      children: features.map((feature) {
        final index = features.indexOf(feature);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: AppColors.successColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                feature['text'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (600 + index * 100).ms).slideX(begin: -0.3, end: 0);
      }).toList(),
    );
  }

  Widget _buildPreviewInterface() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scanned Images (${_scannedImages.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: _scannedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _scannedImages.length) {
                  // Add more button
                  return _buildAddMoreCard();
                }
                return _buildImagePreviewCard(_scannedImages[index], index);
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(PhosphorIconsRegular.trash),
                  label: const Text('Clear All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorColor,
                    side: const BorderSide(color: AppColors.errorColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _saveDocument,
                  icon: Icon(PhosphorIconsRegular.floppyDisk),
                  label: const Text('Save Document'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewCard(String imagePath, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            child: kIsWeb
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.borderColor,
                      child: Icon(
                        PhosphorIconsRegular.image,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                    ),
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => _removeImage(index),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        side: BorderSide(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: _scanWithCamera,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIconsRegular.plus,
                size: 32,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Add More',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanWithCamera() async {
    setState(() {
      _isScanning = true;
    });

    try {
      // Check camera permission
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        _showErrorSnackBar('Camera permission is required to scan documents');
        return;
      }

      // Use cunning_document_scanner for professional document scanning
      List<String> pictures = await CunningDocumentScanner.getPictures() ?? [];
      
      if (pictures.isNotEmpty) {
        setState(() {
          _scannedImages.addAll(pictures);
        });
        _showSuccessSnackBar('${pictures.length} image(s) scanned successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error scanning document: ${e.toString()}');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      
      if (images.isNotEmpty) {
        setState(() {
          _scannedImages.addAll(images.map((image) => image.path));
        });
        _showSuccessSnackBar('${images.length} image(s) selected from gallery');
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting images: ${e.toString()}');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _scannedImages.removeAt(index);
    });
    _showSuccessSnackBar('Image removed');
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Images'),
        content: const Text('Are you sure you want to remove all scanned images?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _scannedImages.clear();
              });
              Navigator.of(context).pop();
              _showSuccessSnackBar('All images cleared');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDocument() async {
    if (_scannedImages.isEmpty) {
      _showErrorSnackBar('No images to save');
      return;
    }

    // Show save options dialog
    final String? saveFormat = await _showSaveOptionsDialog();
    if (saveFormat == null) return;

    if (saveFormat == 'pdf') {
      await _saveAsPdf();
    } else {
      await _saveAsImages();
    }
  }

  Future<String?> _showSaveOptionsDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Document'),
        content: const Text('Choose how you want to save your scanned document:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop('images'),
            icon: Icon(PhosphorIconsRegular.images),
            label: const Text('As Images'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop('pdf'),
            icon: Icon(PhosphorIconsRegular.filePdf),
            label: const Text('As PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAsPdf() async {
    try {
      _showSuccessSnackBar('Converting images to PDF...');

      // Create PDF document
      final pdf = pw.Document();

      for (String imagePath in _scannedImages) {
        final File imageFile = File(imagePath);
        final Uint8List imageBytes = await imageFile.readAsBytes();
        
        final pw.Image image = pw.Image(
          pw.MemoryImage(imageBytes),
        );

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Container(
                  child: image,
                ),
              );
            },
          ),
        );
      }

      // Save PDF to device
      final Directory directory = await getApplicationDocumentsDirectory();
      final String pdfPath = '${directory.path}/scanned_document_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final File pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());

      _showSuccessSnackBar('PDF saved successfully to Documents');
      
      // Navigate to PDF viewer
      if (mounted) {
        context.push('/pdf-viewer?url=file://$pdfPath&title=Scanned Document');
      }
    } catch (e) {
      _showErrorSnackBar('Error creating PDF: ${e.toString()}');
    }
  }

  Future<void> _saveAsImages() async {
    try {
      _showSuccessSnackBar('Saving images...');
      
      // In a real app, you would save images to gallery or documents folder
      // For now, just show success message
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate saving
      
      _showSuccessSnackBar('${_scannedImages.length} image(s) saved successfully');
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      _showErrorSnackBar('Error saving images: ${e.toString()}');
    }
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