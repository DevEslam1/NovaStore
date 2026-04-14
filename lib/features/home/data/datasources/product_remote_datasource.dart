import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/data/models/product_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await firestore.collection(ApiEndpoints.products).get();
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();
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
