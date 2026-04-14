# NovaStore | Premium E-Commerce Marketplace

![NovaStore Banner](https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=1200)

## 🌟 Overview
**NovaStore** is a production-ready, high-end e-commerce application built with Flutter. Designed for a "Curated Boutique" experience, it features a glassmorphic UI, smooth micro-animations, and a highly scalable Clean Architecture. Powered by Firebase, it offers a seamless shopping experience with real-time data sync and robust authentication.

## ✨ Key Features
- **Modern Design System**: Custom glassmorphism-inspired UI with tonal layering, vibrant gradients, and premium typography (Outfit/Inter).
- **Firebase Integration**: Real-time product catalog via Firestore and secure user management with Firebase Authentication (including Guest Mode).
- **Dynamic Theme Management**: Persistent support for **System**, **Light**, and **Dark** modes with seamless transitions.
- **Clean Architecture**: Strictly separated Domain, Data, and Presentation layers for maximum maintainability and testability.
- **BLoC State Management**: Robust and predictable state handling using `flutter_bloc`.
- **Pull-to-Refresh**: Enhanced UX with manual data synchronization on Home, Cart, and Orders pages.
- **Developer Tools**: Integrated seeding utility to quickly populate Firestore with curated mock data.
- **RTL & Localization**: Built-in support for multiple languages (English/Arabic) using a custom JSON-based L10n system.

## 📸 Experience
| Visual Harmony | Fluid Navigation |
| :---: | :---: |
| ![Design](https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&q=80&w=400) | ![UX](https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&q=80&w=400) |

## 🛠 Tech Stack
- **Core**: Flutter / Dart
- **Backend**: Firebase (Core, Auth, Firestore, Storage)
- **State Management**: `flutter_bloc`
- **Routing**: `go_router` (Declarative navigation)
- **Dependency Injection**: `get_it`
- **Storage**: `shared_preferences` (for theme and local config)
- **Networking**: `Dio` (for external API integrations)
- **UI & Animation**: `google_fonts`, `flutter_svg`, `cached_network_image`

## 📂 Project Structure
```text
lib/
├── core/               # Core infrastructure
│   ├── bloc/           # Global BLoCs (Theme, Localization)
│   ├── constants/      # App-wide constants (Asset paths, API keys)
│   ├── theme/          # Premium design tokens and themes
│   └── utils/          # Seeder, Validators, and Helpers
├── features/           # Feature-first modular layers
│   ├── auth/           # Login, Signup, and Guest flows
│   ├── home/           # Dashboard, Banners, and Discovery
│   ├── product/        # Detailed views and Catalogs
│   ├── cart/           # Basket management and Checkout
│   ├── orders/         # Order history and Tracking
│   └── profile/        # User settings and Dev tools
└── main.dart           # App entry point & Provider setup
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.24+)
- A Firebase Project (configured via `flutterfire configure`)

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/novastore.git
   ```
2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```
3. **Setup Firebase**:
   Ensure your `firebase_options.dart` is correctly generated and placed in `lib/`.
4. **Run the application**:
   ```bash
   flutter run
   ```

## 📄 License
Internal project for **NovaStore**. All rights reserved.
