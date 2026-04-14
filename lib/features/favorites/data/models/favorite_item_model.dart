import '../../domain/entities/favorite_item.dart';
import 'package:newstore/shared/data/models/product_model.dart';

class FavoriteItemModel extends FavoriteItem {
  const FavoriteItemModel({
    required super.product,
    required super.addedAt,
  });

  factory FavoriteItemModel.fromEntity(FavoriteItem entity) {
    return FavoriteItemModel(
      product: entity.product,
      addedAt: entity.addedAt,
    );
  }

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'category': product.category,
        'brand': product.brand,
        'stock': product.stock,
      },
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
