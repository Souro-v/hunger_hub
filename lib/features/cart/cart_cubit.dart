import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/food_item_model.dart';

class CartCubit extends Cubit<CartModel> {
  CartCubit()
      :  super(const CartModel(
    restaurantId: '',
    restaurantName: '',
    items: [],
  ));

  // ── Add Item ──
  void addItem(FoodItemModel foodItem) {
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((i) => i.foodItem.id == foodItem.id);
    if (index != -1) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
    } else {
      items.add(CartItemModel(foodItem: foodItem, quantity: 1));
    }
    emit(state.copyWith(items: items));
  }

  // ── Remove Item ──
  void removeItem(FoodItemModel foodItem) {
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((i) => i.foodItem.id == foodItem.id);
    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index] = items[index].copyWith(
          quantity: items[index].quantity - 1,
        );
      } else {
        items.removeAt(index);
      }
    }
    emit(state.copyWith(items: items));
  }

  // ── Delete Item ──
  void deleteItem(FoodItemModel foodItem) {
    final items = List<CartItemModel>.from(state.items);
    items.removeWhere((i) => i.foodItem.id == foodItem.id);
    emit(state.copyWith(items: items));
  }

  // ── Apply Promo ──
  void applyPromo(String code) {
    if (code == 'HUNGRY10') {
      emit(state.copyWith(promoCode: code, discount: 100));
    }
  }

  // ── Clear Cart ──
  void  clearCart() {
    emit(const CartModel(
      restaurantId: '',
      restaurantName: '',
      items: [],
    ));
  }
}