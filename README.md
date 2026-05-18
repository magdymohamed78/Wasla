# Wasla

![Flutter](https://img.shields.io/badge/Flutter-mobile-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%5E3.11.0-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/Android%20%7C%20iOS-supported-lightgrey)
![Docker](https://img.shields.io/badge/Docker-Android%20builds-2496ED?logo=docker&logoColor=white)

Wasla is a Flutter mobile customer portal for discovering service companies, managing service requests and offers, handling customer profile/settings, and using an integrated chatbot experience.

## Overview

Wasla is built for Android and iOS using Flutter.
The app supports guest browsing, authenticated customer flows, company discovery, service request tracking, offers, reviews, profile management, settings, and chatbot interactions.
This repository contains the mobile client, platform projects, assets, localization files, Docker Android build setup, and internal feature specifications.

## Features

- Guest onboarding and authenticated customer access.
- Login, registration, password recovery, and session handling.
- Company discovery, details, and reviews.
- Service request creation, filtering, and tracking.
- Offer viewing, acceptance, and rejection flows.
- Customer/lead profile and settings management.
- Localized UI for multiple languages.
- Chatbot with markdown/table/chart response rendering.
- Docker-based Android release builds.

## Tech Stack

| Area | Technology |
| --- | --- |
| Framework | Flutter |
| Language | Dart `^3.11.0` |
| State management | `flutter_bloc` |
| Routing | `go_router` |
| Networking | `dio` |
| Storage | `flutter_secure_storage`, `shared_preferences` |
| Localization | Flutter localization, ARB files, `intl` |
| Android builds | Docker, Android Gradle |

## Project Structure

```text
.
|-- android/              # Android platform project
|-- ios/                  # iOS platform project
|-- assets/               # App assets
|-- docker/               # Docker Android build script
|-- lib/
|   |-- core/             # Shared routing, theme, session, networking, localization, widgets
|   `-- features/         # Feature modules: auth, home, companies, requests, offers, profile, settings, chatbot
|-- specs/                # Feature specifications and planning docs
|-- Dockerfile            # Android build image definition
|-- docker-compose.yml    # Local Docker build helper
|-- l10n.yaml             # Localization generator config
|-- pubspec.yaml          # Flutter dependencies and project metadata
`-- swagger.json          # Internal API contract artifact; details are not public documentation
```

## Getting Started

### Prerequisites

- Flutter SDK compatible with Dart `^3.11.0`.
- Android Studio or Android SDK for Android development.
- macOS and Xcode for iOS development.
- Docker Desktop if you want to build Android artifacts without installing Flutter/Android SDK locally.

### Install Dependencies

```sh
flutter pub get
```

### Run Locally

```sh
flutter run
```

Run on a specific device:

```sh
flutter run -d <device-id>
```

### Analyze and Test

```sh
flutter analyze
flutter test
```

## Build

### Android APK

```sh
flutter build apk --release
```

### Android App Bundle

```sh
flutter build appbundle --release
```

### iOS

```sh
flutter build ios --release
```

### Docker Android Build

Use the published Docker image to build Android artifacts without installing Flutter, Android Studio, or the Android SDK locally.

```powershell
mkdir dist
docker run --rm -v "${PWD}/dist:/output" magdymohamed/wasla-flutter-android:latest
```

Build an AAB instead:

```powershell
docker run --rm -v "${PWD}/dist:/output" magdymohamed/wasla-flutter-android:latest appbundle
```

Outputs are written to `dist/app-release.apk` or `dist/app-release.aab`.


## Backend/API

This Flutter client integrates with backend capabilities at a high level, including:

- Authentication and account access.
- Company discovery and reviews.
- Service request management.
- Offer management.
- Profile and settings data.
- Chatbot messaging.

Detailed internal API documentation is intentionally not published for security reasons.

## Screenshots

To be added.

## Contributing

1. Create a feature branch.
2. Run `flutter pub get`.
3. Make focused changes.
4. Run `flutter analyze` and `flutter test`.
5. Open a pull request with a clear summary.

## License

To be added.

## Contact

Author: To be added
