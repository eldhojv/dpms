SELECT 
	dent.EMP_ID AS empid,
	DECODE(emp.JOB_ROLE,'dentist', 'Dr. ', '')|| emp.FNAME|| ' '|| emp.LNAME AS empname,
	CASE WHEN dent.SPECIALIZATION='prosthodontist' THEN 'Prosthodontist'
		WHEN dent.SPECIALIZATION='pedodontist' THEN 'Pedodontist'
		WHEN dent.SPECIALIZATION='orthodontist' THEN 'Orthodontist'
		WHEN dent.SPECIALIZATION='periodontist' THEN 'Periodontist'
		WHEN dent.SPECIALIZATION='endodontist' THEN 'Endodontist'
		END AS specs,
	CONCAT(CONCAT(pract.PRACTICE_ID,'-'),pract.STREET) AS practiceloc
FROM F21_S001_22_DENTIST dent 
INNER JOIN F21_S001_22_EMPLOYEE emp ON dent.EMP_ID = emp.EMP_ID 
INNER JOIN F21_S001_22_PRACTICE pract ON emp.PRACTICE_ID = pract.PRACTICE_ID 
