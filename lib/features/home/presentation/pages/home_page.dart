import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newstore/shared/widgets/product_card.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/core/localization/app_localizations.dart';
import 'package:newstore/features/home/presentation/bloc/products_bloc.dart';
import 'package:newstore/features/home/presentation/widgets/home_skeleton.dart';
import 'package:newstore/shared/widgets/app_error_widget.dart';
import 'package:newstore/shared/widgets/empty_state_widget.dart';

/// Home & Discovery screen following the "NovaStore" design system.
/// Updated to support infinite scrolling via ProductsBloc.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductsBloc>().add(LoadMoreProductsRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const HomeSkeleton();
          }

          if (state is ProductsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<ProductsBloc>().add(GetProductsRequested()),
            );
          }

          if (state is ProductsLoaded) {
            final allProducts = state.products;
            // Simple partitioning for demonstration
            final flashDeals = allProducts.take(3).toList();
            final recommended = allProducts.skip(3).toList();

            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<ProductsBloc>();
                final future = bloc.stream.firstWhere(
                    (state) => state is ProductsLoaded || state is ProductsError);
                bloc.add(RefreshProductsRequested());
                await future;
              },
              displacement: 100, // Account for the expanded app bar
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // ── Glassmorphic App Bar ──
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: 110.0,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: FlexibleSpaceBar(
                          titlePadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          centerTitle: false,
                          title: Text(
                            l10n.translate('app_name'),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          background: Container(
                            color: theme.scaffoldBackgroundColor
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => context.push(AppRouter.notifications),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push(AppRouter.search),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search_rounded,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),

                  // ── Hero Banner ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primaryContainer,
                            ],
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=800',
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.35,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  theme.colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'NEW SEASON',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.translate('autumn_collection'),
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        l10n.translate('explore_now'),
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Categories ──
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(title: l10n.translate('shop')),
                        SizedBox(
                          height: 100,
                          child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance.collection('categories').get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator.adaptive());
                              }
                              if (snapshot.hasError || !(snapshot.hasData)) {
                                return const SizedBox.shrink();
                              }
                              final docs = snapshot.data!.docs;
                              if (docs.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final cat = docs[index].data() as Map<String, dynamic>;
                                  IconData icon = Icons.category_rounded;
                                  final catId = cat['id'] ?? '';
                                  if (catId == 'watches') {
                                    icon = Icons.watch_rounded;
                                  } else if (catId == 'tech') {
                                    icon = Icons.computer_rounded;
                                  } else if (catId == 'lifestyle') {
                                    icon = Icons.directions_run_rounded;
                                  } else if (catId == 'audio') {
                                    icon = Icons.headphones_rounded;
                                  } else if (catId == 'apparel') {
                                    icon = Icons.checkroom_rounded;
                                  } else if (catId == 'home') {
                                    icon = Icons.chair_rounded;
                                  }

                                  return _CategoryItem(
                                    label: cat['name'] as String? ?? 'Category',
                                    icon: icon,
                                    onTap: () => context.push(
                                      AppRouter.categoryProducts,
                                      extra: cat['name'],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Flash Deals ──
                  if (flashDeals.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: l10n.translate('flash_deals'),
                            showViewAll: true,
                          ),
                          SizedBox(
                            height: 260,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: flashDeals.length,
                              itemBuilder: (context, index) {
                                final p = flashDeals[index];
                                return Container(
                                  width: 170,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: ProductCard(
                                    product: p,
                                    onTap: () => context.push(
                                      AppRouter.productDetails,
                                      extra: p,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Recommended Header ──
                  if (recommended.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 8),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: l10n.translate('recommended'),
                          showViewAll: true,
                        ),
                      ),
                    ),

                  // ── Recommended Grid ──
                  if (recommended.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = recommended[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push(
                              AppRouter.productDetails,
                              extra: product,
                            ),
                          );
                        }, childCount: recommended.length),
                      ),
                    ),

                  // ── Loading More Indicator ──
                  if (state.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),

                  // Empty state if no products
                  if (allProducts.isEmpty)
                    SliverFillRemaining(
                      child: EmptyStateWidget(
                        title: 'No Products Found',
                        message: 'We couldn\'t find any products in our store right now.',
                        icon: Icons.inventory_2_outlined,
                        actionLabel: 'Try Refreshing',
                        onAction: () =>
                            context.read<ProductsBloc>().add(RefreshProductsRequested()),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;
  const _SectionHeader({required this.title, this.showViewAll = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.translate('view_all'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _CategoryItem({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
