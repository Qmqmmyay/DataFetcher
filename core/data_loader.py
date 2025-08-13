import os,sys
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, project_root)

import time
import logging
import pandas as pd
from datetime import datetime,timedelta
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_message
from threading import Semaphore
from vnstock import Vnstock, Company
from vnstock_data.explorer.vci import Quote, Finance
from core.database import Database
from utils.data_utils import process_duplicate_columns_simple, clean_dataframe, report_symbol_fetch_status
from config.symbols import get_all_hose_symbols

# Constants
os.makedirs("logs", exist_ok=True)
logging.basicConfig(filename= "logs/fetcher.log", level=logging.WARNING)

api_semaphore = Semaphore(15)
class DataFetcher:
    def __init__(self, symbols, 
                 batch_size=30, max_workers=15, sleep=1,
                 db_path=None):
        self.batch_size = batch_size
        self.max_workers = max_workers
        self.sleep = sleep
        self.vnstock = Vnstock().stock(symbol='VNINDEX', source='VCI') #VCI
        self.db = Database(db_path=db_path) if db_path else Database()
        self.symbols = symbols
        self.today = datetime.today()
        self.LAST_1_Y = (self.today - timedelta(days=365)).strftime("%Y-%m-%d")
    @retry(
        stop=stop_after_attempt(5),
        wait=wait_exponential(multiplier=1, min=5, max=60),
        retry=retry_if_exception_message(match = r".*(Rate limit exceeded.*|.*Bạn đã gửi quá nhiều request|thử lại sau).*")
    )
    def fetch_combined_data(self, symbol, fetch_types):
        result = {}
        with api_semaphore:
            try:
                if "Price_Data" in fetch_types:
                    result.update(self.fetch_quote_data(symbol))
                if "Price_Data_Daily" in fetch_types:
                    result.update(self.fetch_quote_data_daily(symbol)) 
                if "Price_Data_Daily_All" in fetch_types:
                    result.update(self.fetch_quote_data_daily_all(symbol))
                if "Intraday_Data" in fetch_types:
                    result.update(self.fetch_intraday_data(symbol))
                if "Finance_Data" in fetch_types:
                    result.update(self.fetch_financials(symbol))
                if "Company_Info" in fetch_types:
                    result.update(self.fetch_company_overview(symbol))
            except Exception as e:
                error_msg = str(e)
                if "gửi quá nhiều request" in error_msg or "thử lại sau" in error_msg:
                    print(f"Bị giới hạn request với {symbol} - retry tự động.")
                    raise Exception("Rate limit exceeded(matched)")
                raise e
        return result
 
    def fetch_quote_data(self, symbol,date = None):
        today = datetime.today().strftime("%Y-%m-%d")
        yesterday = (datetime.today() - timedelta(days=1)).strftime("%Y-%m-%d")
        LAST_1_Y = (datetime.today() - timedelta(days=365)).strftime("%Y-%m-%d")
        LAST_3_Y = (datetime.today() - timedelta(days=365*2)).strftime("%Y-%m-%d")
        stock = Quote(symbol)
        #stock = Vnstock().stock(symbol=symbol, source='VCI').quote
        Price_Data = stock.history(start=today, end=today, interval="1m")
        #if Price_Data is None or Price_Data.empty:
        #     Price_Data = stock.history(start=yesterday, end=today, interval="1m")
        Price_Data["symbol"] = symbol
        return {"Price_Data": Price_Data}
    def fetch_quote_data_daily(self, symbol,date = None):
        today = datetime.today().strftime("%Y-%m-%d")
        yesterday = (datetime.today() - timedelta(days=1)).strftime("%Y-%m-%d")
        stock = Quote(symbol)
        LAST_3_Y = (datetime.today() - timedelta(days=365*3 +20)).strftime("%Y-%m-%d")


        #stock = Vnstock().stock(symbol=symbol, source='VCI').quote
        Price_Data_Daily = stock.history(start=today, end=today, interval="1D")

        #if Price_Data is None or Price_Data.empty:
        #     Price_Data = stock.history(start=yesterday, end=today, interval="1m")
        Price_Data_Daily["symbol"] = symbol
        return {"Price_Data_Daily": Price_Data_Daily}

    def fetch_quote_data_daily_all(self, symbol,date = None):
        today = datetime.today().strftime("%Y-%m-%d")
        yesterday = (datetime.today() - timedelta(days=1)).strftime("%Y-%m-%d")
        LAST_3_Y = (datetime.today() - timedelta(days=365*3 +20)).strftime("%Y-%m-%d")
        stock = Quote(symbol)
        #stock = Vnstock().stock(symbol=symbol, source='VCI').quote
        Price_Data_Daily_All = stock.history(start=LAST_3_Y, end=today, interval="1D")

        #if Price_Data is None or Price_Data.empty:
        #     Price_Data = stock.history(start=yesterday, end=today, interval="1m")
        Price_Data_Daily_All["symbol"] = symbol
        return {"Price_Data_Daily_All": Price_Data_Daily_All}

    def fetch_intraday_data(self, symbol):
        stock = Quote(symbol)
        #stock = Vnstock().stock(symbol=symbol, source='VCI').quote

        Intraday_Data = stock.intraday(page_size=30000)
        Intraday_Data["symbol"] = symbol
        return {"Intraday_Data": Intraday_Data}

    def fetch_financials(self, symbol):
        fin = Finance(symbol)
        finance_frames = []
        for report_type, df in {
            "BS": fin.balance_sheet(period="quarterly", lang="en", dropna=False),
            "IS": fin.income_statement(period="quarterly", lang="en", dropna=False),
            "CF": fin.cash_flow(period="quarterly", lang="en", dropna=False)
        }.items():
            if df is not None:
                df = df.reset_index(drop=True)
                df = df.melt(id_vars=["ticker", "yearReport", "lengthReport"], var_name="field", value_name="value")
                df = df.rename(columns={"ticker": "symbol", "yearReport": "year", "lengthReport": "quarter"})
                df["report_type"] = report_type
                finance_frames.append(df)
        Finance_Data = pd.concat(finance_frames, ignore_index=True) if finance_frames else None
        Finance_Data = clean_dataframe(Finance_Data, table_name="financials")
        return {"Finance_Data": Finance_Data} if Finance_Data is not None else {}

    def fetch_company_overview(self, symbol):
        today = datetime.today().strftime("%Y-%m-%d")
        company = Company(symbol)
        Company_Info = pd.concat([company.overview(), company.profile()], axis=1)
        Company_Info = process_duplicate_columns_simple(Company_Info)
        Company_Info["symbol"] = symbol
        Company_Info["date_updated"] = today
        return {"Company_Info": Company_Info}
    
    def fetch_all_symbols_data(self, fetch_types, log_dir="logs"):
        # Kiểm tra fetch_types
        batch_size= self.batch_size
        max_workers= self.max_workers
        valid_types = {"Price_Data_Daily","Price_Data_Daily_All","Price_Data", "Intraday_Data", "Finance_Data", "Company_Info"}
        if not fetch_types:
            raise ValueError("fetch_types cannot be empty")
        if not all(t in valid_types for t in fetch_types):
            raise ValueError(f"Invalid fetch_types: {fetch_types}. Must be in {valid_types}")

        os.makedirs(log_dir, exist_ok=True)
        log_path = os.path.join(log_dir, "missing_symbols.log")
        symbols = sorted(self.symbols)

        if not symbols:
            print("⚠️ No symbols to fetch.")
            return [], set(), []

        all_attempted, missing_symbols = set(), []

        def process_batch(batch):
            success, failed = set(), []
            with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
                futures = {executor.submit(self.fetch_combined_data, symbol, fetch_types): symbol for symbol in batch}
                for future in tqdm(as_completed(futures), total=len(batch), desc="Processing batch"):
                    symbol = futures[future]
                    try:
                        symbol_data = future.result()
                        #print(symbol_data)
                        if not symbol_data:
                            logging.warning(f"No data returned for {symbol}")
                            continue
                        report_symbol_fetch_status(symbol, symbol_data)
                        self.save_data_to_db(symbol, symbol_data)
                        success.add(symbol)
                    except Exception as e:
                        print(f"❌ Symbol '{symbol}' bị lỗi: {e}")                     
                        logging.warning(f"❌ Symbol '{symbol}' bị lỗi: {e}")
                        failed.append(symbol)
            return success, failed

        # Initial fetch
        for i in range(0, len(symbols), batch_size):
            batch = symbols[i:i + batch_size]
            success, failed = process_batch(batch)
            all_attempted.update(success)
            missing_symbols.extend(failed)
            time.sleep(1)

        # Retry up to 3 times
        for attempt in range(3):
            retry_symbols = sorted(set(missing_symbols) - all_attempted)
            if not retry_symbols:
                break
            print(f"🔁 Lần retry {attempt + 1}/3 cho: {retry_symbols}")
            missing_symbols = []
            for i in range(0, len(retry_symbols), batch_size):
                batch = retry_symbols[i:i + batch_size]
                success, failed = process_batch(batch)
                all_attempted.update(success)
                missing_symbols.extend(failed)
                time.sleep(1)

        # Ghi log lỗi cuối cùng nếu còn
        truly_failed = sorted(set(symbols) - all_attempted)
        if truly_failed:
            with open(log_path, "w", encoding="utf-8") as f:
                f.write("Các symbol không thành công:\n")
                for symbol in truly_failed:
                    f.write(f"{symbol}\n")
            print(f"📄 Ghi log lỗi: {log_path}")

        print("✅ Toàn bộ quá trình xử lý symbols đã hoàn tất")

    def save_data_to_db(self, symbol, symbol_data):
        # Price_Data (Price_Data)
        if "Price_Data" in symbol_data:
            df = clean_dataframe(symbol_data["Price_Data"], table_name="Price_Data")
            self.db.insert_dataframe(df, table_name="Price_Data", conflict_strategy="ignore")  
        if "Price_Data_Daily" in symbol_data:
            df = clean_dataframe(symbol_data["Price_Data_Daily"], table_name="Price_Data_Daily")
            self.db.insert_dataframe(df, table_name="Price_Data_Daily", conflict_strategy="ignore")
        if "Price_Data_Daily_All" in symbol_data:
            df = clean_dataframe(symbol_data["Price_Data_Daily_All"], table_name="Price_Data_Daily_All")
            self.db.insert_dataframe(df, table_name="Price_Data_Daily_All", conflict_strategy="ignore")
            
        # Intraday_Data (intraday_data)
        if "Intraday_Data" in symbol_data:
            df = clean_dataframe(symbol_data["Intraday_Data"], table_name="Intraday_Data")
            self.db.insert_dataframe(df, table_name="Intraday_Data", conflict_strategy="ignore")

        # Finance_Data (financials)
        if "Finance_Data" in symbol_data:
            df = clean_dataframe(symbol_data["Finance_Data"], table_name="Finance_Data")
            self.db.insert_financial_data(symbol_data["Finance_Data"])  # ✅ no table_name here
            
        # Company_Info (Company_Info)
        if "Company_Info" in symbol_data:
            df = clean_dataframe(symbol_data["Company_Info"], table_name="Company_Info")
            self.db.insert_dataframe(df, table_name="Company_Info", conflict_strategy="ignore")
  

