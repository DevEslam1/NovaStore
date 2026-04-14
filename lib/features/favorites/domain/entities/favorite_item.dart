import 'package:equatable/equatable.dart';
import 'package:newstore/shared/domain/entities/product.dart';

class FavoriteItem extends Equatable {
  final Product product;
  final DateTime addedAt;

  const FavoriteItem({
    required this.product,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [product, addedAt];
}
