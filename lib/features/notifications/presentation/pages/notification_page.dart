import 'package:flutter/material.dart';
import '../../domain/entities/notification_item.dart';
import 'package:intl/intl.dart';
import 'package:newstore/core/utils/responsive_layout.dart';
import 'package:newstore/core/utils/staggered_animation.dart';
import 'package:newstore/core/utils/haptic_helper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample messages as requested
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: '🔥 BIG SUMMER SALE!',
      body: 'The biggest sale of the season is here! Up to 50% off on all items. Don\'t miss out on these exclusive deals.',
      timestamp: DateTime.now(),
      type: NotificationType.promotion,
    ),
    NotificationItem(
      id: '2',
      title: 'Order Shipped',
      body: 'Your order #88219 has been handed over to our delivery partner and is on its way to you.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      type: NotificationType.orderUpdate,
    ),
    NotificationItem(
      id: '3',
      title: 'New Collections Arrival',
      body: 'Check out the new arrivals in our Tech & Lifestyle collections. Premium quality, curated just for you.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      type: NotificationType.appUpdate,
    ),
    NotificationItem(
      id: '4',
      title: 'Security Update',
      body: 'Your profile information has been successfully updated. If this wasn\'t you, please contact support immediately.',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      type: NotificationType.appUpdate,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxWidth = ResponsiveLayout.getContentMaxWidth(context) ?? 800.0; // Narrower max-width for lists
    final horizontalPadding = ResponsiveLayout.getHorizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _notifications.isEmpty
              ? Center(
                  child: Text(
                    'No new notifications',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, 
                    vertical: 16,
                  ),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final item = _notifications[index];
                    return StaggeredListItem(
                      index: index,
                      child: Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          HapticHelper.medium();
                          setState(() {
                            _notifications.removeAt(index);
                          });
                        },
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: theme.colorScheme.error,
                            size: 28,
                          ),
                        ),
                        child: _NotificationTile(item: item),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    IconData iconData;
    Color iconColor;
    
    switch (item.type) {
      case NotificationType.appUpdate:
        iconData = Icons.system_update_rounded;
        iconColor = theme.colorScheme.primary;
        break;
      case NotificationType.orderUpdate:
        iconData = Icons.local_shipping_rounded;
        iconColor = theme.colorScheme.secondary;
        break;
      case NotificationType.promotion:
        iconData = Icons.local_fire_department_rounded;
        iconColor = Colors.orangeAccent;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      _formatTimestamp(item.timestamp),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      return 'Just now';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(dt);
    }
  }
}
