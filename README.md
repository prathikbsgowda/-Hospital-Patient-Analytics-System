# 🏥 Healthcare Analytics SQL Project

This SQL project simulates a hospital's patient management and analytics system. It includes table creation, sample data, and a wide range of SQL queries—starting from simple SELECTs to advanced joins and window functions.

---

##  Objective

Analyze patient visits, doctor performance, diagnoses, and hospital operations using SQL.

---

## 🗃 Dataset Schema

### Patients
- patient_id (PK)
- name
- gender
- birth_date

### Doctors
- doctor_id (PK)
- name
- specialty

### Diagnoses
- diagnosis_code (PK)
- diagnosis_description

### Visits
- visit_id (PK)
- patient_id (FK)
- doctor_id (FK)
- visit_date
- discharge_date
- diagnosis_code (FK)

---

##  Included SQL Operations

###  Table Creation
- `CREATE TABLE` statements for all 4 entities

###  Data Insertion
- Sample data for realistic testing

###  Basic Queries
- List of patients, diagnoses, visit logs

###  Aggregations and Group By
- Visits per diagnosis
- Average stay length per doctor
- Total patients seen by each doctor

###  Window Functions
- `ROW_NUMBER()` to get most recent visits
- Top 2 longest stays per diagnosis

###  Update & Delete
- Update patient or diagnosis details
- Delete specific visit or orphan patient

###  Joins
- Inner Join: Patient visit logs with diagnosis
- Left Join: Doctor list with visit counts
- Full Outer Join: All patients and visits
- Self Join: Doctors with same specialty

---

## 🛠️ Tools

- SQL (PostgreSQL / MySQL)
- Optional: DB Browser for SQLite
- Optional: Power BI / Tableau for visualization

---

##  Usage

1. Download and run `healthcare_analytics_project.sql` in your SQL environment.
2. Explore all queries inside the file to analyze hospital data.
3. (Optional) Connect to a BI tool for dashboarding.

---

##  Visualization Ideas

- Bar chart: Number of visits per doctor
- Line chart: Monthly patient admissions
- Heatmap: Avg. stay length by diagnosis
- Pie chart: Top 5 diagnoses

---

