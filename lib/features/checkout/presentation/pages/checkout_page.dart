import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newstore/shared/widgets/custom_button.dart';
import 'package:newstore/core/routing/app_router.dart';
import 'package:newstore/features/profile/presentation/bloc/address_bloc.dart';
import 'package:newstore/features/cart/presentation/bloc/cart_bloc.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/utils/haptic_helper.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddresses());
  }

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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressLoaded && _selectedAddressId == null) {
            final defaultAddr = state.addresses.where((a) => a.isDefault).firstOrNull ??
                state.addresses.firstOrNull;
            if (defaultAddr != null) {
              setState(() {
                _selectedAddressId = defaultAddr.id;
              });
            }
          }
        },
        builder: (context, addressState) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = cartState.items;
              final subtotal = cartState.totalPrice;
              const shippingFee = 0.0;
              final tax = subtotal * 0.05;
              final total = subtotal + shippingFee + tax;

              final leftContent = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionHeader(title: 'Shipping Address', theme: theme),
                      TextButton(
                        onPressed: () {
                          HapticHelper.light();
                          context.push(AppRouter.addAddress);
                        },
                        child: const Text('Add New'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (addressState is AddressLoading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ))
                  else if (addressState is AddressLoaded && addressState.addresses.isEmpty)
                    _EmptyAddressPlaceholder(theme: theme)
                  else if (addressState is AddressLoaded)
                    ...addressState.addresses.map((address) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SelectableCard(
                            title: address.label,
                            subtitle: '${address.street}, ${address.city}',
                            icon: _getIcon(address.label),
                            isSelected: _selectedAddressId == address.id,
                            onTap: () {
                              HapticHelper.selection();
                              setState(() => _selectedAddressId = address.id);
                            },
                          ),
                        ))
                  else if (addressState is AddressError)
                    Text('Error loading addresses: ${addressState.message}', 
                      style: TextStyle(color: theme.colorScheme.error)),
                  
                  const SizedBox(height: 36),

                  // Delivery Method
                  _SectionHeader(title: 'Delivery Method', theme: theme),
                  const SizedBox(height: 16),
                  _SelectableCard(
                    title: 'Standard Delivery',
                    subtitle: '3-5 business days · Free',
                    icon: Icons.local_shipping_outlined,
                    isSelected: true,
                    onTap: () => HapticHelper.selection(),
                  ),
                  const SizedBox(height: 12),
                  _SelectableCard(
                    title: 'Express Delivery',
                    subtitle: '1-2 business days · \$12.00',
                    icon: Icons.bolt_outlined,
                    isSelected: false,
                    onTap: () => HapticHelper.selection(),
                  ),
                  const SizedBox(height: 36),
                ],
              );

              final rightContent = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        _SummaryRow(
                          label: 'Subtotal',
                          value: '\$${subtotal.toStringAsFixed(2)}',
                          theme: theme,
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          label: 'Shipping',
                          value: 'Free',
                          theme: theme,
                          isHighlighted: true,
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          label: 'Tax', 
                          value: '\$${tax.toStringAsFixed(2)}', 
                          theme: theme,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.2,
                            ),
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
                              '\$${total.toStringAsFixed(2)}',
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
                    onPressed: _selectedAddressId == null
                        ? null
                        : () {
                            HapticHelper.medium();
                            final selectedAddress = (addressState as AddressLoaded)
                                .addresses
                                .firstWhere((a) => a.id == _selectedAddressId);
                            
                            context.push(
                              AppRouter.payment,
                              extra: {
                                'items': items,
                                'subtotal': subtotal,
                                'shippingFee': shippingFee,
                                'tax': tax,
                                'total': total,
                                'shippingAddress': '${selectedAddress.street}, ${selectedAddress.city}',
                              },
                            );
                          },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 24),
                ],
              );

              final isCompact = ResponsiveLayout.isCompact(context);

              if (isCompact) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftContent,
                      rightContent,
                    ],
                  ),
                );
              }

              final maxWidth = ResponsiveLayout.getContentMaxWidth(context) ?? 1200.0;
              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(48, 24, 48, 48),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: leftContent,
                        ),
                        const SizedBox(width: 48),
                        Expanded(
                          flex: 4,
                          child: rightContent,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIcon(String label) {
    if (label.toLowerCase() == 'home') return Icons.home_outlined;
    if (label.toLowerCase() == 'work') return Icons.business_outlined;
    return Icons.location_on_outlined;
  }
}

class _EmptyAddressPlaceholder extends StatelessWidget {
  final ThemeData theme;
  const _EmptyAddressPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRouter.addresses),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.add_location_alt_rounded, 
              size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text('No Shipping Address', 
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Tap to add a new shipping address', 
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
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
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
