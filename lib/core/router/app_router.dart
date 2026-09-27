import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/shell/screens/main_shell_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/catalog/screens/service_catalog_screen.dart';
import '../../features/catalog/screens/select_service_screen.dart';
import '../../features/catalog/screens/packages_screen.dart';
import '../../features/pickup/screens/schedule_pickup_screen.dart';
import '../../features/pickup/screens/pickup_scheduled_screen.dart';
import '../../features/address/screens/address_screen.dart';
import '../../features/address/screens/address_form_screen.dart';
import '../../features/address/screens/select_address_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/payment/screens/payment_screen.dart';
import '../../features/tracking/screens/order_tracking_screen.dart';
import '../../features/tracking/screens/order_success_screen.dart';
import '../../features/tracking/screens/order_tracking_vertical_screen.dart';
import '../../features/tracking/screens/order_tracking_horizontal_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/orders/screens/order_details_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/offers/screens/offers_screen.dart';
import '../../features/support/screens/support_settings_screen.dart';
import '../../features/support/screens/contact_us_screen.dart';
import '../../features/support/screens/settings_screen.dart';
import '../../features/support/screens/about_us_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // 1. Onboarding/Splash
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // 2. Login/Signup
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
    ),

    // 5. Select Service
    GoRoute(
      path: '/select-service',
      name: 'select-service',
      builder: (context, state) => const SelectServiceScreen(),
    ),

    // Catalog & Sub-routes
    GoRoute(
      path: '/catalog',
      name: 'catalog',
      builder: (context, state) => const ServiceCatalogScreen(),
    ),
    GoRoute(
      path: '/catalog/:serviceId',
      name: 'catalog-service',
      builder: (context, state) {
        final serviceId = state.pathParameters['serviceId'];
        return ServiceCatalogScreen(serviceId: serviceId);
      },
    ),

    // 6. Schedule Pickup
    GoRoute(
      path: '/schedule',
      name: 'schedule',
      builder: (context, state) => const SchedulePickupScreen(),
    ),

    // 7. Pickup Address (form)
    GoRoute(
      path: '/address-form',
      name: 'address-form',
      builder: (context, state) => const AddressFormScreen(),
    ),

    // 8. Select Address (saved)
    GoRoute(
      path: '/select-address',
      name: 'select-address',
      builder: (context, state) => const SelectAddressScreen(),
    ),
    GoRoute(
      path: '/address',
      name: 'address',
      builder: (context, state) => const SelectAddressScreen(),
    ),

    // 9. Cart
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),

    // 10. Payment
    GoRoute(
      path: '/payment',
      name: 'payment',
      builder: (context, state) => const PaymentScreen(),
    ),

    // 11. Order Success
    GoRoute(
      path: '/order-success/:orderId',
      name: 'order-success',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'];
        return OrderSuccessScreen(orderId: orderId);
      },
    ),

    // 12. Pickup Scheduled (confirm)
    GoRoute(
      path: '/pickup-scheduled',
      name: 'pickup-scheduled',
      builder: (context, state) => const PickupScheduledScreen(),
    ),

    // 13. Order Tracking (vertical timeline)
    GoRoute(
      path: '/tracking-vertical/:orderId',
      name: 'tracking-vertical',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'];
        return OrderTrackingVerticalScreen(orderId: orderId);
      },
    ),

    // 14. Order Tracking (horizontal variant)
    GoRoute(
      path: '/tracking-horizontal/:orderId',
      name: 'tracking-horizontal',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'];
        return OrderTrackingHorizontalScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/tracking',
      name: 'tracking',
      builder: (context, state) => const OrderTrackingScreen(),
    ),
    GoRoute(
      path: '/tracking/:orderId',
      name: 'tracking-order',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'];
        return OrderTrackingScreen(orderId: orderId);
      },
    ),

    // 15. Order Details
    GoRoute(
      path: '/order-details/:orderId',
      name: 'order-details',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'];
        return OrderDetailsScreen(orderId: orderId);
      },
    ),

    // 16. Packages
    GoRoute(
      path: '/packages',
      name: 'packages',
      builder: (context, state) => const PackagesScreen(),
    ),

    // 19. Settings
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // 20. Contact Us
    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: '/support',
      name: 'support',
      builder: (context, state) => const ContactUsScreen(),
    ),

    // 21. About Us
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutUsScreen(),
    ),

    // Main Shell with Persistent Bottom Navigation Bar (3. Home, Orders, Offers, Profile)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShellScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/orders',
          name: 'orders',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OrderHistoryScreen(),
          ),
        ),
        GoRoute(
          path: '/offers',
          name: 'offers',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OffersScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
  ],
);
