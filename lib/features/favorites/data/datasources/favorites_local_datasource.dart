import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item_model.dart';
import '../../domain/entities/favorite_item.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteItemModel>> getFavorites();
  Future<void> saveFavorites(List<FavoriteItem> favorites);
}

const kCachedFavorites = 'CACHED_FAVORITES';

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveFavorites(List<FavoriteItem> favorites) {
    final List<Map<String, dynamic>> favJson = favorites
        .map((item) => FavoriteItemModel.fromEntity(item).toJson())
        .toList();
    
    return sharedPreferences.setString(
      kCachedFavorites,
      json.encode(favJson),
    );
  }

  @override
  Future<List<FavoriteItemModel>> getFavorites() {
    final jsonString = sharedPreferences.getString(kCachedFavorites);
    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return Future.value(
        decodedJson.map((json) => FavoriteItemModel.fromJson(json)).toList(),
      );
    } else {
      return Future.value([]);
    }
  }
}
