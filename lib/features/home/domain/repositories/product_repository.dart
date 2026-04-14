import 'package:dartz/dartz.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
}
