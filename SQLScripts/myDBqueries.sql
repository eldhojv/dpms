-- -------------------------------------------------------------------------------------------------------------------------------------
--•	1. Identify patients with more than 1 insurance denial and the distinct procedures 
-- that insurance doesn't cover for those patients
-- -------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	PatientName, 
	LISTAGG(TreatmentType, ',') WITHIN GROUP (ORDER BY 1) AS TreatmentProcedures 
FROM (
	SELECT 
		CONCAT(CONCAT(fsp.FNAME, ' '), fsp.LNAME) AS PatientName,
		procedures.TX_TYPE AS TreatmentType,
		ROW_NUMBER() OVER(PARTITION BY fsp.PATIENT_ID, procedures.TX_TYPE ORDER BY 1) AS TreatmentCount
	FROM (
			SELECT 
				fst2.PATIENT_ID, 
				fst2.TX_TYPE
			FROM F21_S001_22_TREATMENT fst2 
			INNER JOIN F21_S001_22_PAYMENT_PLAN fspp2 ON fspp2.TX_ID = fst2.TX_ID
			WHERE fspp2.STATUS = 'insurance-denied'
		) procedures, F21_S001_22_PATIENT fsp
	WHERE fsp.PATIENT_ID = procedures.PATIENT_ID 
		AND fsp.PATIENT_ID IN ( 
			SELECT 
				fst.PATIENT_ID
			FROM F21_S001_22_TREATMENT fst 
			WHERE fst.TX_ID IN (
				SELECT fspp.TX_ID FROM F21_S001_22_PAYMENT_PLAN fspp WHERE fspp.STATUS = 'insurance-denied'
			)
		GROUP BY fst.PATIENT_ID HAVING COUNT(fst.PATIENT_ID) > 1
	)
) WHERE TreatmentCount = 1 GROUP BY PatientName;

-- -------------------------------------------------------------------------------------------------------------------------------------
-- 2. Generate reports to find different lab tests taken by patients and the amount the patient is 
-- spending for each lab test. Also find the net profit generated for lab tests by all the practices 
-- -------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	COALESCE((
		SELECT CONCAT(CONCAT(pat.FNAME,' '),pat.LNAME) 
		FROM F21_S001_22_PATIENT pat 
		WHERE pat.PATIENT_ID = fsp.PATIENT_ID ),'GrandTotal'
	) AS PatientName,
	fslt.TEST_TYPE AS LabTestType,
	SUM(fslt.PAT_AMOUNT) AS PatientLabTestAmount,
	SUM(fslt.PRACTICE_COST) AS LabTestPracticeCost,
	SUM(fslt.PAT_AMOUNT-fslt.PRACTICE_COST) AS LabTestPracticeProfit
FROM F21_S001_22_LAB_TEST fslt
	INNER JOIN F21_S001_22_TREATMENT fst ON fslt.TX_ID = fst.TX_ID 
	INNER JOIN F21_S001_22_PATIENT fsp ON fst.PATIENT_ID = fsp.PATIENT_ID 
	INNER JOIN F21_S001_22_PAYMENT_PLAN fspp ON fspp.TX_ID = fst.TX_ID 
WHERE fslt.STATUS NOT IN ('canceled')
GROUP BY ROLLUP (fsp.PATIENT_ID, fslt.TEST_TYPE);

-- ------------------------------------------------------------------------------------------------------------------
-- 3. The practice owner can view the revenue and expenditures of different locations 
-- for 10 years along with the list of employees who contributed to the revenue in different locations
-- ------------------------------------------------------------------------------------------------------------------
SELECT 
	(CONCAT(CONCAT(fse.FNAME, ' '), fse.LNAME)) AS TreatmentDoneBy,
	(CONCAT(CONCAT(fsp.PRACTICE_ID,'-'),fsp.CITY)) AS PracticeName,
	SUM(PatientAmount) AS PatientAmount,
	SUM(PracticeCost) AS PracticeCost, 
	SUM(PracticeProfit) AS PracticeProfit
