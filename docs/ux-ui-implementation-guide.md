# UX/UI Implementation Guide - Company Driver Features

## 🎨 Visual Design System

### Screen Mockups & Implementation

---

## 1. Company Connection Status Banner

### When Driver is Connected to Company

```dart
// Location: Top of Dashboard Screen
CompanyConnectionBanner(
  height: 120,
  gradient: LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
  ),
  child: Row(
    children: [
      // Company Logo
      CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(company.logoUrl),
      ),
      SizedBox(width: 16),
      
      // Company Info
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Swift Transportation LLC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                SizedBox(width: 4),
                Text(
                  'Connected • Synced 2 min ago',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      
      // Action Buttons
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pending Requests Badge
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'Pending',
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    ],
  ),
)
```

---

## 2. Document Request Dashboard

### Main Screen Layout

```
┌─────────────────────────────────┐
│   Company Connection Banner      │
├─────────────────────────────────┤
│   Compliance Score Card          │
│   ┌───────────────────────┐     │
│   │  85% Compliant        │     │
│   │  [====------] 2 docs  │     │
│   └───────────────────────┘     │
├─────────────────────────────────┤
│   Quick Actions                  │
│   [📤 Upload] [📋 Requests]      │
├─────────────────────────────────┤
│   Pending Requests (3)           │
│   ┌───────────────────────┐     │
│   │ 🚨 CDL Renewal        │     │
│   │    Due in 2 days      │     │
│   └───────────────────────┘     │
│   ┌───────────────────────┐     │
│   │ ⚠️ Medical Certificate │     │
│   │    Due in 7 days      │     │
│   └───────────────────────┘     │
└─────────────────────────────────┘
```

### Implementation Code

```dart
class CompanyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Compliance Score Card
        Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Compliance Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getComplianceColor(85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '85%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 20,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
                SizedBox(height: 8),
                
                // Status Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '17 of 20 documents current',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => _navigateToCompliance(),
                      child: Text('View Details →'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Quick Actions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToUpload(),
                  icon: Icon(Icons.upload_file),
                  label: Text('Quick Upload'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _navigateToRequests(),
                  icon: Icon(Icons.assignment),
                  label: Text('All Requests'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Request List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              return DocumentRequestCard(
                request: pendingRequests[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
```

---

## 3. Document Request Card

### Visual Design

```dart
class DocumentRequestCard extends StatelessWidget {
  final DocumentRequest request;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToRequestDetail(request),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Priority Indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: _getPriorityColor(request.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getDocumentColor(request.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getDocumentIcon(request.type),
                  color: _getDocumentColor(request.type),
                ),
              ),
              SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _formatDueDate(request.dueDate),
                          style: TextStyle(
                            color: _getDueDateColor(request.dueDate),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _quickUpload(request),
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  tooltip: 'Quick Upload',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.normal:
        return Colors.blue;
      case Priority.low:
        return Colors.grey;
    }
  }
  
  String _formatDueDate(DateTime dueDate) {
    final days = dueDate.difference(DateTime.now()).inDays;
    if (days < 0) return 'Overdue by ${-days} days';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }
}
```

---

## 4. Upload Wizard Flow

### Step-by-Step Upload Process

```dart
class UploadWizard extends StatefulWidget {
  final DocumentRequest request;
  
  @override
  _UploadWizardState createState() => _UploadWizardState();
}

class _UploadWizardState extends State<UploadWizard> {
  int currentStep = 0;
  File? selectedFile;
  Map<String, dynamic> metadata = {};
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload ${widget.request.title}'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: StepProgressIndicator(
            totalSteps: 4,
            currentStep: currentStep + 1,
            selectedColor: Theme.of(context).primaryColor,
            unselectedColor: Colors.grey[300],
            padding: 0,
            width: double.infinity,
            height: 4,
          ),
        ),
      ),
      body: IndexedStack(
        index: currentStep,
        children: [
          // Step 1: Instructions
          InstructionsStep(
            requirements: widget.request.specifications,
            onNext: () => setState(() => currentStep++),
          ),
          
          // Step 2: Capture/Select
          CaptureStep(
            onFileSelected: (file) {
              setState(() {
                selectedFile = file;
                currentStep++;
              });
            },
          ),
          
          // Step 3: Review & Metadata
          ReviewStep(
            file: selectedFile!,
            onMetadataComplete: (data) {
              setState(() {
                metadata = data;
                currentStep++;
              });
            },
          ),
          
          // Step 4: Submit
          SubmitStep(
            request: widget.request,
            file: selectedFile!,
            metadata: metadata,
            onSubmit: _handleSubmission,
          ),
        ],
      ),
    );
  }
}
```

---

## 5. Document Status Timeline

### Visual Status Tracker

