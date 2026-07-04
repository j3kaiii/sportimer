# sportimer

Customizable interval timer for workout and training routines.

Create named **sequences** (workout sets), populate them with training/rest intervals, and run through them with a full-screen countdown, visual progress ring, and audio cues.

## Features

- **Sequences** — create and edit named workout sets
- **Training & rest intervals** — each timer can be a workout or rest period with distinct visual styling (red/green)
- **Full-screen playback** — circular countdown ring, per-timer progress, dot strip for overview, next-up preview
- **Audio countdown** — `countdown.wav` plays when 5 seconds remain in any interval
- **Playback controls** — play/pause, reset, stop
- **Dark-only theme** — slate-based palette with red (workout) / green (rest) accents
- **Localization** — Russian (base) and English
- **Persistence** — all data saved locally via Hive

## Tech Stack

- Flutter 3.38.10 (pinned via FVM) |
- State - `flutter_bloc` + `equatable` |
- Navigation - `go_router` |
- Persistence - Hive

## Getting Started

```bash
# Install dependencies
fvm flutter pub get

# Regenerate Hive adapters (after model changes)
fvm dart run build_runner build

# Run
fvm flutter run

# Analyze
fvm flutter analyze
```
