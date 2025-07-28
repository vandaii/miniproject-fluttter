@echo off
echo Building for all platforms...

echo.
echo Building for Android...
flutter build apk --release

echo.
echo Building for Web...
flutter build web --release

echo.
echo Building for Windows...
flutter build windows --release

echo.
echo Building for macOS...
flutter build macos --release

echo.
echo Building for Linux...
flutter build linux --release

echo.
echo All builds completed!
pause 