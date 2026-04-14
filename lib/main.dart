import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:newstore/features/order/presentation/bloc/orders_bloc.dart';
import 'package:newstore/features/profile/presentation/bloc/address_bloc.dart';
import 'package:newstore/core/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:newstore/features/auth/presentation/bloc/auth_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/app_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/bloc/app_config_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/home/presentation/bloc/products_bloc.dart';
import 'shared/widgets/network_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize DI
  await di.init();

  // ── Production Polish: Analytics & Crashlytics ──
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // ── Notification Service ──
  await di.sl<NotificationService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AppConfigBloc>()..add(LoadConfig())),
        BlocProvider(create: (context) => di.sl<CartBloc>()..add(LoadCart())),
        BlocProvider(create: (context) => di.sl<OrdersBloc>()),
        BlocProvider(
          create: (context) => di.sl<ProductsBloc>()..add(GetProductsRequested()),
        ),
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => di.sl<AddressBloc>(),
        ),
      ],
      child: BlocBuilder<AppConfigBloc, AppConfigState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'NovaStore',
            debugShowCheckedModeBanner: false,

            // Localization
            locale: state.locale,
            supportedLocales: const [Locale('en', ''), Locale('ar', '')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,

            // Routing
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return NetworkBanner(child: child!);
            },
          );
        },
      ),
    );
  }
}
