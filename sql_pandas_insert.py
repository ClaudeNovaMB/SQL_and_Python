import pyodbc
import os
import pandas as pd

# Build a dataframe
df = pd.DataFrame()  # etc

def insertDB(df):

    # Defining component for connection
    access_driver = '{Microsoft Access Driver (*.mdb, *.accdb)}'
    filepath = os.getcwd() + '\\databaseName.accdb'  # Name your database
    data_dict = df.to_dict('records')

    # Concise format
    with pyodbc.connect(driver=access_driver, dbq=filepath, autocommit=True) as cnxn:
        crsr = cnxn.cursor()
        for i in data_dict:
            h, v = i.keys(), i.values()
            # Ensure your dataframe column names are the same as your database field names!
            h = ", ".join(["`" + i + "`" for i in h])
            v = ", ".join(["'" + str(i) + "'" for i in v])
            sql_query = '''INSERT INTO TBL_name ({}) # Name of your table
                   VALUES ({});'''.format(h, v)
            crsr.execute(sql_query)
        cnxn.commit()
