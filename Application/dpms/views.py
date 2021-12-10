from flask import Blueprint, render_template, request, flash, redirect, url_for
from dpms.utils import table_list, reports_list
from dpms.appointment import *
from dpms.dentist import *
from dpms.dependent import *
from dpms.drug import *
from dpms.reports import *
from dpms import db_cursor

views = Blueprint('views', __name__)

@views.route('/')
def home():
    return render_template("home.html")

@views.route('/relations')
def relations():
    return render_template("relations.html", tables=table_list)

@views.route('/relations/<string:table_name>/update', methods=['POST'])
def relation_data_update(table_name):
    if table_name in table_list:
        rln_name = table_name.lower()+"_data_update"
        return globals()[rln_name](request)
    flash("Invalid request", category = 'danger')
    return redirect(url_for('views.home'))

@views.route('/relations/<string:table_name>/delete', methods=['POST'])
def relation_data_delete(table_name):
    if table_name in table_list:
        rln_name = table_name.lower()+"_data_delete"
        return globals()[rln_name](request)
    flash("invalid", category='danger')
    flash("Invalid request", category = 'danger')
    return redirect(url_for('views.home'))


@views.route('/relations/<string:table_name>/insert', methods=['POST'])
def relation_data_insert(table_name):
    if table_name in table_list:
        rln_name = table_name.lower()+"_data_insert"
        return globals()[rln_name](request)
    flash("invalid", category='danger')
    flash("Invalid request", category = 'danger')
    return redirect(url_for('views.home'))



@views.route('/relations/<string:table_name>', methods=['GET', 'POST'])
def relation_data(table_name):
    if table_name in table_list:
        rln_name = table_name.lower()+"_data"
        if request.method == 'POST':
            rln_name += '_filter'
            return globals()[rln_name](request)

        return globals()[rln_name]()
    
    return render_template("home.html")

@views.route('/reports')
def reports():
    return render_template("reports.html", data=reports_list)

@views.route('/reports/<string:report_num>', methods=['GET', 'POST'])
def report_data(report_num):
    if report_num in ['report1', 'report2']:
        return globals()[report_num](request)
    flash("invalid", category='danger')
    flash("Invalid request", category = 'danger')
    return redirect(url_for('views.home'))

