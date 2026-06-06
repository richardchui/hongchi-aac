# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**匡智溝通易 (Hong Chi AAC)** — a Traditional-Chinese AAC (Augmentative and Alternative Communication) iOS app for the Hong Chi Association. Universal iPhone/iPad, landscape-only, deployment target iOS 5.1 (`hongchiaac` app target) / iOS 6.1 (`hongchiaacTests`).

This appears to be a legacy / archived copy — the working directory is literally `hongchi-aac (old)`. Treat the source as frozen-in-time circa 2013 (Xcode 4-era, `objectVersion = 46`, armv7 only).

## Build, run, test

There is no fastlane / xcconfig / Makefile / CI. Everything goes through Xcode or `xcodebuild` against `hongchiaac.xcodeproj`.

```bash
# Build for simulator
xcodebuild -project hongchiaac.xcodeproj -scheme hongchiaac \
  -configuration Debug -sdk iphonesimulator build

# Run unit tests (XCTest target: hongchiaacTests)
xcodebuild -project hongchiaac.xcodeproj -scheme hongchiaac \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 8' test

# Single test method (Xcode 5+ syntax)
xcodebuild ... test -only-testing:hongchiaacTests/hongchiaacTests/testExample
```

Note: `hongchiaacTests/hongchiaacTests.m` is a stub (`STFail(@"Unit tests are not implemented yet…")`). There is effectively no test suite — don't trust "tests pass" as a signal of correctness.

Code signing in the pbxproj is hard-wired to **"iPhone Distribution: Hong Chi Association (R9FAVVSYYY)"** / a personal "Richard Chui" developer identity. Local builds will fail signing on any other machine; expect to override `CODE_SIGN_IDENTITY=""` `CODE_SIGNING_REQUIRED=NO` for simulator-only work.

## Memory management — read before editing `.m` files

The project-level setting is `CLANG_ENABLE_OBJC_ARC = YES`, but the **`hongchiaac` app target overrides this to `NO`**. The `hongchiaacTests` target keeps ARC on.

Concretely:
- App code under `hongchiaac/` is **manual reference counting (MRC)** — you must write `retain`/`release`/`autorelease` and `dealloc`. Properties use `(retain, nonatomic)` and rely on the synthesized setter to release the old value.
- Test code under `hongchiaacTests/` is ARC.

If you add a new `.m` file to the app target, do not use ARC idioms (`strong`/`weak`, no manual `release`) — the compiler will accept some but you will leak or double-free. Match the surrounding style.

Prefix header `hongchiaac/hongchiaac-Prefix.pch` auto-imports `UIKit` and `Foundation` for every translation unit.

## Architecture

### Universal-app pattern (iPhone + iPad)

Almost every screen exists as a trio:

```
FooViewController.{h,m}             ← abstract base, all logic
FooViewController_iPhone.{h,m,xib}  ← iPhone subclass + XIB
FooViewController_iPad.{h,m,xib}    ← iPad subclass + XIB
```

`AppDelegate.m` picks the subclass via `UI_USER_INTERFACE_IDIOM()` at launch (see `application:didFinishLaunchingWithOptions:`). When changing behaviour, **edit the base class**; only touch the `_iPhone` / `_iPad` files for layout-specific overrides. If you only fix one of the two subclasses you will ship a bug on the other device family.

XIBs live next to their `_iPhone` / `_iPad` subclass; outlets are declared on the base class.

### Screen flow

`ViewController` (abstract loader, owns the loading overlay and `handleOpenURL:` for `.aacprofile` imports) → `StartingViewController` (splash/menu) → `AACViewController` (the main card grid: scroll view of pages of AAC cards, with selected-card "sentence bar" at the top) → editor / library / profile / settings / minigame screens.

The "open URL" path is how the app imports `.aacprofile` zip bundles (custom UTI `com.oem-interactive.oemhongchiaac.aacprofile`, declared in `hongchiaac-Info.plist`).

### Data model — three layers

1. **`Classes/Card`** — abstract card. `UserCard` (a user-customised card from a profile) extends it; `AACCard` and `LibCard` are the UI/view wrappers.
2. **`Classes/UserProfile`** — a saved configuration: layout (1×1 / 1×2 / 1×3 / 2×4 / 2×6 / 3×6), voice/caption modes, swipe lock, and the user's `_cardset` (array of `UserCard`).
3. **`Classes/Tester`** — test helper.

### Handlers — singletons backed by plists in `NSDocumentDirectory`

`Handlers/` contains class-method "handlers" that own all persistence:

- `DefaultCardHandler` — reads `default_cards.plist` (bundled, also cached on `AppDelegate.defaultCardsPlist` for cheap access).
- `ProfileHandler` — CRUD over `profiles.plist` (stored in Documents): add/remove/update/reorder `UserProfile`s. **All persistence flows through here** — don't write directly to `profiles.plist`.
- `SettingHandler` — global settings via `settings.plist`.

The bundle ships six pre-built profile zips in `hongchiaac/defaultProfiles/defaultProfile{1x1,1x2,1x3,2x4,2x6,3x6}.zip`, one per layout.

### Other plists (bundled, read-only inputs)

- `default_cards.plist` — built-in card library shown by `LibCardSelectorViewController`.
- `category.plist`, `sentences.plist` — taxonomy and sentence templates.
- `language_resource.plist` — TW/CN localisation strings (also see `Constants getLanguageCodeTW`/`CN`).
- `sequencing_cardsets.plist` — content for the Sequencing minigame.

### Minigames

`MiniGames/Matching/` and `MiniGames/Sequencing/` are self-contained sub-features, each with their own Level → Game → Score view-controller trio (iPad-only XIBs — the matching/sequencing games never shipped on iPhone). `MiniGameViewController` is the shared base.

### Third-party

`ALAssetsLibrary_CustomPhotoAlbum/ALAssetsLibrary+CustomPhotoAlbum.{h,m}` — vendored category for writing the user's custom card photos into a named album. Don't refactor; treat as a frozen dependency.

## Conventions worth knowing

- File/header naming: device-specific subclasses use the `_iPad` / `_iPhone` suffix (with underscore). Match it exactly — the pbxproj references are case- and underscore-sensitive.
- Bundle identifier `hk.org.hongchi.aac`; display name 「匡智溝通易」. Don't change without coordinating with provisioning.
- Chinese filenames are widespread under `hongchiaac/images/`, `hongchiaac/music/` and audio resources (e.g. `2_天氣信號_f.mp3`). They are intentional — keep encoding intact when editing the pbxproj.
- The "Classes" and "Handlers" folders are **logical** Xcode groups; their `.h` files import siblings using relative paths like `#import "../Classes/UserProfile.h"`.
