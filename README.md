# 📡 Flutter vMix Remote Controller

A simplified version of **River Stream Control**. An application that connects to a **vMix instance** and provides a simple remote control interface.  
It serves as an example of how to structure a Flutter app using:

- **Feature-based architecture**
- **Riverpod for state management**
- **Streams for live updates**
- **Clean and minimal folder organization**

This simplified version contains **no proprietary logic**, making it ideal as a reference architecture or a starting point.

---

## 🚀 Features

### ✔ Connect to a vMix instance

- Enter IP and port
- Basic validation
- Connection preview screen

### ✔ Live vMix status updates

via Riverpod **StreamProviders**

### ✔ Lightweight control panel

- Switcher buttons
- Program/Preview switching
- Simple input list
- Basic stream actions

### ✔ Clean architecture

- `features/` organized by domain
- `common/` folder for shared constants, utilities, and simple validation
- Widgets are small, self-contained, and reusable
- Easy to extend with additional vMix controls

---

## 📁 Project Structure

lib/
├── main.dart
├── common/
│ ├── constants.dart # shared constants + enums
│ ├── validation.dart # small top-level validators
│
└── features/
├── home/ # startup + connection screens
├── panel/ # remote controller UI
└── vmix/ (optional) # recommended extension: API/service logic

**Why this structure?**  
It keeps the app simple, modular, and easy for contributors to understand.

---

## 🧩 Technologies Used

- Flutter 3.x+
- Riverpod (for state + stream management)
- Material 3
- vMix API (HTTP/XML + WebSocket — simplified

---

## 🧱 Architecture Overview

The app follows a unidirectional data flow:

vMix API → StreamService → Riverpod StreamProvider → UI Widgets
↑
Actions (CUT, FADE, inputs, etc)

- Home feature handles connection setup
- Panel feature displays live vMix updates
- StreamProviders deliver real-time updates to widgets
- Widgets trigger actions through Riverpod providers

---

## This project is ideal for:

- Learning how to structure Riverpod + Streams in Flutter
- Building your own vMix remote controller
- Understanding a clean, feature-based architecture
- Using as a boilerplate for real-time apps
- Demonstrating Flutter UI patterns with live data

## 📄 License

MIT License — feel free to use it for learning or as a base for your own project.
