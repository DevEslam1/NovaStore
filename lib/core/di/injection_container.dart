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
  sl.registerLazySingleton(() => ProductsBloc(getProductsUseCase: sl()));

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

  //! Features - Core & Common
  // Blocs
  sl.registerLazySingleton(() => AppConfigBloc());
  sl.registerLazySingleton(() => CartBloc());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Dio());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
