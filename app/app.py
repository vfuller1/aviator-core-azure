import pyodbc
from flask import Flask, render_template

app = Flask(__name__)

def get_db_connection():
    # We switch to 'Authentication=ActiveDirectoryManagedIdentity'
    # This tells the driver to use the VM's identity directly
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=sql-server-aviator-maintenance.database.windows.net,1433;"
        "Database=db-airplane-maintenance;"
        "UID=a58e6bd1-f10e-4cd6-bd86-9aa8f641e5a3;" # Your Managed Identity Client ID
        "Authentication=ActiveDirectoryManagedIdentity;"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
    )
    return pyodbc.connect(conn_str)

@app.route('/')
def index():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        # Fetching your 280 verified records
        cursor.execute("SELECT LogID, TailNumber, Status, Component, PartHours, Details FROM dbo.MaintenanceLogs")
        rows = cursor.fetchall()
        conn.close()
        return render_template('index.html', rows=rows)
    except Exception as e:
        print(f"!!! NEW STRATEGY FAILURE: {str(e)}")
        return f"Database Error: {str(e)}", 500