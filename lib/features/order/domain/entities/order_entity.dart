import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    totalAmount,
    status,
    createdAt,
    shippingAddress,
    paymentMethod,
  ];
}
