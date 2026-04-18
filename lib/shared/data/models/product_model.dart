import 'package:newstore/shared/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.images,
    required super.category,
    required super.brand,
    required super.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, [String? documentId]) {
    return ProductModel(
      id: documentId ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images'] as List) 
          : [json['imageUrl'] as String? ?? ''],
      category: json['category'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'brand': brand,
      'stock': stock,
    };
  }
}
