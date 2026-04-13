 import 'package:get_it/get_it.dart';
import '../bloc/app_config_bloc.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  //! Features
  
  // Blocs
  sl.registerFactory(() => AppConfigBloc());
  sl.registerFactory(() => CartBloc());
  // Use cases
  
  // Repositories
  
  // Data sources
  
  //! Core
  
  sl.registerLazySingleton(() => Dio());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
