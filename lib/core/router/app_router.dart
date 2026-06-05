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
import '../../features/orders/order_cancellation_screen.dart';
import '../../features/orders/order_history_screen.dart';
import '../../features/orders/order_status_screen.dart';
import '../../features/orders/tracking_map_screen.dart';
import '../../features/profile/about_screen.dart';
import '../../features/profile/address_screen.dart';
import '../../features/profile/app_settings_screen.dart';
import '../../features/profile/coupon_screen.dart';
import '../../features/profile/favourite_screen.dart';
import '../../features/profile/payment_history_screen.dart';
import '../../features/profile/personal_info_screen.dart';
import '../../features/profile/privacy_policy_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/rating/rating_screen.dart';
import '../../features/refer/refer_screen.dart';
import '../../features/restaurant/menu_list_screen.dart';
import '../../features/restaurant/restaurant_screen.dart';
import '../../features/restaurant/search_screen.dart';
import '../../features/splash/splash_screen.dart';

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
  static const String search = '/search';
  static const String favourites = '/favourites';
  static const String menuList = '/menu-list';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String paymentMethod = '/payment-method';
  static const String addCard = '/add-card';
  static const String orderCancellation = '/order-cancellation';
  static const String orderStatus = '/order-status';
  static const String orderHistory = '/order-history';
  static const String trackingMap = '/tracking-map';
  static const String addresses = '/addresses';
  static const String profile = '/profile';
  static const String privacyPolicy = '/privacy-policy';
  static const String about = '/about';
  static const String editProfile = '/edit-profile';
  static const String personalInfo = '/personal-info';
  static const String rating = '/rating';
  static const String review = '/review';
  static const String coupons = '/coupons';
  static const String refer = '/refer';
  static const String paymentHistory = '/payment-history';
  static const String appSettings = '/app-settings';
  static const String help = '/help';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final location = state.uri.toString();
      final isLoggedIn = LocalStorage.instance.isLoggedIn();
      // ── Auth routes ──
      final isAuthRoute = location == signIn ||
          location == signUp ||
          location == verifyEmail ||
          location == onboarding ||
          location == splash;

      if (!isLoggedIn && !isAuthRoute) return signIn;
      if (isLoggedIn && (location == signIn || location == signUp)) return home;
      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
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
        path: search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: favourites,
        name: 'favourites',
        builder: (context, state) => const FavouriteScreen(),
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
        path: orderCancellation,
        name: 'orderCancellation',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OrderCancellationScreen(
            orderId: extra?['orderId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: addresses,
        name: 'addresses',
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        path: orderStatus,
        name: 'orderStatus',
        builder: (context, state) => const OrderStatusScreen(),
      ),
      GoRoute(
        path: orderHistory,
        name: 'orderHistory',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: trackingMap,
        name: 'trackingMap',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TrackingMapScreen(
            orderId: extra?['orderId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: privacyPolicy,
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: about,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: personalInfo,
        name: 'personalInfo',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: rating,
        name: 'rating',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RatingScreen(
            restaurantId: extra?['restaurantId'] ?? 'house_of_bbq',
            restaurantName: extra?['restaurantName'] ?? 'House of BBQ',
            restaurantImage: extra?['restaurantImage'] ?? '',
          );
        },
      ),
      GoRoute(
        path: refer,
        name: 'refer',
        builder: (context, state) => const ReferScreen(),
      ),
      GoRoute(
        path: coupons,
        name: 'coupons',
        builder: (context, state) => const CouponScreen(),
      ),
      GoRoute(
        path: appSettings,
        name: 'appSettings',
        builder: (context, state) => const AppSettingsScreen(),
      ),
      GoRoute(
        path: paymentHistory,
        name: 'paymentHistory',
        builder: (context, state) => const PaymentHistoryScreen(),
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
