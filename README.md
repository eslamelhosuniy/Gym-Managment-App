# O2 Gym Management System

## Overview
O2 Gym Management System is a comprehensive mobile application designed to streamline the operations of a modern fitness facility. It provides tools for managing members, trainers, subscription plans, and administrative tasks within a unified interface.

## Architecture
This project implements a Feature-Driven Model-View-Controller (MVC) architecture. This approach ensures high maintainability and scalability by grouping related files (controllers, models, views) by feature rather than globally by file type.

## Technology Stack
* Frontend: Flutter (Dart)
* State Management: Provider
* Database Connection: mongo_dart
* Database: MongoDB

## Project Structure
The application code is organized into three primary directories under `lib/`:
* `core/`: Contains application-wide configurations, database connections, and utility functions.
* `features/`: Contains the core functional modules of the application (e.g., authentication, members, trainers).
* `shared/`: Contains reusable UI components and widgets utilized across multiple features.

## Getting Started
1. Ensure Flutter SDK is installed and configured on your local machine.
2. Clone the repository.
3. Run `flutter pub get` to install project dependencies.
4. Configure the MongoDB connection string in `lib/core/config/constants.dart`.
5. Run the application using `flutter run`.
