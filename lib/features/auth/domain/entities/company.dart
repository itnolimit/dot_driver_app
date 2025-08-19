class Company {
  final String id;
  final String name;
  final String dotNumber;
  final String mcNumber;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final String email;
  final String? website;
  final CompanyType type;
  final CompanyStatus status;
  final DateTime registrationDate;
  final String? contactPersonName;
  final String? contactPersonPhone;
  final String? contactPersonEmail;
  final CompanySettings settings;
  final List<String> driverIds;
  final CompanySubscription subscription;

  const Company({
    required this.id,
    required this.name,
    required this.dotNumber,
    required this.mcNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.email,
    this.website,
    required this.type,
    required this.status,
    required this.registrationDate,
    this.contactPersonName,
    this.contactPersonPhone,
    this.contactPersonEmail,
    required this.settings,
    this.driverIds = const [],
    required this.subscription,
  });

  String get fullAddress => '$address, $city, $state $zipCode';
  
  bool get isActive => status == CompanyStatus.active;
  
  bool get canManageDrivers => subscription.features.contains('driver_management');
  
  int get driverCount => driverIds.length;

  Company copyWith({
    String? id,
    String? name,
    String? dotNumber,
    String? mcNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? phone,
    String? email,
    String? website,
    CompanyType? type,
    CompanyStatus? status,
    DateTime? registrationDate,
    String? contactPersonName,
    String? contactPersonPhone,
    String? contactPersonEmail,
    CompanySettings? settings,
    List<String>? driverIds,
    CompanySubscription? subscription,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      dotNumber: dotNumber ?? this.dotNumber,
      mcNumber: mcNumber ?? this.mcNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      type: type ?? this.type,
      status: status ?? this.status,
      registrationDate: registrationDate ?? this.registrationDate,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      contactPersonPhone: contactPersonPhone ?? this.contactPersonPhone,
      contactPersonEmail: contactPersonEmail ?? this.contactPersonEmail,
      settings: settings ?? this.settings,
      driverIds: driverIds ?? this.driverIds,
      subscription: subscription ?? this.subscription,
    );
  }
}

enum CompanyType {
  trucking,
  logistics,
  delivery,
  passenger,
  freight,
  other,
}

enum CompanyStatus {
  active,
  inactive,
  suspended,
  pending,
}

class CompanySettings {
  final bool requireDriverApproval;
  final bool autoShareDocuments;
  final bool allowDriverDirectShare;
  final int documentRetentionDays;
  final bool enableRealTimeNotifications;
  final bool requireDocumentVerification;
  final List<String> requiredDocumentTypes;
  final bool enableGeofencing;
  final bool enableDriverTracking;

  const CompanySettings({
    this.requireDriverApproval = true,
    this.autoShareDocuments = false,
    this.allowDriverDirectShare = true,
    this.documentRetentionDays = 2555, // 7 years
    this.enableRealTimeNotifications = true,
    this.requireDocumentVerification = false,
    this.requiredDocumentTypes = const [
      'Driver License',
      'Medical Card',
      'Insurance',
    ],
    this.enableGeofencing = false,
    this.enableDriverTracking = false,
  });
}

class CompanySubscription {
  final String planId;
  final String planName;
  final double monthlyPrice;
  final DateTime startDate;
  final DateTime? endDate;
  final SubscriptionStatus status;
  final List<String> features;
  final int maxDrivers;
  final int maxDocuments;

  const CompanySubscription({
    required this.planId,
    required this.planName,
    required this.monthlyPrice,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.features,
    required this.maxDrivers,
    required this.maxDocuments,
  });

  bool get isActive => status == SubscriptionStatus.active;
  
  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());
  
  int get daysRemaining {
    if (endDate == null) return -1;
    return endDate!.difference(DateTime.now()).inDays;
  }
}

enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  suspended,
}