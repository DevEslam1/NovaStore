import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/shared/widgets/custom_button.dart';
import 'package:newstore/core/routing/app_router.dart';

/// Checkout: Address, Delivery & Payment — "The Curated Pavilion" design.
///
/// • Selectable cards with ghost-border when active, tonal shift.
/// • No 1px borders — boundaries from background shifts.
/// • Coral "Place Order" CTA.
/// • Success dialog with 32px corner radius.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: theme.textTheme.headlineSmall?.copyWith(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            _SectionHeader(title: 'Shipping Address', theme: theme),
            const SizedBox(height: 16),
            _SelectableCard(
              title: 'Home Address',
              subtitle: '123 Avenue Street, Cairo, Egypt',
              icon: Icons.home_outlined,
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Work Address',
              subtitle: '456 Business Road, Giza, Egypt',
              icon: Icons.business_outlined,
              isSelected: false,
              onTap: () {},
            ),

            const SizedBox(height: 36),

            // Delivery Method
            _SectionHeader(title: 'Delivery Method', theme: theme),
            const SizedBox(height: 16),
            _SelectableCard(
              title: 'Standard Delivery',
              subtitle: '3-5 business days · Free',
              icon: Icons.local_shipping_outlined,
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Express Delivery',
              subtitle: '1-2 business days · \$12.00',
              icon: Icons.bolt_outlined,
              isSelected: false,
              onTap: () {},
            ),

            const SizedBox(height: 36),

            // Payment Method
            _SectionHeader(title: 'Payment Method', theme: theme),
            const SizedBox(height: 16),
            _SelectableCard(
              title: 'Credit Card',
              subtitle: '**** **** **** 4242',
              icon: Icons.credit_card_rounded,
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Apple Pay',
              subtitle: 'Linked to eslam@example.com',
              icon: Icons.apple_rounded,
              isSelected: false,
              onTap: () {},
            ),

            const SizedBox(height: 36),

            // Order Summary
            _SectionHeader(title: 'Order Summary', theme: theme),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _SummaryRow(label: 'Subtotal', value: '\$948.00', theme: theme),
                  const SizedBox(height: 10),
                  _SummaryRow(label: 'Shipping', value: 'Free', theme: theme, isHighlighted: true),
                  const SizedBox(height: 10),
                  _SummaryRow(label: 'Tax', value: '\$45.00', theme: theme),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
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
                        '\$993.00',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            CustomButton(
              text: 'Continue to Payment',
              isSecondary: true,
              icon: Icons.payment_rounded,
              onPressed: () {
                context.push(AppRouter.payment);
              },
              width: double.infinity,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableCard({
    required this.title,
    required this.subtitle,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryFixed.withValues(alpha: 0.3)
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

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
