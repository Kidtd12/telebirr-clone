# Telebirr Clone (Flutter)

Telebirr Clone is a Flutter wallet app inspired by the Telebirr experience.
It includes authentication flow screens, wallet and transaction views, money transfer screens, QR payment flow, and profile management UI.

## Tech Stack

- Flutter (Dart SDK >= 3.6.0 < 4.0.0)
- Riverpod for state management
- Dio for HTTP networking
- Hive for local storage
- Mobile Scanner for QR workflows
- Google Fonts + flutter_animate for UI styling and motion

## Features

- Splash, login, registration, and OTP verification screens
- Wallet dashboard with reusable UI widgets
- Send money and receive money flows
- QR payment screen
- Transaction list/history screen
- Profile screen
- Structured service, provider, and model layers

## Project Structure

```text
lib/
	core/         # Constants, theme, utilities
	models/       # Data models
	providers/    # Riverpod state providers
	screens/      # App pages (auth, wallet, profile, transactions, etc.)
	services/     # API, storage, and business services
	widgets/      # Reusable UI components
```

## Prerequisites

- Flutter SDK installed
- Dart SDK compatible with the constraint in `pubspec.yaml`
- Chrome or Edge (for web run), or Windows desktop support enabled

## Getting Started

From this folder (`telebirr_clone_flutter`):

```bash
flutter pub get
flutter run -d chrome
```

If you want to use the workspace-local Flutter SDK at `../flutter`:

```powershell
..\flutter\bin\flutter.bat pub get
..\flutter\bin\flutter.bat run -d chrome
```

## Running on Windows Desktop

Windows desktop builds with plugins require symlink support.
If you see `Building with plugins requires symlink support`, enable Developer Mode:

```powershell
start ms-settings:developers
```

Then rerun:

```powershell
..\flutter\bin\flutter.bat run -d windows
```..\flutter\bin\flutter.bat run -d windows

## Testing and Analysis

```bash
flutter analyze
flutter test
```

## Backend Integration

The app is designed to work with a .NET backend API (see the workspace backend project).
Update API base URLs and endpoints in the service/constants layer as needed for your environment.

## License

This project currently has no explicit license file. Add one if you plan to distribute or open-source it broadly.
