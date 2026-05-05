# Tundra 

A Flutter photo editing app that lets you pick an image from your camera or gallery, apply color filters, and save the result directly to your gallery.

## Features

- Pick images from camera or gallery
- Apply real-time color filters:
  - **50's** — grayscale
  - **Hell** — red soft light
  - **Ice** — blue soft light
  - **Warm** — orange overlay
  - **Green** — green overlay
- Save edited image directly to gallery

## Tech Stack

| Package | Purpose |
|---|---|
| `image_picker` | Pick images from camera or gallery |
| `permission_handler` | Request storage/photos permissions |
| `screenshot` | Capture the filtered widget as image bytes |
| `gal` | Save image bytes to device gallery |
| `device_info_plus` | Detect Android version for correct permission |
| `loading_animation_widget` | Loading animation on home screen |

## Getting Started

### Requirements

- Flutter 3.0+
- Android SDK 21+
- Java 17

### Install dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Build APK

```bash
set JAVA_HOME=C:\Users\mique\AppData\Roaming\Code\User\globalStorage\pleiades.java-extension-pack-jdk\java\17 && flutter build apk
```

## Permissions

### Android (`AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
```

### iOS (`Info.plist`)

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to save edited photos.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need access to add photos to your library.</string>
```

## Project Structure

```
lib/
  main.dart     — Home screen, image picker
  editor.dart   — Filter editor, save to gallery
```
