from flask import Flask, render_template
import pyodbc
import struct
import os

app = Flask(__name__)

def get_db_connection():
    # Remove all 'Authentication' keywords to stop the 08001 error
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=sql-server-aviator-maintenance.database.windows.net,1433;"
        "Database=db-airplane-maintenance;"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )
    
    # 1. Fetch the token from the file AKS injected into the pod
    token_path = os.environ.get("AZURE_FEDERATED_TOKEN_FILE")
    with open(token_path, 'r') as f:
        token = f.read().encode("UTF-16-LE")
        
    # 2. Package the token in the format the SQL driver expects
    token_struct = struct.pack(f"<I{len(token)}s", len(token), token)
    
    # 3. Pass the token as a connection attribute (1256 is the ID for Access Token)
    return pyodbc.connect(conn_str, attrs_before={1256: token_struct})

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
        return f"Database Connection Error: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)