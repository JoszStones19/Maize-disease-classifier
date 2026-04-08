# Maize Doctor 🌽

Maize Doctor is a Flutter mobile application for maize leaf disease screening. It lets a farmer take or upload a leaf photo, send it to a Flask API, and view a clean diagnosis screen with confidence, alternatives, treatment guidance, and local scan history.

## Features

- Camera and gallery image input
- Preview before analysis
- Dio-based Flask API integration
- Mock mode for demos without a backend
- Local scan history using `shared_preferences`
- Disease guide for common maize leaf conditions
- Profile dashboard with simple analytics
- Configurable backend base URL

## Tech stack

- Flutter + Dart
- Provider for state management
- GoRouter for navigation
- Dio for HTTP
- image_picker for camera/gallery
- shared_preferences for local persistence
- Google Fonts for typography

## Project structure

```text
lib/
├── main.dart
├── app/
│   └── router.dart
├── screens/
├── widgets/
├── services/
├── providers/
├── models/
└── constants/
```

## Setup

1. Install Flutter.
2. Open this project folder.
3. Run:

```bash
flutter pub get
flutter run
```

## Backend configuration

Edit:

```dart
lib/constants/api_constants.dart
```

Update `ApiConstants.baseUrl` to your Flask server IP, for example:

```dart
static const String baseUrl = 'http://192.168.1.10:5000';
```

## Mock mode

Mock mode is enabled by default so the app is demo-ready even without the real backend.

In `lib/constants/api_constants.dart`:

```dart
static const bool mockMode = true;
```

Set it to `false` when your Flask API is running.

## Expected API contract

### POST `/predict`

Request:

```json
{ "image": "<base64 encoded string>" }
```

Response:

```json
{
  "disease": "northern_leaf_blight",
  "confidence": 0.92,
  "alternatives": [
    { "label": "gray_leaf_spot", "confidence": 0.05 },
    { "label": "common_rust", "confidence": 0.02 },
    { "label": "healthy", "confidence": 0.01 }
  ]
}
```

### GET `/health`

```json
{ "status": "ok" }
```

## Temporary backend note

The app already contains a temporary mock pipeline so your demo works today. Later, remove mock mode and point the base URL to your actual Flask model server.

## Production notes

Before shipping for real users, tighten these areas:

- Add backend URL editing persistence to a settings form or admin-only config flow
- Add retry/offline messaging for poor connectivity
- Add image compression before upload for slow networks
- Add unit/widget/integration tests
- Add secure export/share workflow for history data
