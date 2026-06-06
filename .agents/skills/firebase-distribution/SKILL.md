---
name: firebase-distribution
description: >-
  Sets up Firebase App Distribution so the Android build is delivered to testers
  automatically from CI. Use when configuring Android app distribution, beta/
  internal testing delivery, tester groups, or the GitHub Actions step that
  uploads the APK to Firebase. Pairs with github-cicd.
metadata:
  platform: android
---

# Firebase App Distribution (Android beta delivery)

Goal: every time you run the mobile workflow, the freshly built Android APK is
pushed to a Firebase tester group, and testers get an email/notification. No
Play Store needed for internal testing.

## How it works

The `deploy-mobile` workflow (see `github-cicd`) builds the debug APK and uses
`wzieba/Firebase-Distribution-Github-Action@v1` to upload it. It needs two
secrets and a tester group:

- `FIREBASE_APP_ID` — the Android app id from the Firebase project.
- `FIREBASE_SERVICE_ACCOUNT` — the full JSON of a service account with the
  **Firebase App Distribution Admin** role (pasted as a single secret value).
- a tester group (the template uses `groups: testers`).

## Agent does

- Generate/confirm the `deploy-mobile.yml` workflow with the Firebase upload step
  and `groups: testers`.
- Ensure the Android target produces `composeApp-debug.apk` at the expected path
  (`composeApp/build/outputs/apk/debug/`), and that the build is gated behind
  `-Pandroid.enabled=true` so web-only CI never needs the Android SDK.
- Add release notes wiring (branch + commit + run number + optional human note).
- Record the manual steps in `SECRETS.md`.

## Human must do (→ `SECRETS.md`)

1. Create the Firebase project; register the Android app (package name must
   match the app's `applicationId`). Copy the **App ID** → `FIREBASE_APP_ID`.
2. Create a service account (IAM) with **Firebase App Distribution Admin**,
   download the JSON key, paste its contents → `FIREBASE_SERVICE_ACCOUNT`.
3. In App Distribution, create a tester group named **`testers`** and add tester
   emails. (Rename the group in the workflow if you prefer another name.)

## Optional upgrades

- Add signed **release** APK/AAB later (needs a keystore secret) when moving
  beyond internal testing.
- Auto-increment `versionCode` from `github.run_number` for clean version sorting
  in App Distribution.
- Add an iOS lane (TestFlight) only if/when an iOS target is added — out of scope
  for the default KMP-Android+Web stack.
