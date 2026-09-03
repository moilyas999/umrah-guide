# Umrah Guide

Independent iOS app from **DeskLink.ai** (Mohammed Ilyas). Offline educational companion for the common stages of Umrah.

- **Display name:** Umrah Guide
- **Bundle ID:** `ai.desklink.umrahguide`
- **Version:** 1.0 (build 3)
- **Devices:** iPhone, iOS 17 or later
- **Signing:** Automatic. Select your Apple Development Team in Xcode. This repository does not contain an Apple Team ID.

This listing is a new, standalone app. It does not collect personal data, use the network, request location, or embed third-party SDKs.

## Open in Xcode

1. On a Mac, install **Xcode 15** or later (iOS 17 SDK).
2. Clone this repository and open `UmrahGuide.xcodeproj`.
3. Select the **UmrahGuide** scheme (shared in the project).
4. In the UmrahGuide target → **Signing & Capabilities**:
   - Enable **Automatically manage signing**.
   - Choose **your** Team. Do not paste a Team ID from a document or another project.
5. Choose an iPhone simulator or a device and press Run.

Linux CI cannot compile or simulate this app. Build, test, and archive only on macOS.

## Archive for App Store Connect

1. Select **Any iOS Device (arm64)**.
2. Product → **Archive**.
3. In Organizer, **Distribute App** → App Store Connect.
4. Use the same automatic signing team you selected in the target.
5. After upload, complete App Privacy with **Data Not Collected** (see below).
6. Privacy Policy URL (after GitHub Pages is on): `https://moilyas999.github.io/umrah-guide/privacy.html`
7. Support URL: `https://moilyas999.github.io/umrah-guide/support.html`

Export compliance: the target sets `ITSAppUsesNonExemptEncryption` to `NO`. The app makes no network calls.

## What the app contains

| Tab | Contents |
| --- | --- |
| Perform | Linear flow: one next action at a time through ihram, tawaf, sa'i, and cutting the hair. Huge type, a Next button, optional “I've done this.” Pack and duas open as sheets so you do not lose your place. |
| Pack | Ihram and packing items, stored in on-device `UserDefaults` |
| More | All duas (by stage, plus general), About, and a reset for your Perform place |

Guidance is high-level Sunni majority practice. It is **not a fatwa**. Users are told to consult a qualified scholar.

## Tests

The **UmrahGuide** scheme includes **UmrahGuideTests**:

- Checklist ticks persist across a fresh `ChecklistStore` using an isolated `UserDefaults` suite.
- Ritual catalog contains Ihram, Tawaf, Sa'i, and Halq/Taqsir, each with the required sections.
- Perform catalog is a 16-step linear walk; each step has 1–3 short “do now” sentences.
- Perform place and “I've done this” ticks persist in an isolated `UserDefaults` suite.
- Dua catalog covers ihram, the Sacred Mosque, first sight of the Kaaba, tawaf (including Rabbana atina), Maqam Ibrahim, Zamzam, sa'i, the hair rite, and general duas. Every card has Arabic, English meaning, and an honest source note.

On a Mac: Product → Test, or:

```bash
xcodebuild -project UmrahGuide.xcodeproj -scheme UmrahGuide -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## App Privacy answers

Use these answers in App Store Connect. They match `PrivacyInfo.xcprivacy` and the in-app policy.

| Question | Answer |
| --- | --- |
| Do you or your third-party partners collect data from this app? | **No** → **Data Not Collected** |
| Tracking (NSUserTrackingUsageDescription / ATT) | Not used |
| Location | Not used |
| Contacts, photos, camera, microphone | Not used |
| Account / login | None |
| Analytics, crash, ads, paid APIs | None |
| Network | None (no ATS exceptions, no endpoints) |
| Required Reason API | UserDefaults only, reason **CA92.1** (app-only checklist) |

Do not declare collected data types. There are none.

## GitHub Pages (privacy and support URLs)

HTML copies live in `docs/` for App Store Connect:

- `docs/privacy.html`
- `docs/support.html`
- `docs/index.html`

In the repository: **Settings → Pages → Deploy from a branch → `main` / `docs`**. The app already shows the same text on device and never fetches these pages.

## Project layout

```
UmrahGuide.xcodeproj/     Xcode project + shared scheme
UmrahGuide/               SwiftUI app (no CocoaPods, SPM, or vendor SDKs)
UmrahGuideTests/          XCTest
docs/                     GitHub Pages legal pages
scripts/                  Icon and project generators (optional)
```

Regenerate the icon or `project.pbxproj` only if you are changing the file list:

```bash
python3 scripts/generate_app_icon.py
python3 scripts/generate_xcode_project.py
```

## License and use

Educational use. The religious text is a study aid, not a ruling.
