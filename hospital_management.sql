-- Create the database
CREATE DATABASE IF NOT EXISTS HospitalDB;
USE HospitalDB;

-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    dob DATE,
    contact_info VARCHAR(100)
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(50)
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    diagnosis TEXT,
    status VARCHAR(20), -- Scheduled, Completed, Cancelled
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Treatments Table
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    treatment_description TEXT,
    cost DECIMAL(10,2),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Billing Table
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20), -- Paid, Unpaid, Partial
    billing_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Sample Inserts
INSERT INTO Patients VALUES
(1, 'Moses Johnson', 'Male', '1996-05-15', 'moses@gmail.com'),
(2, 'Divya Sharma', 'Female', '1994-02-20', 'divya@gmail.com');

INSERT INTO Doctors VALUES
(1, 'Dr. Ramesh', 'Cardiology'),
(2, 'Dr. Anita', 'Dermatology');

INSERT INTO Appointments VALUES
(101, 1, 1, '2024-12-01', 'High BP', 'Completed'),
(102, 2, 2, '2024-12-02', 'Acne', 'Completed');

INSERT INTO Treatments VALUES
(1, 101, 'BP medication', 1200.00),
(2, 102, 'Facial Treatment', 800.00);

INSERT INTO Billing VALUES
(1001, 1, 1200.00, 'Paid', '2024-12-03'),
(1002, 2, 800.00, 'Unpaid', '2024-12-03');

-- 1. Get appointment history with doctor and patient
SELECT a.appointment_id, p.name AS Patient, d.name AS Doctor, a.appointment_date, a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- 2. Find unpaid bills
SELECT b.bill_id, p.name, b.total_amount, b.payment_status
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
WHERE b.payment_status != 'Paid';

-- 3. Total revenue per doctor
SELECT d.name AS Doctor, SUM(t.cost) AS Revenue
FROM Treatments t
JOIN Appointments a ON t.appointment_id = a.appointment_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.name;

-- 4. Most visited doctor
SELECT d.name AS Doctor, COUNT(a.appointment_id) AS Appointments
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.name
ORDER BY Appointments DESC
LIMIT 1;

-- 5. Patient treatment history
SELECT p.name AS Patient, t.treatment_description, t.cost
FROM Treatments t
JOIN Appointments a ON t.appointment_id = a.appointment_id
JOIN Patients p ON a.patient_id = p.patient_id;