FROM (
	SELECT 
		fst.PATIENT_ID AS PatientID,
		fst.OPERATORY_ID AS Operatory,
		fstd2.EMP_ID AS TreatmentDoneBy,
		fsd.PAT_AMOUNT*fstd.DAYS*fstd.DOSAGE AS PatientAmount,
		fsd.DRUG_COST*fstd.DAYS*fstd.DOSAGE AS PracticeCost,
		(fsd.PAT_AMOUNT - fsd.DRUG_COST)*fstd.DAYS*fstd.DOSAGE AS PracticeProfit
	FROM F21_S001_22_TREATMENT fst  
		INNER JOIN F21_S001_22_TREATMENT_DRUG fstd ON fst.TX_ID = fstd.TX_ID 
		INNER JOIN F21_S001_22_DRUG fsd ON fstd.DRUG_ID = fsd.DRUG_ID 
		INNER JOIN F21_S001_22_TREATMENT_DONEBY fstd2 ON fst.TX_ID = fstd2.TX_ID
	WHERE fst.DATETIME > date'2007-11-27' AND fst.DATETIME < date'2017-05-31'
	UNION ALL
	SELECT 
		fst.PATIENT_ID AS PatientID,
		fst.OPERATORY_ID AS Operatory,
		fstd2.EMP_ID AS TreatmentDoneBy,
		fslt.PAT_AMOUNT AS PatientAmount,
		fslt.PRACTICE_COST AS PracticeCost,
		(fslt.PAT_AMOUNT - fslt.PRACTICE_COST) AS PracticeProfit
	FROM F21_S001_22_TREATMENT fst 
		INNER JOIN F21_S001_22_TREATMENT_DONEBY fstd2 ON fst.TX_ID = fstd2.TX_ID
		INNER JOIN F21_S001_22_LAB_TEST fslt ON fst.TX_ID = fslt.TX_ID 
	WHERE fst.DATETIME > date'2007-11-27' AND fst.DATETIME < date'2017-05-31'
	UNION ALL
	SELECT 
		fst.PATIENT_ID AS PatientID,
		fst.OPERATORY_ID AS Operatory,
		fstd2.EMP_ID AS TreatmentDoneBy,
		fsm.PAT_AMOUNT AS PatientAmount, 
		fsm.MATERIAL_COST AS PracticeCost,
		(fsm.PAT_AMOUNT - fsm.MATERIAL_COST) AS PracticeProfit
	FROM F21_S001_22_TREATMENT fst 
		INNER JOIN F21_S001_22_TREATMENT_MATERIAL fstm ON fst.TX_ID = fstm.TX_ID 
		INNER JOIN F21_S001_22_MATERIAL fsm ON fstm.MATERIAL_ID = fsm.MATERIAL_ID 
		INNER JOIN F21_S001_22_TREATMENT_DONEBY fstd2 ON fst.TX_ID = fstd2.TX_ID
	WHERE fst.DATETIME > date'2007-11-27' AND fst.DATETIME < date'2017-05-31'
)tempResult
INNER JOIN F21_S001_22_OPERATORY fso ON tempResult.Operatory = fso.OPERATORY_ID 
INNER JOIN F21_S001_22_PRACTICE fsp ON fso.PRACTICE_ID = fsp.PRACTICE_ID 
INNER JOIN F21_S001_22_EMPLOYEE fse ON tempResult.TreatmentDoneBy = fse.EMP_ID 
GROUP BY CUBE(CONCAT(CONCAT(fsp.PRACTICE_ID,'-'),fsp.CITY) , CONCAT(CONCAT(fse.FNAME, ' '), fse.LNAME));

-- ------------------------------------------------------------------------------------------------------------------
-- 4. Find the patient list and their outstanding balance who has either canceled or not shown for the appointment more 
-- than twice and the payment is pending for those patients for the treatments they have taken in the dental practice
-- ------------------------------------------------------------------------------------------------------------------

SELECT 
	fsp.PATIENT_ID AS PatientID,
	CONCAT(CONCAT(fsp.FNAME, ' '), fsp.LNAME) AS PatientName,
	SUM(fspp.INS_AMOUNT) AS InsuranceOutstanding,
	SUM(fspp.PAT_AMOUNT) AS PatientOutstanding
FROM F21_S001_22_TREATMENT fst 
	INNER JOIN F21_S001_22_PAYMENT_PLAN fspp ON fst.TX_ID = fspp.TX_ID 
	INNER JOIN F21_S001_22_PATIENT fsp ON fst.PATIENT_ID = fsp.PATIENT_ID 
WHERE fst.STATUS = 'payment-pending' AND fspp.STATUS IN ('pending-insurance-approval', 'patient-payment-pending', 'insurance-denied')
AND fst.PATIENT_ID IN (
	SELECT 
		fsa.PATIENT_ID
	FROM F21_S001_22_APPOINTMENT fsa 
	WHERE fsa.STATUS IN ('noshow', 'canceled')
	GROUP BY fsa.PATIENT_ID HAVING COUNT(1) > 2
)GROUP BY fsp.PATIENT_ID, CONCAT(CONCAT(fsp.FNAME, ' '), fsp.LNAME);


--- ------------------------------------------------------------------------------------------------------------------
-- 5. Find the practice which does the most treatments and the type of treatment which is done more often 
-- in that practice in a given date range
-- ------------------------------------------------------------------------------------------------------------------

SELECT 
	TX_TYPE AS TreatmentName, 
	(SELECT CONCAT(CONCAT(fsp2.PRACTICE_ID, '-'), fsp2.STREET) 
	FROM F21_S001_22_PRACTICE fsp2 
	WHERE fsp2.PRACTICE_ID = tempRes.PRACTICE_ID) AS PracticeName,
	MAX(NumOfT) AS NumberOfTreatments
