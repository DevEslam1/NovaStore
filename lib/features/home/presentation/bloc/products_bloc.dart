import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'package:newstore/shared/domain/entities/product.dart';

// Events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object?> get props => [];
}

class GetProductsRequested extends ProductsEvent {}

class LoadMoreProductsRequested extends ProductsEvent {}

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
  final bool hasMore;
  final DocumentSnapshot? lastDoc;
  final bool isLoadingMore;

  const ProductsLoaded({
    required this.products,
    required this.hasMore,
    this.lastDoc,
    this.isLoadingMore = false,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    DocumentSnapshot? lastDoc,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      lastDoc: lastDoc ?? this.lastDoc,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, lastDoc, isLoadingMore];
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
  static const int _pageSize = 10;

  ProductsBloc({required this.getProductsUseCase}) : super(ProductsInitial()) {
    on<GetProductsRequested>((event, emit) async {
      if (state is ProductsLoaded || state is ProductsLoading) return;

      emit(ProductsLoading());
      final result = await getProductsUseCase(limit: _pageSize);
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (paginatedResult) => emit(ProductsLoaded(
          products: paginatedResult.products,
          hasMore: paginatedResult.hasMore,
          lastDoc: paginatedResult.lastDoc,
        )),
      );
    });

    on<LoadMoreProductsRequested>((event, emit) async {
      final currentState = state;
      if (currentState is! ProductsLoaded || 
          !currentState.hasMore || 
          currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      final result = await getProductsUseCase(
        limit: _pageSize,
        lastDoc: currentState.lastDoc,
      );

      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (paginatedResult) => emit(currentState.copyWith(
          products: [...currentState.products, ...paginatedResult.products],
          hasMore: paginatedResult.hasMore,
          lastDoc: paginatedResult.lastDoc,
          isLoadingMore: false,
        )),
      );
    });

    on<RefreshProductsRequested>((event, emit) async {
      emit(ProductsLoading());
      final result = await getProductsUseCase(limit: _pageSize);
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (paginatedResult) => emit(ProductsLoaded(
          products: paginatedResult.products,
          hasMore: paginatedResult.hasMore,
          lastDoc: paginatedResult.lastDoc,
        )),
      );
    });
  }
}
