# Inventory Management App

This Flutter application demonstrates CRUD operations with Firebase Cloud Firestore, featuring enhanced search and filtering capabilities.

## Enhanced Features Implemented

The app includes several enhancements to improve inventory management and the user experience:

- Real-time search by product name (search-as-you-type)
- Price range filtering with minimum and maximum values
- Combined search + filter mode (apply search and price filters together)
- Reset filters option to quickly clear active filters
- Visual feedback when no results are found (empty state message)
- Delete confirmation and feedback (snackbar) with immediate UI update
- Basic error handling for failed operations

## Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (SDK version ^3.9.2)
- [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli)
- A compatible IDE (VS Code or Android Studio)

## Getting Started

1. Clone this repository and navigate to the project directory

2. Install dependencies:
```bash
flutter pub get
```

3. Firebase Setup:
   - Create a new project in the [Firebase Console](https://console.firebase.google.com/)
   - Enable Firestore in test mode
   - Download and add configuration files:
     - For Android: Download `google-services.json` and place it in `android/app/`
     - For iOS: Download `GoogleService-Info.plist` and place it in `ios/Runner/`
   - Run flutterfire configure command to set up Firebase

4. Run the app:
```bash
flutter run
```

## Troubleshooting

If you encounter any issues:

1. Clean the build:
```bash
flutter clean
```

2. Get dependencies again:
```bash
flutter pub get
```

3. Ensure all Firebase configuration files are properly placed

## Dependencies

- firebase_core: ^2.19.0
- cloud_firestore: ^4.12.0
- cupertino_icons: ^1.0.8

## Running the App

1. **Prerequisites**
   - Make sure you have Flutter installed on your machine
   - Ensure you have a Firebase project set up
   - Install all required dependencies:
     ```bash
     flutter pub get
     ```

2. **Running the Application**
   ```bash
   flutter run
   ```
   - Choose your target platform when prompted (web, iOS, Android, or desktop)

3. **Testing the Features**
   - Add products using the floating action button (+)
   - Use the search bar to filter products by name
   - Set min/max price filters to narrow down results
   - Click the delete icon to remove items
   - Look for confirmation messages after operations

## Running the App
1. Make sure you have Flutter installed on your machine and a Firebase project configured.

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

Choose your target platform when prompted (web, iOS, Android, or desktop).
