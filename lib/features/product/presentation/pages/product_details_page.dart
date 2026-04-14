import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newstore/features/cart/presentation/bloc/cart_bloc.dart';

/// Product Details — Editorial layout following "The Curated Pavilion."
///
/// Key design decisions:
///   • Full-bleed collapsible product image — imagery bleeds to screen edges.
///   • Asymmetrical spacing (editorial look).
///   • Limited Edition tag with sm radius inside card.
///   • Feature tiles with checked icons.
///   • Bottom bar: ghost-border favorite button + coral "Add to Cart" CTA.
class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsible Image (bleeds to edges) ──
          SliverAppBar(
            expandedHeight: 420.0,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: _buildProductImage(theme),
              ),
            ),
          ),

          // ── Product Info ──
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + Badge row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.brand.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.outline,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryFixed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'LIMITED EDITION',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSecondaryFixed,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product name
                  Text(
                    product.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating (decorative)
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                          color: theme.colorScheme.tertiaryFixedDim,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.5',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.outline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '  ·  128 reviews',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Narrative / Description
                  Text(
                    'The Narrative',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Features
                  _FeatureTile(
                    icon: Icons.verified_rounded,
                    text: 'Scratch-resistant sapphire crystal',
                    theme: theme,
                  ),
                  _FeatureTile(
                    icon: Icons.water_drop_outlined,
                    text: 'Water resistant up to 50 meters',
                    theme: theme,
                  ),
                  _FeatureTile(
                    icon: Icons.shield_outlined,
                    text: '2-year international warranty',
                    theme: theme,
                  ),

                  const SizedBox(height: 120), // floating nav space
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Action Bar ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Favourite (ghost-border)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  child: Icon(
                    Icons.favorite_border_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Add to Cart (conversion CTA)
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                isSecondary: true,
                icon: Icons.shopping_bag_outlined,
                onPressed: () {
                  context.read<CartBloc>().add(AddToCart(product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      action: SnackBarAction(
                        label: 'View Cart',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ThemeData theme) {
    if (product.imageUrl.startsWith('assets/')) {
      return Image.asset(
        product.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: theme.colorScheme.surfaceContainerHigh,
          child: const Center(child: Icon(Icons.broken_image_outlined, size: 48)),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Container(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, url, error) => Container(
        color: theme.colorScheme.surfaceContainerHigh,
        child: const Center(child: Icon(Icons.broken_image_outlined, size: 48)),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;
  const _FeatureTile({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryFixed.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
