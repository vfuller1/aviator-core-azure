import pyodbc
import os
import struct
from flask import Flask, render_template
from azure.identity import DefaultAzureCredential

app = Flask(__name__)

def get_db_connection():
    # 1. Obtain an access token using DefaultAzureCredential
    # It will now pull the Tenant ID from the AZURE_TENANT_ID environment variable
    credential = DefaultAzureCredential()
    token_object = credential.get_token("https://database.windows.net/.default")
    
    # 2. Encode the token for the SQL Server ODBC driver
    token_bytes = token_object.token.encode("utf-16-le")
    token_struct = struct.pack(f'<I{len(token_bytes)}s', len(token_bytes), token_bytes)

    # 3. Standard Connection String
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=sql-server-aviator-maintenance.database.windows.net,1433;"
        "Database=db-airplane-maintenance;"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
    )

    # 4. Pass the token directly (Attribute 1256 = SQL_COPT_SS_ACCESS_TOKEN)
    return pyodbc.connect(conn_str, attrs_before={1256: token_struct})

@app.route('/')
def index():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        # Fetching your 280 maintenance records
        cursor.execute("SELECT LogID, TailNumber, Status, Component, PartHours, Details FROM dbo.MaintenanceLogs")
        rows = cursor.fetchall()
        conn.close()
        return render_template('index.html', rows=rows)
    except Exception as e:
        print(f"!!! DATABASE CONNECTION FAILURE: {str(e)}")
        return f"Database Error: {str(e)}", 500

@app.route('/health')
def health():
    return "Healthy", 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
