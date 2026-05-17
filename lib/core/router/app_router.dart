import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/local_storage.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/auth/sign_up_screen.dart';
import '../../features/auth/verify_email_screen.dart';
import '../../features/auth/verify_phone_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/add_card_screen.dart';
import '../../features/checkout/payment_method_screen.dart';
import '../../features/delivery/delivery_address_screen.dart';
import '../../features/help/help_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/orders/order_status_screen.dart';
import '../../features/orders/tracking_map_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/rating/rating_screen.dart';
import '../../features/rating/review_screen.dart';
import '../../features/refer/refer_screen.dart';
import '../../features/restaurant/menu_list_screen.dart';
import '../../features/restaurant/restaurant_screen.dart';

class AppRouter {
  AppRouter._();

  // ── Route Names ──
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verifyEmail = '/verify-email';
  static const String verifyPhone = '/verify-phone';
  static const String otp = '/otp';
  static const String deliveryAddress = '/delivery-address';
  static const String home = '/home';
  static const String restaurant = '/restaurant';
  static const String menuList = '/menu-list';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String paymentMethod = '/payment-method';
  static const String addCard = '/add-card';
  static const String orderStatus = '/order-status';
  static const String trackingMap = '/tracking-map';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String rating = '/rating';
  static const String review = '/review';
  static const String refer = '/refer';
  static const String help = '/help';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final isLoggedIn = LocalStorage.instance.isLoggedIn();
      final isFirstTime = LocalStorage.instance.isFirstTime();
      final location = state.uri.toString();

      // ── Auth routes ──
      final isAuthRoute = location == signIn ||
          location == signUp ||
          location == verifyEmail ||
          location == verifyPhone ||
          location == otp ||
          location == onboarding ||
          location == splash;

      if (isFirstTime) return onboarding;
      if (!isLoggedIn && !isAuthRoute) return signIn;
      if (isLoggedIn && isAuthRoute) return home;
      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: signIn,
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: signUp,
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: verifyPhone,
        name: 'verifyPhone',
        builder: (context, state) => const VerifyPhoneScreen(),
      ),
      GoRoute(
        path: otp,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            verificationId: extra?['verificationId'] ?? '',
            phoneNumber: extra?['phoneNumber'] ?? '',
          );
        },
      ),
      GoRoute(
        path: deliveryAddress,
        name: 'deliveryAddress',
        builder: (context, state) => const DeliveryAddressScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: restaurant,
        name: 'restaurant',
        builder: (context, state) => const RestaurantScreen(),
      ),
      GoRoute(
        path: menuList,
        name: 'menuList',
        builder: (context, state) => const MenuListScreen(),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: addCard,
        name: 'addCard',
        builder: (context, state) => const AddCardScreen(),
      ),
      GoRoute(
        path: orderStatus,
        name: 'orderStatus',
        builder: (context, state) => const OrderStatusScreen(),
      ),
      GoRoute(
        path: trackingMap,
        name: 'trackingMap',
        builder: (context, state) => const TrackingMapScreen(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: rating,
        name: 'rating',
        builder: (context, state) => const RatingScreen(),
      ),
      GoRoute(
        path: review,
        name: 'review',
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: refer,
        name: 'refer',
        builder: (context, state) => const ReferScreen(),
      ),
      GoRoute(
        path: help,
        name: 'help',
        builder: (context, state) => const HelpScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}