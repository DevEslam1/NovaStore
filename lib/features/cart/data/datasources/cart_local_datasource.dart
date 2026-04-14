import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCachedCart();
  Future<void> cacheCart(List<CartItem> cartItems);
  Future<void> clearCart();
}

const CACHED_CART = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCart(List<CartItem> cartItems) {
    final List<Map<String, dynamic>> cartJson = cartItems
        .map((item) => CartItemModel.fromEntity(item).toJson())
        .toList();
    
    return sharedPreferences.setString(
      CACHED_CART,
      json.encode(cartJson),
    );
  }

  @override
  Future<List<CartItemModel>> getCachedCart() {
    final jsonString = sharedPreferences.getString(CACHED_CART);
    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return Future.value(
        decodedJson.map((json) => CartItemModel.fromJson(json)).toList(),
      );
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> clearCart() {
    return sharedPreferences.remove(CACHED_CART);
  }
}
