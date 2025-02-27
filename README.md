# Sports Betting Simulator Flutter App

## Project Overview

This Flutter application is a Sports Betting Simulator designed to demonstrate key mobile development skills, including user authentication and dynamic UI updates for sports betting odds. The application is built using the **Bloc/Cubit architecture**, promoting a clear separation of concerns and incorporating best practices for code quality and testability.

## Features

**1. Authentication Module:**

*   **Login Screen:**
    *   **Manual Login:** Supports username/password login using dummy credentials (`testuser` / `password123`).
    *   **Biometric Login:**  Offers "Login with Biometrics" using the `local_auth` package, leveraging Face ID or Fingerprint authentication based on device capabilities.
*   **Post-Login Navigation:** Upon successful manual or biometric authentication, the user is navigated to the Sports Betting screen.
*   **Error Handling:** Clear error messages are displayed for invalid manual login credentials and biometric authentication failures.

**2. Sports Betting Module:**

*   **Dynamic Sports Betting Screen:** Displays a scrollable list of simulated sports games.
*   **Game List Display:** Each row in the list initially shows only the names of the participating teams (e.g., "Team A vs Team B").
*   **Accordion Expansion for Odds:**
    *   Pressing an arrow-down button on a game row expands the row in an accordion style.
    *   Expanded rows reveal detailed betting odds for:
        *   "1" (Home Win)
        *   "X" (Draw)
        *   "2" (Away Win)
    *   Only one game row can be expanded at a time (previous expansions are collapsed upon expanding a new row).
*   **Automatic Scrolling:** When a game row is expanded, the app automatically scrolls to ensure the detailed odds are fully visible within the viewport.
*   **Live Odds Update Simulation:**
    *   Simulates live odds updates for at least one game (e.g., "Liverpool vs Barcelona").
    *   Odds are randomly updated periodically (e.g., every 10 seconds) using Dart's `Timer.periodic`.
    *   **Visual Indication of Updates:**
        *   **Expanded Game:** Updated odds values "blink" or highlight briefly to visually signal a change.
        *   **Collapsed Game:** A subtle visual indicator (dot, badge, color change) is displayed on the game row to indicate odds have been updated since last expanded view.
*   **Performance Optimization:** Odds updates are implemented to re-render only the affected game element, optimizing performance and preventing full list re-renders.

## Screenshots - iOS

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/abc43a72-d881-4524-80f4-8167a003b2a4" width="200" alt="iOS"></td>
    <td><img src="https://github.com/user-attachments/assets/c25fb32e-0dad-482b-aa3f-a713da820080" width="200" alt="iOS"></td>
    <td><img src="https://github.com/user-attachments/assets/45e28083-dd20-4f2f-a96d-0e52750c002a" width="200" alt="iOS"></td>
  </tr>
</table>
  

## Screenshots - Android

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/367b1635-0691-4e2d-95ce-bf1353fc5f72" width="200" alt="Huawei P8 Lite screenshot 1"></td>
    <td><img src="https://github.com/user-attachments/assets/570a86de-bb68-408a-a7f7-a57e65594662" width="200" alt="Huawei P8 Lite screenshot 2"></td>
    <td><img src="https://github.com/user-attachments/assets/614fda48-5383-4009-b3b0-26367dbb3614" width="200" alt="Huawei P8 Lite screenshot 3"></td>
  </tr>
</table>


## Architecture

*   **Bloc/Cubit Architecture:** The application is structured using the **Bloc/Cubit** architectural pattern for state management.  This architecture effectively separates the application into distinct layers for improved maintainability and testability:
    *   **Models:**  Data classes representing game information, odds, user credentials, etc.
    *   **BLocs/Cubits:** Manage the business logic, application state, and data transformations. They act as intermediaries between the UI and data sources, handling events and emitting state changes. This is analogous to the ViewModel in MVVM in terms of responsibility for presentation logic.
    *   **Views:** Flutter UI widgets responsible for presentation and user interaction. Views react to state changes emitted by BLocs/Cubits and dispatch events based on user interactions.  Views are designed to be passive and primarily focused on UI rendering.
*   **State Management:** Flutter Bloc is used for state management throughout the application, leveraging the reactive streams paradigm for efficient and predictable state updates.

## Code Quality

*   **Clean and Modular Code:** The codebase is written to be clean, well-organized, and modular, promoting maintainability and readability.
*   **Well-Commented Code:**  Code includes comments to explain complex logic and improve understanding.
*   **Documentation:** This README file serves as documentation for architectural decisions, trade-offs, and assumptions.

## Testing

*   **Unit Tests:**  Includes unit tests for critical business logic, specifically:
    *   Authentication flows (manual and biometric login processes).

## APK
*   An APK file for Android installation is available in the `build/app/outputs/apk/flutter-apk/app-release.apk` directory after building [https://github.com/nikakirkitadze/flutter_project_sports_betting_simulator/blob/main/build/app/outputs/flutter-apk/app-release.apk](https://github.com/nikakirkitadze/flutter_project_sports_betting_simulator/blob/main/build/app/outputs/flutter-apk/app-release.apk)

## Assumptions and Trade-offs

*   **Dummy Authentication:**  "Authentication is implemented using dummy credentials and does not interact with a real backend service. In a production application, a secure backend authentication system would be required."
*   **Local Data:** "Game data and odds are simulated and hardcoded or generated locally within the app. In a real-world application, this data would be fetched from a backend API."
*   **Odds Update Simulation:** "Live odds updates are simulated randomly for demonstration purposes. A real application would receive live odds data from a sports data provider via APIs or WebSockets."
*   **State Management Choice:**  "**Bloc/Cubit was chosen for state management** due to its reactive nature, strong separation of concerns, and suitability for managing complex UI state and event-driven logic in Flutter.  It provides a structured approach for managing state changes and business logic."
*   **Accordion Implementation:** "The accordion expansion is implemented using Flutter's built-in animation and widget capabilities. More complex animations or transitions could be added for enhanced UI/UX if required."
*   **Error Handling:** "Basic error handling is implemented for authentication failures and data loading errors. More comprehensive error handling and logging would be necessary for a production-ready application."

## Dependencies

The project uses the following key dependencies as listed in `pubspec.yaml`:

*   `flutter_bloc: ^9.0.0` - For state management.
*   `local_auth: ^2.3.0` - For biometric authentication.
*   `shared_preferences: ^2.5.2` - For local data persistence (e.g., for settings, if implemented).
*   `equatable: ^2.0.7` - For value-based equality in Dart classes.
*   `mocktail: ^1.0.4` & `bloc_test: ^10.0.0` - For testing (mocks and Bloc testing utilities).
