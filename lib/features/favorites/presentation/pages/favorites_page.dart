import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:newstore/shared/widgets/empty_state_widget.dart';
import 'package:newstore/shared/widgets/product_card.dart';
import 'package:newstore/core/utils/responsive_layout.dart';
import 'package:newstore/core/utils/staggered_animation.dart';
import 'package:newstore/core/utils/haptic_helper.dart';
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
                  onAction: () {
                    HapticHelper.light();
                    context.go(AppRouter.home);
                  },
                ),
              ),
            );
          }

          final horizontalPadding = ResponsiveLayout.getHorizontalPadding(context);
          final maxWidth = ResponsiveLayout.getContentMaxWidth(context) ?? 1200.0;
          final crossAxisCount = ResponsiveLayout.getGridCrossAxisCount(context);

          return RefreshIndicator(
            onRefresh: () async {
              HapticHelper.light();
              final bloc = context.read<FavoritesBloc>();
              final future = bloc.stream.firstWhere((state) => !state.isLoading);
              bloc.add(LoadFavorites());
              await future;
            },
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return StaggeredListItem(
                      index: index,
                      child: ProductCard(
                        product: item.product,
                        onTap: () {
                          HapticHelper.selection();
                          context.push(AppRouter.productDetails, extra: item.product);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
