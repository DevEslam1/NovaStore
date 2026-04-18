import 'package:dartz/dartz.dart';
import 'package:newstore/core/error/failures.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import '../entities/favorite_item.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteItem>>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite(Product product);
  Future<Either<Failure, void>> clearFavorites();
}
