import '../../features/auth/domain/entities/driver.dart';

class DummyData {
  
  // Current user can be either independent or company driver
  static Driver currentDriver = independentDriver; // Change this to test different scenarios
  
  // Independent Driver Example
  static final Driver independentDriver = Driver(
    id: 'driver_001',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@email.com',
    phone: '+1 (555) 123-4567',
    cdlNumber: 'CDL123456789',
    dateOfBirth: DateTime(1985, 3, 15),
    address: '123 Main Street',
    city: 'Dallas',
    state: 'TX',
    zipCode: '75201',
    emergencyContactName: 'Jane Doe',
    emergencyContactPhone: '+1 (555) 987-6543',
    createdAt: DateTime(2023, 1, 15),
    isVerified: true,
    isActive: true,
    driverType: DriverType.independent,
    companyAssociation: null, // No company association
    sharedWithCompanies: [], // Not shared with any companies
    preferences: const DriverPreferences(
      allowCompanySharing: true,
      autoShareNewDocuments: false,
      receiveExpiryNotifications: true,
      receiveCompanyUpdates: false, // No company to receive updates from
      allowLocationTracking: false,
      enableBiometricLogin: true,
    ),
  );
  
  // Company Driver Example
  static final Driver companyDriver = Driver(
    id: 'driver_002',
    firstName: 'Sarah',
    lastName: 'Johnson',
    email: 'sarah.johnson@email.com',
    phone: '+1 (555) 234-5678',
    cdlNumber: 'CDL987654321',
    dateOfBirth: DateTime(1990, 7, 22),
    address: '456 Oak Avenue',
    city: 'Phoenix',
    state: 'AZ',
    zipCode: '85001',
    emergencyContactName: 'Michael Johnson',
    emergencyContactPhone: '+1 (555) 876-5432',
    createdAt: DateTime(2022, 8, 10),
    isVerified: true,
    isActive: true,
    driverType: DriverType.company,
    companyAssociation: CompanyAssociation(
      companyId: 'company_001',
      companyName: 'Swift Transportation',
      companyDotNumber: 'DOT123456',
      position: 'OTR Driver',
      hireDate: DateTime(2022, 9, 1),
      status: EmploymentStatus.active,
      supervisorName: 'Robert Smith',
      supervisorEmail: 'robert.smith@swift.com',
      supervisorPhone: '+1 (555) 111-2222',
      documentsSharedWithCompany: true,
      sharedDocumentTypes: [
        'Driver License',
        'Medical Card',
        'Insurance',
        'DOT Physical',
      ],
    ),
    sharedWithCompanies: ['company_001'], // Shared with current employer
    preferences: const DriverPreferences(
      allowCompanySharing: true,
      autoShareNewDocuments: true, // Auto-share with company
      receiveExpiryNotifications: true,
      receiveCompanyUpdates: true,
      allowLocationTracking: true, // Company may track location
      enableBiometricLogin: true,
    ),
  );
  
  // Another Company Driver Example
  static final Driver anotherCompanyDriver = Driver(
    id: 'driver_003',
    firstName: 'Mike',
    lastName: 'Wilson',
    email: 'mike.wilson@email.com',
    phone: '+1 (555) 345-6789',
    cdlNumber: 'CDL456789123',
    dateOfBirth: DateTime(1988, 11, 5),
    address: '789 Pine Street',
    city: 'Atlanta',
    state: 'GA',
    zipCode: '30301',
    emergencyContactName: 'Lisa Wilson',
    emergencyContactPhone: '+1 (555) 765-4321',
    createdAt: DateTime(2021, 3, 20),
    isVerified: true,
    isActive: true,
    driverType: DriverType.company,
    companyAssociation: CompanyAssociation(
      companyId: 'company_002',
      companyName: 'J.B. Hunt Transport',
      companyDotNumber: 'DOT789123',
      position: 'Regional Driver',
      hireDate: DateTime(2021, 4, 15),
      status: EmploymentStatus.active,
      supervisorName: 'Amanda Davis',
      supervisorEmail: 'amanda.davis@jbhunt.com',
      supervisorPhone: '+1 (555) 333-4444',
      documentsSharedWithCompany: true,
      sharedDocumentTypes: [
        'Driver License',
        'Medical Card',
        'Insurance',
        'Vehicle Registration',
        'Training Certificate',
      ],
    ),
    sharedWithCompanies: ['company_002'],
    preferences: const DriverPreferences(
      allowCompanySharing: true,
      autoShareNewDocuments: true,
      receiveExpiryNotifications: true,
      receiveCompanyUpdates: true,
      allowLocationTracking: true,
      enableBiometricLogin: false,
    ),
  );
  
  // Company Information for display purposes (read-only)
  static final Map<String, CompanyInfo> companyInfoMap = {
    'company_001': CompanyInfo(
      id: 'company_001',
      name: 'Swift Transportation',
      dotNumber: 'DOT123456',
      address: '2200 S 75th Ave, Phoenix, AZ 85043',
      phone: '+1 (602) 269-9700',
      website: 'www.swifttrans.com',
      logoUrl: 'https://example.com/swift-logo.png',
    ),
    'company_002': CompanyInfo(
      id: 'company_002',
      name: 'J.B. Hunt Transport',
      dotNumber: 'DOT789123',
      address: '615 J.B. Hunt Corporate Dr, Lowell, AR 72745',
      phone: '+1 (479) 820-0000',
      website: 'www.jbhunt.com',
      logoUrl: 'https://example.com/jbhunt-logo.png',
    ),
  };
  
  // Method to switch between driver types for testing
  static void switchToIndependentDriver() {
    currentDriver = independentDriver;
  }
  
  static void switchToCompanyDriver() {
    currentDriver = companyDriver;
  }
  
  static void switchToAnotherCompanyDriver() {
    currentDriver = anotherCompanyDriver;
  }
  
  // Get company info for current driver
  static CompanyInfo? getCurrentDriverCompanyInfo() {
    if (currentDriver.companyAssociation != null) {
      return companyInfoMap[currentDriver.companyAssociation!.companyId];
    }
    return null;
  }
}

// Simple company info for display in mobile app
class CompanyInfo {
  final String id;
  final String name;
  final String dotNumber;
  final String address;
  final String phone;
  final String? website;
  final String? logoUrl;

  const CompanyInfo({
    required this.id,
    required this.name,
    required this.dotNumber,
    required this.address,
    required this.phone,
    this.website,
    this.logoUrl,
  });
}