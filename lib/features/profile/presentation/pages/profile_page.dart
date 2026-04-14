import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/bloc/app_config_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:newstore/core/utils/firebase_seeder.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<AppConfigBloc, AppConfigState>(
        builder: (context, configState) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final user = authState is Authenticated ? authState.user : null;

              return RefreshIndicator(
                onRefresh: () async {
                  await FirebaseAuth.instance.currentUser?.reload();
                  if (context.mounted) {
                    context.read<AuthBloc>().add(AuthCheckRequested());
                  }
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                  // ── Profile Header with Signature Gradient ──
                  SliverAppBar(
                    expandedHeight: 240,
                    pinned: true,
                    backgroundColor: theme.colorScheme.primary,
                    surfaceTintColor: Colors.transparent,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Avatar with border ring
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundColor: theme.colorScheme.primaryContainer,
                                backgroundImage: user?.photoUrl != null
                                    ? NetworkImage(user!.photoUrl!)
                                    : const NetworkImage(
                                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200',
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user?.name ?? 'Guest User',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'Explore limited features',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Settings List ──
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _SectionTitle(title: 'Account Settings', theme: theme),
                        const SizedBox(height: 12),
                        _ProfileTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal Information',
                          onTap: () => _showComingSoon(context),
                        ),
                        _ProfileTile(
                          icon: Icons.favorite_border_rounded,
                          title: 'My Favorites',
                          onTap: () => context.push(AppRouter.favorites),
                        ),
                        _ProfileTile(
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          onTap: () => context.push(AppRouter.orders),
                        ),
                        _ProfileTile(
                          icon: Icons.location_on_outlined,
                          title: 'Shipping Addresses',
                          onTap: () => context.push(AppRouter.addresses),
                        ),
                        _ProfileTile(
                          icon: Icons.payment_rounded,
                          title: 'Payment Methods',
                          onTap: () => _showComingSoon(context),
                        ),

                        const SizedBox(height: 28),
                        _SectionTitle(title: 'Preferences', theme: theme),
                        const SizedBox(height: 12),
                        _ProfileTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          onTap: () => _showComingSoon(context),
                        ),
                        _ProfileTile(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          trailing: configState.locale.languageCode == 'en'
                              ? 'English'
                              : 'العربية',
                          onTap: () {
                            final newLocale =
                                configState.locale.languageCode == 'en'
                                ? const Locale('ar')
                                : const Locale('en');
                            context.read<AppConfigBloc>().add(
                              ChangeLocale(newLocale),
                            );
                          },
                        ),
                        _ProfileTile(
                          icon: Icons.palette_outlined,
                          title: 'App Theme',
                          trailing: configState.themeMode == ThemeMode.system
                              ? 'System'
                              : configState.themeMode == ThemeMode.dark
                                  ? 'Dark'
                                  : 'Light',
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: theme.colorScheme.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Choose Theme',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _ThemeOption(
                                      title: 'System Default',
                                      icon: Icons.settings_brightness_rounded,
                                      isSelected: configState.themeMode == ThemeMode.system,
                                      onTap: () {
                                        context.read<AppConfigBloc>().add(const ToggleTheme(ThemeMode.system));
                                        Navigator.pop(context);
                                      },
                                    ),
                                    _ThemeOption(
                                      title: 'Light Mode',
                                      icon: Icons.light_mode_rounded,
                                      isSelected: configState.themeMode == ThemeMode.light,
                                      onTap: () {
                                        context.read<AppConfigBloc>().add(const ToggleTheme(ThemeMode.light));
                                        Navigator.pop(context);
                                      },
                                    ),
                                    _ThemeOption(
                                      title: 'Dark Mode',
                                      icon: Icons.dark_mode_rounded,
                                      isSelected: configState.themeMode == ThemeMode.dark,
                                      onTap: () {
                                        context.read<AppConfigBloc>().add(const ToggleTheme(ThemeMode.dark));
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        if (kDebugMode) ...[
                          const SizedBox(height: 28),
                          _SectionTitle(title: 'Developer Tools', theme: theme),
                          const SizedBox(height: 12),
                          _ProfileTile(
                            icon: Icons.cloud_upload_outlined,
                            title: 'Initialize Store Data',
                            onTap: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('Initializing store with sample data...')),
                                );
                                await FirebaseSeeder.seedAll();
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Store data initialized successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to initialize: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                          _ProfileTile(
                            icon: Icons.cleaning_services_rounded,
                            title: 'Clear All Data',
                            isDestructive: true,
                            onTap: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('Clearing all store data...')),
                                );
                                await FirebaseSeeder.clearAllData();
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Store data cleared successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to clear data: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],

                        const SizedBox(height: 28),
                        _ProfileTile(
                          icon: Icons.logout_rounded,
                          title: 'Sign Out',
                          isDestructive: true,
                          onTap: () {
                            context.read<AuthBloc>().add(AuthSignOutRequested());
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _SectionTitle({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.outline,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tileColor = isDestructive
        ? const Color(0xFFFF4444)
        : theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive
                ? const Color(0xFFFF4444).withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: tileColor, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDestructive ? const Color(0xFFFF4444) : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing != null
            ? Text(
                trailing!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              )
            : Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: theme.colorScheme.outline,
              ),
        onTap: onTap,
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.w700 : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}


