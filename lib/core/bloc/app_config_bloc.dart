import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class AppConfigEvent extends Equatable {
  const AppConfigEvent();
  @override
  List<Object?> get props => [];
}

class LoadConfig extends AppConfigEvent {}

class ChangeLocale extends AppConfigEvent {
  final Locale locale;
  const ChangeLocale(this.locale);
  @override
  List<Object?> get props => [locale];
}

class ToggleTheme extends AppConfigEvent {
  final ThemeMode themeMode;
  const ToggleTheme(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

// State
class AppConfigState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;

  const AppConfigState({
    required this.locale,
    required this.themeMode,
  });

  factory AppConfigState.initial() {
    return const AppConfigState(
      locale: Locale('en'),
      themeMode: ThemeMode.system, // Default to system on first install
    );
  }

  AppConfigState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppConfigState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode];
}

// Bloc
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final SharedPreferences sharedPreferences;

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  AppConfigBloc({required this.sharedPreferences}) : super(AppConfigState.initial()) {
    on<LoadConfig>((event, emit) {
      final themeStr = sharedPreferences.getString(_themeKey);
      final localeStr = sharedPreferences.getString(_localeKey);

      ThemeMode themeMode = ThemeMode.system;
      if (themeStr != null) {
        themeMode = ThemeMode.values.firstWhere(
          (m) => m.toString() == themeStr,
          orElse: () => ThemeMode.system,
        );
      }

      Locale locale = const Locale('en');
      if (localeStr != null) {
        locale = Locale(localeStr);
      }

      emit(state.copyWith(themeMode: themeMode, locale: locale));
    });

    on<ChangeLocale>((event, emit) async {
      await sharedPreferences.setString(_localeKey, event.locale.languageCode);
      emit(state.copyWith(locale: event.locale));
    });

    on<ToggleTheme>((event, emit) async {
      await sharedPreferences.setString(_themeKey, event.themeMode.toString());
      emit(state.copyWith(themeMode: event.themeMode));
    });
  }
}
