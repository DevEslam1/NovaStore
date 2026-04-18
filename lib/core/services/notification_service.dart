import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newstore/core/routing/app_router.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final AuthRepository authRepository;

  NotificationService({required this.authRepository});

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }

    // Get initial FCM token
    final token = await _getFCMToken();
    if (token != null) {
      log('Initial FCM Token: $token');
      await _sendTokenToServer(token);
    }

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((String token) {
      log('FCM Token Refreshed: $token');
      _sendTokenToServer(token);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle initial message when app is opened from terminated state
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Handle messages when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Monitor auth state changes - resend token when user logs in
    authRepository.authStateChanges.listen((user) async {
      if (user != null) {
        final token = await _getFCMToken();
        if (token != null) {
          log('User logged in, syncing FCM token: $token');
          await _sendTokenToServer(token);
        }
      }
    });
  }

  /// Securely retrieves the FCM token, handling the APNS requirements on Apple platforms.
  Future<String?> _getFCMToken() async {
    try {
      // On Apple platforms (iOS, macOS), getToken() will throw an error 
      // if the APNS token is not yet available.
      if (Platform.isIOS || Platform.isMacOS) {
        final apnsToken = await _fcm.getAPNSToken();
        if (apnsToken == null) {
          log('APNS token not yet available. FCM token retrieval postponed.');
          return null;
        }
      }
      return await _fcm.getToken();
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    final result = await authRepository.updateDeviceToken(token);
    result.fold(
      (failure) =>
          log('Failed to update device token on server: ${failure.message}'),
      (_) => log('Successfully updated device token on server'),
    );
  }

  void _handleMessage(RemoteMessage message) {
    log('Handling message: ${message.data}');

    final data = message.data;
    final type =
        data['type']?.toString().toLowerCase() ??
        data['click_action']?.toString().toLowerCase();

    if (type == null) return;

    switch (type) {
      case 'cart':
      case 'open_cart':
        AppRouter.router.push(AppRouter.cart);
        break;
      case 'order':
      case 'orders':
      case 'open_orders':
        AppRouter.router.push(AppRouter.orders);
        break;
      case 'notification':
      case 'notifications':
      case 'promotion':
      case 'update':
        AppRouter.router.push(AppRouter.notifications);
        break;
      default:
        log('Unknown notification type: $type');
        break;
    }
  }
}

// Global background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
}
