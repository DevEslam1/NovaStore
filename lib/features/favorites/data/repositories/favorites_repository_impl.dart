import 'package:dartz/dartz.dart';
import 'package:newstore/core/error/failures.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';
import '../models/favorite_item_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FavoriteItem>>> getFavorites() async {
    try {
      final localFavorites = await localDataSource.getFavorites();
      return Right(localFavorites);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Product product) async {
    try {
      final favoritesList = await localDataSource.getFavorites();
      
      final index = favoritesList.indexWhere((item) => item.product.id == product.id);
      
      if (index >= 0) {
        // Exists, remove it
        favoritesList.removeAt(index);
      } else {
        // Doesn't exist, add it
        favoritesList.add(
          FavoriteItemModel(
            product: product,
            addedAt: DateTime.now(),
          ),
        );
      }
      
      await localDataSource.saveFavorites(favoritesList);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearFavorites() async {
    try {
      await localDataSource.saveFavorites([]);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
