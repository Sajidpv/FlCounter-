# Multi-Counter App

## 📌 Overview
The **Multi-Counter App** is a highly customizable counter management application that allows users to create and manage multiple counters. It features seamless interactions using **Quick Actions**, **Home Screen Widgets**, and **BLoC for state management** to ensure a smooth user experience.

## 🚀 Features
### 🔹 Counter Management
- Create, increment, decrement, jump to, and reset counters.
- Persistent storage using **Hive** for local database management.

### 🔹 Quick Actions
- Access counters instantly from the home screen without opening the app.

### 🔹 Home Screen Widgets
- View and control counters directly from the home screen for faster interactions.

### 🔹 Gesture Customization
- Configurable tap areas using **GestureDetector**:
  - **Fullscreen Tap**: Tap anywhere to interact with the counter.
  - **Custom Tap Area**: Define specific areas for counter actions.

### 🔹 State Management
- Implemented using **BLoC** for efficient and scalable state handling.

## 🛠️ Tech Stack
- **Flutter**: Cross-platform UI framework
- **BLoC**: State management
- **Hive & Hive Flutter**: Local storage
- **Quick Actions**: For home screen shortcuts
- **Home Widget**: To add home screen widgets
- **GestureDetector**: Customizable tap interactions
- **Shared Preferences**: Lightweight key-value storage for Home widget.

## 📸 Screenshots
*(Attach relevant app screenshots here)*

## 📦 Installation
### Prerequisites
- Install **Flutter**: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Install dependencies:
  ```sh
  flutter pub get
  ```

### Run the App
```sh
flutter run
```

## 🏗️ Project Structure
```
lib/
│── main.dart                  # Entry point of the app
│── app.dart/                  # Contain material app and quick action configs
│── bloc_observers.dart/       # BLoC Observer configs
│── configs/                   # String constants for hive boxes
│── models/                    # Data models
│── repository/                # DB repositories
│── routes/                    # Named routes and route configuration 
│── services/                  # Hive and Home Widget services
│── utils/                     # Service handlers
│── view/                      # UI Screens and widgets
│── viewmodel/                 # BLoC statemanagemnets
```

## 🤝 Contributing
Feel free to fork this repository, create new features, and submit a PR! Contributions are always welcome. 😊

## 📜 License
This project is licensed under the MIT License.

## 📬 Contact
For any questions or collaborations, feel free to reach out!

#Flutter #BLoC #QuickActions #HomeScreenWidgets #HiveDB #GestureDetector #StateManagement
