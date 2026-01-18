# Components of Database Schema
## Hospital Management System - DBMS Assignment

---

## 1. Tables

### Definition
Tables are the fundamental building blocks of a database that store data in rows and columns format.

### Hospital Management Tables
| Table | Description | Records |
|-------|-------------|---------|
| **Patients** | Patient demographics, contact, insurance info | 50 |
| **Doctors** | Doctor profiles with specialization | 10 |
| **Appointments** | Scheduling between patients and doctors | 200 |
| **Treatments** | Medical procedures and costs | 200 |
| **Billing** | Payment records and status | 200 |

### Example: Patients Table
```sql
CREATE TABLE Patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1),
    date_of_birth DATE NOT NULL,
    contact_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL
);
```

### Data 
| patient_id | first_name | last_name | gender | contact_number |
|------------|------------|-----------|--------|----------------|
| P001 | Aarav | Sharma | M | 9839585183 |
| P002 | Priya | Patel | F | 8228188767 |
| P003 | Arjun | Singh | M | 8397029847 |
| P004 | Ananya | Reddy | F | 9019443432 |

---

## 2. Fields (Columns)

### Data Types Used
| Data Type | Description | Example Fields |
|-----------|-------------|----------------|
| **VARCHAR(n)** | Variable-length text | first_name, email, address |
| **CHAR(n)** | Fixed-length text | gender |
| **INT** | Whole numbers | years_experience |
| **DATE** | Date values | date_of_birth, appointment_date |
| **TIME** | Time values | appointment_time |
| **DECIMAL(p,s)** | Decimal numbers | cost, amount |

### Example
```sql
CREATE TABLE Doctors (
    doctor_id VARCHAR(10),        -- VARCHAR
    first_name VARCHAR(50),       -- VARCHAR
    years_experience INT,         -- INTEGER
    phone_number VARCHAR(15)      -- VARCHAR
);
```

---

## 3. Relationships

### Primary Key
Unique identifier for each record in a table.
```sql
patient_id VARCHAR(10) PRIMARY KEY
doctor_id VARCHAR(10) PRIMARY KEY
```

### Foreign Key
Reference to a primary key in another table, establishing relationships.

```sql
CREATE TABLE Appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
```

### Relationship Diagram

![ER Diagram](Relationship%20Diagram.png)

---

## 4. Constraints

### Types of Constraints
| Constraint | Purpose | Example |
|------------|---------|---------|
| **NOT NULL** | Column cannot be empty | `first_name VARCHAR(50) NOT NULL` |
| **UNIQUE** | No duplicate values | `email VARCHAR(100) UNIQUE` |
| **CHECK** | Validates data against condition | `gender CHAR(1) CHECK (gender IN ('M', 'F'))` |
| **DEFAULT** | Sets automatic value | `status VARCHAR(20) DEFAULT 'Scheduled'` |
| **PRIMARY KEY** | Unique identifier | `patient_id VARCHAR(10) PRIMARY KEY` |
| **FOREIGN KEY** | Links to another table | `REFERENCES Patients(patient_id)` |

### Examples from Our Schema
```sql
-- NOT NULL
first_name VARCHAR(50) NOT NULL

-- UNIQUE
contact_number VARCHAR(15) UNIQUE

-- CHECK
gender CHAR(1) CHECK (gender IN ('M', 'F'))
cost DECIMAL(10,2) CHECK (cost >= 0)
status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-show'))

-- DEFAULT
registration_date DATE DEFAULT CURRENT_DATE
payment_status VARCHAR(20) DEFAULT 'Pending'
```

---

## 5. Views

### Definition
Virtual tables created by querying data from one or more tables.

### View 1: Patient Appointment Details
```sql
CREATE VIEW Patient_Appointment_Details AS
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;
```

### View 2: Treatment Billing Summary
```sql
CREATE VIEW Treatment_Billing_Summary AS
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    t.treatment_type,
    t.cost,
    b.payment_status
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
JOIN Treatments t ON b.treatment_id = t.treatment_id;
```

### View 3: Doctor Appointment Statistics
```sql
CREATE VIEW Doctor_Appointment_Stats AS
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization;
```

---

## 6. Indexes

### Definition
Database objects that improve query performance by enabling faster data retrieval.

### Types of Indexes
| Type | Description | Example |
|------|-------------|---------|
| **Simple Index** | Index on single column | `CREATE INDEX idx_email ON Patients(email)` |
| **Composite Index** | Index on multiple columns | `CREATE INDEX idx_name ON Patients(last_name, first_name)` |

### Indexes in Our Schema
```sql
-- Index on patient email for login/search
CREATE INDEX idx_patient_email ON Patients(email);

-- Index on patient name for searching
CREATE INDEX idx_patient_name ON Patients(last_name, first_name);

-- Index on doctor specialization for filtering
CREATE INDEX idx_doctor_specialization ON Doctors(specialization);

-- Index on appointment date for scheduling
CREATE INDEX idx_appointment_date ON Appointments(appointment_date);

-- Composite index on billing for reports
CREATE INDEX idx_billing_date_status ON Billing(bill_date, payment_status);
```

---

## Data

### Patients
| Name | City | Insurance |
|------|------|-----------|
| Aarav Sharma | Mumbai | Star Health |
| Priya Patel | Delhi | ICICI Lombard |
| Arjun Singh | Chennai | HDFC ERGO |
| Ananya Reddy | Hyderabad | Max Bupa |
| Vivaan Kumar | Bangalore | Apollo Munich |
| Ishita Gupta | Jaipur | Star Health |
| Aditya Nair | Kochi | ICICI Lombard |
| Diya Verma | Lucknow | HDFC ERGO |

### Doctors
| Name | Specialization | Hospital |
|------|----------------|----------|
| Dr. Rajesh Krishnamurthy | Dermatology | Apollo Hospital |
| Dr. Sunita Iyer | Pediatrics | Fortis Healthcare |
| Dr. Venkatesh Rao | Pediatrics | Max Hospital |
| Dr. Meera Deshmukh | Pediatrics | AIIMS |
| Dr. Suresh Pillai | Dermatology | Medanta |
| Dr. Anjali Chatterjee | General Medicine | Apollo Hospital |
| Dr. Ramesh Agarwal | Oncology | Tata Memorial |
| Dr. Lakshmi Bhat | Cardiology | Narayana Health |

---

## Summary Table

| Component | Purpose | Key Example |
|-----------|---------|-------------|
| **Tables** | Store data as entities | Patients, Doctors, Appointments |
| **Fields** | Define data types | VARCHAR, INT, DATE, DECIMAL |
| **Relationships** | Connect tables | Foreign Keys linking tables |
| **Constraints** | Ensure data integrity | NOT NULL, UNIQUE, CHECK, DEFAULT |
| **Views** | Virtual tables | Patient_Appointment_Details |
| **Indexes** | Faster retrieval | idx_patient_email |

---

## Dataset Source
**Kaggle Hospital Management Dataset** - Contains 5 tables with actual healthcare data structure for educational purposes.

---


