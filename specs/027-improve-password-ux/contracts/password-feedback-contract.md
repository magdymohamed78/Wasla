# Contract: Password Feedback UI Component

## Component
`PasswordRulesWidget`

## Responsibility
Render password requirement checklist and expose deterministic visual states based on password content and field interaction timing.

## Inputs
- `password: String` (required)
- `isBlurred: bool` (required)
- `showNeutralWhenEmpty: bool` (default `true`)
- `textStyle/color overrides`: optional; default to theme tokens

## Rule Evaluation Contract
- `hasMinLength(password)` => `password.trim().length >= 8`
- `hasNumber(password)` => contains at least one ASCII digit `[0-9]`
- `hasSpecialChar(password)` => contains at least one char from `!@#$%^&*`
- `hasUppercase(password)` => contains at least one uppercase letter `[A-Z]`

## Visual State Contract
- Empty password:
  - Checklist is visible in neutral (grey) state
  - Strength meter hidden
- Non-empty + typing (`isBlurred == false`):
  - unmet rules = grey
  - met rules = green
- Non-empty + blurred (`isBlurred == true`):
  - unmet rules = red
  - met rules = green

## Strength Meter Contract
- Score source: `flutter_password_strength_meter`
- Band mapping:
  - weak: `0.00..0.33` => red
  - medium: `0.34..0.66` => orange
  - strong: `0.67..1.00` => green
- Helper text "password is weak" shown immediately when password is non-empty and weak.

## Integration Contract
- Sign-up integration point: under password `TextFormField` in `SignUpForm`.
- State source: `RegisterState.password` from `RegisterCubit` via `BlocBuilder`.
- No changes to backend/API contracts.
