import pandas as pd
import time
import random
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
from threading import Semaphore
from vnstock_data.explorer.vci import Quote

def process_duplicate_columns_simple(df: pd.DataFrame) -> pd.DataFrame:
    """
    Renames duplicated columns by prefixing the second+ occurrences with '_'.
    Keeps all columns instead of dropping.
    """
    cols = pd.Series(df.columns)
    for dup in cols[cols.duplicated()].unique():
        dup_indices = cols[cols == dup].index.tolist()
        for i in range(1, len(dup_indices)):
            cols[dup_indices[i]] = f"_{cols[dup_indices[i]]}"
    df.columns = cols
    return df.reset_index(drop=True)

def clean_dataframe(df: pd.DataFrame, table_name: str) -> pd.DataFrame:
    """
    Cleans a DataFrame to match the database schema for a given table name.
    Handles renaming, type conversion, missing columns, and duplicate removal.
    """
    if table_name in ["Price_Data", "Price_Data_Daily", "Price_Data_Daily_All"]:
        subset = ["symbol", "time"]
        rename_map = {
            "openPrice": "open", "highPrice": "high",
            "lowPrice": "low", "closePrice": "close",
            "value": "volume"
        }
        df = df.rename(columns={k: v for k, v in rename_map.items() if k in df.columns})
        df["volume"] = (
            pd.to_numeric(df.get("volume", 0), errors="coerce")
            .fillna(0).round().astype("Int64")
        )
        df["time"] = pd.to_datetime(df["time"], errors='coerce').astype(str)
        df = df.dropna(subset=subset).drop_duplicates(subset=subset)

    elif table_name == "Intraday_Data":
        subset = ["symbol", "time", "match_type", "id"]
        if "volume" in df.columns:
            df["volume"] = (
                pd.to_numeric(df["volume"], errors="coerce")
                .fillna(0).round().astype("Int64")
            )
        df["time"] = pd.to_datetime(df["time"], errors='coerce').astype(str)
        df = df.dropna(subset=subset).drop_duplicates(subset=subset)

    elif table_name == "Finance_Data":
        subset = ["symbol", "year", "quarter", "field", "report_type", "value"]
        df = df.dropna(subset=subset).drop_duplicates(subset=subset)

    elif table_name == "Company_Info":
        subset = ["symbol", "website", "stock_rating"]
        cols = [
            "symbol", "company_name", "short_name", "exchange", "industry", "industry_id",
            "industry_id_v2", "company_type", "no_shareholders", "no_employees",
            "established_year", "outstanding_share", "issue_share", "foreign_percent",
            "stock_rating", "website", "company_profile", "history_dev",
            "company_promise", "business_risk", "key_developments", "date_updated"
        ]
        df = df[cols]
        df = df.dropna(subset=subset).drop_duplicates(subset=subset)
        df["date_updated"] = pd.to_datetime(df["date_updated"], errors='coerce').astype(str)

    return df.reset_index(drop=True)

def report_symbol_fetch_status(symbol: str, symbol_data: dict) -> None:
    """
    Reports the fetch status for a symbol, indicating missing or empty data parts.
    """
    if not symbol_data:
        print(f"⚠️ No data returned for {symbol}")
        return

    missing_parts = [
        key for key in ["Price_Data", "Intraday_Data", "Finance_Data", "Company_Info"]
        if key not in symbol_data or symbol_data[key] is None or symbol_data[key].empty
    ]

    if missing_parts:
        print(f"⚠️ Missing or empty data for {symbol}: {', '.join(missing_parts)}")
    else:
        print(f"✅ Successfully fetched ALL data for {symbol}")

def fetch_intraday_ohlc(
    symbol: str, start: str = "2023-11-01", end: str = "2025-04-01",
    interval: str = "15m", retries: int = 3, delay: tuple = (0.5, 1.5)
) -> pd.DataFrame | None:
    """
    Fetches intraday OHLC data for a symbol, aggregates by morning/afternoon session.
    Retries on failure and controls rate-limit using a semaphore.
    """
    _semaphore = Semaphore(3)
    for attempt in range(retries):
        with _semaphore:
            try:
                time.sleep(random.uniform(*delay))
                stock = Quote(symbol=symbol)
                df = stock.history(start=start, end=end, interval=interval)
                if df.empty:
                    return None
                df['date'] = df['time'].dt.date
                df['session'] = df['time'].dt.hour.map(lambda x: 'morning' if x < 12 else 'afternoon')
                ohlc = df.groupby(['date', 'session']).agg({
                    'open': 'first', 'high': 'max', 'low': 'min',
                    'close': 'last', 'volume': 'sum'
                }).reset_index()
                for i in range(1, len(ohlc)):
                    if ohlc.loc[i, 'session'] == 'afternoon' and ohlc.loc[i - 1, 'session'] == 'morning':
                        ohlc.loc[i, 'open'] = ohlc.loc[i - 1, 'close']
                ohlc['symbol'] = symbol
                return ohlc
            except Exception as e:
                print(f"[{symbol}] attempt {attempt+1}/{retries} failed: {e}")
                time.sleep(5 * (attempt + 1))  # backoff
    print(f"[{symbol}] Gave up after {retries} retries.")
    return None

def fetch_intraday_batch(
    symbols: list[str], batch_size: int = 10, max_workers: int = 3
) -> pd.DataFrame:
    """
    Multi-threaded fetching of OHLC intraday data for a list of symbols.
    """
    def chunkify(lst, size):
        for i in range(0, len(lst), size):
            yield lst[i:i + size]

    results = []
    batches = list(chunkify(symbols, batch_size))
    for batch in tqdm(batches, desc="Fetching Intraday Batches"):
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            futures = {executor.submit(fetch_intraday_ohlc, sym): sym for sym in batch}
            for future in as_completed(futures):
                sym = futures[future]
                try:
                    result = future.result()
                    if result is not None:
                        results.append(result)
                except Exception as e:
                    print(f"[{sym}] Failed after retries: {e}")

    if not results:
        return pd.DataFrame()

    return pd.concat(results, ignore_index=True).dropna().sort_values(
        ['symbol', 'date', 'session'],
        key=lambda col: col if col.name != 'session' else col.map({'morning': 0, 'afternoon': 1})
    )

def compute_T25_returns(df: pd.DataFrame) -> pd.DataFrame:
    """
    Computes 2.5-period returns for each symbol, based on the 'close' price.
    """
    df = df.sort_values(['symbol', 'date', 'session'],
        key=lambda col: col if col.name != 'session' else col.map({'morning': 0, 'afternoon': 1})
    ).reset_index(drop=True)
    df['return_2.5'] = pd.NA

    for symbol in df['symbol'].unique():
        sub = df[df['symbol'] == symbol].copy().reset_index()
        for i in range(5, len(sub)):
            ref_close = sub.loc[i - 5, 'close']
            if ref_close != 0:
                sub.loc[i, 'return_2.5'] = (sub.loc[i, 'close'] - ref_close) / ref_close
        df.loc[sub['index'], 'return_2.5'] = sub['return_2.5'].values

    return df
