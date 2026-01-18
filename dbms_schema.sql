-- ============================================
-- DBMS ASSIGNMENT: Demonstrating: Tables, Fields, Relationships, Constraints, Views, Indexes
-- ============================================

-- ============================================
-- 1. TABLES 
-- ============================================

-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    phone VARCHAR(15)
);

-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    credits INT CHECK (credits > 0 AND credits <= 6),
    department VARCHAR(50) DEFAULT 'General'
);

-- Professors table
CREATE TABLE Professors (
    professor_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50),
    hire_date DATE
);

-- ============================================
-- 3. RELATIONSHIPS - Using Foreign Keys
-- ============================================

-- Enrollments table 
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Course_Professors table (Many-to-Many relationship)
CREATE TABLE Course_Professors (
    course_id INT,
    professor_id INT,
    semester VARCHAR(20),
    academic_year INT,
    PRIMARY KEY (course_id, professor_id, academic_year),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

-- ============================================
-- 2. FIELDS (COLUMNS) - With Different Data Types
-- ============================================
-- Already demonstrated above with:
-- INT (integer) - student_id, course_id, credits
-- VARCHAR (variable character) - first_name, last_name, email
-- DATE - date_of_birth, enrollment_date
-- CHAR - gender, grade

-- ============================================
-- 4. CONSTRAINTS - Rules for data integrity
-- ============================================

-- NOT NULL: first_name, last_name in Students table
-- UNIQUE: email in Students table, course_code in Courses table
-- CHECK: gender must be 'M', 'F', or 'O'; credits must be between 1 and 6
-- DEFAULT: enrollment_date defaults to current date; department defaults to 'General'
-- PRIMARY KEY: student_id, course_id, professor_id
-- FOREIGN KEY: student_id and course_id in Enrollments table

-- ============================================
-- INSERTING SAMPLE DATA (with Indian Names)
-- ============================================

-- Inserting Students
INSERT INTO Students (student_id, first_name, last_name, email, date_of_birth, gender, phone) VALUES
(1, 'Aarav', 'Sharma', 'aarav.sharma@email.com', '2002-05-15', 'M', '9876543210'),
(2, 'Priya', 'Patel', 'priya.patel@email.com', '2003-08-22', 'F', '9876543211'),
(3, 'Arjun', 'Singh', 'arjun.singh@email.com', '2002-12-10', 'M', '9876543212'),
(4, 'Ananya', 'Reddy', 'ananya.reddy@email.com', '2003-03-18', 'F', '9876543213'),
(5, 'Vivaan', 'Kumar', 'vivaan.kumar@email.com', '2002-07-25', 'M', '9876543214'),
(6, 'Ishita', 'Gupta', 'ishita.gupta@email.com', '2003-11-30', 'F', '9876543215'),
(7, 'Aditya', 'Nair', 'aditya.nair@email.com', '2002-09-05', 'M', '9876543216'),
(8, 'Diya', 'Verma', 'diya.verma@email.com', '2003-01-12', 'F', '9876543217');

-- Inserting Courses
INSERT INTO Courses (course_id, course_name, course_code, credits, department) VALUES
(101, 'Database Management Systems', 'DBMS101', 4, 'Computer Science'),
(102, 'Data Structures', 'DS102', 4, 'Computer Science'),
(103, 'Operating Systems', 'OS103', 3, 'Computer Science'),
(104, 'Computer Networks', 'CN104', 3, 'Computer Science'),
(105, 'Software Engineering', 'SE105', 3, 'Computer Science');

-- Inserting Professors
INSERT INTO Professors (professor_id, first_name, last_name, email, department, hire_date) VALUES
(201, 'Rajesh', 'Krishnamurthy', 'rajesh.k@university.edu', 'Computer Science', '2010-06-15'),
(202, 'Sunita', 'Iyer', 'sunita.iyer@university.edu', 'Computer Science', '2012-08-20'),
(203, 'Venkatesh', 'Rao', 'venkatesh.rao@university.edu', 'Computer Science', '2015-01-10'),
(204, 'Meera', 'Deshmukh', 'meera.d@university.edu', 'Computer Science', '2018-07-01');

-- Inserting Enrollments
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(1001, 1, 101, '2024-08-01', 'A'),
(1002, 1, 102, '2024-08-01', 'A+'),
(1003, 2, 101, '2024-08-01', 'B+'),
(1004, 2, 103, '2024-08-01', 'A'),
(1005, 3, 102, '2024-08-01', 'B'),
(1006, 3, 104, '2024-08-01', 'A'),
(1007, 4, 101, '2024-08-01', 'A+'),
(1008, 4, 105, '2024-08-01', 'A'),
(1009, 5, 103, '2024-08-01', 'B+'),
(1010, 6, 104, '2024-08-01', 'A');

-- Inserting Course-Professor assignments
INSERT INTO Course_Professors (course_id, professor_id, semester, academic_year) VALUES
(101, 201, 'Fall', 2024),
(102, 202, 'Fall', 2024),
(103, 203, 'Fall', 2024),
(104, 204, 'Fall', 2024),
(105, 201, 'Fall', 2024);

-- ============================================
-- 5. VIEWS - Virtual tables created from queries
-- ============================================

-- View 1: Student Enrollment Details (combining multiple tables)
CREATE VIEW Student_Course_Details AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email AS student_email,
    c.course_name,
    c.course_code,
    c.credits,
    e.grade,
    e.enrollment_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- View 2: Course Statistics
CREATE VIEW Course_Statistics AS
SELECT 
    c.course_id,
    c.course_name,
    c.course_code,
    COUNT(e.student_id) AS total_students,
    c.credits
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.course_code, c.credits;

-- View 3: Professor Course Assignments
CREATE VIEW Professor_Courses AS
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    p.email,
    c.course_name,
    cp.semester,
    cp.academic_year
FROM Professors p
JOIN Course_Professors cp ON p.professor_id = cp.professor_id
JOIN Courses c ON cp.course_id = c.course_id;

-- ============================================
-- 6. INDEXES - For faster search and retrieval
-- ============================================

-- Index on student email for faster lookups
CREATE INDEX idx_student_email ON Students(email);

-- Index on student name for searching by name
CREATE INDEX idx_student_name ON Students(last_name, first_name);

-- Index on course code for faster course searches
CREATE INDEX idx_course_code ON Courses(course_code);

-- Index on enrollment date for date-based queries
CREATE INDEX idx_enrollment_date ON Enrollments(enrollment_date);

-- Composite index on enrollments for student-course lookups
CREATE INDEX idx_student_course ON Enrollments(student_id, course_id);

-- ============================================
-- SAMPLE QUERIES DEMONSTRATING ALL CONCEPTS
-- ============================================

-- Query 1: Select all students (using TABLE)
SELECT * FROM Students;

-- Query 2: Select specific fields/columns
SELECT first_name, last_name, email FROM Students;

-- Query 3: Using the VIEW to see enrollment details
SELECT * FROM Student_Course_Details;

-- Query 4: Query demonstrating FOREIGN KEY relationship
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    e.grade
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE s.first_name = 'Aarav';

-- Query 5: Using Course Statistics View
SELECT * FROM Course_Statistics ORDER BY total_students DESC;

-- Query 6: Finding students with grade 'A' or higher
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name,
    e.grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade IN ('A', 'A+');

-- Query 7: Count students per course
SELECT 
    c.course_name,
    COUNT(e.student_id) AS enrolled_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- Query 8: Using Professor Courses View
SELECT * FROM Professor_Courses;
