import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newstore/core/routing/app_router.dart';
import '../widgets/filter_modal.dart';

/// Shop / Categories — "NovaStore" design.
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => FilterModal.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          }
          
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final cat = docs[index].data() as Map<String, dynamic>;
              // Fallback to determine icon
              IconData icon = Icons.category_rounded;
              final catId = cat['id'] ?? '';
              if (catId == 'watches') icon = Icons.watch_rounded;
              else if (catId == 'tech') icon = Icons.computer_rounded;
              else if (catId == 'lifestyle') icon = Icons.directions_run_rounded;
              else if (catId == 'audio') icon = Icons.headphones_rounded;
              else if (catId == 'apparel') icon = Icons.checkroom_rounded;
              else if (catId == 'home') icon = Icons.chair_rounded;

              return _CategoryCard(
                label: cat['name'] as String? ?? 'Category',
                imageUrl: cat['imageUrl'] as String? ?? '',
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
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryCard({
    required this.label,
    required this.imageUrl,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: theme.colorScheme.surfaceContainerHigh,
                ),
              ),
              // Gradient overlay — primary tint for premium cohesion
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

