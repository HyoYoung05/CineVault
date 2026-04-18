# CineVault

CineVault is a Flutter movie app powered by The Movie Database (TMDb) API.

## Setup

1. Install Flutter dependencies:

```bash
flutter pub get
```

2. Run the app with your TMDb API key using `--dart-define`:

```bash
flutter run --dart-define=TMDB_API_KEY=your_real_key_here
```

3. For a release build, pass the same define:

```bash
flutter build apk --dart-define=TMDB_API_KEY=your_real_key_here
```

## Tech Stack

- Flutter
- GetX
- Hive
- TMDb API
