import 'package:dartz/dartz.dart';
import 'package:newstore/features/home/domain/repositories/product_repository.dart';
import 'package:newstore/core/error/failures.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, PaginatedProductsResult>> call({int limit = 10, DocumentSnapshot? lastDoc}) async {
    return await repository.getProducts(limit: limit, lastDoc: lastDoc);
  }
}
