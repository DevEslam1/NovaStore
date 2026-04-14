import 'package:dartz/dartz.dart';
import '../repositories/product_repository.dart';
import '../../../../shared/domain/entities/product.dart';
import '../../../../core/error/failures.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
