from flask import Flask, render_template
import pyodbc
import os

app = Flask(__name__)

def get_db_connection():
    # Updated for Workload Identity Federation
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=sql-server-aviator-maintenance.database.windows.net,1433;"
        "Database=db-airplane-maintenance;"
        "Authentication=ActiveDirectoryWorkloadIdentity;" 
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )
    return pyodbc.connect(conn_str)

@app.route('/')
def index():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        # Fetching the 140 aircraft records
        cursor.execute("SELECT LogID, TailNumber, Status, Component, PartHours, Details FROM MaintenanceLogs")
        rows = cursor.fetchall()
        conn.close()
        return render_template('index.html', rows=rows)
    except Exception as e:
        # Helpful for your interview: returns the error to the screen
        return f"Database Connection Error: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)