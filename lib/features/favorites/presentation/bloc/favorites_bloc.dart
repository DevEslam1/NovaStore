import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';

// Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final Product product;
  const ToggleFavorite(this.product);
  @override
  List<Object?> get props => [product];
}

class ClearFavorites extends FavoritesEvent {}

// State
class FavoritesState extends Equatable {
  final List<FavoriteItem> items;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  bool isFavorite(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  FavoritesState copyWith({
    List<FavoriteItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoritesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}

// Bloc
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository repository;

  FavoritesBloc({required this.repository}) : super(const FavoritesState()) {
    on<LoadFavorites>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await repository.getFavorites();
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (items) => emit(state.copyWith(isLoading: false, items: items)),
      );
    });

    on<ToggleFavorite>((event, emit) async {
      // Optimistic update
      final items = List<FavoriteItem>.from(state.items);
      final index = items.indexWhere((i) => i.product.id == event.product.id);
      
      if (index >= 0) {
        items.removeAt(index);
      } else {
        items.add(FavoriteItem(product: event.product, addedAt: DateTime.now()));
      }
      
      emit(state.copyWith(items: items));
      
      // Perform actual repo update
      final result = await repository.toggleFavorite(event.product);
      
      // If repo update fails, revert the state (by reloading)
      if (result.isLeft()) {
        add(LoadFavorites());
      }
    });

    on<ClearFavorites>((event, emit) async {
      emit(state.copyWith(items: []));
      await repository.clearFavorites();
    });
  }
}
