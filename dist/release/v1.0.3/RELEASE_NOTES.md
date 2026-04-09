aha v1.0.3

Changes in this release:
- Removed unfinished cloud sync UI, placeholder managers, and unused cloud config files.
- Removed the unused Firebase package reference and stale Google service plist.
- Kept local persistence as the single supported storage mode.
- Confirmed the app still builds and launches after cleanup.

Downloads:
- Apple Silicon (M-series): `aha-v1.0.3-macos-apple-silicon.dmg`
- Intel: `aha-v1.0.3-macos-intel.dmg`

Notes:
- These builds are packaged separately by CPU architecture.
- The app is signed for local run only, so macOS may show a trust prompt on first launch.
