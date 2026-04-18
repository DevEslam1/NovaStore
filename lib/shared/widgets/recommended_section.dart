import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/bloc/products_bloc.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/haptic_helper.dart';
import 'product_card.dart';

class RecommendedSection extends StatelessWidget {
  final String title;
  
  const RecommendedSection({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is! ProductsLoaded || state.products.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Take a few items for recommendation, excluding potential duplicates if possible
        // For now, just take the first few
        final products = state.products.take(6).toList();
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 16, bottom: 20),
                    child: ProductCard(
                      product: p,
                      useHero: false,
                      onTap: () {
                        HapticHelper.light();
                        // Push instead of go to allow back navigation
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
