# 📱 FCM & Riverpod Task Manager 

**Internship Task 2** A production-ready Flutter application demonstrating the integration of **Firebase Cloud Messaging (FCM)** for push notifications and **Riverpod** for robust, compile-safe state management.

---

## 📖 Overview
This project was developed as part of an internship module focusing on modern Flutter architecture and native Android integration. The application serves as a dynamic Task Manager that not only handles internal UI state seamlessly via Riverpod but also responds to external system-level events via Firebase Cloud Messaging. 

Special attention was given to native Android configurations, including custom app branding, background isolate execution, and high-priority notification handling.

## ✨ Core Features
* **Reactive State Management:** Utilizes Riverpod (`StateNotifier`) to manage the task list, ensuring the UI updates instantly and efficiently without unnecessary widget rebuilds.
* **Foreground Push Notifications:** Intercepts active FCM payloads while the app is open and passes the data directly into the Flutter UI seamlessly.
* **Background & Terminated Notifications:** Implements native Android background isolates to receive FCM messages even when the app is minimized, triggering Android's native Heads-Up display banner.
* **Dynamic Device Targeting:** Automatically generates and retrieves the unique FCM Device Token required for targeted server-to-device messaging.
* **Custom Native Branding:** Fully customized native Android wrapper, including a custom Application Name and a generated set of mipmap launcher icons using `flutter_launcher_icons`.

## 🛠️ Tech Stack
* **Framework:** Flutter / Dart
* **State Management:** `flutter_riverpod` (^3.3.1)
* **Backend Services:** `firebase_core`, `firebase_messaging`
* **Dev Tools:** `flutter_launcher_icons`

---

## 🏗️ Project Architecture

### 1. State Management (Riverpod)
The application relies on Riverpod to decouple the business logic from the UI. 
* A `TaskProvider` manages the lifecycle of the task list.
* The UI widgets use `ConsumerWidget` to listen to state changes, allowing tasks to be added, toggled, or deleted reactively.

### 2. Push Notification Service (FCM)
A dedicated `FCMService` class was constructed to handle the complex lifecycle of Firebase messages:
* Requests explicit notification permissions on Android 13+.
* Initializes the Firebase messaging environment.
* Listens to `FirebaseMessaging.onMessage` for foreground data.
* Listens to `FirebaseMessaging.onBackgroundMessage` via a top-level Dart function to handle terminated states.

### 3. Native Android Configuration
Several modifications were made directly to the native Android codebase (`build.gradle`, `AndroidManifest.xml`) to support production features:
* Elevated Android Message Priority to "High" to ensure pop-up banner delivery.
* Configured native application ID and labels.

---

## 🚀 Setup & Installation

**Prerequisites:**
* Flutter SDK installed.
* A valid `google-services.json` file from your Firebase Console.

**1. Clone the repository**

git clone https://github.com/talhakhan363/flutter_fcm_riverpod
cd flutter_fcm_riverpod

**2. Install dependencies**
flutter pub get

**3. Add Firebase Credentials**
Place your Firebase google-services.json file into the following directory:
android/app/google-services.json

**4. Run the App**
(Note: FCM testing requires a physical device. Emulators may not reliably receive background push notifications).
flutter run

## 🧪 Testing Push Notifications
To test the FCM integration:
Launch the app on a physical device.
Check the debug console for the printed FCM Device Token and copy it.
Minimize the app to the background.
Navigate to the Firebase Web Console > Messaging.
Create a new campaign, set priority to High, and send a test message using the copied Device Token.

## 🔮 Future Scope
Persistent Storage: Integrate shared_preferences or sqflite within the Riverpod Notifier to save the task state locally across app restarts.
Interactive Notifications: Add quick-action buttons to the FCM payload to allow users to mark a task as complete directly from the Android notification tray.

## 👨‍💻 Author

Muhammad Talha Khan
Software Engineering Undergraduate, UBIT Class of 2026
Flutter Developer | Project Management Memeber (MLSA/GDSC)
GitHub: @talhakhan363
LinkedIn: https://www.linkedin.com/in/muhammad-talha-khan-298941212