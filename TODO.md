# NovaStore — Project Roadmap & Tasks

> **Status:** UI Shell Complete · Backend & Data Layer Needed
> **Last Updated:** April 14, 2026

---

## Phase 1 — Core Backend (Make It Work)

### 1.1 Network Layer (`core/network/`)
- [ ] Create `api_client.dart` — Dio instance with base URL, interceptors, auth token injection
- [ ] Create `api_endpoints.dart` — centralized endpoint constants
- [ ] Create `network_info.dart` — connectivity checker (online/offline detection)

### 1.2 Error Handling (`core/error/`)
- [ ] Create `failures.dart` — Failure base class (ServerFailure, CacheFailure, AuthFailure)
- [ ] Create `exceptions.dart` — Exception classes for data layer
- [ ] Create `error_handler.dart` — map exceptions to user-friendly messages

### 1.3 Firebase Auth (`features/auth/`)
- [ ] Create `auth_repository.dart` (domain) — abstract repo interface
- [ ] Create `auth_repository_impl.dart` (data) — Firebase Auth implementation
- [ ] Create `firebase_auth_datasource.dart` — sign in, sign up, sign out, reset password
- [ ] Create `user_entity.dart` (domain) — User model
- [ ] Create `user_model.dart` (data) — Firebase User → Entity mapping
- [ ] Create `auth_bloc.dart` — AuthState (authenticated, unauthenticated, loading, error)
- [ ] Wire `LoginPage` to AuthBloc (replace `context.go('/')` with real login)
- [ ] Add auth state listener in `main.dart`
- [ ] Add route guards in `app_router.dart` — redirect to `/login` if unauthenticated
- [ ] Implement "Continue as Guest" with proper guest state tracking
- [ ] Implement "Forgot Password" flow (send reset email)

### 1.4 Firestore Product Catalog
- [ ] Create Firestore collection: `products` (with sample data)
- [ ] Create `product_model.dart` (data) — fromJson/toJson for Firestore docs
- [ ] Create `product_remote_datasource.dart` — fetch products from Firestore
- [ ] Create `product_repository.dart` (domain) — abstract interface
- [ ] Create `product_repository_impl.dart` (data) — implementation
- [ ] Create `get_products_usecase.dart` — use case for fetching products
- [ ] Create `products_bloc.dart` — manage product list state (loading, loaded, error)
- [ ] Replace `MockData` usage in `HomePage` with real BLoC data
- [ ] Replace `MockData` usage in `SearchPage` with real BLoC data

### 1.5 Dependency Injection Update (`core/di/`)
- [ ] Register all new repositories in `injection_container.dart`
- [ ] Register all new data sources
- [ ] Register all new use cases
- [ ] Register all new BLoCs (AuthBloc, ProductsBloc, etc.)

---

## Phase 2 — Data Flow (Make It Real)

### 2.1 Cart Persistence
- [ ] Add `hive` or `hive_flutter` package for local storage
- [ ] Create `cart_local_datasource.dart` — save/load cart from Hive
- [ ] Create `cart_repository.dart` — persist cart across app restarts
- [ ] Update `CartBloc` to load saved cart on init and save on every change
- [ ] Optional: sync cart to Firestore for logged-in users

### 2.2 Order System
- [ ] Create Firestore collection: `orders`
- [ ] Create `order_entity.dart` (domain) — Order model with items, status, timestamps
- [ ] Create `order_model.dart` (data) — Firestore mapping
- [ ] Create `order_repository.dart` — create order, get user orders
- [ ] Create `orders_bloc.dart` — manage order list state
- [ ] Wire `CheckoutPage` "Place Order" to actually create a Firestore order
- [ ] Wire `OrdersPage` to display real orders from Firestore
- [ ] Clear cart after successful order placement
- [ ] Navigate to order success page after placing order

### 2.3 Wishlist / Favorites
- [ ] Create Firestore collection: `wishlists` (or subcollection under users)
- [ ] Create `wishlist_bloc.dart` — add/remove/check favorite status
- [ ] Wire product details heart button to WishlistBloc
- [ ] Add wishlist page or section in profile
- [ ] Show favorite indicator on product cards

### 2.4 User Profile
- [ ] Create Firestore collection: `users` (profile data)
- [ ] Create `user_repository.dart` — get/update profile
- [ ] Create `profile_bloc.dart` — manage profile state
- [ ] Wire `ProfilePage` to show real user data from Firebase Auth + Firestore
- [ ] Implement "Edit Profile" screen — update name, photo
- [ ] Implement avatar upload (Firebase Storage)

---

## Phase 3 — Missing Screens (Make It Complete)

### 3.1 Splash Screen
- [ ] Create `splash_page.dart` — animated brand logo + loading
- [ ] Check auth state on splash → route to onboarding/home/login
- [ ] Check if onboarding was seen (SharedPreferences flag)
- [ ] Add route in `app_router.dart`, set as initial

### 3.2 Sign Up Page
- [ ] Create `register_page.dart` — name, email, password, confirm password
- [ ] Wire to AuthBloc for Firebase createUserWithEmailAndPassword
- [ ] Add route in `app_router.dart`
- [ ] Navigate to OTP or directly to home after sign up

### 3.3 OTP Verification Page
- [ ] Create `otp_page.dart` — 4-6 digit code input with auto-focus
- [ ] Implement email verification or phone OTP via Firebase
- [ ] Add resend timer countdown
- [ ] Add route in `app_router.dart`

### 3.4 Filter Modal
- [ ] Create `filter_modal.dart` — bottom sheet with:
  - [ ] Price range slider
  - [ ] Category chips
  - [ ] Brand selection
  - [ ] Rating filter
  - [ ] Sort options (price, newest, popular)
