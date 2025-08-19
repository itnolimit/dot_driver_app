class EmploymentApplication {
  final String id;
  final String driverId;
  final String companyName;
  final String position;
  final ApplicationStatus status;
  final DateTime submittedDate;
  final DateTime? reviewedDate;
  final List<String> attachedDocumentIds;
  final Map<String, dynamic> formData;
  final bool isDraft;
  final String? notes;
  final WorkHistory? previousExperience;
  final List<String> endorsements;
  final AvailabilityPreference availability;
  final double? expectedSalary;

  const EmploymentApplication({
    required this.id,
    required this.driverId,
    required this.companyName,
    required this.position,
    required this.status,
    required this.submittedDate,
    this.reviewedDate,
    this.attachedDocumentIds = const [],
    required this.formData,
    this.isDraft = false,
    this.notes,
    this.previousExperience,
    this.endorsements = const [],
    required this.availability,
    this.expectedSalary,
  });

  EmploymentApplication copyWith({
    String? id,
    String? driverId,
    String? companyName,
    String? position,
    ApplicationStatus? status,
    DateTime? submittedDate,
    DateTime? reviewedDate,
    List<String>? attachedDocumentIds,
    Map<String, dynamic>? formData,
    bool? isDraft,
    String? notes,
    WorkHistory? previousExperience,
    List<String>? endorsements,
    AvailabilityPreference? availability,
    double? expectedSalary,
  }) {
    return EmploymentApplication(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      companyName: companyName ?? this.companyName,
      position: position ?? this.position,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      reviewedDate: reviewedDate ?? this.reviewedDate,
      attachedDocumentIds: attachedDocumentIds ?? this.attachedDocumentIds,
      formData: formData ?? this.formData,
      isDraft: isDraft ?? this.isDraft,
      notes: notes ?? this.notes,
      previousExperience: previousExperience ?? this.previousExperience,
      endorsements: endorsements ?? this.endorsements,
      availability: availability ?? this.availability,
      expectedSalary: expectedSalary ?? this.expectedSalary,
    );
  }
}

enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
  withdrawn,
}

class WorkHistory {
  final String companyName;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final String? reasonForLeaving;
  final String? supervisorName;
  final String? supervisorContact;
  final double? milesDrivern;
  final List<String> equipmentTypes;

  const WorkHistory({
    required this.companyName,
    required this.position,
    required this.startDate,
    this.endDate,
    this.reasonForLeaving,
    this.supervisorName,
    this.supervisorContact,
    this.milesDrivern,
    this.equipmentTypes = const [],
  });

  bool get isCurrentJob => endDate == null;
  
  int get yearsOfExperience {
    final end = endDate ?? DateTime.now();
    return end.difference(startDate).inDays ~/ 365;
  }
}

class AvailabilityPreference {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final bool overnightRuns;
  final bool regionalRuns;
  final bool localRuns;
  final bool otrRuns;
  final DateTime? availableStartDate;

  const AvailabilityPreference({
    this.monday = true,
    this.tuesday = true,
    this.wednesday = true,
    this.thursday = true,
    this.friday = true,
    this.saturday = false,
    this.sunday = false,
    this.overnightRuns = true,
    this.regionalRuns = true,
    this.localRuns = true,
    this.otrRuns = true,
    this.availableStartDate,
  });
}