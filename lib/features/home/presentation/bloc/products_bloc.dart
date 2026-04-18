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

class GetProductsRequested extends ProductsEvent {
  final String? category;
  final String? searchQuery;

  const GetProductsRequested({this.category, this.searchQuery});

  @override
  List<Object?> get props => [category, searchQuery];
}

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
  final String? category;
  final String? searchQuery;

  const ProductsLoaded({
    required this.products,
    required this.hasMore,
    this.lastDoc,
    this.isLoadingMore = false,
    this.category,
    this.searchQuery,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    DocumentSnapshot? lastDoc,
    bool? isLoadingMore,
    String? category,
    String? searchQuery,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      lastDoc: lastDoc ?? this.lastDoc,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, lastDoc, isLoadingMore, category, searchQuery];
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
      emit(ProductsLoading());
      final result = await getProductsUseCase(
        limit: _pageSize,
        category: event.category,
        searchQuery: event.searchQuery,
      );
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (paginatedResult) => emit(ProductsLoaded(
          products: paginatedResult.products,
          hasMore: paginatedResult.hasMore,
          lastDoc: paginatedResult.lastDoc,
          category: event.category,
          searchQuery: event.searchQuery,
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
        category: currentState.category,
        searchQuery: currentState.searchQuery,
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
      final currentState = state;
      String? category;
      String? searchQuery;

      if (currentState is ProductsLoaded) {
        category = currentState.category;
        searchQuery = currentState.searchQuery;
      }

      emit(ProductsLoading());
      final result = await getProductsUseCase(
        limit: _pageSize,
        category: category,
        searchQuery: searchQuery,
      );
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (paginatedResult) => emit(ProductsLoaded(
          products: paginatedResult.products,
          hasMore: paginatedResult.hasMore,
          lastDoc: paginatedResult.lastDoc,
          category: category,
          searchQuery: searchQuery,
        )),
      );
    });
  }
}
