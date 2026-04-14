import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newstore/core/constants/mock_data.dart';
import 'package:newstore/shared/data/models/product_model.dart';
import 'package:newstore/core/network/api_endpoints.dart';

class FirebaseSeeder {
  static Future<void> seedProducts() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection(ApiEndpoints.products);

    final allProducts = [
      ...MockData.flashDeals,
      ...MockData.recommended,
    ];

    for (final product in allProducts) {
      final model = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        category: product.category,
        brand: product.brand,
        stock: product.stock,
      );

      // Use set with merge: true to avoid duplicates if ID is the same
      // or to update details if they changed in mock data.
      await collection.doc(product.id).set(model.toJson(), SetOptions(merge: true));
    }
  }
}
