import 'package:flutter/material.dart';

/// Order Tracking — "NovaStore" design.
///
/// Matches the Stitch "Order Tracking" screen:
///   • Navy gradient header with order number and estimated arrival.
///   • Shipping & Carrier info cards with surfaceContainerLowest background.
///   • Vertical timeline with connected dot/line indicators.
///   • Active step styled with secondaryContainer dot, completed with primary.
///   • No borders — depth via tonal layering and ambient shadows.
class OrderTrackingPage extends StatelessWidget {
  final String orderId;
  final String status;
  final String date;
  final double total;
  final int itemCount;

  const OrderTrackingPage({
    super.key,
    required this.orderId,
    required this.status,
    required this.date,
    required this.total,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header with order details ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 56, 28, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Text(
                          'NovaStore',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Order ID
                        Text(
                          '#$orderId',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Placed on $date · $itemCount Item${itemCount > 1 ? 's' : ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        // Estimated Arrival Card
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Arrival',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Today, 2:30 PM - 4:00 PM',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Content Body ──
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -24, 0),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Shipping & Carrier Info ──
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            title: 'Shipping To',
                            icon: Icons.location_on_outlined,
                            lines: [
                              'Eslam Medhat',
                              '123 Avenue Street',
                              'Cairo, Egypt',
                            ],
                            theme: theme,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _InfoCard(
                            title: 'Carrier Info',
                            icon: Icons.local_shipping_outlined,
                            lines: [
                              'Global Express',
                              'Tracking: GE-99120034',
                              'Signature Required',
                            ],
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // ── Delivery Timeline ──
                    Text(
                      'Delivery Timeline',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _TimelineStep(
                      title: 'Delivered',
                      subtitle: 'Pending arrival at destination',
                      time: null,
                      stepState: _StepState.upcoming,
                      isFirst: true,
                      theme: theme,
                    ),
                    _TimelineStep(
                      title: 'Out for Delivery',
                      subtitle: 'Package is with the local courier and will be delivered shortly.',
                      time: 'Oct 26 · 09:15 AM',
                      stepState: _StepState.active,
                      theme: theme,
                    ),
                    _TimelineStep(
                      title: 'Shipped from Warehouse',
                      subtitle: 'New Jersey Transit Center',
                      time: 'Oct 25 · 11:30 PM',
                      stepState: _StepState.completed,
                      theme: theme,
                    ),
                    _TimelineStep(
                      title: 'Order Processing',
                      subtitle: 'Items verified and packed',
                      time: 'Oct 24 · 04:45 PM',
                      stepState: _StepState.completed,
                      theme: theme,
                    ),
                    _TimelineStep(
                      title: 'Order Placed',
                      subtitle: 'Confirmation sent via email',
                      time: 'Oct 24 · 02:10 PM',
                      stepState: _StepState.completed,
                      isLast: true,
                      theme: theme,
                    ),

                    const SizedBox(height: 32),

                    // ── Action Buttons ──
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.support_agent_rounded, size: 20),
                        label: const Text('Contact Support'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back to Orders'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Info Card (Shipping To / Carrier Info)
// ─────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> lines;
  final ThemeData theme;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.lines,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryFixed.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Timeline Step
// ─────────────────────────────────────────────────────────────
enum _StepState { upcoming, active, completed }

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? time;
  final _StepState stepState;
  final bool isFirst;
  final bool isLast;
  final ThemeData theme;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    this.time,
    required this.stepState,
    this.isFirst = false,
    this.isLast = false,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isUpcoming = stepState == _StepState.upcoming;
    final isActive = stepState == _StepState.active;
    final isCompleted = stepState == _StepState.completed;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Dot & Connecting Line ──
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Top connecting line
                Container(
                  width: 2,
                  height: 8,
                  color: isFirst
                      ? Colors.transparent
                      : (isUpcoming
                          ? theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
                          : theme.colorScheme.primary.withValues(alpha: 0.3)),
                ),
                // Dot
                Container(
                  width: isActive ? 28 : 20,
                  height: isActive ? 28 : 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? theme.colorScheme.secondaryContainer
                        : isCompleted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHigh,
                    border: isActive
                        ? Border.all(
                            color: theme.colorScheme.secondaryContainer
                                .withValues(alpha: 0.3),
                            width: 4,
                          )
                        : null,
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
                  child: isCompleted
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                      : isActive
                          ? Icon(Icons.local_shipping_rounded,
                              color: theme.colorScheme.onSecondaryContainer,
                              size: 12)
                          : null,
                ),
                // Bottom connecting line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : (isUpcoming
                            ? theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
                            : theme.colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // ── Step Content ──
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: isActive ? const EdgeInsets.all(20) : EdgeInsets.zero,
              decoration: isActive
                  ? BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isUpcoming
                          ? theme.colorScheme.outline
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                      height: 1.5,
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      time!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isActive
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.outline.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
