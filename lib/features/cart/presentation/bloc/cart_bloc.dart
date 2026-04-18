import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newstore/features/cart/domain/entities/cart_item.dart';
import 'package:newstore/features/cart/domain/repositories/cart_repository.dart';
import 'package:newstore/shared/domain/entities/product.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

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

class ClearCart extends CartEvent {}

// State
class CartState extends Equatable {
  final List<CartItem> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  double get totalPrice =>
      items.fold(0, (total, item) => total + (item.product.price * item.quantity));

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(const CartState()) {
    on<LoadCart>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await repository.getCart();
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (items) => emit(state.copyWith(isLoading: false, items: items)),
      );
    });

    on<AddToCart>((event, emit) async {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.product.id);

      if (index >= 0) {
        items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      } else {
        items.add(CartItem(product: event.product, variant: event.variant));
      }
      emit(state.copyWith(items: items));
      await repository.saveCart(items);
    });

    on<RemoveFromCart>((event, emit) async {
      final items = state.items.where((i) => i.product.id != event.productId).toList();
      emit(state.copyWith(items: items));
      await repository.saveCart(items);
    });

    on<UpdateQuantity>((event, emit) async {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.productId);
      if (index >= 0) {
        if (event.quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index] = items[index].copyWith(quantity: event.quantity);
        }
        emit(state.copyWith(items: items));
        await repository.saveCart(items);
      }
    });

    on<ClearCart>((event, emit) async {
      emit(state.copyWith(items: []));
      await repository.clearCart();
    });
  }
}
