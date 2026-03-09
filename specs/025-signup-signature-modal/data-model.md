# Data Model: Registration Digital Signature Modal

**Branch**: `025-signup-signature-modal` | **Date**: March 9, 2026

---

## 1. Entities & Models

### 1.1 `LoginEntity` — UPDATE

**File**: `lib/features/auth/domain/entities/login_entity.dart`

Add one nullable field:

| Field | Type | Nullable | Source | Notes |
|---|---|---|---|---|
| `digitalSignature` | `String` | yes | API `CustomerLoginResultDto.digitalSignature` | Opaque string. Present only in registration response. |

All existing fields unchanged (`token`, `refreshToken`, `refreshTokenExpiry`, `userId`, `customerId`, `leadId`, `firstName`, `lastName`, `email`).

---

### 1.2 `LoginResponseModel` — UPDATE

**File**: `lib/features/auth/data/models/login_response_model.dart`

Add `digitalSignature: String?` field.

`fromJson` reads: `json['digitalSignature'] as String?`
`toEntity()` passes: `digitalSignature: digitalSignature`

---

### 1.3 `RegisterState` — UPDATE

**File**: `lib/features/auth/presentation/cubit/register_state.dart`

Add one nullable field to `RegisterState`:

| Field | Type | Default | Purpose |
|---|---|---|---|
| `digitalSignature` | `String?` | `null` | Holds the signature from the API until it is passed to the modal cubit |

`copyWith` must support clearing to null (consistent with existing nullable fields pattern).

---

## 2. New Domain Objects

### 2.1 `SignatureModalStatus` — NEW (enum)

**File**: `lib/features/auth/presentation/cubit/signature_modal_state.dart`

```
enum SignatureModalStatus {
  idle,        // initial; OK button disabled, signature shown in plaintext
  downloading, // file write in progress (optional: show spinner on icon)
  downloaded,  // file written successfully; OK button enabled; signature redacted
  downloadError // file write failed; error message shown; OK button disabled
}
```

---

### 2.2 `SignatureModalState` — NEW

**File**: `lib/features/auth/presentation/cubit/signature_modal_state.dart`

| Field | Type | Default | Invariant |
|---|---|---|---|
| `signature` | `String` | (required) | The raw signature text for display/file write. Never empty when modal is shown. |
| `status` | `SignatureModalStatus` | `idle` | Drives UI rendering |
| `errorMessage` | `String?` | `null` | Set only when `status == downloadError` |

**Lifecycle rule**: A new `SignatureModalState` instance is created fresh every time the modal is opened (FR-012: gate always resets). There is no persistence across sessions.

**Redaction logic**: The widget derives the displayed text from `status`:
- `idle` or `downloadError` → show `state.signature` as plaintext
- `downloading` → show `state.signature` as plaintext (with spinner on icon)
- `downloaded` → show `'*' * state.signature.length` (or a fixed placeholder string)

Redaction is a **view-layer concern** — the `signature` field in state always holds the real value until the cubit is disposed.

---

### 2.3 `SignatureModalCubit` — NEW

**File**: `lib/features/auth/presentation/cubit/signature_modal_cubit.dart`

| Method | Signature | Description |
|---|---|---|
| (constructor) | `SignatureModalCubit(String signature)` | Initializes with `SignatureModalState(signature: signature)` |
| `downloadSignature` | `Future<void> downloadSignature()` | Writes `.txt` file; emits `downloading` → `downloaded` or `downloadError` |

**State transitions**:
```
idle
  └─(tap download)──► downloading
                          ├─[success]──► downloaded
                          └─[failure]──► downloadError
                                             └─(tap download)──► downloading ...
```

---

## 3. Entity Relationships

```
API Response (CustomerLoginResultDto)
    │
    ▼
LoginResponseModel (data layer)
    │  .toEntity()
    ▼
LoginEntity (domain layer)
    │   .digitalSignature: String?
    │
    ▼
RegisterState (presentation/cubit)
    │   .digitalSignature: String?
    │
    ▼ (on RegisterStatus.success, if digitalSignature != null)
SignatureModalCubit (modal-scoped)
    │   .state.signature: String  ← held only while modal is open
    │
    ▼ (on OK pressed)
Navigation → /register-success
    └─► SignatureModalCubit disposed (signature reference dropped)
```

---

## 4. Validation Rules

| Rule | Location | Behaviour |
|---|---|---|
| `digitalSignature` from API is null/empty | `RegisterCubit` | Emit `RegisterStatus.failure` with a dedicated `RegisterErrorCode.missingSignature`; show error with retry option (FR-009) |
| File write fails | `SignatureModalCubit.downloadSignature` | Emit `downloadError` state with localised error message; OK button stays disabled |
| `signature` passed to cubit is empty | Constructor guard | Assert non-empty; RegisterCubit ensures this before showing modal |

---

## 5. File Output

| Property | Value |
|---|---|
| File name | `wasla_digital_signature.txt` |
| Directory | `getApplicationDocumentsDirectory()` (cross-platform, no permission needed) |
| Encoding | UTF-8 |
| Content | Raw signature string only (no wrapper, no metadata) |
| Overwrite policy | Overwrite if file already exists (same name, idempotent) |
