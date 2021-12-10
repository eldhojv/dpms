from flask import flash
from flask.templating import render_template
from dpms import db_cursor
from dpms.utils import read_sql_script_from_file, sql_script_dir, make_filter_query

def dentist_data():
    file_name = sql_script_dir+'dentist.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchmany(30)
    return render_template('dentist_data.html', appts=rows)

def dentist_data_filter(request):
    empname = request.form.get('empname') if request.form.get('empname') != '' else None
    specs = request.form.get('specs') if request.form.get('specs') != '' else None
    practiceloc = request.form.get('location') if request.form.get('location') != '' else None
     
    file_name = sql_script_dir+'dentist.sql'
    script = read_sql_script_from_file(file_name)
    f_query = make_filter_query(script, empname=empname, specs=specs, practiceloc=practiceloc)

    rows = db_cursor.execute(f_query).fetchmany(30)
    return render_template('dentist_data.html', appts=rows)

def dentist_data_update(request):
    empid = request.form.get('empid')
    specs = request.form.get('specs') 
    update_script = "UPDATE F21_S001_22_DENTIST dent SET dent.SPECIALIZATION = '"+ specs +"' WHERE dent.EMP_ID = '"+empid+ "'"
    db_cursor.execute(update_script)

    file_name = sql_script_dir+'dentist.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    flash('updated', category='success')
    flash('Updated successfully', category='success')
    return render_template('dentist_data.html', appts=rows)

def dentist_data_delete(request):
    empid = request.form.get('empid')
    delete_script = "DELETE FROM F21_S001_22_DENTIST dent WHERE dent.EMP_ID = '"+ empid + "'"
    print(delete_script)
    db_cursor.execute(delete_script)

    file_name = sql_script_dir+'dentist.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    flash('deleted', category='success')
    flash('Deleted successfully', category='success')
    return render_template('dentist_data.html', appts=rows)




        