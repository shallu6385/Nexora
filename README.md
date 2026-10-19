# Nexora – Student Companion App

Nexora is a Flutter-based student companion application designed to help college students manage their academic activities in one place. It aims to simplify student life by bringing essential academic tools together in a single mobile application.

## Features

* **User Authentication** – Sign up and log in using Firebase Authentication.
* **Google Sign-In** – Sign in using a Google account.
* **Student Profile** – View and manage student information.
* **Attendance Management** – Track attendance records.
* **Timetable** – Access class schedules.
* **Assignment Management** – Organize assignments and deadlines.
* **Notes** – Manage study notes.
* **GPA Calculator** – Calculate semester GPA.
* **CGPA Calculator** – Calculate cumulative GPA.
* **Notifications** – Access application notifications.
* **Saved Items** – Keep useful academic information accessible.
* **Settings** – Manage application preferences.

*Note: Feature availability depends on the current implementation. Update this list as each feature becomes fully functional.*

## Technologies Used

| Technology              | Purpose                                    |
| ----------------------- | ------------------------------------------ |
| Flutter                 | User interface and application development |
| Dart                    | Application programming language           |
| Firebase Authentication | User authentication                        |
| Cloud Firestore         | Cloud database integration                 |
| Android Studio          | Development environment                    |
| Git and GitHub          | Version control and source code hosting    |

## Project Structure

```text
nexora/
├── android/
├── lib/
│   ├── features/
│   │   ├── data/
│   │   └── presentation/
│   ├── app.dart
│   ├── firebase_options.dart
│   └── main.dart
├── test/
├── web/
├── windows/
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

## Getting Started

### Prerequisites

Install the following tools:

* Flutter SDK
* Dart SDK (included with Flutter)
* Android Studio
* Git
* An Android device or emulator

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/nexora.git
```

Replace `YOUR_USERNAME` with the GitHub account that owns this repository.

**2. Open the project directory**

```bash
cd nexora
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Configure Firebase**

Configure your own Firebase project and enable the authentication providers required by the application.

Follow the official FlutterFire setup instructions to configure Firebase for your development environment.

**5. Run the application**

```bash
flutter run
```

## Screenshots

Application screenshots will be added here as the interface and features are finalized.
## 📸 Screenshots

### 🔐 Login Screen

![Nexora Login Screen](screenshots/login.png)

### 🏠 Dashboard

![Nexora Dashboard](screenshots/dashboard.png)


## Future Enhancements

* Improve academic progress tracking.
* Enhance the student dashboard.
* Add more personalized academic tools.
* Improve notifications and usability.
* Expand academic data management.

## Project Status

Under development.

## Author

**Shalini M.**

B.Tech Information Technology Student

GitHub: [shallu6385](https://github.com/shallu6385)

---

This project is developed as a student application project using Flutter and Firebase.
