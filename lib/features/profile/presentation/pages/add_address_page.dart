import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newstore/features/profile/domain/entities/address_entity.dart';
import 'package:uuid/uuid.dart';
import '../bloc/address_bloc.dart';

class AddAddressPage extends StatefulWidget {
  final AddressEntity? address;

  const AddAddressPage({super.key, this.address});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late String _label;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _label = widget.address?.label ?? 'Home';
    _nameController = TextEditingController(text: widget.address?.fullName);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _streetController = TextEditingController(text: widget.address?.street);
    _cityController = TextEditingController(text: widget.address?.city);
    _stateController = TextEditingController(text: widget.address?.state);
    _zipController = TextEditingController(text: widget.address?.zipCode);
    _countryController = TextEditingController(text: widget.address?.country ?? 'USA');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final address = AddressEntity(
        id: widget.address?.id ?? const Uuid().v4(),
        label: _label,
        fullName: _nameController.text,
        phone: _phoneController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipController.text,
        country: _countryController.text,
        isDefault: widget.address?.isDefault ?? false,
      );

      if (widget.address == null) {
        context.read<AddressBloc>().add(AddAddress(address));
      } else {
        context.read<AddressBloc>().add(UpdateAddress(address));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'New Address' : 'Edit Address',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address Label',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LabelChip(
                    label: 'Home',
                    isSelected: _label == 'Home',
                    onSelect: (val) => setState(() => _label = val),
                  ),
                  const SizedBox(width: 8),
                  _LabelChip(
                    label: 'Work',
                    isSelected: _label == 'Work',
                    onSelect: (val) => setState(() => _label = val),
                  ),
                  const SizedBox(width: 8),
                  _LabelChip(
                    label: 'Other',
                    isSelected: _label == 'Other',
                    onSelect: (val) => setState(() => _label = val),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildTextField('Full Name', _nameController, Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField('Phone Number', _phoneController, Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField('Street Address', _streetController, Icons.location_on_outlined),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField('City', _cityController, null)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('State', _stateController, null)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField('Zip Code', _zipController, null)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Country', _countryController, null)),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.address == null ? 'Save Address' : 'Update Address',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData? icon, {
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(String) onSelect;

  const _LabelChip({
    required this.label,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelect(label),
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
