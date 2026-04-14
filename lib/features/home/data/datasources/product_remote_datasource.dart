import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/data/models/product_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';

class PaginatedProducts {
  final List<ProductModel> products;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;

  PaginatedProducts({
    required this.products,
    required this.lastDoc,
    required this.hasMore,
  });
}

abstract class ProductRemoteDataSource {
  Future<PaginatedProducts> getProducts({
    int limit = 10,
    DocumentSnapshot? lastDoc,
    String? category,
    String? searchQuery,
  });
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  @override
  Future<PaginatedProducts> getProducts({
    int limit = 10,
    DocumentSnapshot? lastDoc,
    String? category,
    String? searchQuery,
  }) async {
    try {
      Query query = firestore
          .collection(ApiEndpoints.products);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        // We remove the restrictive Firestore prefix matching (startsWith).
        // Instead, we fetch products from the database and will apply our 
        // advanced local search algorithm in the repository to support 
        // substring matching and weighted ranking across title and description.
        query = query.orderBy('name');
      } else if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
        // By omitting orderBy('createdAt') here, we bypass the need for a 
        // manual composite index in Firebase Console during development.
        // If sorting is required later, we can re-add it and create the index.
      } else {
        // Default home page query (all products)
        query = query.orderBy('createdAt', descending: true);
      }

      query = query.limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return PaginatedProducts(
        products: products,
        lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore: products.length == limit,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await firestore.collection(ApiEndpoints.products).doc(id).get();
      if (!doc.exists) {
        throw const ServerException('Product not found.');
      }
      return ProductModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

