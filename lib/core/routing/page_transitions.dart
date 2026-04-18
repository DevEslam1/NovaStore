import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Provides custom elegant page transitions for NovaStore.
class PageTransitions {
  static const Curve _defaultCurve = Curves.easeOutCubic;
  static const Duration _defaultDuration = Duration(milliseconds: 350);

  static CustomTransitionPage<T> fadeThrough<T>({
    required Widget child,
    required LocalKey key,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: _defaultCurve)),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<T> sharedAxisHorizontal<T>({
    required Widget child,
    required LocalKey key,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: const Offset(0.05, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: _defaultCurve));
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: _defaultCurve));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  static CustomTransitionPage<T> sharedAxisVertical<T>({
    required Widget child,
    required LocalKey key,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: const Offset(0.0, 0.05), end: Offset.zero)
            .chain(CurveTween(curve: _defaultCurve));
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: _defaultCurve));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  static CustomTransitionPage<T> slideUpModal<T>({
    required Widget child,
    required LocalKey key,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      fullscreenDialog: true,
      transitionDuration: _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: _defaultCurve));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
