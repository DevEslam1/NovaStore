import 'package:dartz/dartz.dart';
import '../datasources/product_remote_datasource.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../shared/domain/entities/product.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection.'));
    }
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
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
