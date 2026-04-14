import 'package:dartz/dartz.dart';
import 'package:newstore/features/home/domain/repositories/product_repository.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/core/error/failures.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
