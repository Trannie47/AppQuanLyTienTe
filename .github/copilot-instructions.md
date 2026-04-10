<!-- Auto-generated guidance for AI coding agents. Keep concise and project-specific. -->
# Copilot instructions for this repository

This is a small Flutter app. The goal of these notes is to help AI coding assistants be immediately productive.

- Project type: Flutter app (Dart SDK ^3.10.4). Key entry: [lib/main.dart](lib/main.dart#L1).
- Package manifest: [pubspec.yaml](pubspec.yaml#L1). Assets are declared under `assets/images/` (2x/3x variants).

- Key folders and their roles:
  - `lib/models/` — simple data models (example: [lib/models/category.dart](lib/models/category.dart#L1)).
  - `lib/values/` — global constants used across the app (see `app_assets.dart`, `app_color.dart`, `shareKey.dart`).
  - `lib/pages/` — UI screens (empty in current tree; add new pages here).
  - `assets/images/2x/` and `assets/images/3x/` — resolution-aware image assets referenced from `AppAssets`.

- Project-specific patterns to follow:
  - Centralized constants: colors and asset paths live in `lib/values/`. Prefer adding shared values here rather than scattering literals.
  - Small, stateless models: `Category` uses a simple constructor and an internal counter. Follow similar simplicity for other models.
  - Persisted keys: shared preference keys are grouped in `lib/values/shareKey.dart`; reuse these keys for consistency.

- Build & developer workflows (commands tested for this repo):
  - Install deps: `flutter pub get`
  - Static analysis: `flutter analyze`
  - Run unit/widget tests: `flutter test`
  - Run app (device): `flutter run -d <device>` (macOS, iOS, Android supported)
  - Android CI/build: from repo root `cd android && ./gradlew assembleDebug` (project uses Gradle Kotlin DSL: `.kts`).
  - iOS: open `ios/Runner.xcworkspace` in Xcode for signing and device builds.

- External deps to be aware of (from `pubspec.yaml`):
  - `shared_preferences` — used for local persistence (see `lib/values/shareKey.dart`).
  - `image_picker` — image selection interaction; check any pages that import it.

- When editing UI or assets:
  - Update `pubspec.yaml` assets section if adding new top-level asset folders.
  - Keep 2x/3x variants under `assets/images/2x` and `assets/images/3x` and reference via `AppAssets.imagesPath`.

- Tests & formatting:
  - The project includes `flutter_test` in `dev_dependencies`. Run `flutter test` for quick checks.
  - Follow existing file layout conventions (small files per screen/component) rather than merging large files.

- Debugging and platform notes:
  - Android build uses `gradlew` scripts in `android/` and Kotlin DSL build files (`build.gradle.kts`).
  - iOS platform files live under `ios/Runner/` — use Xcode for entitlements and provisioning.

- Helpful files to inspect while coding:
  - [lib/main.dart](lib/main.dart#L1) — app entry
  - [lib/models/category.dart](lib/models/category.dart#L1) — model style example
  - [lib/values/app_assets.dart](lib/values/app_assets.dart#L1) — how image paths are centralized
  - [lib/values/app_color.dart](lib/values/app_color.dart#L1) — color constants
  - [pubspec.yaml](pubspec.yaml#L1) — dependencies and assets

If anything important is missing or you want instruction examples for PR messages, tests, or CI, tell me what to add and I will update this file.
