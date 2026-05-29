# Project Blueprint

## Overview

This document outlines the architecture, design, and features of the Steam CRUD application. The app allows users to manage a list of games, with functionalities for creating, reading, updating, and deleting game entries. The application is built with Flutter and leverages Firebase for authentication and database services.

## Style and Design

### Theme

- The app uses Material 3 design principles.
- A two-way theme has been implemented that supports both light and dark modes.
- The primary color is `Colors.deepPurple`.
- Custom typography is applied using the `google_fonts` package, with 'Oswald' for display and title fonts, and 'Roboto' for body text.

### Components

- **AppBar:** Styled with the primary color and custom font.
- **ElevatedButton:** Custom styling for a consistent look and feel.
- **Card:** Used to display game information with a subtle shadow and rounded corners.
- **TextFormField:** Styled for a clean and modern look.

## Features

### Authentication

- Users can sign in with their Google account using Firebase Authentication.
- The app's navigation is protected, redirecting unauthenticated users to the login screen.

### Game CRUD

- **Create:** Users can add new games to the list.
- **Read:** The app displays a list of games from the Firestore database.
- **Update:** Users can edit the details of existing games.
- **Delete:** Users can remove games from the list.

### State Management

- The app uses the `provider` package for state management.
- `AuthService` manages user authentication.
- `GameProvider` manages the state of the game list.
- `ThemeProvider` manages the app's theme.

### Navigation

- The app uses the `go_router` package for declarative routing.
- The router is configured to handle authentication state changes, redirecting users as needed.

## Current Plan: Add Developers and Publishers

**Objective:** Expand the data model to include Developers and Publishers, creating a more relational data structure.

**Steps:**

1.  **Create Data Models:**
    *   `lib/models/developer.dart`: Define the `Developer` class with fields `id`, `name`, `imageUrl`, and `gameIds`.
    *   `lib/models/publisher.dart`: Define the `Publisher` class with fields `id`, `name`, `imageUrl`, and `gameIds`.

2.  **Update Game Model:**
    *   Modify `lib/models/game.dart` to include `developerId` and `publisherId` fields to link to the new collections.

3.  **Update Firestore Security Rules:**
    *   Add rules in `firestore.rules` for the new `developers` and `publishers` collections, allowing authenticated users to read and admins to write.

4.  **Extend DatabaseService:**
    *   Add CRUD (Create, Read, Update, Delete) methods for both `Developer` and `Publisher` entities in `lib/data/services/database_service.dart`.

5.  **Enhance User Interface:**
    *   **Game Detail Screen:** Display the name of the developer and publisher.
    *   **Admin/CRUD Screens:** Create new screens to manage developers and publishers (view list, add, edit, delete).
    *   **Game Form:** Modify the add/edit game form to use dropdown menus (`DropdownButtonFormField`) to select an existing developer and publisher, instead of free-text input.
