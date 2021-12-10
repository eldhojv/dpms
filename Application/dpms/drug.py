from flask import flash
from flask.templating import render_template
from dpms import db_cursor
import cx_Oracle
from dpms.utils import insert_data, read_sql_script_from_file, sql_script_dir, make_filter_query

def drug_data():
    script = "SELECT d.DRUG_ID, d.NAME, d.DRUG_TYPE, d.PAT_AMOUNT, d.DRUG_COST FROM F21_S001_22_DRUG d"
    rows = db_cursor.execute(script).fetchmany(30)
    return render_template('drug_data.html', appts=rows)

def drug_data_filter(request):
    drugid = request.form.get('drugid') if request.form.get('drugid') != '' else None
    drugname = request.form.get('drugname') if request.form.get('drugname') != '' else None
    drugtype = request.form.get('drugtype') if request.form.get('drugtype') != '' else None
    patamount = request.form.get('patamount') if request.form.get('patamount') != '' else None
    drugcost = request.form.get('drugcost') if request.form.get('drugcost') != '' else None
     
    script = "SELECT d.DRUG_ID AS drugid, d.NAME AS drugname, d.DRUG_TYPE AS drugtype , d.PAT_AMOUNT as patamount, d.DRUG_COST as drugcost FROM F21_S001_22_DRUG d"
    f_query = make_filter_query(script, drugid=drugid, drugname=drugname, drugtype=drugtype, patamount=patamount, drugcost=drugcost)

    rows = db_cursor.execute(f_query).fetchmany(30)
    return render_template('drug_data.html', appts=rows)

def drug_data_update(request):
    drugid = request.form.get('drugid') if request.form.get('drugid') != '' else None
    drugname = request.form.get('drugname') if request.form.get('drugname') != '' else None
    drugtype = request.form.get('drugtype') if request.form.get('drugtype') != '' else None
    patamount = request.form.get('patamount') if request.form.get('patamount') != '' else None
    drugcost = request.form.get('drugcost') if request.form.get('drugcost') != '' else None

    print(drugid, drugname, drugtype, patamount, drugcost)
    
    update_script = "UPDATE F21_S001_22_DRUG d SET d.NAME = '"+ drugname +"', d.DRUG_TYPE = '"+drugtype+"', d.PAT_AMOUNT="+patamount+", d.DRUG_COST="+drugcost+" WHERE d.DRUG_ID = '"+drugid+ "'"
    db_cursor.execute(update_script)

    script = "SELECT d.DRUG_ID AS drugid, d.NAME AS drugname, d.DRUG_TYPE AS drugtype , d.PAT_AMOUNT as patamount, d.DRUG_COST as drugcost FROM F21_S001_22_DRUG d"
    rows = db_cursor.execute(script).fetchall()
    flash('updated', category='success')
    flash('Updated successfully', category='success')
    return render_template('drug_data.html', appts=rows)

def drug_data_delete(request):
    drugid = request.form.get('drugid')
    delete_script = "DELETE FROM F21_S001_22_DRUG d WHERE d.DRUG_ID = '"+ drugid + "'"
    db_cursor.execute(delete_script)
    
    script = "SELECT d.DRUG_ID AS drugid, d.NAME AS drugname, d.DRUG_TYPE AS drugtype , d.PAT_AMOUNT as patamount, d.DRUG_COST as drugcost FROM F21_S001_22_DRUG d"
    rows = db_cursor.execute(script).fetchall()
    flash('deleted', category='success')
    flash('Deleted successfully', category='success')
    return render_template('drug_data.html', appts=rows)


def drug_data_insert(request):
    drugid = request.form.get('drugid') if request.form.get('drugid') != '' else None
    drugname = request.form.get('drugname') if request.form.get('drugname') != '' else None
    drugtype = request.form.get('drugtype') if request.form.get('drugtype') != '' else None
    patamount = request.form.get('patamount') if request.form.get('patamount') != '' else None
    drugcost = request.form.get('drugcost') if request.form.get('drugcost') != '' else None

    insert_script = "INSERT INTO F21_S001_22_DRUG (DRUG_ID, NAME, DRUG_TYPE, PAT_AMOUNT, DRUG_COST) VALUES('"+drugid+"', '"+drugname+"', '"+drugtype+"', "+patamount+", "+drugcost+")"
    try:
        db_cursor.execute(insert_script)
        flash('inserted', category='success')
        flash('New record inserted successfully', category='success')
    except cx_Oracle.DatabaseError as e:
        errorstr = "Error"+str(e)
        flash('warning', category='danger')
        flash(errorstr, category='danger')
    script = "SELECT d.DRUG_ID AS drugid, d.NAME AS drugname, d.DRUG_TYPE AS drugtype , d.PAT_AMOUNT as patamount, d.DRUG_COST as drugcost FROM F21_S001_22_DRUG d"
    rows = db_cursor.execute(script).fetchall()
    return render_template('drug_data.html', appts=rows)


        