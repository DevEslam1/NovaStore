import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';

// Events
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  final String userId;
  const LoadOrders(this.userId);
  @override
  List<Object?> get props => [userId];
}

class CreateOrder extends OrdersEvent {
  final OrderEntity order;
  const CreateOrder(this.order);
  @override
  List<Object?> get props => [order];
}

// State
abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderCreatedSuccess extends OrdersState {}

// Bloc
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository repository;

  OrdersBloc({required this.repository}) : super(OrdersInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      final result = await repository.getOrders(event.userId);
      result.fold(
        (failure) => emit(OrdersError(failure.message)),
        (orders) => emit(OrdersLoaded(orders)),
      );
    });

    on<CreateOrder>((event, emit) async {
      emit(OrdersLoading());
      final result = await repository.createOrder(event.order);
      result.fold(
        (failure) => emit(OrdersError(failure.message)),
        (_) => emit(OrderCreatedSuccess()),
      );
    });
  }
}
