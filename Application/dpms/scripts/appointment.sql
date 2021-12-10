SELECT 
	appt.APPT_ID AS apptid, 
	TO_CHAR(appt.DATETIME, 'DD Mon YYYY') AS apptdate,
	CONCAT(CONCAT(pat.FNAME,' '),pat.LNAME) AS patname,
	DECODE(emp.JOB_ROLE,'dentist', 'Dr. ', '')|| emp.FNAME|| ' '|| emp.LNAME AS empname,
	CASE WHEN appt.STATUS='complete' THEN 'Completed'
		WHEN appt.STATUS='noshow' THEN 'NoShow'
		WHEN appt.STATUS='scheduled' THEN 'Scheduled'
		WHEN appt.STATUS='confirmed' THEN 'Confirmed'
		WHEN appt.STATUS='canceled' THEN 'Canceled'
		END AS apptstatus,
	CONCAT(CONCAT(pract.PRACTICE_ID,'-'),pract.STREET) AS practiceloc
FROM F21_S001_22_APPOINTMENT appt 
	INNER JOIN F21_S001_22_PATIENT pat ON appt.PATIENT_ID = pat.PATIENT_ID 
	INNER JOIN F21_S001_22_EMPLOYEE emp ON appt.EMP_ID = emp.EMP_ID 
	INNER JOIN F21_S001_22_PRACTICE pract ON pract.PRACTICE_ID = emp.PRACTICE_ID 
ORDER BY appt.DATETIME DESC