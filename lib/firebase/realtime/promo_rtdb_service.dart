import 'package:firebase_database/firebase_database.dart';
import '../../core/error/exceptions.dart';

class PromoRtdbService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // ── Validate Promo Code ──
  Future<Map<String, dynamic>?> validatePromo(String code) async {
    try {
      final snapshot = await _database
          .ref()
          .child('promoCodes')
          .orderByChild('code')
          .equalTo(code.toUpperCase())
          .once();

      if (snapshot.snapshot.value == null) return null;

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      final promoEntry = data.entries.first;
      final promo = Map<String, dynamic>.from(promoEntry.value as Map);

      // ── Check Active ──
      if (promo['isActive'] != true) return null;

      // ── Check Expiry ──
      final expiryTimestamp = promo['expiryDate'];
      if (expiryTimestamp != null) {
        final expiryDate =
            DateTime.fromMillisecondsSinceEpoch(expiryTimestamp as int);
        if (expiryDate.isBefore(DateTime.now())) return null;
      }

      return promo;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get All Promo Codes ──
  Future<List<Map<String, dynamic>>> getAllPromoCodes() async {
    try {
      final snapshot = await _database.ref().child('promoCodes').once();
      if (snapshot.snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final promo = Map<String, dynamic>.from(e.value as Map);
        promo['id'] = e.key;
        return promo;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
