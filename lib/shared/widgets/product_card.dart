import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:newstore/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/core/theme/colors.dart';
import '../../core/utils/haptic_helper.dart';

/// Product card matching the "NovaStore" spec:
///   • Zero borders, `surfaceContainerLowest` background.
///   • 24px outer radius, 12px image radius (sm nestled in md).
///   • 20px internal padding; imagery must "breathe."
///   • Ambient shadow (40px blur, 4% on-surface) for elevation effect.
///   • Tonal layering: card on surfaceContainerLow → perceived lift.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ──
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-image-${product.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildImage(theme),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, state) {
                        final isFav = state.isFavorite(product.id);
                        return GestureDetector(
                          onTap: () {
                            HapticHelper.light();
                            context.read<FavoritesBloc>().add(ToggleFavorite(product));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFav ? Colors.red : theme.colorScheme.onSurface,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ── Details ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand label
                  Text(
                    product.brand.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price and Add to Cart
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      final cartItem = state.items.indexWhere(
                        (i) => i.product.id == product.id,
                      );
                      final isInCart = cartItem >= 0;
                      final quantity = isInCart ? state.items[cartItem].quantity : 0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: 'product-price-${product.id}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.secondary,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: !isInCart
                                ? GestureDetector(
                                    key: const ValueKey('add_btn'),
                                    onTap: () {
                                      HapticHelper.medium();
                                      context.read<CartBloc>().add(AddToCart(product));
                                      _showAddedToCartToast(context, product.name, theme);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.add_shopping_cart_rounded,
                                        color: theme.colorScheme.onPrimary,
                                        size: 18,
                                      ),
                                    ),
                                  )
                                : Container(
                                    key: const ValueKey('qty_btn'),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            HapticHelper.selection();
                                            if (quantity > 1) {
                                              context.read<CartBloc>().add(
                                                UpdateQuantity(product.id, quantity - 1),
                                              );
                                            } else {
                                              context.read<CartBloc>().add(
                                                RemoveFromCart(product.id),
                                              );
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.remove,
                                              color: AppColors.onSuccess,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 200),
                                          transitionBuilder: (child, animation) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0.0, -0.5),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: FadeTransition(opacity: animation, child: child),
                                            );
                                          },
                                          child: Text(
                                            '$quantity',
                                            key: ValueKey<int>(quantity),
                                            style: theme.textTheme.labelLarge?.copyWith(
                                              color: AppColors.onSuccess,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticHelper.selection();
                                            context.read<CartBloc>().add(
                                              UpdateQuantity(product.id, quantity + 1),
                                            );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.add,
                                              color: AppColors.onSuccess,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    if (product.imageUrl.startsWith('assets/')) {
      return Image.asset(
        product.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(theme),
      );
    }
    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: theme.colorScheme.surfaceContainerHigh,
      ),
      fadeInDuration: const Duration(milliseconds: 300),
      errorWidget: (context, url, error) => _imagePlaceholder(theme),
    );
  }

  Widget _imagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.outline,
          size: 32,
        ),
      ),
    );
  }

  static OverlayEntry? _currentToast;

  void _showAddedToCartToast(BuildContext context, String productName, ThemeData theme) {
    // Remove any existing toast
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(animation),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.onTertiaryContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$productName added to cart',
                        style: TextStyle(
                          color: theme.colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticHelper.light();
                        entry.remove();
                        _currentToast = null;
                        controller.dispose();
                        context.push(AppRouter.cart);
                      },
                      child: Text(
                        'View Cart',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _currentToast = entry;
    overlay.insert(entry);
    controller.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentToast == entry) {
        controller.reverse().then((_) {
          if (entry.mounted) {
            entry.remove();
          }
          controller.dispose();
          _currentToast = null;
        });
      }
    });
  }
}
