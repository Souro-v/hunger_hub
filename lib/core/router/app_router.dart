import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../storage/local_storage.dart';

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
  static const String home = '/home';
  static const String restaurant = '/restaurant';
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

      if (isFirstTime) return onboarding;
      if (!isLoggedIn) return signIn;
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
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Onboarding — Coming Soon')),
        ),
      ),
      GoRoute(
        path: signIn,
        name: 'signIn',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Sign In — Coming Soon')),
        ),
      ),
      GoRoute(
        path: signUp,
        name: 'signUp',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Sign Up — Coming Soon')),
        ),
      ),
      GoRoute(
        path: verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Verify Email — Coming Soon')),
        ),
      ),
      GoRoute(
        path: verifyPhone,
        name: 'verifyPhone',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Verify Phone — Coming Soon')),
        ),
      ),
      GoRoute(
        path: otp,
        name: 'otp',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('OTP — Coming Soon')),
        ),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home — Coming Soon')),
        ),
      ),
      GoRoute(
        path: restaurant,
        name: 'restaurant',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Restaurant — Coming Soon')),
        ),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Cart — Coming Soon')),
        ),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Checkout — Coming Soon')),
        ),
      ),
      GoRoute(
        path: paymentMethod,
        name: 'paymentMethod',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Payment Method — Coming Soon')),
        ),
      ),
      GoRoute(
        path: addCard,
        name: 'addCard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Add Card — Coming Soon')),
        ),
      ),
      GoRoute(
        path: orderStatus,
        name: 'orderStatus',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Order Status — Coming Soon')),
        ),
      ),
      GoRoute(
        path: trackingMap,
        name: 'trackingMap',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Tracking Map — Coming Soon')),
        ),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Profile — Coming Soon')),
        ),
      ),
      GoRoute(
        path: editProfile,
        name: 'editProfile',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Edit Profile — Coming Soon')),
        ),
      ),
      GoRoute(
        path: rating,
        name: 'rating',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Rating — Coming Soon')),
        ),
      ),
      GoRoute(
        path: review,
        name: 'review',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Review — Coming Soon')),
        ),
      ),
      GoRoute(
        path: refer,
        name: 'refer',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Refer — Coming Soon')),
        ),
      ),
      GoRoute(
        path: help,
        name: 'help',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Help — Coming Soon')),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}