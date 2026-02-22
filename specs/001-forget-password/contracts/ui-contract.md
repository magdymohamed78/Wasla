# UI Contract: Forget Password Page

**Feature**: 001-forget-password
**Date**: 2026-02-22

## Page Contract

### Route

| Property | Value |
|----------|-------|
| Path | `/forgot-password` |
| Navigation | Push (modal) |
| Access | Public (no authentication required) |

### Page Layout

```
┌─────────────────────────────────────┐
│         Light Gray Background       │
│  ┌─────────────────────────────┐    │
│  │      White Card (350-400px) │    │
│  │  ┌───────────────────────┐  │    │
│  │  │    WASLA (Red Logo)   │  │    │
│  │  └───────────────────────┘  │    │
│  │  ┌───────────────────────┐  │    │
│  │  │   [Illustration]      │  │    │
│  │  └───────────────────────┘  │    │
│  │      Forget Password ?      │    │
│  │  Don't worry! It occurs...  │    │
│  │  ┌───────────────────────┐  │    │
│  │  │ Enter Your Email      │  │    │
│  │  │ yourmail@gmail.com    │  │    │
│  │  └───────────────────────┘  │    │
│  │  ┌───────────────────────┐  │    │
│  │  │        Send           │  │    │
│  │  └───────────────────────┘  │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### User Interactions

| Action | Input | Output |
|--------|-------|--------|
| Type email | Text characters | Email field updates, real-time validation |
| Clear email | Backspace | Validation updates to "Email is required" |
| Enter invalid email | "invalid" | Error: "Please enter a valid email" |
| Click Send (invalid) | Tap | No action (button disabled) |
| Click Send (valid) | Tap | Show toast "Reset link sent successfully" |
| Press Enter (valid) | Keyboard | Show toast (same as Send click) |
| Press Tab | Keyboard | Focus moves through elements |

### Form States

| State | Email Field | Send Button | Toast |
|-------|-------------|-------------|-------|
| Empty | Error shown | Disabled (gray) | Hidden |
| Invalid format | Error shown | Disabled (gray) | Hidden |
| Valid email | No error | Enabled (red) | Hidden |
| Submitting | Disabled | Disabled (gray) | Shown |
| Success | Disabled | Enabled (red) | Dismissed |

## Accessibility Contract

### ARIA Labels

| Element | Semantics |
|---------|-----------|
| Email field | `TextField` with `autofillHints: [AutofillHints.email]` |
| Send button | `ElevatedButton` with semantic label "Send reset link" |
| Toast | `SnackBar` with accessibility announcement |
| Logo | `Semantics` label "WASLA logo" |
| Illustration | `Semantics` label "Password reset illustration" |

### Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Move focus forward |
| Shift+Tab | Move focus backward |
| Enter | Submit form (when email valid) |

### Focus Management

| Event | Focus Target |
|-------|--------------|
| Page load | Email field |
| After toast dismiss | Email field |

## Localization Contract

### Required Keys

| Key | English (en) | Arabic (ar) |
|-----|--------------|-------------|
| `forgotPasswordTitle` | Forget Password ? | نسيت كلمة المرور ؟ |
| `forgotPasswordDescription` | Don't worry! It occurs. Please enter the email address linked with your account. | لا تقلق! يحدث هذا. يرجى إدخال عنوان البريد الإلكتروني المرتبط بحسابك. |
| `forgotPasswordEmailLabel` | Enter Your Email Address | أدخل عنوان بريدك الإلكتروني |
| `forgotPasswordEmailPlaceholder` | yourmail@gmail.com | yourmail@gmail.com |
| `forgotPasswordSend` | Send | إرسال |
| `forgotPasswordSuccess` | Reset link sent successfully | تم إرسال رابط إعادة التعيين بنجاح |
| `forgotPasswordEmailRequired` | Email is required | البريد الإلكتروني مطلوب |
| `forgotPasswordEmailInvalid` | Please enter a valid email | يرجى إدخال بريد إلكتروني صالح |

## Error Handling

| Error | Display | Recovery |
|-------|---------|----------|
| Empty email | Inline error below field | Type valid email |
| Invalid format | Inline error below field | Type valid email format |
| Image load failure | Hide illustration section | None needed (non-critical) |
