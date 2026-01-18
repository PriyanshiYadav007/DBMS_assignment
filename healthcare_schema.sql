-- DBMS ASSIGNMENT:Here I'm demonstrating; Tables, Fields, Relationships, Constraints, Views, Indexes
-- Dataset Source: Kaggle Hospital Management 

-- 1. TABLES

-- Patients table
CREATE TABLE Patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    date_of_birth DATE NOT NULL,
    contact_number VARCHAR(15) UNIQUE,
    address VARCHAR(200),
    registration_date DATE DEFAULT CURRENT_DATE,
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Doctors table
CREATE TABLE Doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    years_experience INT CHECK (years_experience >= 0),
    hospital_branch VARCHAR(50) DEFAULT 'Central Hospital',
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 2. RELATIONSHIPS - Using Foreign Keys

-- Appointments table (this is linking Patients and Doctors)
CREATE TABLE Appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason_for_visit VARCHAR(50) CHECK (reason_for_visit IN ('Consultation', 'Checkup', 'Follow-up', 'Emergency', 'Therapy')),
    status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-show')) DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Treatments table (linking to Appointments)
CREATE TABLE Treatments (
    treatment_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10) NOT NULL,
    treatment_type VARCHAR(50) CHECK (treatment_type IN ('X-Ray', 'MRI', 'ECG', 'Chemotherapy', 'Physiotherapy')),
    description VARCHAR(100),
    cost DECIMAL(10, 2) CHECK (cost >= 0),
    treatment_date DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Billing table (linking Patients and Treatments)
CREATE TABLE Billing (
    bill_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    treatment_id VARCHAR(10) NOT NULL,
    bill_date DATE NOT NULL,
    amount DECIMAL(10, 2) CHECK (amount >= 0),
    payment_method VARCHAR(20) CHECK (payment_method IN ('Cash', 'Credit Card', 'Insurance')),
    payment_status VARCHAR(20) CHECK (payment_status IN ('Paid', 'Pending', 'Failed')) DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
);


-- 2. FIELDS (COLUMNS) - With different Data Types

-- VARCHAR - patient_id, first_name, email, address
-- CHAR - gender
-- DATE - date_of_birth, registration_date, appointment_date
-- TIME - appointment_time
-- INT - years_experience
-- DECIMAL - cost, amount

-- 4. CONSTRAINTS Demonstrated Above

-- PRIMARY KEY: patient_id, doctor_id, appointment_id, etc.
-- FOREIGN KEY: patient_id, doctor_id in Appointments
-- NOT NULL: first_name, last_name, email
-- UNIQUE: contact_number, email, insurance_number
-- CHECK: gender IN ('M', 'F'), cost >= 0, status validation
-- DEFAULT: registration_date DEFAULT CURRENT_DATE

