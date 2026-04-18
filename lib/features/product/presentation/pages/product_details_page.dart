import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newstore/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:newstore/features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../shared/widgets/recommended_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveLayout.isCompact(context)) {
      return _buildLargeScreen(context);
    }
    return _buildCompactScreen(context);
  }

  Widget _buildLargeScreen(BuildContext context) {
    final theme = Theme.of(context);
    final maxWidth = ResponsiveLayout.getContentMaxWidth(context) ?? 1200.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            HapticHelper.light();
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveLayout.getHorizontalPadding(context),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Image
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: _buildProductImage(theme, showThumbnails: true),
                  ),
                ),
              ),
              const SizedBox(width: 48),
              // Right: Info
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeaderInfo(theme),
                      const SizedBox(height: 24),
                      _buildPrice(theme),
                      const SizedBox(height: 36),
                      _buildDescription(theme),
                      const SizedBox(height: 36),
                      _buildFeatures(theme),
                      const SizedBox(height: 48),
                      _buildBottomActions(context, theme, isLargeMenu: true),
                      const RecommendedSection(title: 'Recommended for You'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactScreen(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420.0,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {
                HapticHelper.light();
                context.pop();
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.85,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.06,
                      ),
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
                  color: theme.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.85,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.06,
                      ),
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
                  onPressed: () => HapticHelper.light(),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-image-${product.id}',
                child: _buildProductImage(theme),
              ),
            ),
          ),
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
                  _buildHeaderInfo(theme),
                  const SizedBox(height: 16),
                  _buildPrice(theme),
                  const SizedBox(height: 36),
                  _buildDescription(theme),
                  const SizedBox(height: 28),
                  _buildFeatures(theme),
                  const RecommendedSection(title: 'Recommended for You'),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(
        context,
        theme,
        isLargeMenu: false,
      ),
    );
  }

  Widget _buildHeaderInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        Text(
          product.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
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
      ],
    );
  }

  Widget _buildPrice(ThemeData theme) {
    return Hero(
      tag: 'product-price-${product.id}',
      child: Material(
        type: MaterialType.transparency,
        child: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildFeatures(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    ThemeData theme, {
    required bool isLargeMenu,
  }) {
    final actions = Row(
      children: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final isFav = state.isFavorite(product.id);
            return Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isFav
                      ? Colors.red.withValues(alpha: 0.4)
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(20),
                color: isFav
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.transparent,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    HapticHelper.light();
                    context.read<FavoritesBloc>().add(ToggleFavorite(product));
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(isFav),
                      color: isFav ? Colors.red : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(child: _AnimatedAddToCartButton(product: product)),
      ],
    );

    if (isLargeMenu) {
      return actions;
    }

    return Container(
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
      child: actions,
    );
  }

  Widget _buildProductImage(ThemeData theme, {bool showThumbnails = false}) {
    return _ImageCarousel(product: product, showThumbnails: showThumbnails);
  }
}

class _ImageCarousel extends StatefulWidget {
  final Product product;
  final bool showThumbnails;

  const _ImageCarousel({required this.product, this.showThumbnails = false});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onThumbnailTap(int index) {
    HapticHelper.light();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.imageUrl];

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return _buildSingleImage(images[index], theme);
                },
              ),
              if (images.length > 1 && !widget.showThumbnails)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (images.length > 1 && widget.showThumbnails)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SizedBox(
              height: 70,
              child: Center(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _currentIndex == index;
                    return GestureDetector(
                      onTap: () => _onThumbnailTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Opacity(
                            opacity: isSelected ? 1.0 : 0.6,
                            child: _buildSingleImage(images[index], theme),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSingleImage(String url, ThemeData theme) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: theme.colorScheme.surfaceContainerHigh,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, size: 48),
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) =>
          Container(color: theme.colorScheme.surfaceContainerHighest),
      errorWidget: (context, url, error) => Container(
        color: theme.colorScheme.surfaceContainerHigh,
        child: const Center(child: Icon(Icons.broken_image_outlined, size: 48)),
      ),
    );
  }
}

class _AnimatedAddToCartButton extends StatefulWidget {
  final Product product;

  const _AnimatedAddToCartButton({required this.product});

  @override
  State<_AnimatedAddToCartButton> createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<_AnimatedAddToCartButton> {
  bool _added = false;

  void _handleTap() async {
    if (_added) return; // Prevent multiple taps during animation
    HapticHelper.medium();
    context.read<CartBloc>().add(AddToCart(widget.product));

    setState(() => _added = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: 56,
        decoration: BoxDecoration(
          color: _added
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: _added
              ? Row(
                  key: const ValueKey('added'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Added!',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('add'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: theme.colorScheme.onSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
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
