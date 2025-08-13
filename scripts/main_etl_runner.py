import os
import sys

# Ensure current directory is the root of the project
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, project_root)
os.chdir(project_root)

import logging
from datetime import datetime
from core.data_loader import DataFetcher
from core.database import Database
from config.symbols import HOSE_SYMBOLS
from utils.data_utils import report_symbol_fetch_status
import sys
from datetime import datetime

# Setup logging
os.makedirs("logs", exist_ok=True)
log_file = os.path.join("logs", f"etl_log_{datetime.today().strftime('%Y%m%d')}.log")
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file),
        logging.StreamHandler(sys.stdout)
    ]
)

# Xác định ngày hôm nay
today = datetime.today()
weekday = today.weekday()  # 0 = Monday, 6 = Sunday
day = today.day
month = today.month
is_quarter_start = day == 11 and month in [1, 4, 7, 10]

# Nếu là cuối tuần và KHÔNG phải ngày đầu quý thì thoát
if weekday > 5 and not is_quarter_start:
    with open("logs/etl_skip.log", "a") as f:
        f.write(f"{datetime.now()}: Skipped ETL on weekend (weekday {weekday})\n")
    sys.exit(0)

def check_table_exists_and_has_data(db, table_name):
    """Safely check if table exists and has data"""
    try:
        result = db.fetch_data(f"SELECT COUNT(*) FROM {table_name}")
        return result.iloc[0, 0] > 0
    except Exception as e:
        logging.warning(f"Table {table_name} doesn't exist or error checking: {e}")
        return False

def ensure_database_setup():
    """Ensure database file exists and tables are created"""
    from core.database import DB_PATH
    
    # Check if database file exists and has content
    if not os.path.exists(DB_PATH) or os.path.getsize(DB_PATH) == 0:
        logging.info("🗄️ Database file doesn't exist or is empty. Initializing database...")
        try:
            # Run database.py to create the database and tables
            import subprocess
            result = subprocess.run([sys.executable, "core/database.py"], 
                                  capture_output=True, text=True, cwd=os.getcwd())
            if result.returncode == 0:
                logging.info("✅ Database initialized successfully via database.py")
            else:
                logging.warning(f"⚠️ Database.py returned non-zero exit code: {result.stderr}")
                # Fallback to manual creation
                db = Database()
                db.create_all_tables()
                logging.info("✅ Database tables created via fallback method")
        except Exception as e:
            logging.error(f"❌ Failed to run database.py: {e}")
            # Fallback to manual creation
            try:
                db = Database()
                db.create_all_tables()
                logging.info("✅ Database tables created via fallback method")
            except Exception as fallback_error:
                logging.error(f"❌ Fallback database creation also failed: {fallback_error}")
                raise
    else:
        logging.info("🗄️ Database file exists. Ensuring tables are created...")
        db = Database()
        db.create_all_tables()

def run_etl():
    symbols = HOSE_SYMBOLS
    fetcher = DataFetcher(symbols=symbols, batch_size=30, sleep=20, max_workers=3)
    
    # Ensure database is properly set up before proceeding
    ensure_database_setup()
    
    db = Database()

    tables_to_check = ["Price_Data","Price_Data_Daily", "Intraday_Data", "Finance_Data", "Company_Info"]
    
    # Check if all tables are empty or don't exist
    try:
        tables_with_data = [table for table in tables_to_check if check_table_exists_and_has_data(db, table)]
        
        if not tables_with_data:
            logging.info("🔁 All tables are empty or don't exist. Performing initial fetch for price data only.")
            # Only fetch essential price and intraday data on initial run
            fetcher.fetch_all_symbols_data(fetch_types=["Price_Data_Daily","Price_Data", "Intraday_Data"])
            return
        else:
            logging.info(f"📋 Found data in tables: {tables_with_data}")
            
    except Exception as e:
        logging.error(f"❌ Error checking table status: {e}")
        logging.info("🔁 Proceeding with full fetch due to table check error.")
        fetcher.fetch_all_symbols_data(fetch_types=tables_to_check)
        return

    # Gọi fetch tùy theo điều kiện
    if weekday <= 5:
        logging.info("📊 Weekday fetch: Price + Intraday")
        fetcher.fetch_all_symbols_data(fetch_types=["Price_Data_Daily","Price_Data", "Intraday_Data"])

    if is_quarter_start:
        logging.info("📋 Quarterly fetch: Company Info + Finance")
        fetcher.fetch_all_symbols_data(fetch_types=["Company_Info", "Finance_Data"])

if __name__ == "__main__":
    try:
        run_etl()
        logging.info("✅ ETL process completed successfully.")
        print("✅ ETL process completed successfully.")
    except Exception as e:
        logging.error(f"❌ ETL process failed with error: {e}")
        print(f"❌ ETL process failed with error: {e}")
        sys.exit(1)