name = 'wonka_db'
backend = 'django.db.backends.postgresql_psycopg2'
password = 'postgres'
user = 'postgres'
host = 'localhost'
port = '5432'
extra_apps = ['IOhandle',
    'Pharmacophore',
    'MMPMaker',
    'Viewer',
    'gunicorn',
    'OOMMPPAA',
    'jfu',
    'south',
    "WONKA"]