- [ ] Wire to products BLoC for filtered queries
- [ ] Add filter button to search page and shop page

### 3.5 Order Tracking Page
- [ ] Create `order_tracking_page.dart` — stepper/timeline UI
- [ ] Show order status: Confirmed → Processing → Shipped → Delivered
- [ ] Show estimated delivery date
- [ ] Show shipping carrier info
- [ ] Add route in `app_router.dart`
- [ ] Wire "Track Order" button in `OrdersPage`

### 3.6 Loading Skeletons
- [ ] Add `shimmer` package
- [ ] Create `product_card_skeleton.dart` — shimmer placeholder
- [ ] Create `home_skeleton.dart` — full home page loading state
- [ ] Show skeleton while ProductsBloc is in loading state
- [ ] Add skeleton states to orders, profile, and cart pages

---

## Phase 4 — Production Ready (Make It Polish)

### 4.1 State Persistence
- [ ] Save theme preference to SharedPreferences
- [ ] Load theme preference on app start in `AppConfigBloc`
- [ ] Save language preference to SharedPreferences
- [ ] Load language preference on app start
- [ ] Save "onboarding seen" flag — skip onboarding on subsequent launches

### 4.2 Address Management
- [ ] Create `address_entity.dart` — address model
- [ ] Create `addresses_page.dart` — list saved addresses
- [ ] Create `add_address_page.dart` — form to add new address
- [ ] Store addresses in Firestore under user document
- [ ] Wire checkout page to select from saved addresses

### 4.3 Payment Integration
- [ ] Choose payment provider (Stripe recommended)
- [ ] Add `flutter_stripe` package
- [ ] Create payment sheet flow in checkout
- [ ] Handle payment success/failure states
- [ ] Store payment method tokens securely

### 4.4 Push Notifications
- [ ] Add `firebase_messaging` package
- [ ] Configure FCM in Android/iOS
- [ ] Create notification service
- [ ] Send order status update notifications
- [ ] Handle notification taps (deep link to order)

### 4.5 Error & Empty States
- [ ] Create `error_widget.dart` — reusable error display with retry button
- [ ] Create `empty_state_widget.dart` — reusable empty state
- [ ] Add pull-to-refresh on all list pages
- [ ] Add "no internet" banner/overlay
- [ ] Add retry logic on failed API calls

### 4.6 Performance & Analytics
- [ ] Add `firebase_analytics` — screen tracking, event logging
- [ ] Add `firebase_crashlytics` — crash reporting
- [ ] Implement product list pagination (infinite scroll)
- [ ] Optimize image loading with proper cache policies
- [ ] Add app icon (Android + iOS)
- [ ] Configure native splash screen (`flutter_native_splash`)

### 4.7 Testing
- [ ] Unit tests for all BLoCs
- [ ] Unit tests for repositories
- [ ] Unit tests for use cases
- [ ] Widget tests for key screens
- [ ] Integration test for auth flow
- [ ] Integration test for checkout flow

---

## File Structure (Target)

```
lib/
├── main.dart
├── firebase_options.dart
├── core/
│   ├── bloc/app_config_bloc.dart
│   ├── constants/mock_data.dart          ← TO BE REMOVED
│   ├── di/injection_container.dart       ← NEEDS UPDATE
│   ├── error/
│   │   ├── exceptions.dart               ← NEW
│   │   └── failures.dart                 ← NEW
│   ├── localization/
│   ├── network/
│   │   ├── api_client.dart               ← NEW
│   │   └── network_info.dart             ← NEW
│   ├── routing/app_router.dart           ← NEEDS AUTH GUARD
│   ├── theme/ ✅
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/              ← NEW
│   │   │   ├── models/                   ← NEW
│   │   │   └── repositories/             ← NEW
│   │   ├── domain/
│   │   │   ├── entities/                 ← NEW
│   │   │   ├── repositories/             ← NEW
│   │   │   └── usecases/                 ← NEW
│   │   └── presentation/
│   │       ├── bloc/auth_bloc.dart        ← NEW
│   │       └── pages/
│   │           ├── login_page.dart ✅
│   │           ├── register_page.dart     ← NEW
│   │           └── otp_page.dart          ← NEW
│   ├── cart/ (needs persistence layer)
│   ├── checkout/ (needs payment integration)
│   ├── favorites/                         ← NEW FEATURE
│   ├── home/ ✅ (needs real data)
│   ├── onboarding/ ✅
│   ├── orders/ (needs real data + tracking page)
│   ├── product/ ✅ (needs real data + variants)
│   ├── profile/ (needs real data + edit)
│   ├── search/ (needs server-side search)
│   ├── shop/ ✅ (needs filter modal)
│   └── splash/                            ← NEW FEATURE
└── shared/
    ├── data/models/
    ├── domain/entities/product.dart ✅
    └── widgets/ ✅
```

---

## Dependencies to Add

```yaml
# Phase 1
cloud_firestore: ^5.x.x        # Firestore database
firebase_storage: ^12.x.x      # Image uploads

# Phase 2
hive: ^4.x.x                   # Local storage
hive_flutter: ^2.x.x           # Flutter Hive adapter

# Phase 3
shimmer: ^3.x.x                # Loading skeletons
pin_code_fields: ^8.x.x        # OTP input

# Phase 4
flutter_stripe: ^11.x.x        # Payment processing
firebase_messaging: ^15.x.x    # Push notifications
firebase_analytics: ^11.x.x    # Analytics
firebase_crashlytics: ^4.x.x   # Crash reporting
flutter_native_splash: ^2.x.x  # Native splash screen
```
