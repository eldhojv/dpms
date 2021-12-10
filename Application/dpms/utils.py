import os
import re
from cx_Oracle import DatabaseError

sql_script_dir = os.getcwd()+"/dpms/scripts/"
table_list = ["APPOINTMENT","DENTIST","DEPENDENT","DRUG","EMPLOYEE","EMPLOYEE_ADDRESS","FEEDBACK","INSURANCE","LAB_TEST","MATERIAL","OPERATORY","PATIENT","PATIENT_INSURANCE","PAYMENT_PLAN","PRACTICE","TREATMENT","TREATMENT_DONEBY","TREATMENT_DRUG","TREATMENT_MATERIAL"]
reports_list = ["report1", "report2"]

def create_table(cursor):
    print("[Info] Creating tables")
    file_name = sql_script_dir+"create_tables.sql"
    execute_scripts_from_file(file_name, cursor, "create")
    return

def drop_table(cursor, dbuser):
    print("[Info] Droping tables")
    all_tables = ["F21_S001_22_" + x for x in table_list] 
    sql_query = "SELECT table_name FROM ALL_ALL_TABLES WHERE OWNER = '" + dbuser.upper() +"'"
    remote_tables = cursor.execute(sql_query).fetchall()
    for x in remote_tables:
        if x[0] in all_tables:
            drop_script = "DROP TABLE "+x[0]+" CASCADE CONSTRAINTS"
            try:
                # print("[Info] Dropping table: ", x[0])
                cursor.execute(drop_script)
            except DatabaseError as error:
                print("[Error] Failed to drop table", x[0], " Err:", error)
            
    return    


def insert_data(cursor):
    print("[Info] Inserting data to tables")
    file_name = sql_script_dir+"insert_data.sql"
    execute_scripts_from_file(file_name, cursor, "insert")
    modify_table(cursor)
    return

def modify_table(cursor):
    print("[Info] Modifying tables")
    file_name = sql_script_dir+"modify_tables.sql"
    execute_scripts_from_file(file_name, cursor, "modify")
    return

def execute_scripts_from_file(filename, cursor, type):
    print("[Info] Executing", type,"scripts from file")
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()
    sqlCommands = sqlFile.split(';')
    if not (re.findall(r"\BTABLE", sqlCommands[-1]) or re.findall(r"\BSELECT", sqlCommands[-1])) :
        sqlCommands = sqlCommands[:-1]
    for command in sqlCommands:
        try:
            # print("[Info] Executing SQL Command: ", command)
            cursor.execute(command)
        except DatabaseError as er:
            print("[Error] Failed to execute command", "Err:", er)
    return

def read_sql_script_from_file(filename):
    print("[Info] Reading file ", filename)
    fd = open(filename, 'r')
    sqlFile = fd.read()
    return sqlFile

def make_filter_query(script, **kwargs):
    query = [""]
    f_query = "SELECT * FROM (" + script +") "
    for key, value in kwargs.items():
        if value is not None: 
            query.append(("lower(%s) like lower('%%%s%%')" %(key, value)))
    query = ' AND '.join(query[1:]) 
    if query == "":
        return f_query
    return f_query+" WHERE "+query


    