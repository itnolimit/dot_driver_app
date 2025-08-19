enum DocumentType { license, medical, insurance, registration, certification, training, other }
enum DocumentStatus { active, expired, expiring, pending, revoked }

class Document {
  final String id;
  final String driverId;
  final DocumentType type;
  final String title;
  final String? description;
  final DateTime? expiryDate;
  final DateTime? issueDate;
  final String? issuer;
  final String? documentNumber;
  final String filePath;
  final String? fileName;
  final String? mimeType;
  final String? thumbnailPath;
  final List<String> tags;
  final DateTime uploadDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastModified;
  final int fileSize;
  final String fileExtension;
  final bool isVerified;
  final String? notes;
  final DocumentStatus status;
  final bool isSharedWithCompany;
  final List<String> sharedCompanies;
  final Map<String, dynamic> metadata;

  const Document({
    required this.id,
    required this.driverId,
    required this.type,
    required this.title,
    this.description,
    this.expiryDate,
    this.issueDate,
    this.issuer,
    this.documentNumber,
    required this.filePath,
    this.fileName,
    this.mimeType,
    this.thumbnailPath,
    this.tags = const [],
    required this.uploadDate,
    required this.createdAt,
    required this.updatedAt,
    this.lastModified,
    required this.fileSize,
    required this.fileExtension,
    this.isVerified = false,
    this.notes,
    this.status = DocumentStatus.active,
    this.isSharedWithCompany = false,
    this.sharedCompanies = const [],
    this.metadata = const {},
  });

  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  String get formattedFileSize {
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = fileSize.toDouble();
    var unitIndex = 0;
    
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    
    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  Document copyWith({
    String? id,
    String? driverId,
    DocumentType? type,
    String? title,
    String? description,
    DateTime? expiryDate,
    DateTime? issueDate,
    String? issuer,
    String? documentNumber,
    String? filePath,
    String? fileName,
    String? mimeType,
    String? thumbnailPath,
    List<String>? tags,
    DateTime? uploadDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastModified,
    int? fileSize,
    String? fileExtension,
    bool? isVerified,
    String? notes,
    DocumentStatus? status,
    bool? isSharedWithCompany,
    List<String>? sharedCompanies,
    Map<String, dynamic>? metadata,
  }) {
    return Document(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      expiryDate: expiryDate ?? this.expiryDate,
      issueDate: issueDate ?? this.issueDate,
      issuer: issuer ?? this.issuer,
      documentNumber: documentNumber ?? this.documentNumber,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      tags: tags ?? this.tags,
      uploadDate: uploadDate ?? this.uploadDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastModified: lastModified ?? this.lastModified,
      fileSize: fileSize ?? this.fileSize,
      fileExtension: fileExtension ?? this.fileExtension,
      isVerified: isVerified ?? this.isVerified,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isSharedWithCompany: isSharedWithCompany ?? this.isSharedWithCompany,
      sharedCompanies: sharedCompanies ?? this.sharedCompanies,
      metadata: metadata ?? this.metadata,
    );
  }
}