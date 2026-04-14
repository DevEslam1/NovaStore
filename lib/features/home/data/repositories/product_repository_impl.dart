import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:newstore/features/home/data/datasources/product_remote_datasource.dart';
import 'package:newstore/features/home/domain/repositories/product_repository.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/core/error/failures.dart';
import 'package:newstore/core/error/exceptions.dart';
import 'package:newstore/core/network/network_info.dart';

import 'package:newstore/core/utils/search_algorithm.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedProductsResult>> getProducts({
    int limit = 10,
    DocumentSnapshot? lastDoc,
    String? category,
    String? searchQuery,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection.'));
    }
    try {
      // If we're searching, we fetch a larger batch to allow our 
      // advanced ranking algorithm to work effectively on a wider dataset.
      final fetchLimit = (searchQuery != null && searchQuery.isNotEmpty) ? 50 : limit;

      final paginatedProducts = await remoteDataSource.getProducts(
        limit: fetchLimit,
        lastDoc: lastDoc,
        category: category,
        searchQuery: searchQuery,
      );

      List<Product> products = paginatedProducts.products;

      // Apply our advanced weighted search algorithm locally
      if (searchQuery != null && searchQuery.isNotEmpty) {
        products = SearchAlgorithm.filterAndRank(products, searchQuery);
      }

      return Right(PaginatedProductsResult(
        products: products,
        lastDoc: paginatedProducts.lastDoc,
        hasMore: paginatedProducts.hasMore,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection.'));
    }
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
