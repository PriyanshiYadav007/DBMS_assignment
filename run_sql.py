import sqlite3
import os

# Removing existing database if exist
if os.path.exists('hospital.db'):
    os.remove('hospital.db')

# Creating database connection
conn = sqlite3.connect('hospital.db')
cursor = conn.cursor()

# Reading and executing SQL file
with open('healthcare_schema.sql', 'r') as f:
    sql_script = f.read()

try:
    cursor.executescript(sql_script)
    conn.commit()
    print("[SUCCESS] DATABASE CREATED SUCCESSFULLY!")
    print("--------------------------------------")
    
    # Showing tables
    print("\n[TABLES CREATED]")
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = cursor.fetchall()
    for t in tables:
        print(f"   * {t[0]}")
    
    # Showing patients
    print("\n[PATIENTS - Data]")
    print("--------------------------------------")
    cursor.execute("SELECT patient_id, first_name, last_name, contact_number FROM Patients LIMIT 5")
    for row in cursor.fetchall():
        print(f"   {row[0]} | {row[1]} {row[2]} | {row[3]}")
    
    # Showing doctors
    print("\n[DOCTORS]")
    print("--------------------------------------")
    cursor.execute("SELECT doctor_id, first_name, last_name, specialization, hospital_branch FROM Doctors")
    for row in cursor.fetchall():
        print(f"   {row[0]} | Dr. {row[1]} {row[2]} | {row[3]} | {row[4]}")
    
    # Showing appointments count
    print("\n[APPOINTMENTS]")
    cursor.execute("SELECT COUNT(*) FROM Appointments")
    count = cursor.fetchone()[0]
    print(f"   Total Appointments: {count}")
    
    # Showing appointment details
    print("\n[APPOINTMENT DETAILS]")
    print("--------------------------------------")
    cursor.execute("""
        SELECT 
            p.first_name || ' ' || p.last_name AS patient,
            d.first_name || ' ' || d.last_name AS doctor,
            a.appointment_date,
            a.reason_for_visit,
            a.status
        FROM Appointments a
        JOIN Patients p ON a.patient_id = p.patient_id
        JOIN Doctors d ON a.doctor_id = d.doctor_id
        LIMIT 5
    """)
    for row in cursor.fetchall():
        print(f"   {row[0]} -> Dr. {row[1]} | {row[2]} | {row[3]} | {row[4]}")
    
    # Showing treatments
    print("\n[TREATMENTS]")
    print("--------------------------------------")
    cursor.execute("SELECT treatment_id, treatment_type, description, cost FROM Treatments LIMIT 5")
    for row in cursor.fetchall():
        print(f"   {row[0]} | {row[1]} | {row[2]} | Rs.{row[3]}")
    
    # Showing billing summary
    print("\n[BILLING SUMMARY]")
    print("--------------------------------------")
    cursor.execute("""
        SELECT payment_status, COUNT(*), SUM(amount) 
        FROM Billing 
        GROUP BY payment_status
    """)
    for row in cursor.fetchall():
        print(f"   {row[0]}: {row[1]} bills | Total: Rs.{row[2]:.2f}")
    
    # Showing views
    print("\n[VIEWS CREATED]")
    cursor.execute("SELECT name FROM sqlite_master WHERE type='view'")
    views = cursor.fetchall()
    for v in views:
        print(f"   * {v[0]}")
    
    # Showing indexes
    print("\n[INDEXES CREATED]")
    cursor.execute("SELECT name FROM sqlite_master WHERE type='index' AND name NOT LIKE 'sqlite_%'")
    indexes = cursor.fetchall()
    for i in indexes:
        print(f"   * {i[0]}")
    
    print("\n" + "--------------------")
    print("[SUCCESS] ALL SQL OPERATIONS COMPLETED!")
    print("--------------------")
    print("\nDatabase file created: hospital.db")
    
except Exception as e:
    print(f"[ERROR]: {e}")

finally:
    conn.close()
