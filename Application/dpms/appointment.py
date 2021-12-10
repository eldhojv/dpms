from flask import flash
from flask.templating import render_template
from dpms import db_cursor
from dpms.utils import read_sql_script_from_file, sql_script_dir, make_filter_query

def appointment_data():
    file_name = sql_script_dir+'appointment.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchmany(30)
    return render_template('appointment_data.html', appts=rows)

def appointment_data_filter(request):
    patient_name = request.form.get('patientname') if request.form.get('patientname') != '' else None 
    employee_name = request.form.get('empname') if request.form.get('empname') != '' else None
    appointment_date = request.form.get('date') if request.form.get('date') != '' else None
    appointment_status = request.form.get('status') if request.form.get('status') != '' else None
    practice_name = request.form.get('location') if request.form.get('location') != '' else None
     
    file_name = sql_script_dir+'appointment.sql'
    script = read_sql_script_from_file(file_name)
    f_query = make_filter_query(script, apptdate=appointment_date, patname=patient_name, empname=employee_name, apptstatus=appointment_status, practiceloc=practice_name)

    rows = db_cursor.execute(f_query).fetchmany(30)
    return render_template('appointment_data.html', appts=rows)

def appointment_data_update(request):
    apptid = request.form.get('apptid')
    apptstatus = request.form.get('status') 
    update_script = "UPDATE F21_S001_22_APPOINTMENT appt SET appt.STATUS = '"+ apptstatus+"' WHERE appt.APPT_ID = '"+apptid + "'"
    db_cursor.execute(update_script)

    file_name = sql_script_dir+'appointment.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    flash('updated', category='success')
    flash('Updated successfully', category='success')
    return render_template('appointment_data.html', appts=rows)

def appointment_data_delete(request):
    apptid = request.form.get('apptid')
    delete_script = "DELETE FROM F21_S001_22_APPOINTMENT appt WHERE appt.APPT_ID = '"+apptid + "'"
    print(delete_script)
    db_cursor.execute(delete_script)

    file_name = sql_script_dir+'appointment.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    flash('updated', category='success')
    flash('Deleted successfully', category='success')
    return render_template('appointment_data.html', appts=rows)




        