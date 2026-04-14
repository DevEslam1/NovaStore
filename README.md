# NovaStore | Premium E-Commerce Marketplace

![NovaStore Banner](https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=1200)

**NovaStore** is a state-of-the-art, feature-rich e-commerce application built with Flutter. It combines a premium "Curated Boutique" aesthetic with a robust, production-grade architecture. Designed for performance, scalability, and visual excellence.

---

## 💎 Brand Identity & Design
NovaStore prioritizes a **Premium Visual Identity** through:
- **Centralized Branding**: New high-resolution app icon and multi-variant logos (Dark/Light).
- **Glassmorphism**: Elegant blur effects and translucent backgrounds inspired by modern UI trends.
- **Tonal Layering**: Harmonious color palettes that adapt dynamically to user preferences.
- **Micro-Animations**: Fluid transitions and hover effects that make the app feel alive.
- **Modern Typography**: Curated font pairings (Outfit/Inter) for maximum readability and brand distinction.

## 🚀 Key Modules & Features

### 1. 🌈 Onboarding & Splash
- **Brand Splash**: Premium animated entry point showing the new NovaStore logo.
- **High-Fidelity Onboarding**: Animated landing screens to guide new users.
- **Remember Me**: Intelligent session persistence for returning users.

### 2. 🔐 Authentication Center
- **Firebase Auth**: Secure email/password login and registration.
- **OTP Verification**: Secure one-time password flow for account validation.
- **Guest Access**: Seamless "Continue as Guest" flow for friction-less browsing.
- **Auth Persistence**: Automatic session management.

### 3. 🏠 Discovery Dashboard (Home)
- **Hero Banners**: Vibrant promotional carousels for new collections.
- **Category Explorer**: Icon-based chips for quick navigation.
- **Flash Deals**: Time-sensitive product spotlights with specialized pricing.
- **Recommended for You**: Personalized product grids based on curated algorithms.
- **Pull-to-Refresh**: Instant data synchronization across the dashboard.

### 4. 🔍 Premium Search & Discovery
- **Real-Time Results**: Dynamic filtering as you type.
- **Advanced Filtering**: Modal-based filter utility to drill down by category, price, or brand.
- **Search History**: Convenient access to recent queries.

### 5. 📦 Product Studio
- **High-Res Imagery**: Support for networked carousels with cached loading.
- **Spec Details**: Detailed descriptions, size selections, and variant options.
- **Shimmer Skeletons**: Premium loading states using the `shimmer` package for smooth content arrival.
- **Tonal Design**: Individual product pages use tonal layering to spotlight content.

### 6. 🛒 Cart & Checkout
- **Fluid Item Management**: Slide-to-delete cards and intuitive quantity controls.
- **Glassmorphic Summary**: Transparent checkout card showing subtotal, shipping, and taxes.
- **Streamlined Flow**: Preparation for full payment integration.

### 7. 📦 Order Management
- **Lifecycle Tracking**: Monitor orders from *Confirmed* to *Delivered*.
- **Order History**: Comprehensive list of past purchases with status badges.
- **Detailed Tracking**: Timeline-based view for shipping progress.

### 8. 👤 Profile & Personalization
- **Triple-Theme Engine**: Toggle between **System**, **Light**, and **Dark** modes with persistent storage.
- **Asset Management**: Centralized `AppAssets` utility for optimized image and logo handling.
- **Developer Tools**: Gated utility section for seeding Firestore with mock product catalogs.

---

## 🏗 Technical Excellence

### Clean Architecture
The project follows a strict **Clean Architecture** pattern to ensure decoupling and testability:
- **Domain Layer**: Pure business logic (Entities, Use Cases, Repository interfaces).
- **Data Layer**: Implementation details (Models, Data Sources, Repository implementations).
- **Presentation Layer**: UI and State Management (Widgets, BLoCs, Theme tokens).

### Tech Stack
- **Framework**: Flutter 3.24+ / Dart 3.5+
- **Backend (mBaaS)**: Firebase (Authentication, Firestore, Storage)
- **State management**: `flutter_bloc` & `equatable`
- **Dependency Injection**: `get_it`
- **Routing**: `go_router` (Declarative path-based navigation)
- **Storage**: `shared_preferences`
- **Networking**: `Dio` (with custom interceptors)
- **Visuals**: `google_fonts`, `flutter_svg`, `cached_network_image`

---

## 📂 Project Structure
```text
lib/
├── core/               # Cross-cutting infrastructure
│   ├── bloc/           # Global application state (Theme, Locale)
│   ├── constants/      # App constants and configuration
│   ├── di/             # Dependency injection container
│   ├── error/          # Failure and Exception mapping
│   ├── theme/          # Design system tokens and styles
│   └── utils/          # Seeder, validators, and helpers
├── features/           # Modular feature domains
│   ├── auth/           # Login, Signup, Guest flows
│   ├── home/           # Dashboard and banners
│   ├── cart/           # Basket management
│   ├── orders/         # Lifecycle and history
│   ├── profile/        # Settings and DevTools
│   └── search/         # Discovery utility
└── shared/             # Reusable UI components & global entities
```

---

## 🛠 Setup & Deployment
1. **Prerequisites**: Ensure Flutter SDK and `flutterfire_cli` are installed.
2. **Clone**: `git clone [repository-url]`
3. **Init**: Run `flutter pub get` and `flutterfire configure`.
4. **Seed**: Use the **Seeder** tool in the Profile page (Debug Mode) to populate your Firestore.
5. **Run**: `flutter run`

---
## 📄 License
Internal project for **NovaStore**. All rights reserved.