FROM (
	SELECT 
		fst.TX_TYPE,
		fso.PRACTICE_ID,
		ROW_NUMBER() OVER(PARTITION BY fst.TX_TYPE, fso.PRACTICE_ID ORDER BY 1) AS NumOfT
	FROM F21_S001_22_TREATMENT fst 
		INNER JOIN F21_S001_22_OPERATORY fso ON fst.OPERATORY_ID = fso.OPERATORY_ID 
		INNER JOIN F21_S001_22_PRACTICE fsp ON fso.PRACTICE_ID = fsp.PRACTICE_ID 
		WHERE fst.DATETIME > date'2007-11-27' AND fst.DATETIME < date'2017-05-31'
	ORDER BY PRACTICE_ID DESC) tempRes
GROUP BY TX_TYPE, PRACTICE_ID ORDER BY MAX(NumOfT) DESC;


-- ------------------------------------------------------------------------------------------------------------------
-- 6. Find the patients which did extraction procedure or was allocated to surgery operatory in the
-- last year and was taking drug medications. Also get the drug details they were taking during those period
-- ------------------------------------------------------------------------------------------------------------------

SELECT 
	CONCAT(CONCAT(fsp.FNAME, ' '), fsp.LNAME) AS PatientName, 
	fsd.NAME AS DrugName, 
	fsd.DRUG_TYPE AS DrugType
FROM (
	SELECT * 
	FROM F21_S001_22_TREATMENT fst 
	WHERE fst.DATETIME > SYSDATE - 365 AND (TX_TYPE = 'extraction' 
		OR OPERATORY_ID IN 	
		(SELECT fso.OPERATORY_ID 
		FROM F21_S001_22_OPERATORY fso 
		WHERE fso.OP_TYPE = 'surgery'))
	) treatmentProcedure
INNER JOIN F21_S001_22_TREATMENT_DRUG fstd ON treatmentProcedure.TX_ID = fstd.TX_ID 
INNER JOIN F21_S001_22_PATIENT fsp ON treatmentProcedure.PATIENT_ID = fsp.PATIENT_ID 
INNER JOIN F21_S001_22_DRUG fsd ON fstd.DRUG_ID = fsd.DRUG_ID ;

-- ------------------------------------------------------------------------------------------------------------------
-- 7. Find the practice that has least average rating and the number of ratings the practice has
-- ------------------------------------------------------------------------------------------------------------------

SELECT 
	CONCAT(CONCAT(fsp.PRACTICE_ID, '-'), fsp.STREET) AS PracticeName, 
	ROUND(ratingInfo.rating, 2) AS averageRaging
FROM (
	SELECT fsf.PRACTICE_ID, AVG(fsf.RATING) AS rating
	FROM F21_S001_22_FEEDBACK fsf 
GROUP BY fsf.PRACTICE_ID ) ratingInfo
INNER JOIN F21_S001_22_PRACTICE fsp ON ratingInfo.PRACTICE_ID = fsp.PRACTICE_ID 
ORDER BY averageRaging ASC;

-- ------------------------------------------------------------------------------------------------------------------
-- 8. Find the number of employees and the location where the practice that has employees earning more than
-- 50k and works more than 42 hours per week. Also find the employee name and the location where they work
-- ------------------------------------------------------------------------------------------------------------------

SELECT 
	CONCAT(CONCAT(fsp.PRACTICE_ID,'-'),fsp.STREET) AS PracticeLocation,
	ROW_NUMBER() OVER(PARTITION BY fse.PRACTICE_ID ORDER BY 1) AS NumberOfEmployees,
	CONCAT(CONCAT(fse.FNAME, ' '),fse.LNAME) AS EmployeeName
FROM F21_S001_22_EMPLOYEE fse
	INNER JOIN F21_S001_22_PRACTICE fsp ON fse.PRACTICE_ID = fsp.PRACTICE_ID 
WHERE fse.SALARY > 50000 AND fse.HOURS_PER_WEEK > 42;

-- ------------------------------------------------------------------------------------------------------------------
-- 9. Find the patients that has done procedures in the hygiene operatory in 
-- last 12 months and the total collection amount the practice getting from those 
-- ------------------------------------------------------------------------------------------------------------------


SELECT  
	(SELECT CONCAT(CONCAT(fsp.FNAME, ' '), fsp.LNAME) 
		FROM F21_S001_22_PATIENT fsp 
		WHERE fsp.PATIENT_ID=fst3.PATIENT_ID) AS PatientID,
	SUM(fspp.PAT_AMOUNT + fspp.INS_AMOUNT) AS PracticeRevenue 
FROM F21_S001_22_PAYMENT_PLAN fspp 
	INNER JOIN F21_S001_22_TREATMENT fst3 ON fspp.TX_ID = fspp.TX_ID 
WHERE fspp.TX_ID IN (
SELECT fst.TX_ID 
FROM F21_S001_22_TREATMENT fst 
WHERE fst.DATETIME > SYSDATE - 365
	AND fst.OPERATORY_ID IN (SELECT fso.OPERATORY_ID 
		FROM F21_S001_22_OPERATORY fso 
		WHERE fso.OP_TYPE = 'hygiene')
) GROUP BY fst3.PATIENT_ID;

