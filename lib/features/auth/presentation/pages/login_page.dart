import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/utils/shake_widget.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

/// Authentication screen — "NovaStore" design.
///
/// Adaptive layout: single column on mobile, two columns (split view) on tablet/desktop.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPhoneLogin = false;
  int _shakeTrigger = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isPhoneLogin) {
        context.read<AuthBloc>().add(
              AuthPhoneSignInRequested(
                _phoneController.text.trim(),
              ),
            );
      } else {
        context.read<AuthBloc>().add(
              AuthSignInRequested(
                _emailController.text.trim(),
                _passwordController.text,
              ),
            );
      }
    } else {
      HapticHelper.error();
      setState(() {
        _shakeTrigger++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          HapticHelper.error();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Trigger shake on error
          setState(() {
            _shakeTrigger++;
          });
        } else if (state is AuthOtpSent) {
          HapticHelper.light();
          context.push('/otp', extra: {
            'verificationId': state.verificationId,
            'phoneNumber': state.phoneNumber,
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isExpanded = ResponsiveLayout.isExpanded(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Row(
            children: [
              // Left branding panel (only on Expanded layout)
              if (isExpanded)
                Expanded(
                  flex: 1,
                  child: Container(
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
                        padding: const EdgeInsets.all(48.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.storefront_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                            const Spacer(),
                            Text(
                              'NovaStore',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Step into a world of curated excellence and elevated living. Discover premium collections tailored just for you.',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              
              // Right side (Form Panel)
              Expanded(
                flex: isExpanded ? 1 : 1,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isExpanded ? 64.0 : 28.0,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: ShakeWidget(
                          shakeTrigger: _shakeTrigger,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!isExpanded) ...[
                                  // Brand mark
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              theme.colorScheme.primary,
                                              theme.colorScheme.primaryContainer,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.storefront_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'NovaStore',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Step into a world of curated excellence.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                ],
                    
                                // Welcome copy
                                Text(
                                  'Welcome\nBack',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.onSurface,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Access your curated collection and exclusive offers.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.outline,
                                    height: 1.5,
                                  ),
                                ),
                    
                                const SizedBox(height: 36),
                                
                                // Auth Method Toggle
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            HapticHelper.light();
                                            setState(() => _isPhoneLogin = false);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            decoration: BoxDecoration(
                                              color: !_isPhoneLogin ? theme.colorScheme.surface : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Email',
                                              style: TextStyle(
                                                fontWeight: !_isPhoneLogin ? FontWeight.bold : FontWeight.normal,
                                                color: !_isPhoneLogin ? theme.colorScheme.primary : theme.colorScheme.outline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            HapticHelper.light();
                                            setState(() => _isPhoneLogin = true);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            decoration: BoxDecoration(
                                              color: _isPhoneLogin ? theme.colorScheme.surface : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Phone',
                                              style: TextStyle(
                                                fontWeight: _isPhoneLogin ? FontWeight.bold : FontWeight.normal,
                                                color: _isPhoneLogin ? theme.colorScheme.primary : theme.colorScheme.outline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                    
                                // Form fields
                                if (!_isPhoneLogin) ...[
                                  CustomTextField(
                                    label: 'Email Address',
                                    hint: 'enter your email',
                                    controller: _emailController,
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: theme.colorScheme.outline,
                                      size: 20,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Email is required';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  CustomTextField(
                                    label: 'Password',
                                    hint: 'enter your password',
                                    isPassword: true,
                                    controller: _passwordController,
                                    prefixIcon: Icon(
                                      Icons.lock_outline_rounded,
                                      color: theme.colorScheme.outline,
                                      size: 20,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ] else ...[
                                  CustomTextField(
                                    label: 'Phone Number',
                                    hint: '+1 234 567 8900',
                                    controller: _phoneController,
                                    prefixIcon: Icon(
                                      Icons.phone_android_rounded,
                                      color: theme.colorScheme.outline,
                                      size: 20,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Phone number is required';
                                      return null;
                                    },
                                  ),
                                ],
                                if (!_isPhoneLogin)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        HapticHelper.light();
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                    
                                const SizedBox(height: 28),
                    
                                // CTA buttons
                                CustomButton(
                                  text: _isPhoneLogin ? 'Send Code' : 'Sign In',
                                  isLoading: isLoading,
                                  onPressed: () {
                                    HapticHelper.light();
                                    _submit();
                                  },
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 14),
                                // Ghost/tertiary CTA
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: OutlinedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            HapticHelper.light();
                                            context
                                              .read<AuthBloc>()
                                              .add(AuthSignInAsGuestRequested());
                                          },
                                    child: const Text('Continue as Guest'),
                                  ),
                                ),
                    
                                const SizedBox(height: 28),
                    
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        HapticHelper.light();
                                        context.push('/register');
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
