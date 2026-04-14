import 'package:flutter/material.dart';
import 'package:newstore/shared/widgets/product_card.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import 'package:newstore/core/constants/mock_data.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

/// Search Results — "The Curated Pavilion" design.
///
/// • Filled search bar using surfaceContainerHigh (not surfaceContainerLow).
/// • Recent searches as pill chips (secondaryFixed hover state).
/// • Grid results with ProductCard tonal layering.
/// • No borders anywhere.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final allProducts = [...MockData.flashDeals, ...MockData.recommended];
    setState(() {
      _searchResults = allProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.brand.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearch,
            autofocus: true,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search products, brands...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.outline,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.outline,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
      body: _searchResults.isEmpty
          ? _buildInitialOrEmptyState()
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
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

  Widget _buildInitialOrEmptyState() {
    final theme = Theme.of(context);
    if (_searchController.text.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recently Searched',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: MockData.recentSearches.map((tag) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = tag;
                    _onSearch(tag);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No results for "${_searchController.text}"',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
