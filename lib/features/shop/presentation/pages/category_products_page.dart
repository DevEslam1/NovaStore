import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newstore/shared/widgets/product_card.dart';
import 'package:newstore/features/home/presentation/bloc/products_bloc.dart';
import 'package:newstore/core/di/injection_container.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductsBloc>()..add(GetProductsRequested(category: category)),
      child: CategoryProductsView(category: category),
    );
  }
}

class CategoryProductsView extends StatefulWidget {
  final String category;
  const CategoryProductsView({super.key, required this.category});

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductsBloc>().add(LoadMoreProductsRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppRouter.search),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('No products in this category yet.', style: theme.textTheme.bodyMedium),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductsBloc>().add(RefreshProductsRequested());
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push(
                      AppRouter.productDetails,
                      extra: product,
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
