# Data Model: Enhance Password Field UX

## Entity: PasswordFeedbackState
- Purpose: Combined UI model used to render password checklist, strength meter, and helper text from current input.
- Fields:
  - `password: String`
  - `isEmpty: bool`
  - `hasMinLength: bool`
  - `hasNumber: bool`
  - `hasSpecialChar: bool` (special set: `!@#$%^&*`)
  - `hasUppercase: bool`
  - `activeRuleColorMode: RuleColorMode` (`typing`, `blurred`)
  - `strengthScore: double` (range `0.0..1.0`)
  - `strengthLevel: PasswordStrengthLevel` (`weak`, `medium`, `strong`, `hidden`)
  - `showWeakHelperText: bool`

## Entity: PasswordRuleItem
- Purpose: Render contract for one checklist row.
- Fields:
  - `id: PasswordRuleType` (`minLength`, `number`, `specialChar`, `uppercase`)
  - `labelKey: String` (localized string key)
  - `isSatisfied: bool`
  - `visualState: RuleVisualState` (`neutral`, `invalidTyping`, `invalidBlurred`, `valid`)

## Entity: PasswordStrengthBand
- Purpose: Deterministic mapping from score to semantic level/color.
- Fields:
  - `minInclusive: double`
  - `maxInclusive: double`
  - `level: PasswordStrengthLevel`
  - `colorToken: String`
- Canonical bands:
  - `0.00..0.33 => weak (red)`
  - `0.34..0.66 => medium (orange)`
  - `0.67..1.00 => strong (green)`

## Relationships
- One `PasswordFeedbackState` owns four `PasswordRuleItem` instances.
- `PasswordFeedbackState.strengthLevel` is derived from `strengthScore` via `PasswordStrengthBand` mapping.
- `PasswordFeedbackState.showWeakHelperText` is true when password is non-empty and `strengthLevel == weak`.

## Derived State Rules
- If password is empty:
  - checklist rows use neutral visual state
  - strength meter level is `hidden`
  - weak helper text is hidden
- If password is non-empty and field focused/typing:
  - unmet rules use grey visual state
- If password is non-empty and field blurred:
  - unmet rules use red visual state
- Met rules always use green visual state.
