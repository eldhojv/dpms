-- ----------------------------------------------------------------------------------------------------------------------
-- Query to update table F21_S001_22_payment_plan and edit the 
-- patient 'Jacinthe Burke' and make the payment status as 'patient-payment-pending'
-- ----------------------------------------------------------------------------------------------------------------------

UPDATE F21_S001_22_PAYMENT_PLAN fspp 
SET fspp.STATUS = 'patient-payment-pending'
WHERE fspp.TX_ID IN (
	SELECT 
		fst.TX_ID 
	FROM F21_S001_22_TREATMENT fst 
	WHERE fst.PATIENT_ID IN ('pat5020')
) AND fspp.STATUS = 'insurance-denied';


-- ----------------------------------------------------------------------------------------------------------------------
-- Query to update table F21_S001_22_lab_test and edit the 
-- payment status to completed for the test that are in bitewing and tomography
-- ----------------------------------------------------------------------------------------------------------------------

UPDATE F21_S001_22_LAB_TEST fslt 
SET STATUS = 'completed'
WHERE TEST_TYPE IN ('bitewing', 'tomography') AND STATUS = 'payment-pending';


-- ----------------------------------------------------------------------------------------------------------------------
-- Query to delete values from table F21_S001_22_EMPLOYEE and F21_S001_22_PRACTICE
-- ----------------------------------------------------------------------------------------------------------------------

DELETE FROM F21_S001_22_EMPLOYEE fse WHERE fse.EMP_ID IN ('emp1035', 'emp1011', 'emp1001', 'emp1020', 'emp1005', 'emp1015');
DELETE FROM F21_S001_22_PRACTICE fsp WHERE fsp.PRACTICE_ID IN ('p701', 'p702', 'p703');


-- ----------------------------------------------------------------------------------------------------------------------
-- Query to insert values to table F21_S001_22_APPOINTMENT
-- ----------------------------------------------------------------------------------------------------------------------

INSERT INTO F21_S001_22_APPOINTMENT
(APPT_ID, DATETIME, PATIENT_ID, EMP_ID, STATUS)
VALUES('appt351', TIMESTAMP '2021-06-02 00:00:00.000000', 'pat5026', 'emp1020', 'noshow');
INSERT INTO F21_S001_22_APPOINTMENT
(APPT_ID, DATETIME, PATIENT_ID, EMP_ID, STATUS)
VALUES('appt352', TIMESTAMP '2021-05-02 00:00:00.000000', 'pat5026', 'emp1008', 'noshow');
INSERT INTO F21_S001_22_APPOINTMENT
(APPT_ID, DATETIME, PATIENT_ID, EMP_ID, STATUS)
VALUES('appt353', TIMESTAMP '2021-03-02 00:00:00.000000', 'pat5044', 'emp1026', 'canceled');
INSERT INTO F21_S001_22_APPOINTMENT
(APPT_ID, DATETIME, PATIENT_ID, EMP_ID, STATUS)
VALUES('appt354', TIMESTAMP '2021-03-02 00:00:00.000000', 'pat5044', 'emp1008', 'canceled');