```dart
class DocumentStatusTimeline extends StatelessWidget {
  final DocumentSubmission submission;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  submission.documentTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatusBadge(status: submission.status),
              ],
            ),
            SizedBox(height: 20),
            
            // Timeline
            Timeline(
              children: [
                TimelineItem(
                  title: 'Submitted',
                  subtitle: _formatDate(submission.submittedAt),
                  isCompleted: true,
                  icon: Icons.upload_file,
                ),
                TimelineItem(
                  title: 'Under Review',
                  subtitle: submission.reviewStartedAt != null 
                      ? _formatDate(submission.reviewStartedAt!)
                      : 'Pending',
                  isCompleted: submission.reviewStartedAt != null,
                  icon: Icons.visibility,
                ),
                TimelineItem(
                  title: submission.status == SubmissionStatus.approved 
                      ? 'Approved' 
                      : 'Decision Pending',
                  subtitle: submission.reviewCompletedAt != null
                      ? _formatDate(submission.reviewCompletedAt!)
                      : 'In progress',
                  isCompleted: submission.reviewCompletedAt != null,
                  icon: submission.status == SubmissionStatus.approved
                      ? Icons.check_circle
                      : Icons.pending,
                  color: submission.status == SubmissionStatus.approved
                      ? Colors.green
                      : submission.status == SubmissionStatus.rejected
                          ? Colors.red
                          : Colors.grey,
                ),
              ],
            ),
            
            // Rejection Reason (if applicable)
            if (submission.status == SubmissionStatus.rejected) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Rejection Reason',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      submission.rejectionReason ?? 'No reason provided',
                      style: TextStyle(color: Colors.red[800]),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _resubmitDocument(),
                      icon: Icon(Icons.refresh),
                      label: Text('Resubmit Document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Push Notification Handling

### In-App Notification Display

```dart
class NotificationHandler {
  static void showInAppNotification(
    BuildContext context,
    PushNotification notification,
  ) {
    showOverlay(
      context: context,
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getNotificationColor(notification.type),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (notification.actionable) ...[
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _handleNotificationAction(notification),
                    child: Text('View'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      duration: Duration(seconds: 5),
    );
  }
}
```

---

## 7. Compliance Dashboard

### Comprehensive Compliance View

```dart
class ComplianceDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Overall Score Header
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[900]!],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: 0.85,
                            strokeWidth: 12,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '85%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Compliant',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
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
          ),
          
          // Category Breakdown
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildListDelegate([
                ComplianceCategoryCard(
                  title: 'Licenses',
                  score: 100,
                  color: Colors.green,
                  icon: Icons.card_membership,
                ),
                ComplianceCategoryCard(
                  title: 'Medical',
                  score: 75,
                  color: Colors.orange,
                  icon: Icons.medical_services,
                ),
                ComplianceCategoryCard(
                  title: 'Training',
                  score: 90,
                  color: Colors.blue,
                  icon: Icons.school,
                ),
                ComplianceCategoryCard(
                  title: 'Insurance',
                  score: 100,
                  color: Colors.purple,
                  icon: Icons.security,
                ),
              ]),
            ),
          ),
          
          // Upcoming Expirations
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Expirations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  ...upcomingExpirations.map((doc) => ExpirationCard(doc)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 8. Best Practices Implementation

### Responsive Layout Example

```dart
class ResponsiveDocumentGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate columns based on screen width
        int columns = 2;
        if (constraints.maxWidth > 600) columns = 3;
        if (constraints.maxWidth > 900) columns = 4;
        
        // Calculate aspect ratio based on screen height
        double aspectRatio = 1.5;
        if (MediaQuery.of(context).size.height < 700) {
          aspectRatio = 1.3; // More vertical space on small screens
        }
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return ResponsiveDocumentCard(
              document: documents[index],
            );
          },
        );
      },
    );
  }
}
```

### Offline-First Implementation

```dart
class OfflineAwareDocumentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state is DocumentOffline) {
          return Column(
            children: [
              // Offline Banner
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.orange[100],
                child: Row(
                  children: [
                    Icon(Icons.wifi_off, color: Colors.orange[800]),
                    SizedBox(width: 8),
                    Text(
                      'Offline Mode - Changes will sync when connected',
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                  ],
                ),
              ),
              
              // Local Data List
              Expanded(
                child: ListView.builder(
                  itemCount: state.localDocuments.length,
                  itemBuilder: (context, index) {
                    final doc = state.localDocuments[index];
                    return ListTile(
                      leading: Icon(Icons.description),
                      title: Text(doc.title),
                      subtitle: Text('Saved locally'),
                      trailing: doc.pendingSync
                          ? Icon(Icons.sync, color: Colors.orange)
                          : Icon(Icons.check, color: Colors.green),
                    );
                  },
                ),
              ),
            ],
          );
        }
        
        // Online mode UI...
        return OnlineDocumentList();
      },
    );
  }
}
```

---

## 9. Animation Examples

### Smooth Transitions

```dart
class AnimatedDocumentCard extends StatelessWidget {
  final Document document;
  final int index;
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Card(
              child: ListTile(
                leading: Hero(
                  tag: 'document_${document.id}',
                  child: Icon(Icons.description),
                ),
                title: Text(document.title),
                subtitle: Text(document.status),
                onTap: () => _navigateToDetail(document),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

---

## 10. Error Handling UI

### User-Friendly Error States

```dart
class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _getUserFriendlyError(error),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getUserFriendlyError(String error) {
    if (error.contains('network')) {
      return 'Please check your internet connection and try again.';
    } else if (error.contains('permission')) {
      return 'We need permission to access your camera/files.';
    } else if (error.contains('expired')) {
      return 'Your session has expired. Please login again.';
    }
    return 'We couldn\'t complete your request. Please try again.';
  }
}
```

---

*This guide provides comprehensive UX/UI implementation patterns for the company-driver integration features.*