# health_app

A mental health app built with Flutter designed to promote wellbeing with engaging UI and animations

## Current Structure

- **main.dart**: App entry point and global configuration
- **login.dart**: Login screen and forgot password functionality
- **home.dart**: Home screen with tabs for activities, meditation, and profile
- **animations.dart**: Custom animated background components

## Getting Started

1. **Prerequisites:**  
   - Ensure you have Flutter installed and configured
   - Verify Android Studio installation
        - Android SDK
        - Android Emulator
        

2. **Clone the Repository:**  
   ```bash
   git clone https://github.com/WillGasser/FlutterApp
   cd health_app

3. **Install dependencies:**
   ```bash
   flutter pub get

   ```
   #Optional; I am unsure if this is required for all but I ran these commands
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
4. **Run:**
    ```bash
    flutter run
    ```

# Android Emulation NOTES
- Use CTRL + uparrow or CTRL + downarrow to configure your emulator size
- Make sure to use --no-enable-impeller to remove arbitrary emulator logs

# Additional notes
- If you are having trouble with the cache, you can reset by running
   ```bash
   flutter clean
   flutter pub get
   ```
- Before running the app, I reccommend running
```bash
   flutter analyze
   ```
   This gives you detailed syntax and semantic notes about possible sources of error

