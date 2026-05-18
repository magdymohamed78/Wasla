# Wasla

![Flutter](https://img.shields.io/badge/Flutter-mobile-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%5E3.11.0-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-lightgrey)
![Docker](https://img.shields.io/badge/Docker-Android%20builder-2496ED?logo=docker&logoColor=white)

Wasla is a Flutter mobile customer portal for browsing service companies, managing service requests and offers, reviewing companies, editing profiles and settings, and using a customer chatbot.

The app is configured for Android and iOS. A Flutter Web target is not present in this repository.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Environment Variables](#environment-variables)
- [Running Locally](#running-locally)
- [Available Scripts](#available-scripts)
- [Build Instructions](#build-instructions)
- [Usage Guide](#usage-guide)
- [Backend/API Overview](#backendapi-overview)
- [Authentication and Access Notes](#authentication-and-access-notes)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

Verified highlights from the current codebase. &#x2728;

- Customer onboarding, login, registration, forgot password, OTP resend, reset password, and change password flows.
- Remember-me support using secure storage, with an in-memory session path when remember-me is not selected.
- Role-aware navigation for guest, lead, and customer sessions.
- Company discovery for all companies, recommended companies, trending companies, company details, and company reviews.
- Customer dashboard metrics for authenticated customer users.
- Service request browsing, filtering, detail view, and new service request submission.
- Offer listing, filtering, detail view, accept flow, reject flow, digital signature confirmation, and payment method selection.
- Customer and lead profile views plus profile editing.
- Settings pages with language selection, security actions, digital signature reveal, logout, and logout-all support.
- My Reviews management with create, update, and delete review API calls.
- Customer chatbot with chat history, markdown rendering, table rendering, and chart extraction.
- Localization support for Arabic, German, English, Spanish, French, and Italian.
- Dockerized Android release artifact builder.

## Tech Stack

| Area | Technology |
| --- | --- |
| Language | Dart `^3.11.0` |
| Framework | Flutter |
| State management | `flutter_bloc` |
| Routing | `go_router` |
| Networking | `dio` with custom auth interceptors |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Localization | `flutter_localizations`, `intl`, ARB files, `flutter gen-l10n` |
| Lists and loading states | `infinite_scroll_pagination`, `shimmer` |
| Media and caching | `cached_network_image`, `flutter_cache_manager` |
| UI helpers | `pinput`, `modal_bottom_sheet`, `flutter_rating_bar`, `markdown_widget`, `fl_chart` |
| Device utilities | `path_provider`, `flutter_file_dialog`, `url_launcher`, `uuid` |
| Testing dependencies | `flutter_test`, `bloc_test`, `mocktail` |
| Supported platforms in repo | Android, iOS |
| Container support | Docker Android build environment |

## Project Structure

```text
.
|-- android/                  # Android Flutter host project and Gradle config
|-- assets/images/            # App image assets declared in pubspec.yaml
|-- docker/                   # Android build entrypoint script for Docker
|-- ios/                      # iOS Flutter host project
|-- lib/
|   |-- main.dart             # App entrypoint and legacy auth cleanup
|   |-- app.dart              # Dependency wiring, Dio clients, repositories, blocs, app shell
|   |-- core/
|   |   |-- localization/     # ARB files and generated localizations
|   |   |-- networking/       # Auth and chatbot Dio interceptors
|   |   |-- routing/          # GoRouter route definitions
|   |   |-- session/          # Session state, role resolution, token claims
|   |   |-- theme/            # App colors, typography, dimensions, theme
|   |   |-- utils/            # Validators, URL helpers, toast helpers, logo preload
|   |   `-- widgets/          # Shared UI widgets
|   `-- features/
|       |-- auth/             # Login, registration, password, OTP, signature UI
|       |-- chatbot/          # Customer chatbot data/domain/presentation layers
|       |-- companies/        # Company lists, details, reviews UI
|       |-- explore/          # Company/service exploration screen
|       |-- home/             # Home dashboard, discovery, portal repositories
|       |-- offers/           # Offer list/details/accept/reject flows
|       |-- onboarding/       # First-run onboarding screen
|       |-- profile/          # Customer and lead profile screens
|       |-- requests/         # Customer request list/details/new request flow
|       |-- reviews/          # My reviews screen and review actions
|       |-- settings/         # Settings, language, security, signature, logout
|       |-- splash/           # Splash screen and startup flow
|       `-- support/          # Support page
|-- specs/                    # Feature plans, contracts, checklists, and research notes
|-- Dockerfile                # Flutter/Android SDK image for release builds
|-- docker-compose.yml        # Compose service that builds Android artifacts
|-- error-responses.md        # API error response notes
|-- l10n.yaml                 # Flutter localization generator config
|-- pubspec.yaml              # Flutter package metadata and dependencies
`-- swagger.json              # Internal API contract artifact; details omitted from this public README
```

## Installation

Start with the standard Flutter toolchain. &#x1F680;

### Prerequisites

- Flutter SDK with Dart `^3.11.0` support.
- Android Studio or Android SDK for Android builds.
- Xcode and macOS for iOS builds.
- Docker Desktop, only if you want to use the included Android build container.

Check your Flutter setup:

```sh
flutter doctor
```

Install dependencies:

```sh
flutter pub get
```

Regenerate localization files when ARB files change:

```sh
flutter gen-l10n
```

## Environment Variables

No `.env.example` file was found, and the app does not currently use `flutter_dotenv`, `String.fromEnvironment`, or `--dart-define` configuration.

For public documentation, real backend URLs and private configuration values are intentionally not listed. If configuration is externalized later, use safe placeholder values like these:

| Name | Example value | Notes |
| --- | --- | --- |
| `WASLA_API_BASE_URL` | `<API_BASE_URL>` | Main backend API base URL |
| `WASLA_CHATBOT_API_BASE_URL` | `<CHATBOT_API_BASE_URL>` | Chatbot service base URL |

Required environment variables in the current codebase: none.

Do not commit secrets, tokens, API keys, database URLs, webhook secrets, signing keys, or production service URLs.

## Running Locally

List connected devices:

```sh
flutter devices
```

Run the app on the selected default device:

```sh
flutter run
```

Run on a specific device:

```sh
flutter run -d <device-id>
```

Useful development checks:

```sh
flutter analyze
flutter test
```

There is no committed `test/` directory at the moment, so add Dart tests before expecting meaningful `flutter test` coverage.

## Available Scripts

This is a Flutter/Dart project. No root `package.json` file was found, so there are no npm, yarn, or pnpm scripts for the app.

Use these Flutter and Docker commands instead:

| Command | Purpose |
| --- | --- |
| `flutter pub get` | Install Dart/Flutter dependencies |
| `flutter gen-l10n` | Generate localization classes from ARB files |
| `flutter analyze` | Run static analysis with configured Flutter lints |
| `flutter test` | Run Flutter tests |
| `flutter run` | Run the app locally |
| `flutter build apk --release` | Build an Android APK |
| `flutter build appbundle --release` | Build an Android App Bundle |
| `flutter build ios --release` | Build iOS release artifacts on macOS |
| `docker compose up --build` | Build the Android APK through Docker |
| `docker compose run --rm android appbundle` | Build the Android AAB through Docker |

## Build Instructions

### Android APK

```sh
flutter build apk --release
```

### Android App Bundle

```sh
flutter build appbundle --release
```

### iOS

iOS builds require macOS and Xcode:

```sh
flutter build ios --release
```

### Docker Android Builder

This repository is dockerized as an Android build environment. It is not packaged as a Flutter Web/Nginx app because the project currently has no `web/` platform folder.

Build the Docker image and APK with Docker Compose:

```sh
docker compose up --build
```

The APK is copied to:

```text
dist/app-release.apk
```

Build the Android App Bundle with Docker Compose:

```sh
docker compose run --rm android appbundle
```

The AAB is copied to:

```text
dist/app-release.aab
```

Build the image directly:

```sh
docker build -t wasla-flutter-android .
```

Run the Android APK build directly with Docker:

```sh
docker run --rm -v "${PWD}/dist:/output" wasla-flutter-android
```

Run the Android AAB build directly with Docker:

```sh
docker run --rm -v "${PWD}/dist:/output" wasla-flutter-android appbundle
```

The Docker image installs Flutter `3.41.1`, Android SDK platform `36`, Android build tools `36.0.0`, compatibility Android SDK/build tools `34`, NDK `28.2.13676358`, and CMake `3.22.1`.

## Usage Guide

No screenshot files were found in the repository. Suggested screenshot placeholders: &#x1F5BC;

| Screen or flow | Screenshot |
| --- | --- |
| Splash and onboarding | To be added |
| Login and registration | To be added |
| Home and company discovery | To be added |
| Company details and reviews | To be added |
| Service requests | To be added |
| Offers and offer details | To be added |
| Chatbot | To be added |
| Profile and settings | To be added |

Typical app flow:

1. Open the app and continue through splash/onboarding.
2. Browse companies as a guest, or sign in/register for authenticated features.
3. Use Home/Explore to find companies and view company details and reviews.
4. Submit a service request from a company context.
5. For customer accounts, view service requests, offers, profile, settings, and chatbot.
6. Accept or reject offers from the offers flow.
7. Manage reviews from the My Reviews screen.

## Backend/API Overview

This repository is a Flutter mobile client. It consumes backend services but does not implement public backend routes itself.

For security reasons, detailed internal API documentation, route paths, webhook URLs, admin routes, database routes, and security-sensitive endpoints are not published in this README.

High-level backend capabilities used by the app include:

| Area | Description |
| --- | --- |
| Authentication | Customer registration, sign-in, password recovery, session management, and account security flows |
| Company discovery | Browsing service companies, viewing company details, and reading reviews |
| Lead and consultation requests | Creating and tracking service requests from interested users and customers |
| Offers | Viewing, accepting, or rejecting offers connected to service requests |
| Profile and settings | Managing customer or lead profile data, app language, security settings, and account actions |
| Reviews | Creating, updating, deleting, and viewing customer reviews |
| Chatbot | Sending customer messages to an external assistant service and rendering structured responses |
| Admin-related actions | Supported by the broader backend, but not documented publicly here |
| External integrations | Payment, messaging, AI, or webhook-style integrations may exist outside this public client documentation |

Security note: keep internal API contracts, privileged routes, webhook configuration, tokens, keys, and production URLs in private documentation or protected secret stores.

## Authentication and Access Notes

- The app uses token-based authentication for protected mobile features.
- Persistent sessions use secure device storage when remember-me is enabled.
- Non-persistent sessions are kept in memory.
- The UI distinguishes between guest, lead, and customer access levels.
- Requests, offers, profile, settings, and chatbot access are role-aware.
- Admin mobile screens were not found in `lib/`.

## Deployment

### Android

Android release artifacts can be created with Flutter or the included Docker builder.

```sh
flutter build apk --release
flutter build appbundle --release
```

Production signing is To be added. The current Android release build configuration uses the debug signing config in `android/app/build.gradle.kts`.

### iOS

iOS publishing requires macOS, Xcode, Apple Developer signing, and App Store Connect setup.

```sh
flutter build ios --release
```

iOS signing and release setup: To be added.

### Docker

Docker is supported for Android artifact builds only. No ports are exposed, and the container does not run the mobile app.

```sh
docker compose up --build
```


### CI/CD

No `.github/workflows/` CI configuration was found. CI/CD setup is To be added.

## Contributing

1. Create a feature branch.
2. Install dependencies with `flutter pub get`.
3. Keep changes scoped to the relevant feature or layer.
4. Run `flutter analyze`.
5. Run `flutter test` when tests are present or added.
6. Open a pull request with a clear summary and screenshots for UI changes.

## License

To be added. No `LICENSE` file was found in the repository root.

## Contact

Author: To be added
