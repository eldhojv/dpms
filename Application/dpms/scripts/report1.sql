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
GROUP BY CUBE(CONCAT(CONCAT(fsp.PRACTICE_ID,'-'),fsp.CITY) , CONCAT(CONCAT(fse.FNAME, ' '), fse.LNAME))
ORDER BY (CONCAT(CONCAT(fse.FNAME, ' '), fse.LNAME)), (CONCAT(CONCAT(fsp.PRACTICE_ID,'-'),fsp.CITY))