# DOT Driver Files - Mobile App

A professional mobile application for drivers to manage their qualification documents and employment information.

## 📱 **App Overview**

This Flutter mobile app is designed for drivers who need to manage their documents and qualifications. It supports two types of users:

### 🚛 **User Types**

#### 1. **Independent Drivers**
- Self-employed drivers who manage their own documents
- Personal document storage and management
- No company association
- Full control over document sharing

#### 2. **Company Drivers** 
- Drivers employed by companies that use the DOTDriverFiles web system
- Connected to their employer's management system
- Can share documents with their company
- Company information displayed in the app

## 🔧 **Testing Driver Types**

The app includes a developer section in Settings to switch between different driver types for testing:

1. **Go to Settings** → Developer (Testing)
2. **Switch Driver Types:**
   - Independent Driver (John Doe)
   - Company Driver (Sarah Johnson - Swift Transportation)
   - Another Company Driver (Mike Wilson - J.B. Hunt)

## 🎨 **Key Features**

### **For All Drivers:**
- 📄 Document management (scan, store, organize)
- 📱 Mobile-first design with beautiful UI
- 🔒 Secure document storage
- 📅 Expiry tracking and notifications
- 👤 Profile management

### **For Company Drivers (Additional):**
- 🏢 Company information display
- 📊 Employment details
- 🤝 Document sharing with employer
- 👨‍💼 Supervisor contact information
- 📈 Service time tracking

## 🏗️ **Architecture**

### **Data Models**
- `Driver` - Core driver entity with company association support
- `CompanyAssociation` - Employment relationship details
- `DriverPreferences` - User preferences and sharing settings
- `CompanyInfo` - Read-only company information for display

### **Driver Types**
```dart
enum DriverType {
  independent,  // Self-employed drivers
  company,      // Company-employed drivers
}
```

### **Company Integration**
- Companies use the separate DOTDriverFiles web application
- Mobile app connects via REST API (Phase 2)
- Current implementation uses dummy data for testing

## 🚀 **Getting Started**

### **Prerequisites**
- Flutter SDK 3.9.0+
- Dart 3.0+
- CocoaPods (for iOS)

### **Installation**
```bash
# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on iOS Simulator
flutter run -d "iPhone 15"

# Run on macOS
flutter run -d macos
```

### **Testing Different Scenarios**

1. **Independent Driver Testing:**
   - Settings → Developer → Switch to Independent Driver
   - Notice: No company information displayed
   - Focus on personal document management

2. **Company Driver Testing:**
   - Settings → Developer → Switch to Company Driver
   - Notice: Company card on dashboard
   - Employment section in profile
   - Document sharing options

## 📋 **Current Status**

### ✅ **Phase 1 - Completed**
- [x] Clean architecture setup
- [x] Authentication UI (Login/Register/Forgot Password)
- [x] Dashboard with company information
- [x] Document management system
- [x] Profile with employment details
- [x] Settings with driver switching
- [x] Beautiful Material 3 design
- [x] Company association data models
- [x] Multi-platform support (Web, macOS, iOS ready)

### 🚧 **Phase 2 - Upcoming**
- [ ] REST API integration with DOTDriverFiles backend
- [ ] Document scanner with camera
- [ ] PDF viewer and conversion
- [ ] Real-time document sharing
- [ ] Push notifications
- [ ] Offline storage with SQLite

## 🎯 **Integration with DOTDriverFiles**

### **Company Management System**
- Companies use the web-based DOTDriverFiles system
- Manage driver qualifications and compliance
- View shared driver documents
- Track driver certifications and expiry dates

### **Mobile App Role**
- Driver's personal tool for document management
- Secure sharing with authorized companies
- Real-time updates to company systems
- Offline access to critical documents

## 🔒 **Security & Privacy**

- Documents stored locally with encryption
- Selective sharing with companies
- Driver controls what documents to share
- Biometric authentication support
- Privacy-first approach

## 📱 **Platform Support**

- ✅ **iOS** - iPhone and iPad
- ✅ **Android** - Phones and tablets  
- ✅ **Web** - Progressive Web App
- ✅ **macOS** - Desktop application
- ✅ **Windows** - Desktop application (future)

## 🎨 **Design System**

- **Primary Color:** Deep Blue (#1E3A8A) - Professional and trustworthy
- **Secondary Color:** Orange (#F97316) - Energy and action
- **Typography:** System fonts with clear hierarchy
- **Layout:** Card-based design with consistent spacing
- **Animations:** Smooth transitions and micro-interactions

## 📞 **Support**

For questions about integrating with DOTDriverFiles:
- Technical documentation available
- REST API endpoints documented
- Sample integration code provided

---

**Built with Flutter** 💙 | **Professional Driver Document Management** 🚛