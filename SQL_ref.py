import pyodbc

"""
This file contains the method for connecting to a Microsoft Access database as well as SQL scripts to interact with the database.
There are 2 ways of interacting with a database depending on your style of scripting. 
For other database drivers and information see https://github.com/mkleehammer/pyodbc/wiki

"""


# 1. The step by step process

# Defining component for connection
access_driver = '{Microsoft Access Driver (*.mdb, *.accdb)}'
filepath = ''

# Creating connection
cnxn = pyodbc.connect(driver=access_driver, dbq=filepath, autocommit=True)
crsr = cnxn.cursor()

# Interacting with database tables

# Select table

table1 = ""
sql_query1 = "SELECT * FROM {}".FORMAT(table1)

# Run query
crsr.execute(sql_query1)  # Query data is in the crsr object

# Create a variable to store data in crsr
data = crsr.fetchall()

# Display results
print(data[:5])  # Shows first 5 items in the list
print(data[-5:])  # Shows last 5 items in the list

# Close the cnxn
cnxn.close()


# 2. The concise way to interact with a database

# Defining component for connection
access_driver = '{Microsoft Access Driver (*.mdb, *.accdb)}'
filepath = ''
table2 = ""
sql_query2 = "SELECT * FROM {}".FORMAT(table2)


# Concise format
with pyodbc.connect(driver=access_driver, dbq=filepath, autocommit=True) as cnxn:
    crsr = cnxn.cursor()
    crsr.execute(sql_query2)
    data = crsr.fetchall()

# Display results
print(data[:5])  # Shows first 5 items in the list of named Tuple
print(data[-5:])  # Shows last 5 items in the list of named Tuple
