import sqlite3
import os
import pandas as pd
from typing import Optional
from datetime import datetime

DB_PATH = os.path.join("data", "trading_system.db")

class Database:
    def __init__(self, db_path=None):
        self.db_path = DB_PATH if db_path is None else db_path
        self.conn = sqlite3.connect(self.db_path) 
        self.cursor = self.conn.cursor()

    def insert_dataframe(self, df, table_name, conflict_strategy="ignore"):
        if "volume" in df.columns:
            df["volume"] = (
                pd.to_numeric(df["volume"], errors="coerce")
                .fillna(0)
                .round()
                .astype("int64")   # ép kiểu an toàn hơn apply(int)
            )


        if conflict_strategy in ["ignore", "replace"]:
            query = f"INSERT OR {conflict_strategy.upper()} INTO {table_name} ({','.join(df.columns)}) VALUES ({','.join(['?' for _ in df.columns])})"
        else:
            query = f"INSERT INTO {table_name} ({','.join(df.columns)}) VALUES ({','.join(['?' for _ in df.columns])})"
        
        self.cursor.executemany(query, df.values.tolist())
        self.conn.commit()
            
    def create_all_tables(self):
        self.create_price_table()
        self.create_price_daily_table()
        self.create_price_daily_all_table()
        self.create_intraday_table()
        self.create_Finance_data_table()
        self.create_Company_Info_table()
        print("✅ All tables created successfully.")

    def create_price_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS Price_Data (
                symbol TEXT,
                time TEXT,
                open REAL,
                high REAL,
                low REAL,
                close REAL,
                volume INTEGER,
                PRIMARY KEY (symbol, time)
            )
        ''')
        self.conn.commit()

    def create_price_daily_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS Price_Data_Daily (
                symbol TEXT,
                time TEXT,
                open REAL,
                high REAL,
                low REAL,
                close REAL,
                volume INTEGER,
                PRIMARY KEY (symbol, time)
            )
        ''')
        self.conn.commit()

    def create_price_daily_all_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS Price_Data_Daily_All (
                symbol TEXT,
                time TEXT,
                open REAL,
                high REAL,
                low REAL,
                close REAL,
                volume INTEGER,
                PRIMARY KEY (symbol, time)
            )
        ''')
        self.conn.commit()

    def create_intraday_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS Intraday_Data (
                symbol TEXT,
                time TEXT,
                id REAL,
                price REAL,
                volume INTEGER,
                match_type TEXT,
                PRIMARY KEY (symbol, time, match_type,id    )
            )
        ''')
        self.conn.commit()

    def create_Finance_data_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS Finance_Data (
                symbol TEXT,
                report_type TEXT,
                year INTEGER,
                quarter INTEGER,
                field TEXT,
                value REAL,
                version TEXT,
                downloaded_at TEXT,
                is_latest BOOLEAN,
                PRIMARY KEY (symbol, report_type, year, quarter, field, version)
            )
        ''')
        self.conn.commit()

    def create_Company_Info_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS Company_Info (
                symbol TEXT,
                company_name TEXT,
                short_name TEXT,
                exchange TEXT,
                industry TEXT,
                industry_id TEXT,
                industry_id_v2 TEXT,
                company_type TEXT,
                no_shareholders INTEGER,
                no_employees INTEGER,
                established_year INTEGER,
                outstanding_share REAL,
                issue_share REAL,
                foreign_percent REAL,
                stock_rating TEXT,
                website TEXT,
                company_profile TEXT,
                history_dev TEXT,
                company_promise TEXT,
                business_risk TEXT,
                key_developments TEXT,
                date_updated,
                PRIMARY KEY (symbol, website, stock_rating) )
                            
        ''')
        self.conn.commit()

    def fetch_data(self, query: str, params: Optional[tuple] = None) -> pd.DataFrame:
        if params:
            return pd.read_sql_query(query, self.conn, params=params)
        return pd.read_sql_query(query, self.conn)

    def insert_financial_data(self, df: pd.DataFrame):
        for _, row in df.iterrows():
            symbol = row['symbol']
            report_type = row['report_type']
            year = row['year']
            quarter = row['quarter']
            field = row['field']
            value = row['value']
            version = row.get('version', datetime.today().strftime("%Y-%m-%d"))
            downloaded_at = row.get('downloaded_at', datetime.today().strftime("%Y-%m-%d"))

            self.cursor.execute('''
                SELECT 1 FROM Finance_data
                WHERE symbol = ? AND report_type = ? AND year = ? AND quarter = ?
                AND field = ? AND value = ?
            ''', (symbol, report_type, year, quarter, field, value))

            if self.cursor.fetchone():
                continue

            self.cursor.execute('''
                UPDATE Finance_data
                SET is_latest = 0
                WHERE symbol = ? AND report_type = ? AND year = ? AND quarter = ? AND field = ?
            ''', (symbol, report_type, year, quarter, field))

            self.cursor.execute('''
                INSERT INTO Finance_data (
                    symbol, report_type, year, quarter, field, value, version, downloaded_at, is_latest
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)
            ''', (symbol, report_type, year, quarter, field, value, version, downloaded_at))

        self.conn.commit()

if __name__ == "__main__":
    db = Database()
    db.create_all_tables()

