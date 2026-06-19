# 📚 University Library Management System

A robust, fully normalized relational database blueprint and structural design designed to power a modern University Library Management System. This repository contains the conceptual model, logical schema, and execution-ready SQL scripts with sample data and analytic queries.

---

## 🛠️ Tech Stack & Tools
- **Modeling:** brModelo / Draw.io
- **Database Engine:** MySQL / PostgreSQL compliant SQL
- **Documentation:** Markdown

---

## 📁 Repository Structure
```text
├── database/
│   └── database.sql         # Main SQL script containing Schema, Seeds, and Queries
└── docs/
    ├── models/              # Editable model files (.brM3)
    └── images/              # Model visualizations (PNG/JPG)
```
## 🗺️ Database Models

### 1. Conceptual Model

The conceptual model represents high-level business entities and their cardinalities before physical deployment constraints.

### 2. Logical Model

The logical schema maps entities into normalized tables, mapping foreign keys, unique constraints, and data types properly.

---

## 📑 Database Normalization Documentation

### **1NF (First Normal Form) - Atomicity**

All tables comply with 1NF because all attributes are atomic (indivisible) and single-valued. There are no repeating groups or multi-valued attributes storing lists of data (such as multiple phone numbers or emails within a single cell).

### **2NF (Second Normal Form) - Full Functional Dependency**

The model satisfies 2NF because, in addition to meeting 1NF, no non-key attribute partially depends on a composite primary key. Since most tables utilize a single-column primary key (e.g., `user_id`, `book_id`, `loan_id`), full functional dependency is automatically guaranteed. The only table with a composite primary key is the associative table `written_by` (`author_id` + `book_id`), where the `author_order` attribute exhibits full functional dependency, strictly requiring the combination of both keys to hold meaning.

### **3NF (Third Normal Form) - Transitive Dependency Eliminated**

The model achieves 3NF because it meets 2NF and contains no transitive dependencies (where a non-key attribute depends on another non-key attribute). Every piece of information depends solely and exclusively on its respective primary key.

*Practical Application Example:* Address data was fully normalized into distinct entities (`country`, `state`, `city`). If the state or country name were stored directly inside the `user` or `publisher` tables, it would violate 3NF. The same architectural pattern was applied by isolating `publisher` and `subject_area` from the `book` table.

---

## 🧠 Design Decision: Storing Calculated Fields

The `total_amount` field in the `fine` table was intentionally retained for historical tracking and audit purposes. Although it is a calculated value (`daily_rate` * `days_overdue`), storing it ensures that any future changes to the library's daily fine rates do not retroactively alter the amount of fines already settled or recorded for users.

---

## 🚀 How to Run the Scripts

1. Spin up your preferred SQL database instance (MySQL Workbench, pgAdmin, or terminal console).
2. Create a new schema:
```sql
CREATE DATABASE university_library;
USE university_library;

```


3. Execute the full script located in `database/database.sql` to build the infrastructure, populate seed data, and run verification analytical queries.

---

Developed as part of academic portfólio architecture. 🚀

```
