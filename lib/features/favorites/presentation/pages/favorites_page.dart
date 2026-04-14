import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:newstore/shared/widgets/empty_state_widget.dart';
import 'package:newstore/shared/widgets/product_card.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: EmptyStateWidget(
                  title: 'No favorites yet',
                  message: 'Tap the heart icon on a product to save it here.',
                  icon: Icons.favorite_border_rounded,
                  actionLabel: 'Explore Products',
                  onAction: () => context.go(AppRouter.home),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<FavoritesBloc>();
              final future = bloc.stream.firstWhere((state) => !state.isLoading);
              bloc.add(LoadFavorites());
              await future;
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ProductCard(
                  product: item.product,
                  onTap: () => context.push(AppRouter.productDetails, extra: item.product),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
