import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AppConfigEvent extends Equatable {
  const AppConfigEvent();
  @override
  List<Object?> get props => [];
}

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
      themeMode: ThemeMode.light,
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
  AppConfigBloc() : super(AppConfigState.initial()) {
    on<ChangeLocale>((event, emit) {
      emit(state.copyWith(locale: event.locale));
    });
    on<ToggleTheme>((event, emit) {
      emit(state.copyWith(themeMode: event.themeMode));
    });
  }
}
