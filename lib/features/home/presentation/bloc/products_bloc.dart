import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'package:newstore/shared/domain/entities/product.dart';

// Events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object?> get props => [];
}

class GetProductsRequested extends ProductsEvent {}
class RefreshProductsRequested extends ProductsEvent {}

// States
abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  const ProductsLoaded(this.products);
  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase}) : super(ProductsInitial()) {
    on<GetProductsRequested>((event, emit) async {
      if (state is ProductsLoaded || state is ProductsLoading) return;
      
      emit(ProductsLoading());
      final result = await getProductsUseCase();
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) => emit(ProductsLoaded(products)),
      );
    });

    on<RefreshProductsRequested>((event, emit) async {
      // Don't emit Loading state here to avoid total screen flicker if desired,
      // but for RefreshIndicator, we just need to return a future.
      // However, to keep it simple and consistent:
      final result = await getProductsUseCase();
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) => emit(ProductsLoaded(products)),
      );
    });
  }
}
