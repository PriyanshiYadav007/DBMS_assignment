# Key Components of a Database Schema
## DBMS Assignment - Complete Notes with Examples

---

## 1. Tables

### Definition
Tables are the fundamental building blocks of a database. They represent **entities** or objects in the real world and are used to organize and store data.

### Characteristics
- Defined with **columns (fields)** and **rows (records)**
- Each table has a unique name
- Represents a single entity type (e.g., Students, Courses, Professors)

### Example
```sql
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    phone VARCHAR(15)
);
```

### Sample Data (Indian Names)
| student_id | first_name | last_name | email | date_of_birth |
|------------|------------|-----------|-------|---------------|
| 1 | Aarav | Sharma | aarav.sharma@email.com | 2002-05-15 |
| 2 | Priya | Patel | priya.patel@email.com | 2003-08-22 |
| 3 | Arjun | Singh | arjun.singh@email.com | 2002-12-10 |
| 4 | Ananya | Reddy | ananya.reddy@email.com | 2003-03-18 |

---

## 2. Fields (Columns)

### Definition
Fields (also called **columns**) specify the type of data stored in a table. Each field has a **name** and a **data type**.

### Common Data Types
| Data Type | Description | Example |
|-----------|-------------|---------|
| **INT / INTEGER** | Whole numbers | student_id, age, credits |
| **VARCHAR(n)** | Variable-length text up to n characters | name, email, address |
| **CHAR(n)** | Fixed-length text of exactly n characters | gender ('M'/'F'), country_code |
| **DATE** | Date values (YYYY-MM-DD) | date_of_birth, enrollment_date |
| **DECIMAL(p,s)** | Decimal numbers with precision | salary, price |
| **BOOLEAN** | True/False values | is_active, is_enrolled |

### Example
```sql
CREATE TABLE Courses (
    course_id INT,              -- INTEGER data type
    course_name VARCHAR(100),   -- VARCHAR data type
    course_code VARCHAR(10),    -- VARCHAR data type
    credits INT,                -- INTEGER data type
    start_date DATE             -- DATE data type
);
```

---

## 3. Relationships

### Definition
Relationships define how tables are **connected** to each other using **keys**. This enables data to be linked across multiple tables.

### Types of Keys

#### Primary Key
- A **unique identifier** for each record in a table
- Cannot contain NULL values
- Each table should have one primary key

```sql
CREATE TABLE Students (
    student_id INT PRIMARY KEY,  -- Primary Key
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);
```

#### Foreign Key
- A **reference** to a primary key in another table
- Establishes a link between two tables
- Ensures referential integrity

```sql
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,              -- Foreign Key
    course_id INT,               -- Foreign Key
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```

### Relationship Types
| Type | Description | Example |
|------|-------------|---------|
| **One-to-One** | One record relates to one record | Student ↔ StudentProfile |
| **One-to-Many** | One record relates to many records | Professor → Courses |
| **Many-to-Many** | Many records relate to many records | Students ↔ Courses (via Enrollments) |

### Example Diagram
```
Students (1) -------- (Many) Enrollments (Many) -------- (1) Courses
    ↑                            ↑                           ↑
 student_id                  student_id                  course_id
 (Primary Key)               (Foreign Key)            (Foreign Key)
```

---

## 4. Constraints

### Definition
Constraints are **rules** that ensure data integrity and accuracy in the database. They restrict the type of data that can be inserted into a table.

### Types of Constraints

#### NOT NULL
Ensures a column **cannot have NULL values**.

```sql
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,  -- Cannot be empty
    last_name VARCHAR(50) NOT NULL    -- Cannot be empty
);
```

#### UNIQUE
Ensures all values in a column are **different** (no duplicates).

```sql
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE  -- No duplicate emails allowed
);
```

#### CHECK
Ensures a column value **satisfies a specific condition**.

```sql
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    credits INT CHECK (credits > 0 AND credits <= 6)  -- Must be between 1 and 6
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O'))  -- Must be M, F, or O
);
```

#### DEFAULT
Assigns a **default value** to a column if no value is provided.

```sql
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    enrollment_date DATE DEFAULT CURRENT_DATE,  -- Defaults to today's date
    department VARCHAR(50) DEFAULT 'General'    -- Defaults to 'General'
);
```

### Constraints Summary Table
| Constraint | Purpose | Example |
|------------|---------|---------|
| **NOT NULL** | Prevents empty values | first_name NOT NULL |
| **UNIQUE** | Prevents duplicate values | email UNIQUE |
| **CHECK** | Validates data against condition | credits CHECK (credits > 0) |
| **DEFAULT** | Sets automatic value if none provided | status DEFAULT 'Active' |
| **PRIMARY KEY** | Unique identifier + NOT NULL + UNIQUE | student_id PRIMARY KEY |
| **FOREIGN KEY** | Links to another table's primary key | REFERENCES Students(student_id) |

---

## 5. Views

### Definition
Views are **virtual tables** created by querying data from one or more tables. They don't store data themselves but display data from underlying tables.

