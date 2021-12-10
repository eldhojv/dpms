from flask import flash
from flask.templating import render_template
from dpms import db_cursor
from dpms.utils import read_sql_script_from_file, sql_script_dir, make_filter_query

def report1(request):
    file_name = sql_script_dir+'report1.sql'
    script = read_sql_script_from_file(file_name)
    rows = db_cursor.execute(script).fetchall()
    return render_template('report1.html', appts=rows)

def report2(request):
    print(request.form.get('days'))
    days = request.form.get('days') if request.form.get('days') != '' else None
    if days is None:
        days = str(12*30)
    else:
        days = days

    if request.form.get('optype') == '' or request.form.get('optype') is None:
        optype = 'hygiene' 
    else: 
        optype = request.form.get('optype')

    file_name = sql_script_dir+'report2.sql'
    script = read_sql_script_from_file(file_name)
    d_query = make_report2_query(script, days, optype)
    print(d_query)
    rows = db_cursor.execute(d_query).fetchmany(30)
    return render_template('report2.html', appts=rows)

def make_report2_query(script, days, optype):
    script = script.replace("#DAYSVAL#", days)
    script = script.replace("#OPERATORYTYPE#", optype)
    return script