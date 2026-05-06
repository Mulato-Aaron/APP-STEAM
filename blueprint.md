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
