Maize Doctor

Maize Doctor is a Flutter mobile application that helps users detect maize leaf diseases using image analysis. Users can capture or upload a leaf image, send it to a backend API, and receive a diagnosis with confidence levels and basic treatment guidance.

Features
Capture image using camera or select from gallery
Preview image before analysis
Send image to Flask API for prediction
Display diagnosis with confidence score
Show alternative possible diseases
Store scan history locally
Mock mode for testing without backend

Tech Stack
Flutter (Dart)
Provider (state management)
GoRouter (navigation)
Dio (API requests)
image_picker
shared_preferences

Project Structure

lib/
├── main.dart
├── app/
├── screens/
├── widgets/
├── services/
├── providers/
├── models/
└── constants/

Setup

flutter pub get
flutter run

Backend Configuration

The app connects to a Flask API for disease prediction. During development, the backend URL is defined in the project constants file.

Mock mode is enabled by default, so the app can still run and demonstrate functionality without requiring a live server.

Enabled by default:

static const bool mockMode = true;

Set to false when backend is available.


API Endpoints
POST /predict

Request:

{ "image": "<base64 string>" }

Response:

{
  "disease": "northern_leaf_blight",
  "confidence": 0.92,
  "alternatives": [
    { "label": "gray_leaf_spot", "confidence": 0.05 },
    { "label": "common_rust", "confidence": 0.02 },
    { "label": "healthy", "confidence": 0.01 }
  ]
}

GET /health
{ "status": "ok" }

Limitations
Requires internet when not in mock mode
Accuracy depends on backend model
No image compression yet

Future Improvements
Add image compression
Improve offline support
Enhance model accuracy