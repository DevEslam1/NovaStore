import 'package:dartz/dartz.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/core/error/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginatedProductsResult {
  final List<Product> products;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;

  PaginatedProductsResult({
    required this.products,
    required this.lastDoc,
    required this.hasMore,
  });
}

abstract class ProductRepository {
  Future<Either<Failure, PaginatedProductsResult>> getProducts({int limit = 10, DocumentSnapshot? lastDoc});
  Future<Either<Failure, Product>> getProductById(String id);
}
