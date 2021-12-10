-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_patient
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_patient (
	patient_id VARCHAR2(10) NOT NULL , 
	fname VARCHAR2(30) NOT NULL, 
	lname VARCHAR2(30) NOT NULL, 
	dob DATE NOT NULL, 
	gender CHAR(1) NULL,
	ssn VARCHAR2(15) NOT NULL,
	email VARCHAR2(50) NOT NULL, 
	CONSTRAINT patient_pk PRIMARY KEY(patient_id),
	CONSTRAINT patient_uk UNIQUE(patient_id, ssn),
	CONSTRAINT patient_gender_ck CHECK (gender = 'M' OR gender = 'F')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_insurance
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_insurance (
	ins_id VARCHAR2(10) NOT NULL , 
	name VARCHAR2(30) NOT NULL, 
	ins_type VARCHAR2(20) NOT NULL, 
	coverage INT NOT NULL, 
	duration INT NOT NULL,
	plan VARCHAR2(15) NULL,
	CONSTRAINT insurance_pk PRIMARY KEY(ins_id),
	CONSTRAINT insurance_type CHECK (ins_type = 'dental' OR ins_type = 'comprehensive'),
	CONSTRAINT insurance_plan CHECK (plan = 'hmo' OR plan = 'ppo' OR plan = 'indeminity' OR plan = 'medicare')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_patient_insurance
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_patient_insurance (
	ins_id VARCHAR2(10) NOT NULL , 
	patient_id VARCHAR2(10) NOT NULL, 
	premium DECIMAL(6,2) NOT NULL,
	CONSTRAINT patient_insurance_pk PRIMARY KEY(ins_id, patient_id),
	CONSTRAINT patient_insurance_ins_fk FOREIGN KEY(ins_id) REFERENCES F21_S001_22_insurance(ins_id) ON DELETE CASCADE,
	CONSTRAINT patient_insurance_pat_fk FOREIGN KEY(patient_id) REFERENCES F21_S001_22_patient(patient_id) ON DELETE CASCADE	
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_drug
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_drug (
	drug_id VARCHAR2(10) NOT NULL , 
	name VARCHAR2(20) NOT NULL, 
    drug_type VARCHAR2(15) NOT NULL,  
	pat_amount DECIMAL(6,2) NULL,
	drug_cost DECIMAL(6,2) NOT NULL, 
    CONSTRAINT drug_pk PRIMARY KEY(drug_id),
    CONSTRAINT drug_ck CHECK (drug_type = 'tablets' OR drug_type = 'capsules' OR drug_type = 'intravenous')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_material
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_material (
	material_id VARCHAR2(10) NOT NULL , 
	name VARCHAR2(20) NOT NULL,  
	material_type VARCHAR2(10) NULL,
	pat_amount DECIMAL(6,2) NULL,
	material_cost DECIMAL(6,2) NOT NULL,
    CONSTRAINT material_pk PRIMARY KEY(material_id),
    CONSTRAINT material_ck CHECK (material_type = 'composites' OR material_type = 'ceramics' OR material_type = 'amalgam')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_practice
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_practice(
	practice_id VARCHAR2(10) NOT NULL, 
	npi INT NULL,
	tax_id INT NULL, 
	phone VARCHAR2(15) NOT NULL,
	street VARCHAR2(50) NOT NULL, 
	city CHAR(15) NOT NULL, 
	zip INT NOT NULL, 
	mgr_emp_id VARCHAR2(10) NOT NULL, 
	CONSTRAINT practice_pk PRIMARY KEY(practice_id)
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_feedback
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_feedback (
	feedback_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
	patient_id VARCHAR2(10) NOT NULL , 
	rating FLOAT NOT NULL,
	practice_id VARCHAR2(10) NOT NULL,
	feedback_comment VARCHAR2(500) NULL, 
	CONSTRAINT feedback_pk PRIMARY KEY (feedback_id),
	CONSTRAINT feedback_ck CHECK (rating > 0 AND rating <= 5),
	CONSTRAINT feedback_patient_fk FOREIGN KEY(patient_id) REFERENCES F21_S001_22_patient(patient_id) ON DELETE CASCADE,
	CONSTRAINT feedback_practice_fk FOREIGN KEY(practice_id) REFERENCES F21_S001_22_practice(practice_id) ON DELETE CASCADE	
);


-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_employee
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_employee (
	emp_id VARCHAR2(10) NOT NULL , 
	fname VARCHAR2(30) NOT NULL, 
	lname VARCHAR2(30) NOT NULL, 
	job_role VARCHAR2(15) NOT NULL,
	salary DECIMAL(8,2) NULL, 
	hours_per_week INT NULL,
	ssn VARCHAR2(15) NOT NULL, 
	practice_id VARCHAR2(10) NOT NULL,
	CONSTRAINT employee_pk PRIMARY KEY(emp_id),
	CONSTRAINT employee_uk UNIQUE(emp_id, ssn),
	CONSTRAINT employee_job_role_ck CHECK (job_role = 'dentist' OR job_role = 'hygienist' OR job_role = 'technician' OR job_role = 'staff'), 
	CONSTRAINT employee_hours_per_week_ck CHECK (hours_per_week > 10 AND hours_per_week <= 48)
);


-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_employee_address
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_employee_address (
	emp_id VARCHAR2(10) NOT NULL , 
	add_type VARCHAR2(20) NOT NULL, 
	street VARCHAR2(50) NOT NULL, 
	city CHAR(25) NOT NULL, 
	zip INT NOT NULL, 
	CONSTRAINT employee_address_pk PRIMARY KEY (emp_id, add_type),
	CONSTRAINT employee_address_fk FOREIGN KEY(emp_id) REFERENCES F21_S001_22_employee(emp_id) ON DELETE CASCADE,
	CONSTRAINT employee_add_type_ck CHECK (add_type = 'office' OR add_type = 'home')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_dentist
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_dentist (
	emp_id VARCHAR2(10) NOT NULL , 
	specialization VARCHAR2(20) NOT NULL,
	CONSTRAINT dentist_pk PRIMARY KEY(emp_id),
	CONSTRAINT dentist_fk FOREIGN KEY(emp_id) REFERENCES F21_S001_22_employee(emp_id) ON DELETE CASCADE,
	CONSTRAINT dentist_ck CHECK (specialization = 'endodontist' OR specialization = 'orthodontist' OR specialization = 'periodontist' 
            OR specialization = 'prosthodontist' OR specialization = 'pedodontist')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_operatory
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_operatory (
	operatory_id VARCHAR2(10) NOT NULL , 
	room_no INT NOT NULL,  
	op_type VARCHAR2(20) NULL,
	practice_id VARCHAR2(10) NOT NULL,
	CONSTRAINT operatory_pk PRIMARY KEY(operatory_id),
	CONSTRAINT operatory_fk FOREIGN KEY(practice_id) REFERENCES F21_S001_22_practice(practice_id) ON DELETE CASCADE,
	CONSTRAINT operatory_ck CHECK (op_type = 'surgery' OR op_type = 'hygiene' OR op_type = 'treatment')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_treatment
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_treatment (
	tx_id VARCHAR2(10) NOT NULL, 
	tooth INT NOT NULL, 
	description VARCHAR2(60) NULL, 
	datetime DATE NOT NULL, 
	phase INT NOT NULL,
	tx_type VARCHAR2(10) NULL,
	surface VARCHAR2(10) NULL,
	status VARCHAR2(30) NOT NULL,
	operatory_id VARCHAR2(10) NOT NULL,
	patient_id VARCHAR2(10) NOT NULL,
	CONSTRAINT treatment_pk PRIMARY KEY(tx_id),
	CONSTRAINT treatment_op_fk FOREIGN KEY(operatory_id) REFERENCES F21_S001_22_operatory(operatory_id) ON DELETE CASCADE,
	CONSTRAINT treatment_pat_fk FOREIGN KEY(patient_id) REFERENCES F21_S001_22_patient(patient_id) ON DELETE CASCADE,
	CONSTRAINT treatment_tooth_ck CHECK (tooth > 0 AND tooth <= 32),
	CONSTRAINT treatment_tx_type_ck CHECK (tx_type = 'filling' OR tx_type = 'preventive' OR tx_type = 'crown' 
            OR tx_type = 'extraction' OR tx_type = 'implant' OR tx_type = 'braces'),
    CONSTRAINT treatment_surface_ck CHECK (surface = 'occlusal' OR surface = 'mesial' OR surface = 'distal'
            OR surface = 'buccal' OR surface = 'lingual'),
    CONSTRAINT treatment_status_ck CHECK (status = 'completed' OR status = 'payment-pending' OR status = 'payment-done' OR status = 'pending' 
            OR status = 'proposed' OR status = 'scheduled' OR status = 'pending-approval' OR status = 'canceled')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_treatment_doneby
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_treatment_doneby(
	tx_id VARCHAR2(10) NOT NULL,
	emp_id VARCHAR2(10) NOT NULL,
	CONSTRAINT treatment_doneby_pk PRIMARY KEY(tx_id, emp_id),
	CONSTRAINT treatment_doneby_emp_fk FOREIGN KEY(emp_id) REFERENCES F21_S001_22_employee(emp_id) ON DELETE CASCADE,
	CONSTRAINT treatment_doneby_tx_fk FOREIGN KEY(tx_id) REFERENCES F21_S001_22_treatment(tx_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_dependent
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_dependent(
	patient_id VARCHAR2(10) NOT NULL, 
	name VARCHAR2(20) NOT NULL,
	dob DATE NOT NULL,
	gender CHAR(1) NULL,
	relationship VARCHAR2(20) NOT NULL,
	CONSTRAINT dependent_pk PRIMARY KEY(patient_id, name),
	CONSTRAINT dependent_fk FOREIGN KEY(patient_id) REFERENCES F21_S001_22_patient(patient_id) ON DELETE CASCADE,
	CONSTRAINT dependent_gender_ck CHECK (gender = 'M' OR gender = 'F'),
	CONSTRAINT dependent_relationship_ck CHECK (relationship = 'son' OR relationship = 'daughter' OR relationship = 'spouse')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_lab_test
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_lab_test(
	test_id VARCHAR2(10) NOT NULL,
	name VARCHAR2(20) NOT NULL, 
	test_type VARCHAR2(10) NOT NULL,
	test_result VARCHAR2(100) NOT NULL, 
	status VARCHAR2(35) NOT NULL,  
    pat_amount decimal(6,2) NOT NULL,  
    practice_cost decimal(6,2) NOT NULL,
	emp_id VARCHAR2(10) NOT NULL,
	tx_id VARCHAR2(10) NOT NULL,
	CONSTRAINT lab_test_pk PRIMARY KEY(test_id),
	CONSTRAINT lab_test_emp_fk FOREIGN KEY(emp_id) REFERENCES F21_S001_22_employee(emp_id) ON DELETE CASCADE,
	CONSTRAINT lab_test_tx_fk FOREIGN KEY(tx_id) REFERENCES F21_S001_22_treatment(tx_id) ON DELETE CASCADE,
	CONSTRAINT lab_test_test_type_ck CHECK (test_type = 'diagnostic' OR test_type = 'bitewing' OR test_type = 'periapical'
            OR test_type = 'panoramic' OR test_type = 'tomography'), 
    CONSTRAINT lab_test_status_ck CHECK (status = 'completed' OR status = 'canceled' OR status = 'in-progress' OR status = 'payment-pending')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_treatment_drug
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_treatment_drug(
	tx_id VARCHAR2(10) NOT NULL, 
	drug_id VARCHAR2(10) NOT NULL,
	dosage VARCHAR2(10) NOT NULL, 
	days INT NOT NULL,
	CONSTRAINT treatment_drug_pk PRIMARY KEY(tx_id, drug_id),
	CONSTRAINT treatment_drug_tx_fk FOREIGN KEY(tx_id) REFERENCES F21_S001_22_treatment(tx_id) ON DELETE CASCADE,
	CONSTRAINT treatment_drug_fk FOREIGN KEY(drug_id) REFERENCES F21_S001_22_drug(drug_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_treatment_material
-- ---------------------------------------------------------------------

CREATE TABLE F21_S001_22_treatment_material(
	tx_id VARCHAR2(10) NOT NULL, 
	material_id VARCHAR2(10) NOT NULL,
	CONSTRAINT tx_material_fk FOREIGN KEY(material_id) REFERENCES F21_S001_22_material(material_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_appointment
-- ---------------------------------------------------------------------


CREATE TABLE F21_S001_22_appointment(
	appt_id VARCHAR2(10) NOT NULL, 
	datetime DATE NOT NULL,
	patient_id VARCHAR2(10) NOT NULL,
	emp_id VARCHAR2(10) NOT NULL, 
	status VARCHAR2(10) NOT NULL,
	CONSTRAINT appt_pk PRIMARY KEY(appt_id),
	CONSTRAINT appt_pat_fk FOREIGN KEY(patient_id) REFERENCES F21_S001_22_patient(patient_id) ON DELETE CASCADE,
	CONSTRAINT appt_emp_fk FOREIGN KEY(emp_id) REFERENCES F21_S001_22_employee(emp_id) ON DELETE CASCADE,
	CONSTRAINT appt_status_ck CHECK (status = 'scheduled' OR status = 'canceled' OR status = 'complete' OR status = 'noshow' OR status = 'confirmed')
);

-- ---------------------------------------------------------------------
-- Query to create table F21_S001_22_payment_plan
-- ---------------------------------------------------------------------


CREATE TABLE F21_S001_22_payment_plan(
	bill_id VARCHAR2(10) NOT NULL, 
	ins_amount DECIMAL(6,2) NOT NULL,
	pat_amount DECIMAL(6,2) NOT NULL, 
	status VARCHAR2(50) NOT NULL,
	datetime DATE NOT NULL,
	tx_id VARCHAR2(10) NOT NULL,
	CONSTRAINT plan_pk PRIMARY KEY(bill_id),
	CONSTRAINT plan_tx_fk FOREIGN KEY(tx_id) REFERENCES F21_S001_22_treatment(tx_id) ON DELETE CASCADE,
	CONSTRAINT plan_status_ck CHECK (status = 'patient-payment-pending' OR status = 'payment-done' OR status = 'insurance-payment-pending' 
        OR status = 'pending-insurance-approval' OR status = 'insurance-denied')
);

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- this add constraint query should only execute after inserting all the data into all tables - present in myDBinsert.sql file 
-- ---------------------------------------------------------------------------------------------
-- Query to add foreign key constraint in table F21_S001_22_practice and F21_S001_22_employee
-- ---------------------------------------------------------------------------------------------

-- ALTER TABLE F21_S001_22_practice ADD CONSTRAINT practice_fk FOREIGN KEY(mgr_emp_id) REFERENCES F21_S001_22_employee(emp_id) ON DELETE CASCADE;
-- ALTER TABLE F21_S001_22_employee ADD CONSTRAINT employee_fk FOREIGN KEY(practice_id) REFERENCES F21_S001_22_practice(practice_id) ON DELETE CASCADE,

-- ------------------------------------------------------------------------------------------------------------------------------------------





