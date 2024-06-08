CREATE DATABASE IF NOT EXISTS diabetes_prediction;
USE diabetes_prediction;

SELECT * FROM diabetic_patients;
-- TO CONVERT A STRING TO DATE VALUE
SELECT *
FROM diabetic_patients
WHERE STR_TO_DATE(DOB, '%m/%d/%Y') IS NULL;
-- Update invalid dates manually
UPDATE diabetic_patients
SET DOB = '1995-02-28'
WHERE DOB = '2/29/1995';
-- CHANGING THE DATATYPE FROM TEXT TO DATE
ALTER TABLE diabetic_patients 
MODIFY COLUMN DOB DATE;

-- ADDING AGE COLOUMN TO THE TABLE
ALTER TABLE diabetic_patients 
ADD COLUMN Age_calculated INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE diabetic_patients
SET Age_calculated = TIMESTAMPDIFF(YEAR, DOB, CURDATE());

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM diabetic_patients;

-- Retrieve the Patient_id and ages of all patients.
SELECT Patient_id, Age_calculated 
FROM diabetic_patients;

-- Select all female patients who are older than 30.
SELECT EmployeeName, Patient_id, gender, Age_calculated FROM diabetic_patients
WHERE Age_calculated > 30 AND gender = 'Female';

-- Calculate the average BMI of patients.
SELECT ROUND(AVG(bmi),2) AS Average_BMI
 FROM diabetic_patients;

-- List patients in descending order of blood glucose levels.
SELECT EmployeeName, Patient_id, blood_glucose_level 
FROM diabetic_patients
ORDER BY blood_glucose_level DESC;

--  Find patients who have hypertension and diabetes. 
SELECT EmployeeName, Patient_id, hypertension, diabetes
FROM diabetic_patients
WHERE hypertension = 1 and diabetes = 1;

-- Determine the number of patients with heart disease. 
SELECT COUNT(distinct Patient_id) AS HeartDisease_Patients
FROM diabetic_patients
WHERE heart_disease = 1;

-- Group patients by smoking history and count how many smokers and non-smokers there are. 
SELECT smoking_history, COUNT(Patient_id) AS `Number of Patients`
FROM diabetic_patients
GROUP BY smoking_history;

-- Retrieve the Patient_id of patients who have a BMI greater than the average BMI.
SELECT Patient_id, bmi
FROM diabetic_patients
WHERE bmi > (SELECT ROUND(AVG(bmi),2) AS Average_BMI
 FROM diabetic_patients);
 
 -- Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel. 
(SELECT EmployeeName, Patient_id, HbA1c_level
FROM diabetic_patients
ORDER BY HbA1c_level DESC LIMIT 1)
UNION
(SELECT EmployeeName, Patient_id, HbA1c_level
FROM diabetic_patients
ORDER BY HbA1c_level LIMIT 1)

-- Calculate the age of patients in years (assuming the current date as of now); 
ALTER TABLE diabetic_patients 
ADD COLUMN Age_calculated INT;
UPDATE diabetic_patients
SET Age_calculated = TIMESTAMPDIFF(YEAR, DOB, CURDATE());
SELECT * FROM diabetic_patients;

-- Rank patients by blood glucose level within each gender group.
SELECT EmployeeName, Patient_id, gender, blood_glucose_level,
DENSE_RANK()OVER (PARTITION BY gender ORDER BY blood_glucose_level DESC) 'Rank'
FROM diabetic_patients;

-- Update the smoking history of patients who are older than 40 to "Ex-smoker." 
UPDATE diabetic_patients
SET smoking_history = 'Ex-smoker'
WHERE Age_calculated > 40;

-- Insert a new patient into the database with sample data. 
INSERT INTO diabetic_patients
VALUES('RAHUL', 'PT100102', 'Male', '2002-01-29', 0, 0, 'never', 25.08, 5.3, 90, 1, 22);

SELECT * FROM diabetic_patients
WHERE Patient_id = 'PT100102';

--  Delete all patients with heart disease from the database.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM diabetic_patients
WHERE heart_disease = 1;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM diabetic_patients
WHERE heart_disease = 1;

--  Find patients who have hypertension but not diabetes using the EXCEPT operator. 
SELECT EmployeeName, Patient_id, hypertension, diabetes
FROM diabetic_patients 
WHERE hypertension = 1 
AND diabetes NOT IN (SELECT diabetes FROM diabetic_patients WHERE diabetes =1);

--  Define a unique constraint on the "patient_id" column to ensure its values are unique.
ALTER TABLE diabetic_patients
ADD CONSTRAINT unique_patient_id UNIQUE (Patient_id(255));

-- Create a view that displays the Patient_ids, ages, and BMI of patients.
CREATE VIEW dia_patients_view AS
SELECT Patient_id, Age_calculated, bmi
FROM diabetic_patients;

SELECT * FROM dia_patients_view;