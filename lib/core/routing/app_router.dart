import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/cart/presentation/pages/payment_page.dart';
import '../../features/shop/presentation/pages/search_page.dart';
import '../../features/orders/presentation/pages/order_tracking_page.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../shared/domain/entities/product.dart';

class AppRouter {
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String productDetails = '/product-details';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String search = '/search';
  static const String orderTracking = '/order-tracking';

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: payment,
        builder: (context, state) => const PaymentPage(),
      ),
      GoRoute(
        path: search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailsPage(product: product);
        },
      ),
      GoRoute(
        path: orderTracking,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return OrderTrackingPage(
            orderId: args['id'] as String,
            status: args['status'] as String,
            date: args['date'] as String,
            total: args['total'] as double,
            itemCount: args['items'] as int,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.matchedLocation}'),
      ),
    ),
  );
}
