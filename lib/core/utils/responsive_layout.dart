import 'package:flutter/material.dart';

enum ScreenType { compact, medium, expanded }

/// Utility class for handling responsive layouts mapping to NovaStore design breakpoints.
/// 
/// Breakpoints:
/// - Compact (Phone): < 600px
/// - Medium (Tablet): 600px - 839px
/// - Expanded (Desktop): >= 840px
class ResponsiveLayout extends StatelessWidget {
  final Widget compact;
  final Widget? medium;
  final Widget? expanded;

  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 840) {
      return ScreenType.expanded;
    } else if (width >= 600) {
      return ScreenType.medium;
    } else {
      return ScreenType.compact;
    }
  }

  static bool isCompact(BuildContext context) => getScreenType(context) == ScreenType.compact;
  static bool isMedium(BuildContext context) => getScreenType(context) == ScreenType.medium;
  static bool isExpanded(BuildContext context) => getScreenType(context) == ScreenType.expanded;

  static int getGridCrossAxisCount(BuildContext context) {
    final type = getScreenType(context);
    switch (type) {
      case ScreenType.compact:
        return 2;
      case ScreenType.medium:
        return 3;
      case ScreenType.expanded:
        return 4;
    }
  }

  static double? getContentMaxWidth(BuildContext context) {
    final type = getScreenType(context);
    switch (type) {
      case ScreenType.compact:
        return null;
      case ScreenType.medium:
        return 720;
      case ScreenType.expanded:
        return 1200;
    }
  }

  static double getHorizontalPadding(BuildContext context) {
    final type = getScreenType(context);
    switch (type) {
      case ScreenType.compact:
        return 24.0;
      case ScreenType.medium:
        return 32.0;
      case ScreenType.expanded:
        return 48.0;
    }
  }

  static double getProductCardAspectRatio(BuildContext context) {
    final type = getScreenType(context);
    switch (type) {
      case ScreenType.compact:
        return 0.62;
      case ScreenType.medium:
        return 0.65;
      case ScreenType.expanded:
        return 0.70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= 840) {
          return expanded ?? medium ?? compact;
        } else if (width >= 600) {
          return medium ?? compact;
        } else {
          return compact;
        }
      },
    );
  }
}
