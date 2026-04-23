# Wasla Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-04-23

## Active Technologies
- Existing session storage via `SessionCubit`; language via existing `LocaleCubit`/`SharedPreferences` (feature/029-settings-page)
- Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `intl`, `infinite_scroll_pagination`, `shimmer`, `cached_network_image` (feature/031-service-requests-page)
- N/A (read-only requests data from backend; no new local persistence) (feature/031-service-requests-page)
- Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `intl`, `shimmer`, `cached_network_image`, `modal_bottom_sheet`, `flutter_rating_bar` (new) (032-add-customer-dashboard)
- N/A (read/write through backend API only; no new local persistence) (032-add-customer-dashboard)
- Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `intl`, `url_launcher` (033-add-offers-flow)
- N/A (all from API) (033-add-offers-flow)

- Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `flutter_localizations` (feature/029-settings-page)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Dart 3.11 (Flutter stable, null-safe)

## Code Style

Dart 3.11 (Flutter stable, null-safe): Follow standard conventions

## Recent Changes
- 033-add-offers-flow: Added Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `intl`, `url_launcher`
- 032-add-customer-dashboard: Added Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `intl`, `shimmer`, `cached_network_image`, `modal_bottom_sheet`, `flutter_rating_bar` (new)
- feature/031-service-requests-page: Added Dart 3.11 (Flutter stable, null-safe) + `flutter_bloc`, `go_router`, `dio`, `intl`, `infinite_scroll_pagination`, `shimmer`, `cached_network_image`


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
