# Quickstart: Registration Digital Signature Modal

**Branch**: `025-signup-signature-modal` | **Date**: March 9, 2026

---

## Prerequisites

1. Flutter SDK installed (Dart ^3.11.0)
2. Android emulator or iOS simulator running, OR a physical device connected
3. `flutter pub get` run from the repo root

---

## 1. Add the `path_provider` Dependency

In `pubspec.yaml`, under `dependencies`, add:

```yaml
path_provider: ^2.1.0
```

Then run:

```sh
flutter pub get
```

---

## 2. Files to Create

| File | Action |
|---|---|
| `lib/features/auth/presentation/cubit/signature_modal_state.dart` | Create |
| `lib/features/auth/presentation/cubit/signature_modal_cubit.dart` | Create |
| `lib/features/auth/presentation/widgets/digital_signature_modal.dart` | Create |

---

## 3. Files to Update

| File | Change Summary |
|---|---|
| `lib/features/auth/domain/entities/login_entity.dart` | Add `digitalSignature: String?` field |
| `lib/features/auth/data/models/login_response_model.dart` | Add `digitalSignature` field; update `fromJson` and `toEntity` |
| `lib/features/auth/presentation/cubit/register_state.dart` | Add `digitalSignature: String?` to state and `copyWith` |
| `lib/features/auth/presentation/cubit/register_cubit.dart` | Pass `digitalSignature` from `LoginEntity` to state on success; add `missingSignature` error code handling |
| `lib/features/auth/presentation/pages/sign_up_page.dart` | Show `DigitalSignatureModal` as dialog on success — navigate to `/register-success` only after OK is pressed |

---

## 4. Key Implementation Notes

### 4.1 Showing the Modal (sign_up_page.dart)

Replace the direct navigation in the BlocListener:

```dart
// BEFORE
if (state.status == RegisterStatus.success) {
  context.go(AppRouter.registerSuccess);
}

// AFTER
if (state.status == RegisterStatus.success) {
  final signature = state.digitalSignature;
  if (signature == null || signature.isEmpty) return; // handled by failure path
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => SignatureModalCubit(signature),
      child: DigitalSignatureModal(
        onOkPressed: () {
          Navigator.of(context).pop();
          context.go(AppRouter.registerSuccess);
        },
      ),
    ),
  );
}
```

### 4.2 File Download (signature_modal_cubit.dart)

```dart
Future<void> downloadSignature() async {
  emit(state.copyWith(status: SignatureModalStatus.downloading));
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/wasla_digital_signature.txt');
    await file.writeAsString(state.signature, flush: true);
    emit(state.copyWith(status: SignatureModalStatus.downloaded));
  } catch (e) {
    emit(state.copyWith(
      status: SignatureModalStatus.downloadError,
      errorMessage: 'Could not save file. Please try again.',
    ));
  }
}
```

### 4.3 Redaction in the Widget

```dart
// In DigitalSignatureModal build():
final displayText = state.status == SignatureModalStatus.downloaded
    ? '•' * state.signature.length  // or a fixed placeholder
    : state.signature;
```

---

## 5. Running the Feature

```sh
# Run on connected device / emulator
flutter run

# Navigate to: Sign Up screen → fill form → submit
# Expected: signature modal appears; download → OK → register-success screen
```

---

## 6. Running Tests

```sh
# All tests
flutter test

# Auth feature tests only
flutter test test/features/auth/

# Specific cubit test
flutter test test/features/auth/cubit/signature_modal_cubit_test.dart
```

---

## 7. Verifying File Download

### On Android Emulator
- Open **Files** app → **Internal storage** → navigate to the app's files directory, OR
- `adb shell run-as com.example.waslaapp ls /data/data/com.example.waslaapp/files/`
- Confirm `wasla_digital_signature.txt` exists and contains the correct signature string.

### On iOS Simulator
- Open **Files** app → **On My iPhone** → look for the Wasla app folder
- Confirm `wasla_digital_signature.txt` is present.

---

## 8. Regression Check

After implementation, verify these existing paths still work:

| Scenario | Expected |
|---|---|
| Login (existing user) | Not affected. `LoginEntity.digitalSignature` will be null — no modal shown. |
| Forgot password flow | Not affected. |
| Registration failure (bad input) | Error snackbar shown as before. No modal. |
| Registration failure (email in use) | `emailAlreadyRegistered` error shown as before. |
| Registration failure (missing signature from API) | New: `missingSignature` error shown with Retry. |
