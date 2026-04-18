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
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/order/presentation/pages/orders_page.dart';
import '../../features/order/presentation/pages/order_tracking_page.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../features/profile/presentation/pages/addresses_page.dart';
import '../../features/profile/presentation/pages/add_address_page.dart';
import '../../features/profile/domain/entities/address_entity.dart';
import '../../features/cart/domain/entities/cart_item.dart';
import 'package:newstore/shared/domain/entities/product.dart';
import '../di/injection_container.dart';
import 'page_transitions.dart';

import 'package:newstore/features/splash/presentation/pages/splash_page.dart';
import 'package:newstore/features/auth/presentation/pages/otp_page.dart';
import 'package:newstore/features/notifications/presentation/pages/notification_page.dart';

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
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';

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
        pageBuilder: (context, state) => PageTransitions.fadeThrough(
          key: state.pageKey,
          child: const MainScaffold(),
        ),
      ),
      GoRoute(
        path: onboarding,
        pageBuilder: (context, state) => PageTransitions.fadeThrough(
          key: state.pageKey,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: login,
        pageBuilder: (context, state) => PageTransitions.fadeThrough(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: register,
        pageBuilder: (context, state) => PageTransitions.fadeThrough(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: otp,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return PageTransitions.fadeThrough(
            key: state.pageKey,
            child: OtpPage(
              email: args?['email'] as String? ?? (args?['phoneNumber'] as String? ?? ''),
              verificationId: args?['verificationId'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: checkout,
        pageBuilder: (context, state) => PageTransitions.sharedAxisHorizontal(
          key: state.pageKey,
          child: const CheckoutPage(),
        ),
      ),
      GoRoute(
        path: payment,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return PageTransitions.sharedAxisHorizontal(
            key: state.pageKey,
            child: PaymentPage(
              items: args['items'] as List<CartItem>,
              subtotal: args['subtotal'] as double,
              shippingFee: args['shippingFee'] as double,
              tax: args['tax'] as double,
              total: args['total'] as double,
              shippingAddress: args['shippingAddress'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: search,
        pageBuilder: (context, state) => PageTransitions.slideUpModal(
          key: state.pageKey,
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: categoryProducts,
        pageBuilder: (context, state) {
          final category = state.extra as String;
          return PageTransitions.sharedAxisHorizontal(
            key: state.pageKey,
            child: CategoryProductsPage(category: category),
          );
        },
      ),
      GoRoute(
        path: productDetails,
        pageBuilder: (context, state) {
          final product = state.extra as Product;
          return PageTransitions.sharedAxisVertical(
            key: state.pageKey,
            child: ProductDetailsPage(product: product),
          );
        },
      ),
      GoRoute(
        path: orders,
        pageBuilder: (context, state) => PageTransitions.sharedAxisHorizontal(
          key: state.pageKey,
          child: const OrdersPage(),
        ),
      ),
      GoRoute(
        path: cart,
        pageBuilder: (context, state) => PageTransitions.sharedAxisHorizontal(
          key: state.pageKey,
          child: const CartPage(),
        ),
      ),
      GoRoute(
        path: favorites,
        pageBuilder: (context, state) => PageTransitions.sharedAxisHorizontal(
          key: state.pageKey,
          child: const FavoritesPage(),
        ),
      ),
      GoRoute(
        path: notifications,
        pageBuilder: (context, state) => PageTransitions.sharedAxisHorizontal(
          key: state.pageKey,
          child: const NotificationPage(),
        ),
      ),
      GoRoute(
        path: orderTracking,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return PageTransitions.sharedAxisVertical(
            key: state.pageKey,
            child: OrderTrackingPage(
              orderId: args['id'] as String,
              status: args['status'] as String,
              date: args['date'] as String,
              total: args['total'] as double,
              itemCount: args['items'] as int,
            ),
          );
        },
      ),
      GoRoute(
        path: addresses,
        pageBuilder: (context, state) => PageTransitions.sharedAxisHorizontal(
          key: state.pageKey,
          child: const AddressesPage(),
        ),
      ),
      GoRoute(
        path: addAddress,
        pageBuilder: (context, state) {
          final address = state.extra as AddressEntity?;
          return PageTransitions.sharedAxisVertical(
            key: state.pageKey,
            child: AddAddressPage(address: address),
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
