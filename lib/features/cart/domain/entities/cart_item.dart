import 'package:equatable/equatable.dart';
import 'package:newstore/shared/domain/entities/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final String? variant;

  const CartItem({
    required this.product,
    this.quantity = 1,
    this.variant,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? variant,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
    );
  }

  @override
  List<Object?> get props => [product, quantity, variant];
}
