# This Python script retrieves and prints out the table names and row counts
# of the database ./database/main.db
import duckdb

# Opens connection to the duckdb database
con = duckdb.connect('./database/nyc_transit.db')

# Gets a list of table names from the main schema (the only one schema for this database)
tables = con.sql('SELECT table_name FROM information_schema.tables').fetchall()

# Cycle thru the list of table names, for each table gets the row count
# and prints out the table name and the row count
# Formatting of thousand separator taken from: https://www.w3schools.com/python/ref_string_format.asp
for table in tables:
    row_count = con.sql('SELECT Count(*) FROM ' + table[0]).fetchall()
    out_line = "Table: {}, number of rows: {:,}".format(table[0], row_count[0][0])
    print(out_line)
