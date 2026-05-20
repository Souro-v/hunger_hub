import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/error/exceptions.dart';

class PromoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Validate Promo Code ──
  Future<Map<String, dynamic>?> validatePromo(String code) async {
    try {
      final snapshot = await _firestore
          .collection('promoCodes')
          .where('code', isEqualTo: code.toUpperCase())
          .where('isActive', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final promo = snapshot.docs.first.data();
      final expiryDate = promo['expiryDate']?.toDate();

      // ── Check Expiry ──
      if (expiryDate != null && expiryDate.isBefore(DateTime.now())) {
        return null;
      }

      return promo;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}