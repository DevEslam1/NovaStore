import '../../domain/entities/cart_item.dart';
import '../../../../shared/data/models/product_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.product,
    super.quantity = 1,
    super.variant,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      variant: json['variant'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
      'variant': variant,
    };
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      product: ProductModel(
        id: entity.product.id,
        name: entity.product.name,
        description: entity.product.description,
        price: entity.product.price,
        imageUrl: entity.product.imageUrl,
        category: entity.product.category,
        brand: entity.product.brand,
        stock: entity.product.stock,
      ),
      quantity: entity.quantity,
      variant: entity.variant,
    );
  }
}
