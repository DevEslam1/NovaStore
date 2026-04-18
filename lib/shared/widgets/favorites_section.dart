import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/haptic_helper.dart';
import 'product_card.dart';

class FavoritesSection extends StatelessWidget {
  final String title;
  
  const FavoritesSection({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }
        
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final p = state.items[index].product;
                  return Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 16, bottom: 24),
                    child: ProductCard(
                      product: p,
                      useHero: false,
                      onTap: () {
                        HapticHelper.light();
                        context.push(AppRouter.productDetails, extra: p);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
