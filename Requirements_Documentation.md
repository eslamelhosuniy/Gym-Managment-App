# System Requirements & Documentation - O2 Gym

## 1. Introduction
This document outlines the requirements and specifications for the O2 Gym Management System, based on the provided Figma prototype analysis.

## 2. Core Modules

### 2.1 Authentication Module
- Secure login for system administrators using an email address and password.

### 2.2 Admin Dashboard
- A centralized overview of gym statistics:
  - Total Members.
  - Active Members.
  - Expired Members.
  - Members Expiring Soon (within 7 days).
  - Today's Attendance count.

### 2.3 Member Management
- **Members List:** A searchable directory with filtering capabilities based on status (All, Active, Expired, Expiring Soon).
- **Member Details:** A comprehensive profile view showing contact information, membership plan type, start and expiry dates, payment status, and total attendance count.
- **Add Member:** A multi-field form for registering new members, selecting their membership plan, and assigning them to a trainer.

### 2.4 Trainer Management
- **Trainers List:** A directory displaying trainers and the number of members assigned to each.
- **Trainer Details:** A view of the trainer's schedule and a list of members assigned to them, along with their membership plans.
- **Reassign Members:** Functionality to transfer or reassign members from one trainer to another.

### 2.5 Attendance Tracking
- **Check-in/Logging:** The ability to record daily attendance manually or by scanning a QR Code.
- **Attendance History:** Detailed logs of member visits, including entry dates and times.

## 3. Pages and Sub-pages

| Page Name | Purpose | Displayed Fields & Data | Available Actions |
| :--- | :--- | :--- | :--- |
| **Login** | Secure Access | Email, Password | Login |
| **Admin Dashboard** | Operations Overview | Member Statistics, Attendance Figures | Navigation to other modules |
| **Members List** | Member Directory | Name, Phone, Status Badge | Search, Filter, Add Member (+) |
| **Member Details** | Profile View | Age, Gender, Plan Type, Dates, Payment Status | View Attendance History |
| **Add Member** | Registration | Name, Phone, Age, Gender, Plan, Trainer | Save Member |
| **Trainers List** | Staff Overview | Name, Phone, Assigned Member Count | View Trainer Details |
| **Trainer Details** | Staff Profile | Schedule, Assigned Member List | Reassign Members |
| **Attendance** | Check-in / Logs | Date, Time, Success Messages | Mark Attendance Manually, Scan QR |
