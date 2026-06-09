import subprocess
import os
import sys

def setup_database():
    print("=" * 50)
    print(" Enterprise Helpdesk - Database Setup Script")
    print("=" * 50)
    
    sql_file = "script.sql"
    if not os.path.exists(sql_file):
        print(f"❌ Error: {sql_file} not found in the current directory!")
        sys.exit(1)

    print(f"✅ Found {sql_file}.")
    print("⏳ Executing SQL script into MySQL...")
    
    # We use the mysql CLI tool which must be in the system PATH
    command = f'mysql -u helpdesk_user -phelpdesk123 < "{sql_file}"'
    
    try:
        # Run the command and capture output
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Database setup completed successfully!")
            print("   The 'helpdesk_db' is now ready for use.")
        else:
            print("❌ Error executing database setup:")
            print(result.stderr)
            sys.exit(result.returncode)
            
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    setup_database()
