// Driver entity with company association support

class Driver {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? cdlNumber;
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? profilePhotoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerified;
  final bool isActive;
  
  // Company Association
  final DriverType driverType;
  final CompanyAssociation? companyAssociation;
  final List<String> sharedWithCompanies;
  final DriverPreferences preferences;

  const Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.cdlNumber,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.profilePhotoUrl,
    required this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
    required this.driverType,
    this.companyAssociation,
    this.sharedWithCompanies = const [],
    required this.preferences,
  });

  String get fullName => '$firstName $lastName';
  
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  
  bool get hasCompleteProfile {
    return cdlNumber != null &&
        dateOfBirth != null &&
        address != null &&
        emergencyContactName != null &&
        emergencyContactPhone != null;
  }
  
  bool get isIndependentDriver => driverType == DriverType.independent;
  
  bool get isCompanyDriver => driverType == DriverType.company;
  
  String? get currentCompanyName => companyAssociation?.companyName;
  
  String? get currentCompanyId => companyAssociation?.companyId;
  
  bool get hasActiveEmployment => 
    companyAssociation != null && 
    companyAssociation!.status == EmploymentStatus.active;
  
  bool get canShareWithCompanies => preferences.allowCompanySharing;

  Driver copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? cdlNumber,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? profilePhotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
    DriverType? driverType,
    CompanyAssociation? companyAssociation,
    List<String>? sharedWithCompanies,
    DriverPreferences? preferences,
  }) {
    return Driver(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cdlNumber: cdlNumber ?? this.cdlNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      driverType: driverType ?? this.driverType,
      companyAssociation: companyAssociation ?? this.companyAssociation,
      sharedWithCompanies: sharedWithCompanies ?? this.sharedWithCompanies,
      preferences: preferences ?? this.preferences,
    );
  }
}

enum DriverType {
  independent,
  company,
}

class CompanyAssociation {
  final String companyId;
  final String companyName;
  final String? companyDotNumber;
  final String position;
  final DateTime hireDate;
  final DateTime? terminationDate;
  final EmploymentStatus status;
  final String? supervisorName;
  final String? supervisorEmail;
  final String? supervisorPhone;
  final bool documentsSharedWithCompany;
  final List<String> sharedDocumentTypes;

  const CompanyAssociation({
    required this.companyId,
    required this.companyName,
    this.companyDotNumber,
    required this.position,
    required this.hireDate,
    this.terminationDate,
    required this.status,
    this.supervisorName,
    this.supervisorEmail,
    this.supervisorPhone,
    this.documentsSharedWithCompany = false,
    this.sharedDocumentTypes = const [],
  });

  bool get isActive => status == EmploymentStatus.active;
  
  int get yearsOfService {
    final endDate = terminationDate ?? DateTime.now();
    return endDate.difference(hireDate).inDays ~/ 365;
  }
  
  int get monthsOfService {
    final endDate = terminationDate ?? DateTime.now();
    return endDate.difference(hireDate).inDays ~/ 30;
  }
}

enum EmploymentStatus {
  active,
  terminated,
  suspended,
  onLeave,
}

class DriverPreferences {
  final bool allowCompanySharing;
  final bool autoShareNewDocuments;
  final bool receiveExpiryNotifications;
  final bool receiveCompanyUpdates;
  final bool allowLocationTracking;
  final int notificationDaysBefore;
  final List<String> preferredDocumentFormats;
  final bool enableBiometricLogin;
  final bool enableAutoBackup;
  final String preferredLanguage;

  const DriverPreferences({
    this.allowCompanySharing = true,
    this.autoShareNewDocuments = false,
    this.receiveExpiryNotifications = true,
    this.receiveCompanyUpdates = true,
    this.allowLocationTracking = false,
    this.notificationDaysBefore = 30,
    this.preferredDocumentFormats = const ['PDF'],
    this.enableBiometricLogin = false,
    this.enableAutoBackup = true,
    this.preferredLanguage = 'en',
  });

  DriverPreferences copyWith({
    bool? allowCompanySharing,
    bool? autoShareNewDocuments,
    bool? receiveExpiryNotifications,
    bool? receiveCompanyUpdates,
    bool? allowLocationTracking,
    int? notificationDaysBefore,
    List<String>? preferredDocumentFormats,
    bool? enableBiometricLogin,
    bool? enableAutoBackup,
    String? preferredLanguage,
  }) {
    return DriverPreferences(
      allowCompanySharing: allowCompanySharing ?? this.allowCompanySharing,
      autoShareNewDocuments: autoShareNewDocuments ?? this.autoShareNewDocuments,
      receiveExpiryNotifications: receiveExpiryNotifications ?? this.receiveExpiryNotifications,
      receiveCompanyUpdates: receiveCompanyUpdates ?? this.receiveCompanyUpdates,
      allowLocationTracking: allowLocationTracking ?? this.allowLocationTracking,
      notificationDaysBefore: notificationDaysBefore ?? this.notificationDaysBefore,
      preferredDocumentFormats: preferredDocumentFormats ?? this.preferredDocumentFormats,
      enableBiometricLogin: enableBiometricLogin ?? this.enableBiometricLogin,
      enableAutoBackup: enableAutoBackup ?? this.enableAutoBackup,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}