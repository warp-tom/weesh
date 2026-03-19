import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weesh_mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:weesh_mobile/features/auth/presentation/screens/welcome_screen.dart';
import 'package:weesh_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:weesh_mobile/features/auth/presentation/screens/otp_screen.dart';
import 'package:weesh_mobile/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:weesh_mobile/features/core/presentation/screens/main_shell.dart';
import 'package:weesh_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:weesh_mobile/features/location/presentation/screens/location_search_screen.dart';
import 'package:weesh_mobile/features/home/presentation/screens/choose_chariot_screen.dart';
import 'package:weesh_mobile/features/core/presentation/screens/permission_priming_screen.dart';
import 'package:weesh_mobile/features/core/presentation/screens/notifications_screen.dart';
import 'package:weesh_mobile/features/core/presentation/screens/edit_profile_screen.dart';
import 'package:weesh_mobile/features/core/presentation/screens/help_center_screen.dart';
import 'package:weesh_mobile/features/home/presentation/screens/booking_confirmed_screen.dart';
import 'package:weesh_mobile/features/home/presentation/screens/driver_en_route_screen.dart';
import 'package:weesh_mobile/features/parcel/presentation/screens/parcel_service_type_screen.dart';
import 'package:weesh_mobile/features/parcel/presentation/screens/parcel_receiver_details_screen.dart';
import 'package:weesh_mobile/features/parcel/presentation/screens/parcel_tracking_screen.dart';
import 'package:weesh_mobile/features/pabili/presentation/screens/pabili_store_selection_screen.dart';
import 'package:weesh_mobile/features/pabili/presentation/screens/pabili_custom_list_screen.dart';
import 'package:weesh_mobile/features/pabili/presentation/screens/merchant_store_screen.dart';
import 'package:weesh_mobile/features/pabili/presentation/screens/product_detail_screen.dart';
import 'package:weesh_mobile/features/pabili/presentation/screens/cart_screen.dart';
import 'package:weesh_mobile/features/pabili/presentation/screens/checkout_screen.dart';
import 'package:weesh_mobile/features/ride/presentation/screens/active_ride_screen.dart';
import 'package:weesh_mobile/features/ride/presentation/screens/ride_invoice_screen.dart';
import 'package:weesh_mobile/features/ride/presentation/screens/ride_completion_screen.dart';
import 'package:weesh_mobile/features/wallet/presentation/screens/weesh_wallet_screen.dart';
import 'package:weesh_mobile/features/wallet/presentation/screens/cash_in_screen.dart';
import 'package:weesh_mobile/features/wallet/presentation/screens/promo_vouchers_screen.dart';
import 'package:weesh_mobile/features/wallet/presentation/screens/promo_card_detail_screen.dart';
import 'package:weesh_mobile/features/wallet/presentation/screens/weesh_pay_dashboard_screen.dart';
import 'package:weesh_mobile/features/ride/presentation/screens/safety_hub_screen.dart';
import 'package:weesh_mobile/features/history/presentation/screens/activity_history_screen.dart';
import 'package:weesh_mobile/features/chat/presentation/screens/chat_interface_screen.dart';
import 'package:weesh_mobile/features/settings/presentation/screens/emergency_contacts_screen.dart';
import 'package:weesh_mobile/features/social/presentation/screens/invite_friends_screen.dart';
import 'package:weesh_mobile/features/settings/presentation/screens/profile_settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorActivityKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellActivity');
final _shellNavigatorWalletKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellWallet');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    // Basic Auth GoRouter Guard
    // If the user is going into the app but has no session, redirect to welcome
    // If they have a session and hit splash, send them to home

    // Using a simple synchronous check here since this is triggered often.
    // Riverpod's authController handles the deeper stream listening.
    final session = Supabase.instance.client.auth.currentSession;
    final isAuth = session != null;

    final isGoingToAuthPaths = state.matchedLocation == '/splash' ||
        state.matchedLocation == '/welcome' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/otp';

    if (state.matchedLocation == '/splash') {
      return null; // Let splash screen handle initial logic if needed
    }

    if (!isAuth && !isGoingToAuthPaths) {
      return '/welcome';
    } else if (isAuth && isGoingToAuthPaths) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/help_center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/priming',
      builder: (context, state) => PermissionPrimingScreen(
        onAllow: () async {
          await Permission.locationWhenInUse.request();
          if (context.mounted) context.pop();
        },
        onSkip: () => context.pop(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OtpScreen(phone: phone);
      },
    ),
    GoRoute(
      path: '/location_search',
      builder: (context, state) => const LocationSearchScreen(),
    ),
    GoRoute(
      path: '/choose_chariot',
      builder: (context, state) => const ChooseChariotScreen(),
    ),
    GoRoute(
      path: '/booking_confirmed',
      builder: (context, state) => const BookingConfirmedScreen(),
    ),
    GoRoute(
      path: '/driver_en_route',
      builder: (context, state) => const DriverEnRouteScreen(),
    ),
    GoRoute(
      path: '/parcel_service_type',
      builder: (context, state) => const ParcelServiceTypeScreen(),
    ),
    GoRoute(
      path: '/parcel_receiver_details',
      builder: (context, state) => const ParcelReceiverDetailsScreen(),
    ),
    GoRoute(
      path: '/parcel_tracking',
      builder: (context, state) => const ParcelTrackingScreen(),
    ),
    GoRoute(
      path: '/pabili_store_selection',
      builder: (context, state) => const PabiliStoreSelectionScreen(),
    ),
    GoRoute(
      path: '/pabili_custom_list',
      builder: (context, state) => const PabiliCustomListScreen(),
    ),
    GoRoute(
      path: '/merchant_store',
      builder: (context, state) => const MerchantStoreScreen(),
    ),
    GoRoute(
      path: '/product_detail/:id',
      builder: (context, state) => const ProductDetailScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/active_ride',
      builder: (context, state) => const ActiveRideScreen(),
    ),
    GoRoute(
      path: '/invoice',
      builder: (context, state) => const RideInvoiceScreen(),
    ),
    GoRoute(
      path: '/ride_completion',
      builder: (context, state) => const RideCompletionScreen(),
    ),
    GoRoute(
      path: '/weesh_wallet',
      builder: (context, state) => const WeeshWalletScreen(),
    ),
    GoRoute(
      path: '/cash_in',
      builder: (context, state) => const CashInScreen(),
    ),
    GoRoute(
      path: '/weesh_pay_dashboard',
      builder: (context, state) => const WeeshPayDashboardScreen(),
    ),
    GoRoute(
      path: '/promo_vouchers',
      builder: (context, state) => const PromoVouchersScreen(),
    ),
    GoRoute(
      path: '/promo_detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PromoDetailScreen(id: id, extra: extra);
      },
    ),
    GoRoute(
      path: '/activity_history',
      builder: (context, state) => const ActivityHistoryScreen(),
    ),
    GoRoute(
      path: '/chat_interface',
      builder: (context, state) => const ChatInterfaceScreen(),
    ),
    GoRoute(
      path: '/emergency_contacts',
      builder: (context, state) => const EmergencyContactsScreen(),
    ),
    GoRoute(
      path: '/safety_hub',
      builder: (context, state) => const SafetyHubScreen(),
    ),
    GoRoute(
      path: '/invite_friends',
      builder: (context, state) => const InviteFriendsScreen(),
    ),
    GoRoute(
      path: '/profile_settings',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/profile_setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorActivityKey,
          routes: [
            GoRoute(
              path: '/activity',
              builder: (context, state) => const ActivityHistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorWalletKey,
          routes: [
            GoRoute(
              path: '/wallet',
              builder: (context, state) => const WeeshWalletScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileSettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    // Future routes will be added here
  ],
);