### Benefits
- Simplify complex queries
- Provide security by restricting access to specific data
- Present data in different formats without changing the base tables

### Syntax
```sql
CREATE VIEW view_name AS
SELECT columns
FROM tables
WHERE conditions;
```

### Examples

#### View 1: Student Enrollment Details
```sql
CREATE VIEW Student_Course_Details AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email AS student_email,
    c.course_name,
    c.course_code,
    e.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;
```

**Usage:**
```sql
SELECT * FROM Student_Course_Details;
```

**Result:**
| student_id | student_name | student_email | course_name | course_code | grade |
|------------|--------------|---------------|-------------|-------------|-------|
| 1 | Aarav Sharma | aarav.sharma@email.com | Database Management Systems | DBMS101 | A |
| 2 | Priya Patel | priya.patel@email.com | Operating Systems | OS103 | A |

#### View 2: Course Statistics
```sql
CREATE VIEW Course_Statistics AS
SELECT 
    c.course_name,
    COUNT(e.student_id) AS total_students,
    c.credits
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.credits;
```

---

## 6. Indexes

### Definition
Indexes are database objects that **improve query performance** by enabling faster search and retrieval of data. They work similar to the index in a book.

### Benefits
- Faster SELECT queries
- Improved search performance
- Efficient sorting and filtering

### Trade-offs
- Slower INSERT, UPDATE, DELETE operations
- Additional storage space required

### Syntax
```sql
CREATE INDEX index_name ON table_name(column_name);
```

### Examples

#### Simple Index
```sql
-- Index on email for faster lookups
CREATE INDEX idx_student_email ON Students(email);
```

#### Composite Index (Multiple Columns)
```sql
-- Index on both last_name and first_name
CREATE INDEX idx_student_name ON Students(last_name, first_name);
```

#### Index for Frequent Searches
```sql
-- Index on course code for faster course searches
CREATE INDEX idx_course_code ON Courses(course_code);

-- Index on enrollment date for date-based queries
CREATE INDEX idx_enrollment_date ON Enrollments(enrollment_date);
```

### When to Use Indexes
| Use Case | Recommendation |
|----------|----------------|
| Columns in WHERE clause | ✅ Create index |
| Columns used for JOIN | ✅ Create index |
| Columns used for ORDER BY | ✅ Consider index |
| Small tables | ❌ Not necessary |
| Frequently updated columns | ❌ Avoid (slows updates) |

---

## Complete Database Schema Diagram

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│    Students     │       │   Enrollments   │       │    Courses      │
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ student_id (PK) │──┐    │ enrollment_id(PK│       │ course_id (PK)  │
│ first_name      │  │    │ student_id (FK) │───┐   │ course_name     │
│ last_name       │  └───►│ course_id (FK)  │◄──┼───│ course_code     │
│ email           │       │ enrollment_date │   │   │ credits         │
│ date_of_birth   │       │ grade           │   │   │ department      │
│ gender          │       └─────────────────┘   │   └─────────────────┘
│ phone           │                             │
└─────────────────┘                             │
                                                │
┌─────────────────┐       ┌─────────────────┐   │
│   Professors    │       │Course_Professors│   │
├─────────────────┤       ├─────────────────┤   │
│professor_id (PK)│──┐    │ course_id (FK)  │◄──┘
│ first_name      │  │    │professor_id(FK) │
│ last_name       │  └───►│ semester        │
│ email           │       │ academic_year   │
│ department      │       └─────────────────┘
│ hire_date       │
└─────────────────┘

Legend: PK = Primary Key, FK = Foreign Key
```

---

## Sample Indian Names Used in This Assignment

### Students
| Name | Email |
|------|-------|
| Aarav Sharma | aarav.sharma@email.com |
| Priya Patel | priya.patel@email.com |
| Arjun Singh | arjun.singh@email.com |
| Ananya Reddy | ananya.reddy@email.com |
| Vivaan Kumar | vivaan.kumar@email.com |
| Ishita Gupta | ishita.gupta@email.com |
| Aditya Nair | aditya.nair@email.com |
| Diya Verma | diya.verma@email.com |

### Professors
| Name | Department |
|------|------------|
| Dr. Rajesh Krishnamurthy | Computer Science |
| Dr. Sunita Iyer | Computer Science |
| Dr. Venkatesh Rao | Computer Science |
| Dr. Meera Deshmukh | Computer Science |

---

## Summary

| Component | Purpose | Key Points |
|-----------|---------|------------|
| **Tables** | Store data as entities | Rows and columns structure |
| **Fields** | Define data types | INT, VARCHAR, DATE, etc. |
| **Relationships** | Connect tables | Primary Key & Foreign Key |
| **Constraints** | Ensure data integrity | NOT NULL, UNIQUE, CHECK, DEFAULT |
| **Views** | Virtual tables from queries | Simplify complex queries |
| **Indexes** | Faster data retrieval | Improve query performance |

---

*Assignment completed with Indian names as required.*
