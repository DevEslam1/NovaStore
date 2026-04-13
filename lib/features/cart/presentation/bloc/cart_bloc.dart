import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newstore/features/cart/domain/entities/cart_item.dart';
import 'package:newstore/shared/domain/entities/product.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;
  final String? variant;
  const AddToCart(this.product, {this.variant});
  @override
  List<Object?> get props => [product, variant];
}

class RemoveFromCart extends CartEvent {
  final String productId;
  const RemoveFromCart(this.productId);
  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;
  const UpdateQuantity(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

// State
class CartState extends Equatable {
  final List<CartItem> items;
  const CartState({this.items = const []});

  double get totalPrice => items.fold(0, (total, item) => total + (item.product.price * item.quantity));

  @override
  List<Object?> get props => [items];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.product.id);
      
      if (index >= 0) {
        items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      } else {
        items.add(CartItem(product: event.product, variant: event.variant));
      }
      emit(CartState(items: items));
    });

    on<RemoveFromCart>((event, emit) {
      final items = state.items.where((i) => i.product.id != event.productId).toList();
      emit(CartState(items: items));
    });

    on<UpdateQuantity>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.productId);
      if (index >= 0) {
        if (event.quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index] = items[index].copyWith(quantity: event.quantity);
        }
        emit(CartState(items: items));
      }
    });
  }
}
