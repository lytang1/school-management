# 🏫 School Management System (Flutter + SQLite)

A lightweight and fully offline School Management System built with Flutter and SQLite. This project helps manage students, classes, expenses, liabilities, invoices, and financial reports — ideal for small institutions.

---

## 🚀 Features

- **Authentication**
    - Login with username and password (stored in SQLite)

- **Dashboard**
    - Overview cards and visual graphs for:
        - Total students
        - Total classes
        - Total expenses

- **Class Management**
    - List, create, update, delete classes
    - Each class includes: `studyYear`, `className`, `fee`

- **Student Management**
    - Add, edit, view, delete students
    - Students include: `name`, `dob`, `gender`, `class`

- **Expense Management**
    - Track daily/monthly expenses
    - Fields: `amount`, `description`, `createdAt`

- **Liability Management**
    - Track liabilities or loans
    - Fields: `name`, `value`, `createdAt`

- **Invoice Management**
    - Generate dynamic invoices for students
    - Each invoice includes dynamic items: `class_fee`, `books`, `uniform`

- **Reports**
    - Visual reports using charts:
        - Cash Flow
        - Expense Report
        - Balance Sheet
        - Income Statement

---

## 📱 Screenshots

> _Add screenshots here to show UI preview (login, dashboard, reports, etc.)_

---

## 🧰 Tech Stack

- **Flutter** (default stable version)
- **Material UI** (clean and simple)
- **SQLite** (offline local storage)
- **sqflite** + **path_provider** for DB
- **provider** for state management (if extended)
- **charts_flutter** or **fl_chart** for graphs

---

## 📦 Installation

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/school-management-system.git
   cd school-management-system
