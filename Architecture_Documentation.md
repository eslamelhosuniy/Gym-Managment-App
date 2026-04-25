# Professional Lightweight Architecture - O2 Gym

This document outlines architecture for the O2 Gym Management System.

To ensure the project remains scalable, maintainable, and highly professional, it follows a **Feature-Driven MVC (Model-View-Controller)** pattern. Instead of grouping all models together and all controllers together globally, files are grouped by the specific feature they belong to.

## 1. Technology Stack

* **Frontend & Logic:** Flutter (Dart)
* **Database Connection:** `mongo_dart` package (Direct connection to MongoDB)
* **Database:** MongoDB (NoSQL)
* **State Management:** `Provider` (Highly recommended for clean controller injection and state updates).

## 2. Feature-Driven MVC Folder Structure (`lib/` directory)

The project is divided into `core/` (app-wide configurations), `features/` (the actual modules of the app), and `shared/` (reusable UI components).

```text
lib/
│
├── core/                       # App-wide configurations and setups
│   ├── config/
│   │   ├── constants.dart      # MongoDB Connection URI, Strings
│   │   └── theme.dart          # Light/Dark mode, Typography
│   ├── database/
│   │   └── db_connection.dart  # Singleton managing the MongoDB connection
│   └── utils/
│       └── formatters.dart     # Date, time, and currency formatters
│
├── features/                   # Application Features (Feature-First approach)
│   │
│   ├── auth/                   # 1. Authentication Feature
│   │   ├── controllers/        # auth_controller.dart (Login logic)
│   │   ├── models/             # admin_model.dart
│   │   └── views/              # login_screen.dart
│   │
│   ├── members/                # 2. Members Feature
│   │   ├── controllers/        # member_controller.dart (CRUD operations)
│   │   ├── models/             # member_model.dart
│   │   ├── views/              # members_screen.dart, add_member_screen.dart
│   │   └── widgets/            # member_card.dart (specific to members feature)
│   │
│   ├── trainers/               # 3. Trainers Feature
│   │   ├── controllers/        # trainer_controller.dart
│   │   ├── models/             # trainer_model.dart
│   │   └── views/              # trainers_screen.dart
│   │
│   ├── plans/                  # 4. Membership Plans Feature
│   │   ├── controllers/        # plan_controller.dart
│   │   └── models/             # plan_model.dart
│   │
│   └── dashboard/              # 5. Dashboard Feature
│       ├── controllers/        # dashboard_controller.dart (Aggregates stats)
│       └── views/              # dashboard_screen.dart
│
├── shared/                     # Reusable UI widgets across multiple features
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_indicator.dart
│
└── main.dart                   # Application entry point & initialization
```

## 3. Layer Responsibilities

* **`models/`**: Dart classes representing MongoDB documents. They must include `fromMap` (to decode BSON from MongoDB) and `toMap` (to encode data before saving). They contain NO business logic.
* **`views/` (Screens)**: Pure Flutter widgets. They are responsible only for building the UI and listening to user interactions. They contain NO database queries.
* **`controllers/`**: The brain of each feature. Controllers request the `Db` instance from `core/database/db_connection.dart`, execute `find()`, `insert()`, or `update()` queries on the specific MongoDB collection, map the results to the `models`, and notify the `views` to rebuild.

## 4. End-to-End Logic Flow Example (Fetching Members)

This structure provides a highly professional, decoupled flow:

1. **App Initialization (`main.dart`)**: The app calls `await DbConnection.connect()` to open the MongoDB connection.
2. **Flutter UI (`features/members/views/members_screen.dart`)**: The user opens the Members page. The View asks the `MemberController` to load data.
3. **Controller Execution (`features/members/controllers/member_controller.dart`)**:
   - The Controller retrieves the database instance from `DbConnection.db`.
   - Executes the query: `db.collection('members').find().toList()`.
4. **Data Conversion**: The `MemberController` maps the raw database maps into Dart `MemberModel` objects: `rawList.map((map) => MemberModel.fromMap(map)).toList()`.
5. **UI Update**: The Controller updates its internal list of members and notifies the View to rebuild (e.g., via `notifyListeners()` if using Provider). The View then displays the data using the `member_card.dart` widget.