-- INSERTING DATA 
-- Inserting Patients 
INSERT INTO Patients VALUES
('P001', 'Aarav', 'Sharma', 'M', '1955-06-04', '9839585183', '45 MG Road, Mumbai', '2022-06-23', 'Star Health', 'INS840674', 'aarav.sharma@gmail.com'),
('P002', 'Priya', 'Patel', 'F', '1984-10-12', '8228188767', '12 Nehru Nagar, Delhi', '2022-01-15', 'ICICI Lombard', 'INS354079', 'priya.patel@gmail.com'),
('P003', 'Arjun', 'Singh', 'M', '1977-08-21', '8397029847', '78 Gandhi Street, Chennai', '2022-02-07', 'HDFC ERGO', 'INS650929', 'arjun.singh@gmail.com'),
('P004', 'Ananya', 'Reddy', 'F', '1981-02-20', '9019443432', '23 Jubilee Hills, Hyderabad', '2021-03-02', 'Max Bupa', 'INS789944', 'ananya.reddy@gmail.com'),
('P005', 'Vivaan', 'Kumar', 'M', '1960-06-23', '7734463155', '56 Koramangala, Bangalore', '2021-09-29', 'Apollo Munich', 'INS788105', 'vivaan.kumar@gmail.com'),
('P006', 'Ishita', 'Gupta', 'F', '1963-06-16', '7561777264', '89 Civil Lines, Jaipur', '2022-10-02', 'Star Health', 'INS613758', 'ishita.gupta@gmail.com'),
('P007', 'Aditya', 'Nair', 'M', '1989-06-08', '6278710077', '34 Marine Drive, Kochi', '2021-12-25', 'ICICI Lombard', 'INS465890', 'aditya.nair@gmail.com'),
('P008', 'Diya', 'Verma', 'F', '1976-07-05', '7090558393', '67 Cantonment, Lucknow', '2021-05-25', 'HDFC ERGO', 'INS545101', 'diya.verma@gmail.com'),
('P009', 'Rohan', 'Joshi', 'M', '1971-12-11', '7060324619', '12 Banjara Hills, Hyderabad', '2022-09-18', 'Max Bupa', 'INS136631', 'rohan.joshi@gmail.com'),
('P010', 'Kavya', 'Menon', 'F', '2001-10-13', '7081396733', '45 Anna Nagar, Chennai', '2022-08-24', 'Apollo Munich', 'INS866577', 'kavya.menon@gmail.com'),
('P011', 'Arnav', 'Iyer', 'M', '1966-12-04', '8990604070', '78 Indiranagar, Bangalore', '2022-09-27', 'Star Health', 'INS172991', 'arnav.iyer@gmail.com'),
('P012', 'Saanvi', 'Deshmukh', 'F', '1991-12-08', '8135666049', '23 Bandra, Mumbai', '2023-04-27', 'ICICI Lombard', 'INS104014', 'saanvi.deshmukh@gmail.com'),
('P013', 'Vihaan', 'Rao', 'M', '1990-03-28', '9059178882', '56 Whitefield, Bangalore', '2021-12-23', 'HDFC ERGO', 'INS373237', 'vihaan.rao@gmail.com'),
('P014', 'Myra', 'Kapoor', 'F', '1968-02-27', '7292262512', '89 Connaught Place, Delhi', '2023-12-12', 'Max Bupa', 'INS118070', 'myra.kapoor@gmail.com'),
('P015', 'Advait', 'Malhotra', 'M', '1964-05-11', '6636028516', '34 Powai, Mumbai', '2021-09-25', 'Apollo Munich', 'INS922209', 'advait.malhotra@gmail.com');

-- Inserting Doctors 
INSERT INTO Doctors VALUES
('D001', 'Rajesh', 'Krishnamurthy', 'Dermatology', '8322010158', 17, 'Apollo Hospital', 'dr.rajesh.k@apollo.com'),
('D002', 'Sunita', 'Iyer', 'Pediatrics', '9004382050', 24, 'Fortis Healthcare', 'dr.sunita.iyer@fortis.com'),
('D003', 'Venkatesh', 'Rao', 'Pediatrics', '8737740598', 19, 'Max Hospital', 'dr.venkatesh.rao@max.com'),
('D004', 'Meera', 'Deshmukh', 'Pediatrics', '6594221991', 28, 'AIIMS', 'dr.meera.d@aiims.com'),
('D005', 'Suresh', 'Pillai', 'Dermatology', '9118538547', 26, 'Medanta', 'dr.suresh.pillai@medanta.com'),
('D006', 'Anjali', 'Chatterjee', 'General Medicine', '6570137231', 23, 'Apollo Hospital', 'dr.anjali.c@apollo.com'),
('D007', 'Ramesh', 'Agarwal', 'Oncology', '8217493115', 26, 'Tata Memorial', 'dr.ramesh.a@tata.com'),
('D008', 'Lakshmi', 'Bhat', 'Cardiology', '9069162601', 5, 'Narayana Health', 'dr.lakshmi.b@narayana.com'),
('D009', 'Karthik', 'Subramanian', 'Orthopedics', '7387087517', 26, 'Apollo Hospital', 'dr.karthik.s@apollo.com'),
('D010', 'Deepa', 'Menon', 'Oncology', '6176383634', 21, 'Fortis Healthcare', 'dr.deepa.m@fortis.com');

