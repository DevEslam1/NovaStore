import 'package:flutter/material.dart';

/// Premium button that follows "The Curated Pavilion" design system.
///
/// - **Primary**: Pill-shaped with a navy-to-deep-navy gradient (Signature Texture).
/// - **Secondary (conversion)**: Coral-orange solid fill.
/// - **Tertiary (ghost)**: No background, subtle text styling.
///
/// Uses a 0.97 scale-down press effect instead of color-shifting.
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final bool isTertiary;
  final double? width;
  final double height;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.isTertiary = false,
    this.width,
    this.height = 56,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isTertiary) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextButton(
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: _buildButton(theme),
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme) {
    if (widget.isSecondary) {
      // Coral-orange conversion CTA
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.secondary,
              theme.colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.onPressed,
            child: Center(
              child: _buildLabel(Colors.white),
            ),
          ),
        ),
      );
    }

    // Primary navy gradient (Signature Texture)
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: widget.onPressed,
          child: Center(
            child: _buildLabel(theme.colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(Color color) {
    if (widget.isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2,
        ),
      );
    }
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }
    return Text(
      widget.text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: color,
        letterSpacing: 0.3,
      ),
    );
  }
}
