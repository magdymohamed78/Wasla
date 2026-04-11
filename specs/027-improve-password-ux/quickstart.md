# Quickstart: Enhance Password Field UX

## 1. Add package dependency
1. Add `flutter_password_strength_meter` to dependencies.
2. Run dependency resolution.

## 2. Implement reusable validation helpers
1. In shared validators, add:
   - `hasMinLength(String)`
   - `hasNumber(String)`
   - `hasSpecialChar(String)` using set `!@#$%^&*`
   - `hasUppercase(String)`
2. Keep existing `validatePasswordLength` unchanged for backward compatibility.

## 3. Build reusable widget contract
1. Create `PasswordRulesWidget` as a reusable widget.
2. Inputs should include password value and interaction mode (typing vs blurred).
3. Render four rows with icon/text states:
   - valid: green
   - unmet while typing: grey
   - unmet after blur: red
   - empty password: neutral checklist state

## 4. Integrate in sign-up flow
1. In `SignUpForm`, insert `PasswordRulesWidget` directly under password field.
2. Keep spacing consistent with existing `AppDimensions` values.
3. Add strength meter under checklist; hide strength meter when password is empty.
4. Show weak helper text immediately when password is non-empty and weak.
5. Use `BlocBuilder<RegisterCubit, RegisterState>` and `state.password` as source of truth.

## 5. Keep architecture and theme compliance
1. Use `AppColors`, `AppTypography`, `AppDimensions` only.
2. Avoid moving/changing existing layout structure outside password section.
3. Do not add a new Cubit.

## 6. Validate behavior
1. Verify checklist updates on each keystroke.
2. Verify blur transition changes unmet rules from grey to red.
3. Verify strength thresholds:
   - weak `0.00..0.33`
   - medium `0.34..0.66`
   - strong `0.67..1.00`
4. Verify no overflow on supported phone sizes.
5. Run relevant widget and cubit tests.

## 7. Implementation Validation & Polish
- [x] **Design Token Consistency**: Verified `AppTypography`, `AppColors`, and `AppDimensions` are exclusively used in new UI components.
- [x] **Small-Screen Overflow**: Verified `PasswordFeedbackSection` is strictly bounded and avoids overflowing standard mobile viewports.
- [x] **RTL/LTR Support**: Verified localization and layout components correctly adapt spacing and icon orientation for Arabic / RTL context.
- [x] **Artifact Sync**: Verified pubspec dependencies and string resources match implementation.
