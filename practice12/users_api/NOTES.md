# NOTES

## Package verdicts (publisher · last release · platforms · points · issues vs commits · deps · licence)
1. shared_preferences – verified publisher flutter.dev, released <месяц год>, <платформы>, <N> points, <issues/commits>, deps: platform plugins only, <licence>. Fine for settings.
2. flutter_secure_storage – publisher <проверь>, released <месяц год>, <платформы>, <N> points, <issues/commits>, deps: <…>, <licence>. The only one of the six that is allowed to hold a token.
3. path_provider – verified publisher flutter.dev, released <…>, <платформы>, <N> points, <…>, <licence>.
4. image_picker – verified publisher flutter.dev, released <…>, <платформы>, <N> points, <…>, <licence>.
5. permission_handler – publisher <проверь, Baseflow>, released <…>, <платформы>, <N> points, <…>, <licence>. Needs Podfile macros on iOS.
6. url_launcher – verified publisher flutter.dev, released <…>, <платформы>, <N> points, <…>, <licence>.

## Caret
`http: ^1.2.0` accepts >=1.2.0 and <2.0.0 (1.2.1, 1.5.0 – yes). It refuses 2.0.0 (breaking change) and 1.1.x (older than the minimum).
pubspec.lock holds the exact version pub resolved (http = <версия из lock>). It is committed for an app so that every teammate, CI and the release build get identical versions. A library does not commit it, because its users resolve their own.
Experiment: `http: 1.2.0` without caret + `flutter pub get` → lock pins 1.2.0, `pub outdated` shows newer ones as unavailable. Caret put back.

## pub outdated
<пакет> could be newer (<текущая> → <новая>); not upgraded because <причина: major bump / constraint of another package / SDK constraint>.

## Where the token would go with prefs.setString('token', ...)
Android: an XML file in /data/data/<pkg>/shared_prefs/. iOS: a plist (NSUserDefaults) in the app container. Both are plain text.
Who can read it: a device backup (adb backup / iTunes backup), root or jailbreak, anyone with the cable and a debuggable build.
Secure storage instead: Keychain (iOS) / Keystore-backed encrypted prefs (Android).
Platform surprises:
- iOS: Keychain items can survive uninstall, so after reinstall the app may start already signed in. Fix: store a "first run" flag in prefs and clear the keychain when it is missing.
- Android: if the user removes the lock screen or the keys get invalidated, the encrypted data becomes unreadable. Reading throws, so SecureStore catches, clears and treats it as signed out.

## Permissions (camera)
Android: 1st No → denied, 2nd No → permanentlyDenied, 3rd tap → no system dialog, my own dialog → openAppSettings().
iOS: the system asks only once. One No → permanentlyDenied straight away; the only way back is Settings.
The fourth Photos state is `limited` (user shared only selected photos). The others: granted, denied, restricted (parental control), permanentlyDenied.
launchUrl(Uri.parse('kbtu.edu.kz')) → no scheme → false, nothing opens. With https:// → browser opens.