import 'package:firebase_database/firebase_database.dart';

class SeedData {
  SeedData._();

  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static Future<void> seedAll() async {
    await seedCategories();
    await seedRestaurants();
    await seedPromoCodes();
    print('✅ All data seeded successfully!');
  }

  // ── Categories ──
  static Future<void> seedCategories() async {
    final categories = {
      'cat_nonveg': {
        'name': 'Non Veg',
        'iconUrl': 'assets/icons/cat_nonveg.png',
      },
      'cat_veg': {
        'name': 'Veg',
        'iconUrl': 'assets/icons/cat_veg.png',
      },
      'cat_spicy': {
        'name': 'Spicy',
        'iconUrl': 'assets/icons/cat_spicy.png',
      },
      'cat_pizza': {
        'name': 'Pizza',
        'iconUrl': 'assets/icons/cat_pizza.png',
      },
    };

    await _database.ref().child('categories').set(categories);
    print('✅ Categories seeded!');
  }

  // ── Restaurants ──
  static Future<void> seedRestaurants() async {
    final restaurants = {
      'rest_001': {
        'name': 'Arabian Restaurant',
        'description':
        'Authentic Arabian cuisine with the finest ingredients',
        'imageUrl': 'assets/images/rest1.png',
        'category': 'Chinese',
        'rating': 4.0,
        'totalReviews': 127,
        'address': 'Peelamedu, Coimbatore',
        'deliveryFee': 0.0,
        'deliveryTime': 45,
        'minimumOrder': 100.0,
        'isOpen': true,
        'tags': ['Arabian', 'Chinese', 'Biryani'],
      },
      'rest_002': {
        'name': 'Golden Restaurant',
        'description': 'Best Indian food in town',
        'imageUrl': 'assets/images/rest2.png',
        'category': 'Indian',
        'rating': 3.5,
        'totalReviews': 89,
        'address': 'Peelamedu, Coimbatore',
        'deliveryFee': 0.0,
        'deliveryTime': 25,
        'minimumOrder': 80.0,
        'isOpen': true,
        'tags': ['Indian', 'Curry', 'Rice'],
      },
      'rest_003': {
        'name': 'Italian Restaurants',
        'description': 'Authentic Italian pasta and noodles',
        'imageUrl': 'assets/images/rest3.png',
        'category': 'Chinese  Italian',
        'rating': 4.2,
        'totalReviews': 203,
        'address': 'Saibaba Colony, Coimbatore',
        'deliveryFee': 0.0,
        'deliveryTime': 32,
        'minimumOrder': 120.0,
        'isOpen': true,
        'tags': ['Italian', 'Chinese', 'Noodles'],
      },
      'rest_004': {
        'name': 'Huking Hub',
        'description': 'Best BBQ and grilled food',
        'imageUrl': 'assets/images/rest4.png',
        'category': 'Chinese  Italian  Indian',
        'rating': 4.2,
        'totalReviews': 156,
        'address': 'RS Puram, Coimbatore',
        'deliveryFee': 0.0,
        'deliveryTime': 32,
        'minimumOrder': 150.0,
        'isOpen': true,
        'tags': ['BBQ', 'Chinese', 'Italian'],
      },
      'rest_005': {
        'name': 'Star Grills',
        'description': 'Premium grilled chicken and seafood',
        'imageUrl': 'assets/images/rest5.png',
        'category': 'Chinese  Italyan  Indian',
        'rating': 4.6,
        'totalReviews': 312,
        'address': 'Gandhipuram, Coimbatore',
        'deliveryFee': 0.0,
        'deliveryTime': 54,
        'minimumOrder': 200.0,
        'isOpen': true,
        'tags': ['Grills', 'Chicken', 'Seafood'],
      },
      'rest_006': {
        'name': 'House of BBQ',
        'description': 'The best BBQ experience in town',
        'imageUrl': 'assets/images/rest8.png',
        'category': 'Chinese  Africian Deshi food',
        'rating': 4.6,
        'totalReviews': 445,
        'address': 'Peelamedu, Coimbatore',
        'deliveryFee': 0.0,
        'deliveryTime': 54,
        'minimumOrder': 180.0,
        'isOpen': true,
        'tags': ['BBQ', 'African', 'Deshi'],
      },
    };

    await _database.ref().child('restaurants').set(restaurants);

    // ── Seed Food Items ──
    await _seedFoodItems();
    print('✅ Restaurants seeded!');
  }

