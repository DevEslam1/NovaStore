import 'package:flutter/services.dart';

/// Helper to provide centralized haptic feedback
class HapticHelper {
  /// Use for light actions: toggling a switch, tab changes, filtering
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Use for confirmation actions: add to cart, check out
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Use for heavy/destructive actions: error states, deleting items
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Use for scrolling or selections (steppers, picking values)
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Alias for error haptics, maps to heavy impact
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }
}
