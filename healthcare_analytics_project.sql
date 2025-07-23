

--                                                                                                                        Hospital Patient Analytics System


CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    birth_date DATE
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(50)
);

CREATE TABLE Diagnoses (
    diagnosis_code VARCHAR(10) PRIMARY KEY,
    diagnosis_description VARCHAR(255)
);

CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    discharge_date DATE,
    diagnosis_code VARCHAR(10),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (diagnosis_code) REFERENCES Diagnoses(diagnosis_code)
);

-- ---------------------
-- Sample Data insertion
-- ---------------------

INSERT INTO Patients VALUES
(1, 'Alice Johnson', 'Female', '1985-04-12'),
(2, 'Bob Smith', 'Male', '1978-08-23'),
(3, 'Carol Davis', 'Female', '1990-12-01');

INSERT INTO Doctors VALUES
(1, 'Dr. Gregory House', 'Diagnostics'),
(2, 'Dr. Meredith Grey', 'Surgery'),
(3, 'Dr. John Watson', 'General Medicine');

INSERT INTO Diagnoses VALUES
('D001', 'Flu'),
('D002', 'Hypertension'),
('D003', 'Diabetes');

INSERT INTO Visits VALUES
(101, 1, 1, '2024-05-01', '2024-05-03', 'D001'),
(102, 2, 2, '2024-05-10', '2024-05-15', 'D002'),
(103, 3, 3, '2024-06-05', '2024-06-10', 'D003'),
(104, 1, 2, '2024-07-01', '2024-07-03', 'D002'),
(105, 2, 1, '2024-07-15', '2024-07-17', 'D001');

-- ---------------------
-- Queries
-- ---------------------

-- 1. List all patients
SELECT * FROM Patients;

-- 2. Count visits per diagnosis
SELECT diagnosis_code, COUNT(*) AS total_visits
FROM Visits
GROUP BY diagnosis_code;

-- 3. Join to get diagnosis descriptions
SELECT d.diagnosis_description, COUNT(*) AS total_cases
FROM Visits v
JOIN Diagnoses d ON v.diagnosis_code = d.diagnosis_code
GROUP BY d.diagnosis_description;

-- 4. Average length of stay per diagnosis
SELECT d.diagnosis_description,
       ROUND(AVG(discharge_date - visit_date), 2) AS avg_stay_days
FROM Visits v
JOIN Diagnoses d ON v.diagnosis_code = d.diagnosis_code
GROUP BY d.diagnosis_description;

-- 5. Top doctors by number of visits
SELECT doc.name AS doctor_name,
       doc.specialty,
       COUNT(*) AS total_patients
FROM Visits v
JOIN Doctors doc ON v.doctor_id = doc.doctor_id
GROUP BY doc.name, doc.specialty
ORDER BY total_patients DESC;

-- 6. Monthly visits count
SELECT DATE_TRUNC('month', visit_date) AS month,
       COUNT(*) AS total_visits
FROM Visits
GROUP BY month
ORDER BY month;

-- 7. Patient visit history with diagnosis details
SELECT p.name AS patient_name,
       d.diagnosis_description,
       v.visit_date,
       v.discharge_date,
       doc.name AS doctor
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Diagnoses d ON v.diagnosis_code = d.diagnosis_code
JOIN Doctors doc ON v.doctor_id = doc.doctor_id
ORDER BY p.name, v.visit_date;


-- Update and Delete Queries


-- Update: Correct a patient name
UPDATE Patients
SET name = 'Alice J. Johnson'
WHERE patient_id = 1;

-- Update: Change diagnosis description
UPDATE Diagnoses
SET diagnosis_description = 'Influenza (Flu)'
WHERE diagnosis_code = 'D001';

-- Delete: Remove a visit record by visit_id
DELETE FROM Visits
WHERE visit_id = 105;

-- Delete: Remove a patient who has no visits (example)
DELETE FROM Patients
WHERE patient_id = 999; -- Assuming 999 has no visits


-- Aggregate Functions and Window Functions


-- 1. Count number of visits per doctor and specialty
SELECT d.name AS doctor_name,
       d.specialty,
       COUNT(v.visit_id) AS total_visits
FROM Doctors d
LEFT JOIN Visits v ON d.doctor_id = v.doctor_id
GROUP BY d.name, d.specialty
ORDER BY total_visits DESC;

-- 2. Average length of stay per doctor
SELECT d.name AS doctor_name,
       ROUND(AVG(discharge_date - visit_date), 2) AS avg_length_of_stay
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
GROUP BY d.name;

-- 3. Most recent visit per patient using ROW_NUMBER()
SELECT *
FROM (
    SELECT 
        p.name AS patient_name,
        v.visit_date,
        v.diagnosis_code,
        ROW_NUMBER() OVER (PARTITION BY p.patient_id ORDER BY v.visit_date DESC) AS rn
    FROM Visits v
    JOIN Patients p ON v.patient_id = p.patient_id
) recent_visits
WHERE rn = 1;

-- 4. Top 2 longest stays per diagnosis using ROW_NUMBER()
SELECT *
FROM (
    SELECT 
        d.diagnosis_description,
        p.name AS patient_name,
        v.visit_date,
        discharge_date - visit_date AS stay_duration,
        ROW_NUMBER() OVER (PARTITION BY v.diagnosis_code ORDER BY discharge_date - visit_date DESC) AS rn
    FROM Visits v
    JOIN Patients p ON v.patient_id = p.patient_id
    JOIN Diagnoses d ON v.diagnosis_code = d.diagnosis_code
) ranked
WHERE rn <= 2;
