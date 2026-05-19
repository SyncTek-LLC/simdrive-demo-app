# simdrive-demo-app

> The demo app used in the SimDrive hero recording.
> Build it, run it, break it, fix it with Claude.

A deliberately minimal two-screen SwiftUI iOS app whose only purpose is to be
driven by [SimDrive](https://simdrive.dev) in the hero demo. It is intentionally
generic — vanilla SwiftUI, default styling, no dependencies — so every iOS
developer thinks "yeah, that looks like my app."

## Build & run

```bash
git clone https://github.com/SyncTek-LLC/simdrive-demo-app
cd simdrive-demo-app
xcodegen generate   # regenerate simdrive-demo-app.xcodeproj from project.yml
open simdrive-demo-app.xcodeproj
# then press Cmd-R in Xcode to launch on the iPhone 17 simulator
```

Or build from the command line:

```bash
xcodebuild \
  -scheme simdrive-demo-app \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

## The app

Two screens. That's it.

1. **Sign In** — email + password fields, "Sign In" button.
   Any non-empty email + non-empty password "signs you in."
   No backend, no networking, no persistence — local mock only.
2. **Dashboard** — `NavigationStack` with five `List` placeholder items
   (Inbox, Calendar, Files, Tasks, Settings) and a Log Out button in the nav bar.

All interactive elements expose `accessibilityIdentifier`s so SimDrive (or
XCUITest, or any other test driver) can find them by name:

| Element                | accessibilityIdentifier |
| ---------------------- | ----------------------- |
| Email field            | `email-field`           |
| Password field         | `password-field`        |
| Sign In button         | `sign-in-button`        |
| Validation error label | `validation-error`      |
| Log Out button         | `logout-button`         |

## The bug

This repo has two branches, and that's the whole point of the demo:

| Branch                       | Behavior on empty-password sign-in tap                                |
| ---------------------------- | --------------------------------------------------------------------- |
| `main`                       | Shows inline "Password is required" validation error. No navigation.  |
| `bug/empty-password-crash`   | Force-unwraps `password.first!` and crashes (`EXC_BAD_INSTRUCTION`).  |

Both branches have identical accessibility identifiers, so the same SimDrive
script reproduces on `bug/...` and validates the fix on `main`.

The demo flow:

```bash
# 1. Reproduce the crash
git checkout bug/empty-password-crash
# Run the app, tap Sign In with an empty password -> EXC_BAD_INSTRUCTION

# 2. Switch to the fix
git checkout main
# Run the app, tap Sign In with an empty password -> "Password is required"
```

## Use with SimDrive

Once SimDrive is installed (`pip install simdrive`), a minimal hero script
looks like:

```python
import simdrive as sd

session = sd.session_start(app_bundle_id="io.synctek.simdrive.demo",
                           device="iPhone 17")

sd.observe()                                       # screenshot + element tree
sd.tap(accessibility_id="email-field")
sd.type_text("test@example.com")
sd.tap(accessibility_id="password-field")
# (no password — this is the reproduction)
sd.tap(accessibility_id="sign-in-button")
sd.observe()                                       # crash or validation-error?

sd.session_end()
```

Full driver reference and the hero demo recording live at
<https://simdrive.dev/docs>.

## Tests

```bash
xcodebuild \
  -scheme simdrive-demo-app \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

- `simdrive-demo-appTests/SignInValidatorTests.swift` — unit tests for the
  validation logic (empty/whitespace email, empty password, success path).
- `simdrive-demo-appUITests/SignInUITests.swift` — UI test scripts the happy
  path (sign in lands on the dashboard) and the validation-error path.

The UI test that asserts a validation error is **expected to fail** on
`bug/empty-password-crash` — the bug is the feature on that branch.

## License

[MIT](LICENSE) — fork it, riff on it, break it differently. The point is to
have a known-shape app to demo against.

---

Built as part of **INIT-2026-549** for the SimDrive hero demo.