-- ----------------------------------------------------------------------------------------------------------------------
-- Query to insert values to table F21_S001_22_TREATMENT
-- ----------------------------------------------------------------------------------------------------------------------

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx151', 21, 'Dulsog ridgwayi', TIMESTAMP '2009-02-12 00:00:00.000000', 4, 'preventive', 'occlusal', 'completed', 'opt612', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx152', 12, 'Gostesr', TIMESTAMP '2009-03-12 00:00:00.000000', 3, 'preventive', 'mesial', 'completed', 'opt611', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx153', 23, 'Minopiay ridgwayi', TIMESTAMP '2009-02-13 00:00:00.000000', 1, 'preventive', 'distal', 'completed', 'opt610', 'pat5014');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx154', 11, 'Histosl', TIMESTAMP '2009-04-12 00:00:00.000000', 1, 'preventive', 'occlusal', 'completed', 'opt612', 'pat5024');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx155', 10, 'Plegstol', TIMESTAMP '2009-05-02 00:00:00.000000', 2, 'preventive', 'buccal', 'completed', 'opt611', 'pat5003');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx156', 8, 'Rigowayi', TIMESTAMP '2009-03-07 00:00:00.000000', 3, 'preventive', 'mesial', 'completed', 'opt610', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx157', 21, 'Mesiale ridgwayi', TIMESTAMP '2009-02-12 00:00:00.000000', 4, 'filling', 'occlusal', 'completed', 'opt619', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx158', 12, 'Histolesr', TIMESTAMP '2009-03-12 00:00:00.000000', 3, 'filling', 'mesial', 'completed', 'opt620', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx159', 23, 'Jokls ridgwayi', TIMESTAMP '2009-02-13 00:00:00.000000', 1, 'filling', 'distal', 'completed', 'opt621', 'pat5014');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx160', 11, 'Howldkf', TIMESTAMP '2009-04-12 00:00:00.000000', 1, 'filling', 'occlusal', 'completed', 'opt619', 'pat5024');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx161', 10, 'Gootch', TIMESTAMP '2009-05-02 00:00:00.000000', 2, 'filling', 'buccal', 'completed', 'opt620', 'pat5003');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx162', 8, 'Timeox', TIMESTAMP '2009-03-07 00:00:00.000000', 3, 'filling', 'mesial', 'completed', 'opt621', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx163', 21, 'Mesiale ridgwayi', TIMESTAMP '2009-02-12 00:00:00.000000', 4, 'extraction', 'occlusal', 'completed', 'opt601', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx164', 12, 'Histolesr', TIMESTAMP '2009-03-12 00:00:00.000000', 3, 'extraction', 'mesial', 'completed', 'opt602', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx165', 23, 'Jokls ridgwayi', TIMESTAMP '2009-02-13 00:00:00.000000', 1, 'extraction', 'distal', 'completed', 'opt603', 'pat5014');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx166', 11, 'Howldkf', TIMESTAMP '2009-04-12 00:00:00.000000', 1, 'extraction', 'occlusal', 'completed', 'opt601', 'pat5024');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx167', 10, 'Gootch', TIMESTAMP '2009-05-02 00:00:00.000000', 2, 'extraction', 'buccal', 'completed', 'opt602', 'pat5003');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx168', 8, 'Timeox', TIMESTAMP '2009-03-07 00:00:00.000000', 3, 'extraction', 'mesial', 'completed', 'opt603', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx169', 21, 'Mesiale ridgwayi', TIMESTAMP '2009-02-12 00:00:00.000000', 4, 'extraction', 'occlusal', 'completed', 'opt604', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx170', 12, 'Histolesr', TIMESTAMP '2009-03-12 00:00:00.000000', 3, 'extraction', 'mesial', 'completed', 'opt605', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx171', 23, 'Jokls ridgwayi', TIMESTAMP '2009-02-13 00:00:00.000000', 1, 'extraction', 'distal', 'completed', 'opt606', 'pat5014');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx172', 11, 'Howldkf', TIMESTAMP '2009-04-12 00:00:00.000000', 1, 'extraction', 'occlusal', 'completed', 'opt604', 'pat5024');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx173', 10, 'Gootch', TIMESTAMP '2009-05-02 00:00:00.000000', 2, 'extraction', 'buccal', 'completed', 'opt605', 'pat5003');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx174', 8, 'Timeox', TIMESTAMP '2009-03-07 00:00:00.000000', 3, 'extraction', 'mesial', 'completed', 'opt606', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx175', 21, 'Mesiale ridgwayi', TIMESTAMP '2009-02-12 00:00:00.000000', 4, 'crown', 'occlusal', 'completed', 'opt619', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx176', 12, 'Histolesr', TIMESTAMP '2009-03-12 00:00:00.000000', 3, 'crown', 'mesial', 'completed', 'opt620', 'pat5004');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx177', 23, 'Jokls ridgwayi', TIMESTAMP '2009-02-13 00:00:00.000000', 1, 'crown', 'distal', 'completed', 'opt621', 'pat5014');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx178', 11, 'Howldkf', TIMESTAMP '2009-04-12 00:00:00.000000', 1, 'crown', 'occlusal', 'completed', 'opt619', 'pat5024');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx179', 10, 'Gootch', TIMESTAMP '2009-05-02 00:00:00.000000', 2, 'crown', 'buccal', 'completed', 'opt620', 'pat5003');

INSERT INTO F21_S001_22_TREATMENT
(TX_ID, TOOTH, DESCRIPTION, DATETIME, PHASE, TX_TYPE, SURFACE, STATUS, OPERATORY_ID, PATIENT_ID)
VALUES('tx180', 8, 'Timeox', TIMESTAMP '2009-03-07 00:00:00.000000', 3, 'crown', 'mesial', 'completed', 'opt621', 'pat5004');

-- ----------------------------------------------------------------------------------------------------------------------
-- Query to insert values to table F21_S001_22_OPERATORY
-- ----------------------------------------------------------------------------------------------------------------------

DELETE FROM F21_S001_22_OPERATORY fso WHERE fso.OP_TYPE = 'surgery';



