import os
import sys
import cx_Oracle
from flask import Flask
from dpms.utils import create_table, drop_table, insert_data
from dotenv import load_dotenv

path = os.getcwd()+'/dpms/config/.env' 
load_dotenv(path)

# load_dotenv()

HOST = os.getenv('HOST')
PORT = os.getenv('HOST_PORT')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
SECRET_KEY = os.getenv('SECRET_KEY')
DSN = HOST+":"+PORT+"/"+DB_NAME

db_cursor = None

def connect_db():
    try: 
        global db_cursor
        connection = cx_Oracle.connect(user=DB_USER, password=DB_PASSWORD, dsn=DSN, encoding="UTF-8")
        db_cursor = connection.cursor()
        print("====== omega connection successfull ======")
    except cx_Oracle.DatabaseError as e:
        print("[Error] There is a problem connecting omega serve: ", e)
    return

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = SECRET_KEY
    connect_db()

    from dpms.views import views

    app.register_blueprint(views, url_prefix='/')    

    create_database(db_cursor)

    return app


def create_database(db_cursor):
    rows = db_cursor.execute('SELECT count(*) FROM ALL_ALL_TABLES WHERE OWNER = \'EXJ6525\'').fetchone()
    print("[Info] Table count = ", rows[0])
    if rows[0] != 0:
        drop_table(db_cursor, DB_USER)
    create_table(db_cursor)
    insert_data(db_cursor)
    print('[Info] Created Database!')
    return