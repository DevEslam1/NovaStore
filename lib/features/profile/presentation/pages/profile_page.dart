import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/app_config_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppConfigBloc, AppConfigState>(
        builder: (context, configState) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Eslam Medhat',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'eslam@example.com',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _ProfileHeader(title: 'Account Settings'),
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'Shipping Addresses',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    const _ProfileHeader(title: 'Preferences'),
                    _ProfileTile(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.language_outlined,
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
                          ToggleTheme(value ? ThemeMode.dark : ThemeMode.light),
                        );
                      },
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    _ProfileTile(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      color: Colors.red,
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

class _ProfileHeader extends StatelessWidget {
  final String title;
  const _ProfileHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.outline,
        ),
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
  final Color? color;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
        trailing: isSwitch
            ? Switch(
                value: switchValue ?? false,
                onChanged: onSwitchChanged,
                activeThumbColor: Theme.of(context).colorScheme.primary,
              )
            : (trailing != null
                  ? Text(
                      trailing!,
                      style: TextStyle(color: Theme.of(context).colorScheme.outline),
                    )
                  : const Icon(Icons.chevron_right, size: 20)),
        onTap: isSwitch ? null : onTap,
      ),
    );
  }
}
