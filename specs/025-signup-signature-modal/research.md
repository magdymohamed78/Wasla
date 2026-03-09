# Research: Registration Digital Signature Modal

**Branch**: `025-signup-signature-modal` | **Date**: March 9, 2026

All NEEDS CLARIFICATION items resolved. Research covers three topics:
1. Cross-platform file saving in Flutter
2. Android storage permissions for the target SDK
3. Secure in-memory handling of a sensitive credential in a Cubit

---

## 1. Cross-Platform File Saving in Flutter

### Decision
Use `path_provider` (`getApplicationDocumentsDirectory()`) to write the `.txt` file, combined with `dart:io` `File.writeAsString()`.

### Rationale
- `path_provider` is **already resolved as a transitive dependency** in this project (evidenced by `build/path_provider_android/` in the build output). Promoting it to a direct dependency in `pubspec.yaml` requires no new package resolution.
- `getApplicationDocumentsDirectory()` returns a directory that is:
  - **iOS**: `NSDocumentDirectory` — visible in the Files app, iCloud-syncable, accessible to the user.
  - **Android**: The app's internal files directory — no WRITE_EXTERNAL_STORAGE permission needed on Android 10+ (API 29+), which covers the overwhelming majority of the project's target devices.
- Writing a single short string to a `.txt` file is synchronous-equivalent at this scale (a few hundred bytes max for a digital signature token); no streaming or chunking needed.
- File name convention: `wasla_digital_signature.txt` — prefixed with app name to be clearly identifiable in the user's Files app.

### Alternatives Considered
| Alternative | Why Rejected |
|---|---|
| `share_plus` — share sheet instead of direct save | Adds friction; user may share to wrong destination. Spec explicitly says "save to device". |
| `flutter_file_dialog` — system file picker for save | Not needed; a fixed documents-directory path is sufficient and keeps UX simple. |
| `getDownloadsDirectory()` | Returns `null` on iOS; also requires `WRITE_EXTERNAL_STORAGE` on Android < 10. More fragile. |
| `getExternalStorageDirectory()` | Android-only; requires runtime permission. iOS not supported. |

---

## 2. Android Storage Permissions

### Decision
No runtime permission request needed for this feature.

### Rationale
- Writing to `getApplicationDocumentsDirectory()` on Android uses the **app's internal files sandbox** — no manifest permission required on any API level.
- The app's minimum SDK is not explicitly set in the checked files, but modern Flutter projects template to `minSdk 21` (Android 5). The `WRITE_EXTERNAL_STORAGE` permission was deprecated in Android 10 (API 29) for apps targeting API 29+. Since the current `build.gradle.kts` targets current API levels, no permission entry is needed.
- iOS: No `NSPhotoLibraryUsageDescription` or other permission needed for the documents directory.

### Alternatives Considered
| Alternative | Why Rejected |
|---|---|
| `permission_handler` + `WRITE_EXTERNAL_STORAGE` | Not needed. Adding a permission request introduces friction and is rejected by the Google Play store for unused/unnecessary permissions. |
| Checking/requesting permission at runtime | Unnecessary for the chosen directory. Would complicate the modal flow for no benefit. |

---

## 3. Sensitive Credential Handling in a Cubit (Flutter)

### Decision
The digital signature is held **only in the `SignatureModalCubit` state** while the modal is open. When the modal is dismissed (OK pressed), the cubit is closed and garbage collected — the signature never touches persistent storage, shared preferences, or the navigation state.

### Rationale
- Flutter's Cubit state is heap-only; it is not serialized by the framework.
- Closing the cubit (via `BlocProvider` scope ending) zeroes the reference, making the string eligible for GC.
- The `RegisterState` in `RegisterCubit` holds the `LoginEntity` (which will include `digitalSignature`), but only long enough to trigger the modal. Once the modal is shown, the parent cubit's signature value is no longer needed. The signature is passed to `SignatureModalCubit` at modal creation, and `RegisterCubit` is not directly involved after that.
- After the download completes, the modal **redacts** the on-screen text (replaces with `*` characters) so it is not visible in screenshots or screen readers, satisfying FR-010.
- The `SignatureModalCubit` tracks two boolean flags: `hasDownloaded` (gates OK button) and `isRedacted` (drives display). Both reset to `false` when a new cubit instance is created (FR-012).

### Alternatives Considered
| Alternative | Why Rejected |
|---|---|
| Store signature in `flutter_secure_storage` | Not required and contradicts FR-011 (must not be persisted). Secure storage is for tokens, not temporary display credentials. |
| Pass signature through go_router `extra` | Would expose it in navigation state; violates the session-only principle. |
| Hold in a global singleton / service locator | Creates longer-lived reference, harder to reason about lifecycle. Unnecessary for a single-use modal. |

---

## Summary Table

| Unknown | Decision | Confidence |
|---|---|---|
| File saving library & directory | `path_provider` → `getApplicationDocumentsDirectory()` | High — already transitive dep |
| Android permissions needed | None (internal documents dir) | High |
| iOS considerations | Documents dir = Files app visible, no permission needed | High |
| Credential in-memory management | Cubit-scoped only; redacted after download; discarded on close | High |
| File name | `wasla_digital_signature.txt` | Medium — can be adjusted |
