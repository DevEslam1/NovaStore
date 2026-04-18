import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';

class NetworkBanner extends StatefulWidget {
  final Widget child;
  final InternetConnectionChecker? connectionChecker;

  const NetworkBanner({
    super.key,
    required this.child,
    this.connectionChecker,
  });

  @override
  State<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends State<NetworkBanner> {
  late StreamSubscription<InternetConnectionStatus> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    final checker = widget.connectionChecker ?? InternetConnectionChecker.instance;
    _subscription = checker.onStatusChange.listen((status) {
      final isConnected = status == InternetConnectionStatus.connected;
      if (_isConnected != isConnected) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Theme.of(context).colorScheme.error,
              child: Row(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    color: Theme.of(context).colorScheme.onError,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No internet connection',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
