import 'package:flutter/material.dart';
import 'package:newstore/shared/widgets/custom_button.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            const _SectionHeader(title: 'Shipping Address'),
            const SizedBox(height: 16),
            _SelectableCard(
              title: 'Home Address',
              subtitle: '123 Avenue Street, Cairo, Egypt',
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Work Address',
              subtitle: '456 Business Road, Giza, Egypt',
              isSelected: false,
              onTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            // Payment Method
            const _SectionHeader(title: 'Payment Method'),
            const SizedBox(height: 16),
            _SelectableCard(
              title: 'Credit Card',
              subtitle: '**** **** **** 4242',
              icon: Icons.credit_card,
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Apple Pay',
              subtitle: 'Linked to eslam@example.com',
              icon: Icons.apple,
              isSelected: false,
              onTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            // Order Summary
            const _SectionHeader(title: 'Order Summary'),
            const SizedBox(height: 16),
            const _SummaryRow(label: 'Subtotal', value: '\$948.00'),
            const _SummaryRow(label: 'Shipping', value: 'Free'),
            const _SummaryRow(label: 'Tax', value: '\$45.00'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            const _SummaryRow(
              label: 'Total', 
              value: '\$993.00', 
              isTotal: true,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Place Order', 
              onPressed: () {
                _showSuccessDialog(context);
              },
              width: double.infinity,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Order Placed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your order has been placed successfully. We\'ll notify you once it ships.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Back to Home', 
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Back to cart
                  // In a real app we'd navigate to home tab
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha:0.05) : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
