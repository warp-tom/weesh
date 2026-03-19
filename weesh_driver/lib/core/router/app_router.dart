import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:weesh_driver/features/auth/auth_controller.dart';
import 'package:weesh_driver/features/auth/presentation/splash_screen.dart';
import 'package:weesh_driver/features/auth/presentation/login_screen.dart';
import 'package:weesh_driver/features/home/presentation/driver_home_screen.dart';
import 'package:weesh_driver/features/dispatch/presentation/incoming_request_screen.dart';
import 'package:weesh_driver/features/dispatch/presentation/navigate_screen.dart';
import 'package:weesh_driver/features/delivery/presentation/parcel_camera_screen.dart';
import 'package:weesh_driver/features/earnings/presentation/earnings_screen.dart';
import 'package:weesh_driver/features/profile/presentation/settings_screen.dart';
import 'package:weesh_driver/features/profile/presentation/driver_rating_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuth = authState.valueOrNull?.session != null;
      final loc = state.matchedLocation;
      final isSplash = loc == '/splash';
      final isLogin = loc == '/login';

      if (isSplash) return null;
      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/incoming',
        builder: (context, state) => IncomingRequestScreen(
          weeshId: (state.extra as Map<String, dynamic>?)?['weeshId'] as String? ?? '',
        ),
      ),
      GoRoute(
        path: '/navigate',
        builder: (context, state) => const NavigateScreen(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const ParcelCameraScreen(),
      ),
      GoRoute(
        path: '/rating',
        builder: (context, state) => const DriverRatingScreen(),
      ),
    ],
  );
}
