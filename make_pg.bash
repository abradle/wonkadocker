service postgresql restart
su - postgres <<EOF
createdb wonka_db
psql<<EOSQL
ALTER USER POSTGRES PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE wonka_db TO postgres;
EOSQL
EOF
su - postgres <<EOF
psql wonka_db < /infile
EOF
