import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/app_config_bloc.dart';

/// User Profile — "The Curated Pavilion" design.
///
/// • Gradient header (Signature Texture) with avatar.
/// • Setting tiles on surfaceContainerLowest with ambient shadows.
/// • No borders — tonal layering only.
/// • Premium feel with generous spacing and 24px card radii.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<AppConfigBloc, AppConfigState>(
        builder: (context, configState) {
          return CustomScrollView(
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
                          child: const CircleAvatar(
                            radius: 42,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Eslam Medhat',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'eslam@example.com',
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
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'Shipping Addresses',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.payment_rounded,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),

                    const SizedBox(height: 28),
                    _SectionTitle(title: 'Preferences', theme: theme),
                    const SizedBox(height: 12),
                    _ProfileTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      onTap: () {},
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
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      isSwitch: true,
                      switchValue: configState.themeMode == ThemeMode.dark,
                      onSwitchChanged: (value) {
                        context.read<AppConfigBloc>().add(
                          ToggleTheme(
                            value ? ThemeMode.dark : ThemeMode.light,
                          ),
                        );
                      },
                      onTap: () {},
                    ),

                    const SizedBox(height: 28),
                    _ProfileTile(
                      icon: Icons.logout_rounded,
                      title: 'Sign Out',
                      isDestructive: true,
                      onTap: () {},
                    ),
                  ]),
                ),
              ),
            ],
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
  final bool isSwitch;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tileColor =
        isDestructive ? const Color(0xFFFF4444) : theme.colorScheme.primary;

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
        trailing: isSwitch
            ? Switch(
                value: switchValue ?? false,
                onChanged: onSwitchChanged,
              )
            : (trailing != null
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
                  )),
        onTap: isSwitch ? null : onTap,
      ),
    );
  }
}
