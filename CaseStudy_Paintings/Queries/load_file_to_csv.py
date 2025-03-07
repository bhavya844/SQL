import pandas as pd
from sqlalchemy import create_engine

conn_string = 'mysql://<DB_user>:<DB_password>@<DB_host>:<DB_port>/<DB_name>'
db = create_engine(conn_string)
conn = db.connect()


#specify the name of the files here
files = ['product_size','work']

for file in files:
    df = pd.read_csv(f'path/to/the/file/{file}.csv')
    df.to_sql(file, con=conn, if_exists='replace', index=False)
