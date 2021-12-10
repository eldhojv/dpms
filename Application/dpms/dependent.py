from flask import flash
from flask.templating import render_template
from dpms import db_cursor
from dpms.utils import read_sql_script_from_file, sql_script_dir, make_filter_query

def dependent_data():
    file_name = sql_script_dir+'dependent.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchmany(30)
    return render_template('dependent_data.html', appts=rows)

def dependent_data_filter(request):
    deptname = request.form.get('deptname') if request.form.get('deptname') != '' else None
    dob = request.form.get('dob') if request.form.get('dob') != '' else None
    gender = request.form.get('gender') if request.form.get('gender') != '' else None
    patname = request.form.get('patient') if request.form.get('patient') != '' else None
    relationship = request.form.get('relationship') if request.form.get('relationship') != '' else None
     
    file_name = sql_script_dir+'dependent.sql'
    script = read_sql_script_from_file(file_name)
    f_query = make_filter_query(script, deptname=deptname, dob=dob, gender=gender,  patname=patname,  relationship=relationship)

    rows = db_cursor.execute(f_query).fetchmany(30)
    return render_template('dependent_data.html', appts=rows)

def dependent_data_update(request):
    deptid = request.form.get('deptid')
    deptname = request.form.get('deptname')
    gender = request.form.get('gender')
    relationship = request.form.get('relationship') 
    update_script = "UPDATE F21_S001_22_DEPENDENT dept SET dept.GENDER = '"+ gender +"', dept.RELATIONSHIP = '"+ relationship+"' WHERE dept.PATIENT_ID = '"+deptid+ "' AND dept.NAME = '"+ deptname +"'"
    print(update_script)
    db_cursor.execute(update_script)

    file_name = sql_script_dir+'dependent.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    flash('updated', category='success')
    flash('Updated successfully', category='success')
    return render_template('dependent_data.html', appts=rows)

def dependent_data_delete(request):
    deptid = request.form.get('deptid')
    deptname = request.form.get('deptname')
    delete_script = "DELETE FROM F21_S001_22_DEPENDENT dept WHERE dept.PATIENT_ID = '"+deptid+ "' AND dept.NAME = '"+ deptname +"'"
    print(delete_script)
    db_cursor.execute(delete_script)

    file_name = sql_script_dir+'dependent.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    flash('deleted', category='success')
    flash('Deleted successfully', category='success')
    return render_template('dependent_data.html', appts=rows)




        