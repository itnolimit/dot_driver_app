import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/documents/presentation/screens/documents_screen.dart';
import '../../features/documents/presentation/screens/document_detail_screen.dart';
import '../../features/documents/presentation/screens/document_scanner_screen.dart';
import '../../features/documents/presentation/screens/pdf_viewer_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/employment/presentation/screens/employment_applications_screen.dart';
import '../../features/employment/presentation/screens/new_application_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/bottom_nav_scaffold.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/documents',
            name: 'documents',
            builder: (context, state) => const DocumentsScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: 'document-detail',
                builder: (context, state) {
                  final documentId = state.pathParameters['id']!;
                  return DocumentDetailScreen(documentId: documentId);
                },
              ),
              GoRoute(
                path: 'scanner',
                name: 'document-scanner',
                builder: (context, state) => const DocumentScannerScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/pdf-viewer',
            name: 'pdf-viewer',
            builder: (context, state) {
              final url = state.uri.queryParameters['url'] ?? '';
              final title = state.uri.queryParameters['title'] ?? 'PDF Document';
              return PdfViewerScreen(pdfUrl: url, title: title);
            },
          ),
          GoRoute(
            path: '/applications',
            name: 'applications',
            builder: (context, state) => const EmploymentApplicationsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'new-application',
                builder: (context, state) => const NewApplicationScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}