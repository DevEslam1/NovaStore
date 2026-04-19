import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_router.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/home/presentation/bloc/products_bloc.dart';
import '../../../shared/domain/entities/product.dart';

class AutoDemoHelper {
  static final ValueNotifier<bool> isRunning = ValueNotifier<bool>(false);

  static Future<void> runFullDemo(BuildContext context) async {
    if (isRunning.value) return;
    isRunning.value = true;

    try {
      // 1. Start at Home
      AppRouter.router.go(AppRouter.home);
      await Future.delayed(const Duration(milliseconds: 2500));

      // 2. Identify a product to add
      final productsBloc = context.read<ProductsBloc>();
      Product? demoProduct;
      
      if (productsBloc.state is ProductsLoaded) {
        final state = productsBloc.state as ProductsLoaded;
        if (state.products.isNotEmpty) {
          demoProduct = state.products.first;
        }
      }

      // fallback mock if bloc not loaded or empty
      demoProduct ??= const Product(
        id: 'demo_1',
        name: 'Artisan Wool Rug',
        description: 'A premium handcrafted wool rug with abstract patterns.',
        price: 850.00,
        imageUrl: 'assets/images/products/rug.png',
        images: ['assets/images/products/rug.png'],
        category: 'Home',
        brand: 'Artisan',
        stock: 10,
      );

      // 3. Open Details
      AppRouter.router.push(AppRouter.productDetails, extra: demoProduct);
      await Future.delayed(const Duration(milliseconds: 2500));

      // 4. Add to Cart
      context.read<CartBloc>().add(AddToCart(demoProduct));
      await Future.delayed(const Duration(milliseconds: 1500));

      // 5. Go to Cart
      AppRouter.router.push(AppRouter.cart);
      await Future.delayed(const Duration(milliseconds: 2500));

      // 6. Go to Checkout
      AppRouter.router.push(AppRouter.checkout);
      await Future.delayed(const Duration(milliseconds: 2500));

      // 7. Success / Tracking
      // We simulate placing order by going directly to tracking with mock data
      AppRouter.router.go(AppRouter.orderTracking, extra: {
        'id': 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        'status': 'Processing',
        'date': 'Apr 19, 2026',
        'total': demoProduct.price,
        'items': 1,
      });

      await Future.delayed(const Duration(milliseconds: 3500));
      
      // 8. Final: Back to Home
      AppRouter.router.go(AppRouter.home);

    } catch (e) {
      debugPrint('Demo Error: $e');
    } finally {
      isRunning.value = false;
    }
  }
}
