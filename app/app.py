from flask import Flask, render_template
import pyodbc

app = Flask(__name__)

def get_db_connection():
    # Connection string for your specific Azure SQL server
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=sql-server-aviator-maintenance.database.windows.net,1433;"
        "Database=db-airplane-maintenance;"
        "Authentication=ActiveDirectoryMsi;" # Uses AKS Managed Identity
        "Encrypt=yes;TrustServerCertificate=no;"
    )
    return pyodbc.connect(conn_str)

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    # Fetching the new columns you just seeded
    cursor.execute("SELECT LogID, TailNumber, Status, Component, PartHours, Details FROM MaintenanceLogs")
    rows = cursor.fetchall()
    conn.close()
    return render_template('index.html', rows=rows)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)