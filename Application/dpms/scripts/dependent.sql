SELECT 
    dept.PATIENT_ID AS patid,
	dept.NAME AS deptname,
	TO_CHAR(dept.DOB, 'DD Mon YYYY') AS dob,
	CASE WHEN dept.GENDER = 'M' THEN 'Male'
		WHEN dept.GENDER = 'F' THEN 'Female' END AS gender,
	CASE WHEN dept.RELATIONSHIP = 'son' THEN 'Son'
		WHEN dept.RELATIONSHIP = 'daughter' THEN 'Daughter'
		WHEN dept.RELATIONSHIP = 'spouse' THEN 'Spouse' END AS relationship,
	CONCAT(CONCAT(pat.FNAME,' '),pat.LNAME) AS patname
FROM F21_S001_22_DEPENDENT dept 
INNER JOIN F21_S001_22_PATIENT pat ON dept.PATIENT_ID = pat.PATIENT_ID 