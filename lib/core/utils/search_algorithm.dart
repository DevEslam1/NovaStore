import 'package:newstore/shared/domain/entities/product.dart';

class SearchAlgorithm {
  /// Filters and ranks products based on relevance to the search query.
  static List<Product> filterAndRank(List<Product> products, String query) {
    if (query.isEmpty) return products;
    
    final normalizedQuery = query.toLowerCase().trim();
    final results = <_ScoredProduct>[];

    for (final product in products) {
      final name = product.name.toLowerCase();
      final brand = product.brand.toLowerCase();
      final description = product.description.toLowerCase();
      
      int score = 0;

      // Rule 1: Exact match on title (highest priority)
      if (name == normalizedQuery) {
        score += 1000;
      }
      
      // Rule 2: Title starts with query
      else if (name.startsWith(normalizedQuery)) {
        score += 500;
      }

      // Rule 3: Query is a substring of the title
      else if (name.contains(normalizedQuery)) {
        score += 200;
      }

      // Rule 4: Query matches brand
      if (brand.contains(normalizedQuery)) {
        score += 100;
      }

      // Rule 5: Query matches description
      if (description.contains(normalizedQuery)) {
        score += 50;
      }

      if (score > 0) {
        results.add(_ScoredProduct(product, score));
      }
    }

    // Sort by score descending
    results.sort((a, b) => b.score.compareTo(a.score));

    return results.map((e) => e.product).toList();
  }
}

class _ScoredProduct {
  final Product product;
  final int score;

  _ScoredProduct(this.product, this.score);
}
