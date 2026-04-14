import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String? verificationId;

  const OtpPage({
    super.key,
    required this.email,
    this.verificationId,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String? _verificationId;
  String currentText = "";
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _resendOtp() {
    if (_secondsRemaining == 0) {
      if (_verificationId != null) {
        // Resend for Phone
        context.read<AuthBloc>().add(AuthPhoneSignInRequested(widget.email));
      } else {
        // Handle Email resend if implemented
      }
    }
  }

  @override
  void dispose() {
    errorController?.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is Authenticated) {
          context.go('/');
        } else if (state is AuthOtpSent) {
          setState(() {
            _verificationId = state.verificationId;
          });
          _startTimer();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP Resent successfully")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("OTP Verification"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _verificationId != null ? Icons.phone_android_rounded : Icons.mark_email_read_outlined,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Verification Code",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "We have sent the code verification to\n",
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 64,
                    fieldWidth: 64,
                    activeFillColor: theme.colorScheme.surface,
                    inactiveFillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    selectedFillColor: theme.colorScheme.surface,
                    activeColor: theme.colorScheme.primary,
                    inactiveColor: theme.colorScheme.outlineVariant,
                    selectedColor: theme.colorScheme.primary,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  enabled: !isLoading,
                  onCompleted: (v) {
                    if (_verificationId != null) {
                      context.read<AuthBloc>().add(
                            AuthOtpVerificationRequested(
                              verificationId: _verificationId!,
                              smsCode: v,
                              phoneNumber: widget.email,
                            ),
                          );
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't receive the code? ",
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                    ),
                    GestureDetector(
                      onTap: isLoading ? null : _resendOtp,
                      child: Text(
                        _secondsRemaining > 0 ? "Resend in ${_secondsRemaining}s" : "Resend Code",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _secondsRemaining > 0 || isLoading ? theme.colorScheme.outline : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: currentText.length == 6 && !isLoading
                        ? () {
                            if (_verificationId != null) {
                              context.read<AuthBloc>().add(
                                    AuthOtpVerificationRequested(
                                      verificationId: _verificationId!,
                                      smsCode: currentText,
                                      phoneNumber: widget.email,
                                    ),
                                  );
                            } else {
                              // Fallback for email or other flows
                              context.go('/');
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : const Text(
                            "Verify",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