  // ── Food Items ──
  static Future<void> _seedFoodItems() async {
    final restaurantIds = [
      'rest_001',
      'rest_002',
      'rest_003',
      'rest_004',
      'rest_005',
      'rest_006',
    ];

    for (final restaurantId in restaurantIds) {
      final foodItems = {
        '${restaurantId}_food_001': {
          'restaurantId': restaurantId,
          'name': 'Gunpowder chicken wings',
          'description':
          'Chicken wings, green, spring onions, fresh mint, garlic',
          'imageUrl': 'assets/images/menu1.png',
          'price': 225.0,
          'rating': 4.5,
          'category': 'Non Veg',
          'isAvailable': true,
          'isPopular': true,
          'ingredients': ['chicken', 'spring onions', 'mint', 'garlic'],
        },
        '${restaurantId}_food_002': {
          'restaurantId': restaurantId,
          'name': 'Lamb and halloumi kebabs',
          'description':
          'Halloumi, lamb mince, lemon, rosemary, red onion',
          'imageUrl': 'assets/images/menu2.png',
          'price': 324.0,
          'rating': 4.5,
          'category': 'Non Veg',
          'isAvailable': true,
          'isPopular': true,
          'ingredients': ['halloumi', 'lamb', 'lemon', 'rosemary'],
        },
        '${restaurantId}_food_003': {
          'restaurantId': restaurantId,
          'name': 'Pepper houmous and turkey burgers',
          'description':
          'Turkey breast mince, new potatoes, rolls, lemon, peppers',
          'imageUrl': 'assets/images/menu3.png',
          'price': 199.0,
          'rating': 4.5,
          'category': 'Non Veg',
          'isAvailable': true,
          'isPopular': false,
          'ingredients': ['turkey', 'potatoes', 'peppers', 'lemon'],
        },
        '${restaurantId}_food_004': {
          'restaurantId': restaurantId,
          'name': 'Smash burgers',
          'description': 'Ground beef chuck, roll, black pepper',
          'imageUrl': 'assets/images/menu4.png',
          'price': 99.0,
          'rating': 4.5,
          'category': 'Non Veg',
          'isAvailable': true,
          'isPopular': true,
          'ingredients': ['beef', 'roll', 'black pepper'],
        },
        '${restaurantId}_food_005': {
          'restaurantId': restaurantId,
          'name': 'Teriyaki wings',
          'description':
          'Chicken wings, soy sauce, toasted sesame seeds, garlic',
          'imageUrl': 'assets/images/menu5.png',
          'price': 179.0,
          'rating': 4.5,
          'category': 'Non Veg',
          'isAvailable': true,
          'isPopular': false,
          'ingredients': ['chicken', 'soy sauce', 'sesame', 'garlic'],
        },
        '${restaurantId}_food_006': {
          'restaurantId': restaurantId,
          'name': 'Salmon skewers',
          'description':
          'Frozen boneless salmon fillets, skin removed, cut into 3cm chunks',
          'imageUrl': 'assets/images/menu6.png',
          'price': 299.0,
          'rating': 4.5,
          'category': 'Non Veg',
          'isAvailable': true,
          'isPopular': false,
          'ingredients': ['salmon', 'lemon', 'herbs'],
        },
      };

      await _database
          .ref()
          .child('foodItems/$restaurantId')
          .set(foodItems);
    }
  }

  // ── Promo Codes ──
  static Future<void> seedPromoCodes() async {
    final promoCodes = {
      'promo_001': {
        'code': 'HUNGRY10',
        'discountAmount': 100.0,
        'isActive': true,
        'expiryDate': DateTime.now()
            .add(const Duration(days: 30))
            .millisecondsSinceEpoch,
        'description': 'Get ৳100 off on your order',
      },
      'promo_002': {
        'code': 'WELCOME20',
        'discountAmount': 200.0,
        'isActive': true,
        'expiryDate': DateTime.now()
            .add(const Duration(days: 60))
            .millisecondsSinceEpoch,
        'description': 'Welcome offer - ৳200 off',
      },
      'promo_003': {
        'code': 'SAVE50',
        'discountAmount': 50.0,
        'isActive': true,
        'expiryDate': DateTime.now()
            .add(const Duration(days: 15))
            .millisecondsSinceEpoch,
        'description': 'Save ৳50 on your order',
      },
    };

    await _database.ref().child('promoCodes').set(promoCodes);
    print('✅ Promo codes seeded!');
  }
}