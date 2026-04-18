import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:newstore/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newstore/features/order/domain/entities/order_entity.dart';
import 'package:newstore/features/order/presentation/bloc/orders_bloc.dart';
import 'package:newstore/shared/widgets/empty_state_widget.dart';
import 'package:newstore/core/utils/responsive_layout.dart';
import 'package:newstore/core/utils/staggered_animation.dart';
import 'package:newstore/core/utils/haptic_helper.dart';

/// Orders — "NovaStore" design.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<OrdersBloc>().add(LoadOrders(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadOrders(),
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text(state.message)),
                ),
              );
            }

            if (state is OrdersLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top,
                    child: EmptyStateWidget(
                      title: 'No orders yet',
                      message: 'Your order history will appear here. Start shopping to see your orders!',
                      icon: Icons.receipt_long_outlined,
                      actionLabel: 'Shop Now',
                      onAction: () => context.go(AppRouter.home),
                    ),
                  ),
                );
              }

              final maxWidth = ResponsiveLayout.getContentMaxWidth(context) ?? 800.0;
              final horizontalPadding = ResponsiveLayout.getHorizontalPadding(context);

              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 120),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return StaggeredListItem(
                        index: index,
                        child: _OrderCard(order: orders[index]),
                      );
                    },
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderCard({required this.order});

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(OrderStatus status, ThemeData theme) {
    if (status == OrderStatus.delivered) return const Color(0xFF10B981);
    if (status == OrderStatus.cancelled) return theme.colorScheme.error;
    return theme.colorScheme.onSecondaryFixed;
  }

  Color _getStatusBg(OrderStatus status, ThemeData theme) {
    if (status == OrderStatus.delivered) return const Color(0xFF10B981).withValues(alpha: 0.1);
    if (status == OrderStatus.cancelled) return theme.colorScheme.errorContainer;
    return theme.colorScheme.secondaryFixed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = _getStatusText(order.status);
    final statusColor = _getStatusColor(order.status, theme);
    final statusBg = _getStatusBg(order.status, theme);
    final dateFormatted = DateFormat('MMM dd, yyyy').format(order.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ORDER #${order.id.substring(0, 8).toUpperCase()}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                dateFormatted,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const Spacer(),
              Text(
                '${order.items.length} Item${order.items.length > 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.outline,
                ),
              ),
              Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                HapticHelper.light();
                context.push(
                  AppRouter.orderTracking,
                  extra: {
                    'id': order.id,
                    'status': statusText,
                    'date': dateFormatted,
                    'total': order.totalAmount,
                    'items': order.items.length,
                  },
                );
              },
              child: const Text('Track Order'),
            ),
          ),
        ],
      ),
    );
  }
}
