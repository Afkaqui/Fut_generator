import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_form_screen.dart';
import '../../features/profile/presentation/screens/profile_select_screen.dart';
import '../../features/tramites/presentation/screens/tramite_list_screen.dart';
import '../../features/tramites/presentation/screens/tramite_detail_screen.dart';
import '../../features/pdf_generator/presentation/screens/pdf_preview_screen.dart';
import '../../features/pdf_generator/presentation/screens/signature_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProfileSelectScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final isOnboarding =
              state.uri.queryParameters['onboarding'] == 'true';
          return ProfileFormScreen(isOnboarding: isOnboarding);
        },
      ),
      GoRoute(
        path: '/tramites',
        builder: (context, state) => const TramiteListScreen(),
      ),
      GoRoute(
        path: '/tramite/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TramiteDetailScreen(tramiteId: id);
        },
      ),
      GoRoute(
        path: '/preview',
        builder: (context, state) {
          final pdfBytes = state.extra as List<int>;
          return PdfPreviewScreen(pdfBytes: pdfBytes);
        },
      ),
      GoRoute(
        path: '/signature',
        builder: (context, state) => const SignatureScreen(),
      ),
    ],
  );
}
