# waslaapp

Wasla is a Flutter application configured for Android and iOS mobile targets.

## Docker

This repository is dockerized as an Android build environment. It is not
packaged as a Flutter Web/Nginx app because the project currently has no
`web/` platform folder.

iOS release builds still require macOS and Xcode, so they are outside the
Linux Docker workflow.

### Prerequisites

- Docker Desktop installed and running.
- Docker Compose available. You can check with:

```sh
docker compose version
```

### Docker Compose Quick Start

Build the Android builder image:

```sh
docker compose build
```

Build the APK with one command:

```sh
docker compose up --build
```

The APK is copied to:

```text
dist/app-release.apk
```

Run the existing image without rebuilding:

```sh
docker compose up
```

Stop and remove the Compose container/network:

```sh
docker compose down
```

Remove the Compose Gradle cache volume too:

```sh
docker compose down -v
```

Rebuild the image from scratch if Docker cache causes problems:

```sh
docker compose build --no-cache
```

The default Compose service builds the Android APK, copies it to `dist/`, and
exits. It does not run the mobile app in Docker. Compose keeps a named Gradle
cache volume so repeated Android builds are faster. This repository uses
`docker-compose.yml` as the single Compose configuration file.

### Build The Docker Image Directly

```sh
docker build -t wasla-flutter-android .
```

The image installs Flutter `3.41.1`, Android SDK platform `36`, Android
build-tools `36.0.0`, compatibility Android SDK/build-tools `34`, and NDK
`28.2.13676358`, plus CMake `3.22.1` for Android native builds. It runs
`flutter pub get` with `pubspec.yaml` and `pubspec.lock` copied first for
better Docker layer caching, then copies the rest of the project and runs
`flutter gen-l10n`.

### Build An APK

Docker Compose:

```sh
docker compose run --rm android
```

Or use the default Compose service:

```sh
docker compose up --build
```

PowerShell:

```powershell
docker run --rm -v "${PWD}/dist:/output" wasla-flutter-android
```

Bash:

```sh
docker run --rm -v "$(pwd)/dist:/output" wasla-flutter-android
```

The APK is written to:

```text
dist/app-release.apk
```

### Build An AAB

Docker Compose:

```sh
docker compose run --rm android appbundle
```

PowerShell:

```powershell
docker run --rm -v "${PWD}/dist:/output" wasla-flutter-android appbundle
```

Bash:

```sh
docker run --rm -v "$(pwd)/dist:/output" wasla-flutter-android appbundle
```

The AAB is written to:

```text
dist/app-release.aab
```

### Ports

No ports are exposed. This Docker image builds Android artifacts; it does not
run the mobile app in a container. There is no `http://localhost:8080` web
runtime for this project because no Flutter Web target exists.

### Configuration Notes

- The app currently uses hard-coded API base URLs in Dart code.
- No `.env` file is required for the Docker build.
- No secrets are included in the Docker image.
- `android/local.properties` is intentionally ignored by Docker because it
  contains host-specific SDK paths. The Dockerfile creates a Linux-compatible
  `android/local.properties` inside the image.
- Android release signing currently follows the existing project setup, which
  uses the debug signing config for release builds. Configure production
  signing separately before publishing.
