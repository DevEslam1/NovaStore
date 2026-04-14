import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../bloc/app_config_bloc.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../network/network_info.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/domain/repositories/product_repository.dart';
import '../../features/home/data/repositories/product_repository_impl.dart';
import '../../features/home/data/datasources/product_remote_datasource.dart';
import '../../features/home/domain/usecases/get_products_usecase.dart';
import '../../features/home/presentation/bloc/products_bloc.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/data/datasources/order_remote_datasource.dart';
import '../../features/order/presentation/bloc/orders_bloc.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/profile/presentation/bloc/address_bloc.dart';
import '../../features/profile/domain/repositories/address_repository.dart';
import '../../features/profile/data/repositories/address_repository_impl.dart';
import '../../features/profile/data/datasources/address_remote_datasource.dart';
import '../services/notification_service.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  //! Features - Auth
  // Blocs
  sl.registerLazySingleton(() => AuthBloc(authRepository: sl()));
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(sl()),
  );

  //! Features - Products
  // Blocs
  sl.registerFactory(() => ProductsBloc(getProductsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  //! Features - Core & Common
  // Blocs
  sl.registerLazySingleton(() => AppConfigBloc(sharedPreferences: sl()));
  sl.registerLazySingleton(() => CartBloc(repository: sl()));
  sl.registerLazySingleton(() => OrdersBloc(repository: sl()));
  sl.registerLazySingleton(() => FavoritesBloc(repository: sl()));
  sl.registerLazySingleton(() => AddressBloc(repository: sl()));

  // Repositories
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(
      firestore: sl(),
      auth: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => NotificationService(authRepository: sl()));
  sl.registerLazySingleton(() => Dio());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
