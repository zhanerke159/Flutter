# users_api — Practice 12: Survive a Restart

Users app from Practice 11 + persistence:
settings (shared_preferences), token (flutter_secure_storage), offline list (file in Documents), profile photo (image_picker + permission_handler), links (url_launcher).

Run: `flutter pub get && flutter run`. iOS: after the first `pod install` add `PERMISSION_CAMERA=1` to the Podfile `GCC_PREPROCESSOR_DEFINITIONS` (see permission_handler docs).
