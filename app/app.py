from flask import Flask, render_template
import pyodbc
import struct
import os

app = Flask(__name__)

def get_db_connection():
    try:
        # Standard connection string without the 'Authentication' keyword to avoid ODBC 18 errors
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
        
        # Verify the token file exists for debugging in kubectl logs
        if not token_path or not os.path.exists(token_path):
            print(f"CRITICAL ERROR: Token file not found at {token_path}")
            return None

        with open(token_path, 'r') as f:
            token = f.read().encode("UTF-16-LE")
            
        # 2. Package the token in the format the SQL driver expects
        token_struct = struct.pack(f"<I{len(token)}s", len(token), token)
        
        # 3. Pass the token as a connection attribute (1256 is the ID for Access Token)
        return pyodbc.connect(conn_str, attrs_before={1256: token_struct})
        
    except Exception as e:
        # Detailed logging to help identify the 500 error cause in 'kubectl logs'
        print(f"DATABASE CONNECTION FAILURE: {str(e)}")
        raise e

@app.route('/')
def index():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Added 'dbo.' schema prefix to ensure the table is found
        # Querying the airplane maintenance logs for the dashboard
        query = "SELECT LogID, TailNumber, Status, Component, PartHours, Details FROM dbo.MaintenanceLogs"
        cursor.execute(query)
        
        rows = cursor.fetchall()
        conn.close()
        return render_template('index.html', rows=rows)
    except Exception as e:
        # This will display the full error message in your browser for final debugging
        return f"Database Connection Error: {str(e)}", 500

if __name__ == '__main__':
    # Flask runs on port 5000 as configured in your deployment.yaml
    app.run(host='0.0.0.0', port=5000)