# 🇻🇳 VNTrading DataFetcher - Database Description

## 📊 Database Overview

The VNTrading DataFetcher uses a **SQLite database** (`trading_system.db`) to store comprehensive Vietnamese stock market data. The database contains **6 main tables** organized to efficiently store different types of financial data with proper indexing and relationships.

**Database Location:** `data/trading_system.db`  
**Database Type:** SQLite 3  
**Total Tables:** 6

---

## 📋 Table Descriptions

### 1. Price_Data - Real-time Intraday Price Data
**Purpose:** Stores high-frequency intraday trading data with minute-level granularity.

**Schema:**
```sql
CREATE TABLE Price_Data (
    symbol TEXT,        -- Stock symbol (e.g., "VIC", "VCB")
    time TEXT,          -- Timestamp (YYYY-MM-DD HH:MM:SS)
    open REAL,          -- Opening price
    high REAL,          -- Highest price in the period
    low REAL,           -- Lowest price in the period
    close REAL,         -- Closing price
    volume INTEGER,     -- Volume traded
    PRIMARY KEY (symbol, time)
)
```

**Sample Data:**
| symbol | time | open | high | low | close | volume |
|--------|------|------|------|-----|-------|--------|
| AAM | 2025-08-13 09:15:00 | 7.29 | 7.29 | 7.29 | 7.29 | 1000 |
| VIC | 2025-08-13 10:15:00 | 45.50 | 45.80 | 45.30 | 45.65 | 5200 |

**Data Volume:** ~434 records (varies with market activity)  
**Update Frequency:** Real-time during market hours (9:00-15:00 VN time)

### 2. Price_Data_Daily - End-of-Day OHLCV Data
**Purpose:** Stores daily summary data (Open, High, Low, Close, Volume) for each trading day.

**Sample Data:**
| symbol | time | open | high | low | close | volume |
|--------|------|------|------|-----|-------|--------|
| AAM | 2025-08-13 | 7.29 | 7.30 | 7.25 | 7.29 | 11100 |
| AAT | 2025-08-13 | 3.50 | 3.50 | 3.44 | 3.47 | 89300 |

### 3. Intraday_Data - Tick-by-Tick Transaction Data
**Purpose:** Stores individual trade transactions with precise timing and execution details.

**Sample Data:**
| symbol | time | id | price | volume | match_type |
|--------|------|----|----|--------|------------|
| AAM | 2025-08-13 09:15:00+07:00 | 342742815.0 | 7290.0 | 1000 | ATO |
| AAM | 2025-08-13 09:37:00+07:00 | 342895013.0 | 7290.0 | 300 | Sell |

**Match Types:**
- **ATO**: Auction To Open (opening auction)
- **ATC**: Auction To Close (closing auction)  
- **Buy**: Regular buy order execution
- **Sell**: Regular sell order execution

### 4. Finance_Data - Financial Statements & Metrics
**Purpose:** Stores comprehensive financial data from quarterly and annual reports.

**Report Types:**
- **IncomeStatement**: Revenue, profits, expenses
- **BalanceSheet**: Assets, liabilities, equity
- **CashFlow**: Operating, investing, financing cash flows

### 5. Company_Info - Corporate Information & Profiles
**Purpose:** Stores comprehensive company information, profiles, and fundamental data.

**Exchange Types:**
- **HOSE**: Ho Chi Minh Stock Exchange (blue-chip stocks)
- **HNX**: Hanoi Stock Exchange (medium-cap stocks)
- **UPCOM**: Unlisted Public Company Market (small-cap)

### 6. Price_Data_Daily_All - Historical Daily Data Archive
**Purpose:** Comprehensive historical daily price data for long-term analysis and backtesting.

---

## 📈 Vietnamese Market Coverage

### Market Coverage:
- **HOSE**: ~400+ blue-chip companies (VIC, VCB, HPG, etc.)
- **HNX**: ~300+ mid-cap companies  
- **UPCOM**: ~100+ small-cap companies

### Data Providers:
- **vnstock**: Primary API for price data
- **vnstock_data**: Enhanced data with fundamentals
- **vnai**: AI-enhanced market analysis
- **vnii**: Vietnamese market intelligence

### Update Schedule:
- **Market Hours**: 9:00 AM - 3:00 PM (GMT+7)
- **Real-time Updates**: Every minute during trading
- **Daily Batch**: 3:30 PM (post-market close)

---

## 🛠 Technical Implementation

### Database Optimization:
- Composite primary keys for efficient time-series queries
- Indexed symbols for fast filtering
- Volume data type optimization (INTEGER vs REAL)
- UTF-8 encoding for Vietnamese company names

### Data Quality Features:
- Duplicate prevention with PRIMARY KEY constraints
- Volume data cleaning and type conversion
- Version tracking for financial data updates
- Timestamp standardization across tables

---

## 📊 Usage Examples

### Common Queries:

```sql
-- Get latest daily prices for top 10 stocks
SELECT symbol, time, close, volume 
FROM Price_Data_Daily 
ORDER BY time DESC, volume DESC 
LIMIT 10;

-- Calculate daily returns
SELECT symbol, time, close,
       LAG(close) OVER (PARTITION BY symbol ORDER BY time) as prev_close,
       (close - LAG(close) OVER (PARTITION BY symbol ORDER BY time)) / 
       LAG(close) OVER (PARTITION BY symbol ORDER BY time) * 100 as daily_return
FROM Price_Data_Daily;
```

---

## 🎯 Use Cases

### Investment Analysis:
- Portfolio performance tracking
- Risk assessment and diversification
- Sector rotation analysis
- Fundamental screening

### Algorithmic Trading:
- Real-time signal generation
- Backtesting strategies
- Market microstructure analysis
- Execution cost analysis

---

**Last Updated:** August 14, 2025  
**Database Version:** 1.0  
**Record Count:** 400+ active records, growing daily
