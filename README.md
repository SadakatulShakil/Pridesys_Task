# Rick and Morty Character Explorer (Flutter)

A production-ready Flutter application that consumes the 
**Rick and Morty API** and implements a robust **Offline-First** architecture using **Clean Architecture**, **GetX**, and **SQLite**.

## Features

* **Paginated Character List**: Infinite scroll implementation to browse the multiverse.
* **Detailed View**: Comprehensive character bios including origin and location data.
* **Favorites System**: Add or remove characters from a persistent local collection.
* **Local Editing (Key Requirement)**: Ability to override API data with local edits that persist after app restarts.
* **Offline Support**: Full access to previously loaded characters and user edits without an internet connection.
* **Vibrant Cartoon UI**: Modern, kid-friendly design with Hero animations and high-contrast elements.

---

## Tech Stack

| Feature | Choice | Reasoning |
| :--- | :--- | :--- |
| **State Management** | **GetX** | [cite_start]Chosen for its high-performance reactive state, integrated Dependency Injection (DI), and clean route management. |
| **Local Storage** | **SQLite (sqflite)** | [cite_start]Selected over Hive or SharedPreferences to handle complex relational data (Cache vs. Overrides vs. Favorites) using SQL queries. |
| **Networking** | **HTTP** | [cite_start]Standardized, lightweight client used to consume the read-only Rick and Morty API. |
| **Architecture** | **Clean Architecture** | [cite_start]Strict separation into Data, Domain, and Presentation layers to ensure scalability and testability. |

---

## Storage & Merge Strategy

The app implements a **Runtime Merge Logic** to satisfy the requirement that local edits must override API data.

### The Three-Table System:
1.  **`characters`**: A cache table storing raw API responses for offline support.
2.  **`favorites`**: Stores IDs of characters marked as favorites by the user.
3.  **`overrides`**: Stores locally edited fields (Name, Status, etc.).

### The Merge Process:
When the Repository fetches data, it performs a join-like operation in Dart:
* It checks if a character ID exists in the `overrides` table.
* If an override exists, the local values are prioritized over the API values.
* The `isFavorite` status is toggled based on the `favorites` table.
* The final `CharacterEntity` is marked with an `isEdited` flag for UI transparency.

---

## Setup Instructions

1.  **Clone the Repository**:
    ```bash
    git clone <repository-url>
    ```
2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Generate Code (if applicable)**:
    ```bash
    flutter pub run build_runner build
    ```
4.  **Run the App**:
    ```bash
    flutter run
    ```

---

## Known Limitations
* **Read-Only API**: Per requirements, no data is sent back to the Rick and Morty API (POST/PUT/PATCH are not supported by the endpoint).
* **Image Caching**: While data is cached in SQLite, image persistence depends on the `cached_network_image` disk cache.

---

## Walkthrough
A short video explaining the architecture and demonstrating the offline editing features can be found here: **[Link to YouTube Video]**.