-- Inserting Appointments 
INSERT INTO Appointments VALUES
('A001', 'P001', 'D009', '2023-08-09', '15:15:00', 'Therapy', 'Scheduled'),
('A002', 'P002', 'D004', '2023-06-09', '14:30:00', 'Therapy', 'No-show'),
('A003', 'P003', 'D004', '2023-06-28', '08:00:00', 'Consultation', 'Cancelled'),
('A004', 'P004', 'D006', '2023-09-01', '09:15:00', 'Consultation', 'Cancelled'),
('A005', 'P005', 'D003', '2023-07-06', '12:45:00', 'Emergency', 'No-show'),
('A006', 'P006', 'D006', '2023-06-19', '16:15:00', 'Checkup', 'Scheduled'),
('A007', 'P001', 'D007', '2023-04-09', '10:30:00', 'Consultation', 'Scheduled'),
('A008', 'P007', 'D010', '2023-05-24', '08:45:00', 'Consultation', 'Cancelled'),
('A009', 'P008', 'D010', '2023-03-05', '13:45:00', 'Follow-up', 'Scheduled'),
('A010', 'P005', 'D003', '2023-01-13', '15:30:00', 'Therapy', 'Completed'),
('A011', 'P009', 'D007', '2023-11-12', '16:00:00', 'Checkup', 'No-show'),
('A012', 'P010', 'D003', '2023-05-07', '10:00:00', 'Follow-up', 'Completed'),
('A013', 'P003', 'D002', '2023-08-16', '12:00:00', 'Emergency', 'Scheduled'),
('A014', 'P012', 'D010', '2023-05-25', '10:30:00', 'Emergency', 'Cancelled'),
('A015', 'P011', 'D004', '2023-01-15', '17:15:00', 'Consultation', 'No-show');

-- Inserting Treatments 
INSERT INTO Treatments VALUES
('T001', 'A001', 'Chemotherapy', 'Basic screening', 3941.97, '2023-08-09'),
('T002', 'A002', 'MRI', 'Advanced protocol', 4158.44, '2023-06-09'),
('T003', 'A003', 'MRI', 'Standard procedure', 3731.55, '2023-06-28'),
('T004', 'A004', 'MRI', 'Basic screening', 4799.86, '2023-09-01'),
('T005', 'A005', 'ECG', 'Standard procedure', 582.05, '2023-07-06'),
('T006', 'A006', 'Chemotherapy', 'Standard procedure', 1381.00, '2023-06-19'),
('T007', 'A007', 'Chemotherapy', 'Advanced protocol', 534.03, '2023-04-09'),
('T008', 'A008', 'Physiotherapy', 'Basic screening', 3413.64, '2023-05-24'),
('T009', 'A009', 'Physiotherapy', 'Standard procedure', 4541.14, '2023-03-05'),
('T010', 'A010', 'Physiotherapy', 'Standard procedure', 1595.67, '2023-01-13'),
('T011', 'A011', 'MRI', 'Basic screening', 4671.66, '2023-11-12'),
('T012', 'A012', 'Chemotherapy', 'Standard procedure', 771.20, '2023-05-07'),
('T013', 'A013', 'MRI', 'Standard procedure', 4704.96, '2023-08-16'),
('T014', 'A014', 'ECG', 'Basic screening', 2082.30, '2023-05-25'),
('T015', 'A015', 'Physiotherapy', 'Basic screening', 956.39, '2023-01-15');

-- Inserting Billing 
INSERT INTO Billing VALUES
('B001', 'P001', 'T001', '2023-08-09', 3941.97, 'Insurance', 'Pending'),
('B002', 'P002', 'T002', '2023-06-09', 4158.44, 'Insurance', 'Paid'),
('B003', 'P003', 'T003', '2023-06-28', 3731.55, 'Insurance', 'Paid'),
('B004', 'P004', 'T004', '2023-09-01', 4799.86, 'Insurance', 'Failed'),
('B005', 'P005', 'T005', '2023-07-06', 582.05, 'Credit Card', 'Pending'),
('B006', 'P006', 'T006', '2023-06-19', 1381.00, 'Insurance', 'Pending'),
('B007', 'P001', 'T007', '2023-04-09', 534.03, 'Cash', 'Failed'),
('B008', 'P007', 'T008', '2023-05-24', 3413.64, 'Cash', 'Failed'),
('B009', 'P008', 'T009', '2023-03-05', 4541.14, 'Credit Card', 'Paid'),
('B010', 'P005', 'T010', '2023-01-13', 1595.67, 'Cash', 'Paid'),
('B011', 'P009', 'T011', '2023-11-12', 4671.66, 'Cash', 'Failed'),
('B012', 'P010', 'T012', '2023-05-07', 771.20, 'Insurance', 'Pending'),
('B013', 'P003', 'T013', '2023-08-16', 4704.96, 'Cash', 'Paid'),
('B014', 'P012', 'T014', '2023-05-25', 2082.30, 'Credit Card', 'Paid'),
('B015', 'P011', 'T015', '2023-01-15', 956.39, 'Insurance', 'Pending');

