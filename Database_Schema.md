# Proposed Database Schema - O2 Gym

## Tables & Attributes

### 1. Admins Table
Stores credentials for system administrators who can log into the dashboard.
| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `id` | INT (PK) | Unique Identifier |
| `email` | VARCHAR(255) | Email address (for login) |
| `password_hash` | VARCHAR(255) | Encrypted password |
| `full_name` | VARCHAR(100) | Full name of the admin |
| `last_login` | DATETIME | Date and time of the last login |
| `created_at` | DATETIME | Account creation timestamp |

### 2. Members Table
Stores the profiles of gym members.
| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `id` | INT (PK) | Unique Identifier |
| `full_name` | VARCHAR(100) | Full Name |
| `phone_number` | VARCHAR(20) | Contact phone number |
| `age` | INT | Age of the member |
| `gender` | ENUM('Male', 'Female', 'Other') | Gender |
| `status` | ENUM('Active', 'Expired') | Current membership status |
| `joined_at` | DATETIME | Date and time of registration |
| `qr_code_id` | VARCHAR(255) | QR Code ID for attendance scanning |

### 3. Trainers Table
Stores information about the training staff and their schedules.
| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `id` | INT (PK) | Unique Identifier |
| `full_name` | VARCHAR(100) | Full Name |
| `phone_number` | VARCHAR(20) | Contact phone number |
| `schedule_json` | JSON / TEXT | Trainer's working days and hours |
| `bio` | TEXT | Short biography or specialties |
| `created_at` | DATETIME | Record creation timestamp |

### 4. Plans Table
Stores the available membership packages.
| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `id` | INT (PK) | Unique Identifier |
| `plan_name` | VARCHAR(100) | Plan Name (e.g., Monthly, Quarterly, Yearly) |
| `duration_days` | INT | Duration in days (e.g., 30 for monthly) |
| `price` | DECIMAL(10, 2) | Price of the membership plan |

### 5. Memberships Table
Links members to their chosen plans and assigned trainers, logging the actual subscription.
| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `id` | INT (PK) | Unique Identifier |
| `member_id` | INT (FK) | Reference to Members table |
| `plan_id` | INT (FK) | Reference to Plans table |
| `assigned_trainer_id` | INT (FK) | Reference to Trainers table (Nullable) |
| `start_date` | DATE | Subscription start date |
| `expiry_date` | DATE | Subscription expiration date |
| `payment_status` | ENUM('Paid', 'Pending') | Payment status of the subscription |
| `created_at` | DATETIME | Record creation timestamp |

### 6. Attendance Table
Tracks check-in and check-out logs for members.
| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `id` | INT (PK) | Unique Identifier |
| `member_id` | INT (FK) | Reference to Members table |
| `check_in_time` | DATETIME | Date and time of check-in |
| `check_out_time` | DATETIME | Date and time of check-out (Nullable) |
| `method` | ENUM('Manual', 'QR') | Method of attendance tracking |
