import 'package:flutter/material.dart';
import 'package:newstore/shared/widgets/custom_button.dart';

/// Checkout: Payment & Confirm — "NovaStore" design.
///
/// Matches the Stitch "Checkout: Payment & Confirm" screen:
///   • Step indicator at top (3 steps).
///   • Saved payment cards with radio-style selection (tonal highlight).
///   • "Add new card" button with ghost-border style.
///   • Order preview card with product thumbnail.
///   • Benefit badges (Free Delivery, Easy Returns).
///   • Navy "Confirm & Pay" CTA at bottom.
///   • Secure checkout banner with lock icon.
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Secure Checkout',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Step Indicator ──
                  Row(
                    children: [
                      _StepDot(
                        step: 1,
                        label: 'Address',
                        isCompleted: true,
                        theme: theme,
                      ),
                      _StepConnector(isCompleted: true, theme: theme),
                      _StepDot(
                        step: 2,
                        label: 'Delivery',
                        isCompleted: true,
                        theme: theme,
                      ),
                      _StepConnector(isCompleted: false, theme: theme),
                      _StepDot(
                        step: 3,
                        label: 'Payment',
                        isActive: true,
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // ── Payment Method Section ──
                  Text(
                    'Payment Method',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select or add a payment method.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Saved Card: Visa ──
                  Text(
                    'SAVED CARDS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PaymentCard(
                    brand: 'Visa Platinum',
                    lastFour: '8824',
                    expiry: '05/27',
                    icon: Icons.credit_card_rounded,
                    gradientColors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                    isSelected: _selectedCardIndex == 0,
                    onTap: () => setState(() => _selectedCardIndex = 0),
                    theme: theme,
                  ),
                  const SizedBox(height: 12),

                  // ── Saved Card: Mastercard ──
                  _PaymentCard(
                    brand: 'Mastercard World',
                    lastFour: '1092',
                    expiry: '11/25',
                    icon: Icons.credit_card_rounded,
                    gradientColors: [
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E),
                    ],
                    isSelected: _selectedCardIndex == 1,
                    onTap: () => setState(() => _selectedCardIndex = 1),
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // ── Add New Card ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        'Add New Card',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Order Summary ──
                  Text(
                    'Order Summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.03),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Product Preview
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 64,
                                height: 64,
                                color: theme.colorScheme.surfaceContainerHigh,
                                child: Icon(
                                  Icons.watch_rounded,
                                  color: theme.colorScheme.outline,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Architectural Timepiece',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Brushed Steel / 42mm',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$349.00',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        // Summary rows
                        _SummaryRow(
                          label: 'Subtotal',
                          value: '\$349.00',
                          theme: theme,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Shipping',
                          value: 'Free',
                          theme: theme,
                          isHighlighted: true,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Tax',
                          value: '\$18.50',
                          theme: theme,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '\$367.50',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Benefit Badges ──
                  Row(
                    children: [
                      Expanded(
                        child: _BenefitBadge(
                          icon: Icons.local_shipping_outlined,
                          title: 'Free Delivery',
                          subtitle: 'Orders over \$200',
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _BenefitBadge(
                          icon: Icons.replay_rounded,
                          title: 'Easy Returns',
                          subtitle: '30-day window',
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Bottom CTA Bar ──
          Container(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    text: 'Confirm & Pay · \$367.50',
                    icon: Icons.lock_outline_rounded,
                    onPressed: () {
                      _showPaymentSuccessDialog(context);
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Secured with 256-bit SSL encryption',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 48,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Payment Successful!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your order has been confirmed.\nWe\'ll send you a confirmation email shortly.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Track Your Order',
                isSecondary: true,
                onPressed: () {
                  Navigator.of(context).pop(); // dismiss dialog
                  Navigator.of(context).pop(); // back to checkout
                },
                width: double.infinity,
                height: 52,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Step Indicator Dot
// ─────────────────────────────────────────────────────────────
class _StepDot extends StatelessWidget {
  final int step;
  final String label;
  final bool isCompleted;
  final bool isActive;
  final ThemeData theme;

  const _StepDot({
    required this.step,
    required this.label,
    this.isCompleted = false,
    this.isActive = false,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? theme.colorScheme.primary
                  : isActive
                      ? theme.colorScheme.secondaryContainer
                      : theme.colorScheme.surfaceContainerHigh,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                  : Text(
                      '$step',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isActive
                            ? theme.colorScheme.onSecondaryContainer
                            : theme.colorScheme.outline,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isActive || isCompleted
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.outline,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Step Connector Line
// ─────────────────────────────────────────────────────────────
class _StepConnector extends StatelessWidget {
  final bool isCompleted;
  final ThemeData theme;
  const _StepConnector({required this.isCompleted, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 2,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isCompleted
            ? theme.colorScheme.primary.withValues(alpha: 0.4)
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Payment Card (Selectable)
// ─────────────────────────────────────────────────────────────
class _PaymentCard extends StatelessWidget {
  final String brand;
  final String lastFour;
  final String expiry;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _PaymentCard({
    required this.brand,
    required this.lastFour,
    required this.expiry,
    required this.icon,
    required this.gradientColors,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondaryContainer
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 28),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: theme.colorScheme.onSecondaryContainer,
                      size: 14,
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '····  ····  ····  $lastFour',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  brand,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Exp $expiry',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Benefit Badge
// ─────────────────────────────────────────────────────────────
class _BenefitBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;

  const _BenefitBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryFixed.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Summary Row
// ─────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool isHighlighted;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.theme,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isHighlighted
                ? theme.colorScheme.secondary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
