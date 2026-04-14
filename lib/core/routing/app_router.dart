import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/checkout/presentation/pages/payment_page.dart';
import '../../features/shop/presentation/pages/search_page.dart';
import '../../features/shop/presentation/pages/category_products_page.dart';
import '../../features/order/presentation/pages/orders_page.dart';
import '../../features/order/presentation/pages/order_tracking_page.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../features/profile/presentation/pages/addresses_page.dart';
import '../../features/profile/presentation/pages/add_address_page.dart';
import '../../features/profile/domain/entities/address_entity.dart';
import '../../features/cart/domain/entities/cart_item.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import '../di/injection_container.dart';

import 'package:newstore/features/splash/presentation/pages/splash_page.dart';
import 'package:newstore/features/auth/presentation/pages/otp_page.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';

  static const String productDetails = '/product-details';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String search = '/search';
  static const String categoryProducts = '/category-products';
  static const String orders = '/orders';
  static const String orderTracking = '/order-tracking';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
      final bool onSplash = state.matchedLocation == splash;
      final bool loggingIn = state.matchedLocation == login;
      final bool registering = state.matchedLocation == register;
      final bool onOnboarding = state.matchedLocation == onboarding;
      final bool onOtp = state.matchedLocation == otp;

      // During Splash, don't redirect yet
      if (onSplash) return null;

      // Unauthenticated users can only be on login, onboarding, register or otp
      if (authState is Unauthenticated || authState is AuthInitial) {
        if (!loggingIn && !onOnboarding && !registering && !onOtp) return login;
        return null;
      }

      // Authenticated users should not see login/register/otp pages
      if (authState is Authenticated) {
        if (loggingIn || registering || onOtp) return home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
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
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: otp,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return OtpPage(
            email: args?['email'] as String? ?? (args?['phoneNumber'] as String? ?? ''),
            verificationId: args?['verificationId'] as String?,
          );
        },
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: payment,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return PaymentPage(
            items: args['items'] as List<CartItem>,
            subtotal: args['subtotal'] as double,
            shippingFee: args['shippingFee'] as double,
            tax: args['tax'] as double,
            total: args['total'] as double,
            shippingAddress: args['shippingAddress'] as String,
          );
        },
      ),
      GoRoute(
        path: search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: categoryProducts,
        builder: (context, state) {
          final category = state.extra as String;
          return CategoryProductsPage(category: category);
        },
      ),
      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailsPage(product: product);
        },
      ),
      GoRoute(
        path: orders,
        builder: (context, state) => const OrdersPage(),
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
      GoRoute(
        path: addresses,
        builder: (context, state) => const AddressesPage(),
      ),
      GoRoute(
        path: addAddress,
        builder: (context, state) {
          final address = state.extra as AddressEntity?;
          return AddAddressPage(address: address);
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

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
