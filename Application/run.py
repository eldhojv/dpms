#---------------------------------------------------------
#
# Author : Eldho Joy 
# Written Date   : 12/02/2021
# Modified date : 
# Practice management system - connects with remote server 
# and executes dynamic SQL query and displays results
#---------------------------------------------------------

from dpms import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
