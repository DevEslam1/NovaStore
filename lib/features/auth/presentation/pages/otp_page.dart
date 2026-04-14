import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
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
      setState(() {
        _secondsRemaining = 30;
      });
      _startTimer();
      // Add logic to resend OTP via BLoC
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Resent successfully")),
      );
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
                Icons.mark_email_read_outlined,
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
              length: 4,
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
              onCompleted: (v) {
                debugPrint("Completed: $v");
                // Navigate to home after brief delay to simulate verification success
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    context.go('/');
                  }
                });
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
                  onTap: _resendOtp,
                  child: Text(
                    _secondsRemaining > 0 
                      ? "Resend in ${_secondsRemaining}s"
                      : "Resend Code",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _secondsRemaining > 0 ? theme.colorScheme.outline : theme.colorScheme.primary,
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
                onPressed: currentText.length == 4 
                  ? () => context.go('/')
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
