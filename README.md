# NutriDiet - Mobile 📱🥗

**NutriDiet** is a mobile application developed with **Flutter**, integrated with **Android Health Connect**, and powered by **Gemini AI** to suggest personalized meal plans based on health profiles, preferences, allergies, and personal goals. This app is part of the NutriDiet ecosystem, which also includes a robust web platform and backend database system.

---

## 🚀 Key Features

- 🔎 **Search & Manage Foods**: Filter foods by ingredients, medical conditions, or allergies.
- 🧠 **Smart Meal Suggestions**: AI-powered meal recommendations tailored to user health profiles and goals.
- 🚫 **Reject Meal Suggestions**: Users can reject AI-suggested meals and provide reasons to improve AI training.
- 👣 **Step Counter Integration**: Tracks daily steps using Pedometer or Android Health Connect.
- 🔥 **Calories & Health Tracking**: Automatically logs calorie consumption and physical activity.
- 🔔 **Reminders & Notifications**: Meal time alerts and nutritional deficiency warnings.
- 🌐 **Data Sync & Backup**: Synchronizes data with the server to ensure data integrity and backup.

---

## 🏗️ Core Architecture

- **Flutter**: Cross-platform UI development.
- **Provider / Riverpod**: State management (configurable per project).
- **Health Connect SDK**: Integration with Android health data.
- **Pedometer Plugin**: Real-time step tracking.
- **RESTful API**: Backend communication (ASP.NET Web API).
- **SQLServer / SharedPreferences**: For temporary or local data storage.

---

## 📲 Installation Guide

### 1. System Requirements

- Flutter >= 3.10
- Dart >= 3.0
- Android SDK >= 30
- Health Connect installed on the device

### 2. Project Setup

```bash
git clone https://github.com/TungSke/NutriDiet-Mobile.git
cd nutridiet-mobile
flutter pub get
````

### 3. Run the App

```bash
flutter run
```

> 💡 Make sure you have granted Health Connect permissions and enabled motion sensors.

---

## 🔐 Permissions Required

The application requires the following permissions:

* `ACTIVITY_RECOGNITION`: To track step count.
* `BODY_SENSORS`: To access health-related sensors.
* `INTERNET`: To communicate with the AI server.
* `READ_HEALTH_DATA`, `WRITE_HEALTH_DATA`: For interacting with Health Connect.

---

## 📁 Project Structure

```plaintext
lib/
├── main.dart
├── models/           # Data models
├── services/         # Health, AI, API, Local DB services
├── screens/          # UI screens
├── components/       # Reusable widgets
├── app_state.dart/   # State management
```

---

## 🤖 AI-Powered Meal Suggestions

The app sends health profiles and user preferences to **Gemini AI**, which returns personalized meal plans. User feedback is also collected to improve future recommendations.

---

## 📜 License

NutriDiet - Mobile is released under the [MIT License](LICENSE).

---

> Let's build a smart and comprehensive personal health ecosystem together!
