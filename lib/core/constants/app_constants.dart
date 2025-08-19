class AppConstants {
  static const String appName = 'DOT Driver Files';
  static const String appVersion = '1.0.0';
  
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double circularRadius = 100.0;
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxDocuments = 100;
  
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];
  
  static const List<String> documentTypes = [
    'Driver License',
    'Medical Card',
    'Insurance',
    'Vehicle Registration',
    'DOT Physical',
    'Drug Test Results',
    'Training Certificate',
    'Employment Verification',
    'Background Check',
    'MVR Report',
    'Other'
  ];
  
  static const List<String> employmentPositions = [
    'OTR Driver',
    'Regional Driver',
    'Local Driver',
    'Owner Operator',
    'Team Driver',
    'Dedicated Driver',
    'Intermodal Driver',
    'Flatbed Driver',
    'Tanker Driver',
    'Hazmat Driver'
  ];
  
  static const Map<String, int> documentExpiryWarningDays = {
    'Driver License': 30,
    'Medical Card': 30,
    'Insurance': 15,
    'DOT Physical': 30,
    'Training Certificate': 60,
  };
}