-- 5. VIEWS - Virtual tables created from queries

-- View 1: Patient Appointment Details
CREATE VIEW Patient_Appointment_Details AS
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.contact_number,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.appointment_time,
    a.reason_for_visit,
    a.status
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- View 2: Treatment and Billing Summary
CREATE VIEW Treatment_Billing_Summary AS
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    t.treatment_type,
    t.description,
    t.cost AS treatment_cost,
    b.payment_method,
    b.payment_status,
    b.bill_date
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
JOIN Treatments t ON b.treatment_id = t.treatment_id;

-- View 3: Doctor Appointment Statistics
CREATE VIEW Doctor_Appointment_Stats AS
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    d.hospital_branch,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) AS completed_appointments,
    SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization, d.hospital_branch;

-- View 4: Hospital Revenue Report
CREATE VIEW Hospital_Revenue_Report AS
SELECT 
    d.hospital_branch,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(b.amount) AS total_revenue,
    AVG(b.amount) AS average_bill_amount
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
LEFT JOIN Treatments t ON a.appointment_id = t.appointment_id
LEFT JOIN Billing b ON t.treatment_id = b.treatment_id
GROUP BY d.hospital_branch;

-- 6. INDEXES - For faster search and retrieval

-- Index on patient email for login/search
CREATE INDEX idx_patient_email ON Patients(email);

-- Index on patient name for searching
CREATE INDEX idx_patient_name ON Patients(last_name, first_name);

-- Index on doctor specialization for filtering
CREATE INDEX idx_doctor_specialization ON Doctors(specialization);

-- Index on appointment date for scheduling queries
CREATE INDEX idx_appointment_date ON Appointments(appointment_date);

-- Index on appointment status for filtering
CREATE INDEX idx_appointment_status ON Appointments(status);

-- Composite index on billing for financial reports
CREATE INDEX idx_billing_date_status ON Billing(bill_date, payment_status);

-- Index on treatment type for analysis
CREATE INDEX idx_treatment_type ON Treatments(treatment_type);

-- QUERIES DEMONSTRATING ALL CONCEPTS

-- Query 1: View all patients
SELECT * FROM Patients;

-- Query 2: View all doctors with their specialization
SELECT doctor_id, CONCAT(first_name, ' ', last_name) AS doctor_name, specialization, hospital_branch
FROM Doctors;

-- Query 3: Get appointments for a specific patient
SELECT * FROM Patient_Appointment_Details
WHERE patient_name LIKE '%Sharma%';

-- Query 4: Find all pending bills
SELECT * FROM Treatment_Billing_Summary
WHERE payment_status = 'Pending';

-- Query 5: Doctor-wise appointment count
SELECT * FROM Doctor_Appointment_Stats
ORDER BY total_appointments DESC;

-- Query 6: Revenue by hospital branch
SELECT * FROM Hospital_Revenue_Report;

-- Query 7: Patients with upcoming appointments
SELECT 
    p.first_name, p.last_name, 
    a.appointment_date, a.reason_for_visit,
    d.first_name AS doctor_first_name, d.specialization
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date;

-- Query 8: Total revenue by treatment type
SELECT 
    t.treatment_type,
    COUNT(*) AS total_treatments,
    SUM(t.cost) AS total_revenue,
    AVG(t.cost) AS average_cost
FROM Treatments t
GROUP BY t.treatment_type
ORDER BY total_revenue DESC;

-- Query 9: Insurance provider wise patient distribution
SELECT 
    insurance_provider,
    COUNT(*) AS patient_count
FROM Patients
GROUP BY insurance_provider
ORDER BY patient_count DESC;

-- Query 10: Find patients who missed appointments
SELECT 
    p.first_name, p.last_name, p.contact_number,
    a.appointment_date, d.first_name AS doctor_name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'No-show';
