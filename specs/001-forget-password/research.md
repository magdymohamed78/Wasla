# Research: Forget Password Page

**Feature**: 001-forget-password
**Date**: 2026-02-22

## Decisions

### 1. State Management Approach

**Decision**: Use Cubit (flutter_bloc) with simple state

**Rationale**: 
- Project already uses Cubit pattern for login (LoginCubit, LoginState)
- Forget password page has minimal state: email value, validation status, submission status
- Cubit is simpler than full Bloc for UI-only features with no complex event logic

**Alternatives Considered**:
- StatefulWidget with setState: Rejected - inconsistent with project architecture
- Full Bloc pattern: Rejected - overkill for simple validation + toast display

### 2. Form Validation Strategy

**Decision**: Use existing Validators class with real-time validation

**Rationale**:
- Validators class already exists with validateEmail method
- Project pattern shows validation on input change (see LoginForm)
- Immediate feedback aligns with SC-002 requirement

**Alternatives Considered**:
- Create new validator: Rejected - reuse existing, DRY principle
- Validation only on submit: Rejected - spec requires immediate feedback

### 3. Toast/Snackbar Implementation

**Decision**: Use ScaffoldMessenger with SnackBar (existing pattern)

**Rationale**:
- Login page uses ScaffoldMessenger.showSnackBar pattern
- Consistent UX across app
- No additional dependencies needed

**Alternatives Considered**:
- Third-party toast library: Rejected - adds unnecessary dependency
- Custom overlay: Rejected - over-engineering for simple toast

### 4. Responsive Layout Approach

**Decision**: Use LayoutBuilder + ConstrainedBox pattern (existing pattern from LoginPage)

**Rationale**:
- Login page uses identical pattern for centered card
- Provides proper constraints for responsive behavior
- Follows mobile-first design principle

**Alternatives Considered**:
- MediaQuery: Less precise for layout constraints
- flutter_screenutil: Not used in project

### 5. Button State Management

**Decision**: Control via cubit state with disabled/enabled states

**Rationale**:
- Clean separation of UI and logic
- Easy to test
- Follows LoginCubit pattern

**Implementation Details**:
- Disabled state: light gray background (VR-005)
- Enabled state: red background (VR-003)
- Disable during toast display (FR-017)

### 6. Localization Keys

**Decision**: Add new keys to AppLocalizations following existing naming convention

**Required Keys**:
- `forgotPasswordTitle`: "Forget Password ?"
- `forgotPasswordDescription`: "Don't worry! It occurs. Please enter the email address linked with your account."
- `forgotPasswordEmailLabel`: "Enter Your Email Address"
- `forgotPasswordEmailPlaceholder`: "yourmail@gmail.com"
- `forgotPasswordSend`: "Send"
- `forgotPasswordSuccess`: "Reset link sent successfully"
- `forgotPasswordEmailRequired`: "Email is required"
- `forgotPasswordEmailInvalid`: "Please enter a valid email"

**Rationale**: Follows existing `login*` naming convention pattern

### 7. Image Handling

**Decision**: Use Image.asset with error builder for graceful degradation

**Rationale**:
- Image exists at `assets/images/forget password.png`
- errorBuilder handles load failures (FR-018)
- No placeholder image in assets, so hide section on error

## Dependencies Resolved

All technical context items resolved:
- Language: Dart 3.11.0 ✓
- Dependencies: flutter_bloc, go_router, intl ✓
- Testing: flutter_test, bloc_test, mocktail ✓
- Platform: Mobile (iOS/Android) ✓

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Image load failure | Use errorBuilder to hide illustration section |
| Long email addresses | CSS-like overflow ellipsis with TextOverflow.ellipsis |
| Rapid button clicks | Disable button in cubit state during toast display |
| Direct URL access | Page works independently, no navigation guard needed |
