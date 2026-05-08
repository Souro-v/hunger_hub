class AppConstants {
  AppConstants._();

  // ── App Info ──
  static const String appName = 'HungryHub';
  static const String appVersion = '1.0.0';

  // ── Firebase Collections ──
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String ordersCollection = 'orders';
  static const String foodItemsCollection = 'foodItems';
  static const String categoriesCollection = 'categories';
  static const String reviewsCollection = 'reviews';

  // ── Firebase Storage Paths ──
  static const String restaurantImagesPath = 'restaurants/images';
  static const String foodItemImagesPath = 'foodItems/images';
  static const String userAvatarsPath = 'users/avatars';
  static const String iconsPath = 'icons';

  // ── Shared Preferences Keys ──
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';
  static const String isFirstTimeKey = 'is_first_time';
  static const String cartKey = 'cart_items';

  // ── Padding / Spacing ──
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // ── Border Radius ──
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 100.0;

  // ── Icon Sizes ──
  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;

  // ── Animation Duration ──
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ── Order Status ──
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderOnTheWay = 'on_the_way';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
}