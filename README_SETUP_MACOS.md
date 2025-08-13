# 🇻🇳 VNTrading DataFetcher - Complete macOS Setup Guide

> **Automated Vietnamese Stock Market Data Collection & Analysis System**

## 🚨 **CRITICAL: Read This First**

This repository includes a **578MB virtual environment** with **offline Vietnamese trading packages** that are NOT available on PyPI:

- 📊 **vnstock** (3.2.6) - Vietnamese stock data APIs
- 📈 **vnstock_ta** (0.1.1) - Technical analysis for VN market  
- 📉 **vnstock_data** (2.0.7) - VN market data pipelines
- 📋 **vnstock_ezchart** (0.0.2) - VN market visualization
- 🔄 **vnstock_pipeline** (2.0) - VN data processing workflows
- 🤖 **vnai** (2.0.4) - Vietnamese AI trading tools
- 🧠 **vnii** (0.0.7) - VN investment intelligence

**⚠️ These packages cannot be installed anywhere else!**

---

## 📊 **Project Overview**

| Component | Size | Description |
|-----------|------|-------------|
| 🐍 **Virtual Environment** | 578MB | Complete Python environment with offline VN packages |
| 📁 **Source Code & Config** | 196KB | Core ETL logic, configuration, utilities |
| 📄 **Documentation** | 48KB | Setup guides, documentation, scripts |
| 📊 **Logs/Data** | 180KB | Runtime logs and database files |
| **TOTAL** | **~760MB** | Complete automated trading system |

## 🖥️ **System Requirements**

| Requirement | Details |
|-------------|---------|
| **Operating System** | macOS only (LaunchAgent automation) |
| **Python Version** | 3.12+ (included in virtual environment) |
| **Required Location** | `/Users/username/VNTrading_DataFetcher` |
| **❌ Avoid** | Desktop directory (causes LaunchAgent issues) |
| **Disk Space** | ~800MB free space |
| **Internet** | Required for Vietnamese stock market APIs |
| **Schedule** | Daily execution at 15:00 (3:00 PM) |

---

## ⚡ **Quick Setup (3 Steps - Recommended)**

### **Step 1: Clone Repository**
```bash
# Clone to your home directory (NOT Desktop!)
cd /Users/$(whoami)/
git clone https://github.com/Qmqmmyay/DataFetcher.git VNTrading_DataFetcher
cd VNTrading_DataFetcher
```

### **Step 2: Run Setup Script**
```bash
# This script is SAFE and preserves Vietnamese packages
./setup_new_computer.sh
```

**What the script does:**
- ✅ Preserves existing virtual environment with offline VN packages
- ✅ Updates Python paths for your system using `--upgrade-deps`
- ✅ Detects Vietnamese packages and skips unnecessary installation
- ✅ Tests all components to ensure everything works
- ✅ Creates necessary directories and makes scripts executable

### **Step 3: Setup Automation**
```bash
# Enable daily automated execution at 3:00 PM
./setup_launchd.sh
```

---

## 🔧 **Manual Setup Options**

### **Option A: Preserve Offline Packages (Recommended)**
```bash
# Update virtual environment paths while keeping packages
python3 -m venv VNTrading_env --upgrade-deps
source VNTrading_env/bin/activate

# Verify Vietnamese packages are preserved
python -c "import vnstock_ta, vnai, vnii; print('✅ Offline packages preserved!')"
```

### **Option B: Fresh Installation (⚠️ Loses Vietnamese Packages)**
```bash
# WARNING: This destroys offline Vietnamese packages!
rm -rf VNTrading_env
python3 -m venv VNTrading_env
source VNTrading_env/bin/activate
pip install -r requirements.txt
# Result: Only basic packages, no advanced Vietnamese tools
```

---

## 🔍 **Verification & Testing**

### **Check Vietnamese Package Status**
```bash
source VNTrading_env/bin/activate
pip list | grep -E "^(vnstock|vnai|vnii)"
```

**Expected output if offline packages are preserved:**
```
vnai                    2.0.4
vnii                    0.0.7
vnstock                 3.2.6
vnstock_data            2.0.7
vnstock_ezchart         0.0.2
vnstock_pipeline        2.0
vnstock_ta              0.1.1
```

### **Test Core Functionality**
```bash
# Test Vietnamese packages
source VNTrading_env/bin/activate
python -c "import vnstock_ta, vnai, vnii; print('🇻🇳 All VN packages working!')"

# Test ETL pipeline
./run_etl.sh

# Check automation status
launchctl list | grep vntrading

# Monitor logs
tail -f RunningLog/cron_etl.log
```

---

## 🎯 **Features & Capabilities**

- ✅ **Automated Daily Data Collection** - Runs daily at 3:00 PM using macOS LaunchAgent
- 📊 **SQLite Database Storage** - Structured data storage with proper schema
- 📈 **Vietnamese Market Focus** - Specialized for VN stock exchanges (HOSE, HNX, UPCOM)
- 🔄 **ETL Pipeline** - Extract, Transform, Load with error handling
- 📋 **Excel Export** - Daily reports in Excel format timestamped
- 🖥️ **macOS Integration** - Native LaunchAgent scheduling
- 🛠️ **Offline Packages** - No dependency on external package repositories
- 🇻🇳 **Vietnamese AI Tools** - Advanced trading intelligence and technical analysis

---

## 📁 **Project Structure**

```
VNTrading_DataFetcher/                    # 760MB total
├── 🐍 VNTrading_env/                     # 578MB - Complete Python environment
│   └── lib/python3.12/site-packages/    # 24,000+ files including VN packages
├── 🔧 setup_new_computer.sh             # Smart setup script (preserves VN packages)
├── ⏰ setup_launchd.sh                  # macOS automation setup
├── 🔄 run_etl.sh                        # Manual ETL execution
├── 💾 core/                             # Data processing engine
│   ├── data_loader.py                   # Vietnamese market data fetching
│   └── database.py                      # SQLite database management
├── ⚙️ config/                           # Stock symbols and constants
│   ├── symbols.py                       # Vietnamese stock symbols
│   └── const.py                         # Configuration constants
├── 📜 scripts/                          # Main ETL orchestration
│   └── main_etl_runner.py              # Core ETL execution logic
├── 🛠️ utils/                            # Helper functions
│   └── data_utils.py                    # Data processing utilities
├── 🗄️ data/                             # SQLite database storage
└── 📊 RunningLog/                       # Execution logs and Excel reports
```

---

## 🔄 **Daily Automation Setup**

### **Enable Automated Execution**
```bash
./setup_launchd.sh
```

**What this creates:**
- macOS LaunchAgent that runs daily at 15:00 (3:00 PM)
- Automatic data collection from Vietnamese stock markets
- Excel reports generated in `RunningLog/` directory
- Comprehensive logging for monitoring

### **Automation Schedule:**
- **Daily at 15:00** - Automated execution
- **Weekdays**: Fetch price + intraday data
- **Quarterly (11th of Jan/Apr/Jul/Oct)**: Also fetch company + finance data  
- **Weekends**: Skip execution (unless quarterly date)

### **Monitor Automation**
```bash
# Check if automation is active
launchctl list | grep vntrading

# View recent execution logs
ls -la RunningLog/

# Watch live execution
tail -f RunningLog/cron_etl.log

# Check LaunchAgent status
launchctl print gui/$(id -u)/com.vntrading.etl
```

### **Disable Automation**
```bash
./uninstall_launchd.sh
```

---

## 🔄 **How It Works**

1. **15:00 Daily Trigger** - macOS LaunchAgent starts the process
2. **Network Check** - Verifies internet connectivity and DNS
3. **Market Data Collection** - Fetches Vietnamese stock market data using offline packages
4. **Data Processing** - Cleans and validates market information using vnstock_ta
5. **AI Analysis** - Applies Vietnamese AI tools (vnai, vnii) for market intelligence
6. **Database Storage** - Saves processed data to SQLite
7. **Excel Export** - Generates timestamped report with Vietnamese market specifics
8. **Logging** - Records execution details and any errors

---

## 🛡️ **Why Include Virtual Environment?**

**Unique Vietnamese Packages:**
- These packages contain proprietary Vietnamese market data connectors
- They are not available on PyPI or any public repository
- They were custom-built for Vietnamese trading firms
- Without them, you only get basic functionality

**Benefits of Including Full Environment:**
- ✅ Guaranteed compatibility across macOS systems
- ✅ Offline installation capability
- ✅ No dependency conflicts
- ✅ Immediate deployment readiness
- ✅ Preservation of irreplaceable Vietnamese tools

---

## 📈 **Data Sources & Coverage**

- **Stock Exchanges**: HOSE, HNX, UPCOM
- **Data Types**: Real-time prices, historical data, technical indicators
- **Analysis Tools**: AI-driven insights, investment intelligence  
- **Export Formats**: Excel reports with Vietnamese market specifics
- **Update Frequency**: Daily automated collection
- **Market Intelligence**: Vietnamese-specific trading patterns and insights

---

## 🆘 **Troubleshooting**

### **"Virtual Environment Path Errors"**
```bash
# Fix hardcoded paths (this is normal after cloning)
python3 -m venv VNTrading_env --upgrade-deps
source VNTrading_env/bin/activate
```

### **"Vietnamese Package Import Errors"**
```bash
# Check if packages are available
source VNTrading_env/bin/activate
python -c "import vnstock_ta, vnai, vnii"

# If missing, you may have accidentally deleted them
echo "⚠️ Vietnamese packages lost - consider re-cloning repository"
```

### **"Permission Denied on Scripts"**
```bash
chmod +x *.sh
```

### **"LaunchAgent Not Working"**
```bash
# Ensure correct location (not Desktop)
pwd  # Should be /Users/username/VNTrading_DataFetcher

# Reset automation
./cleanup_old_launchd.sh
./setup_launchd.sh

# Check LaunchAgent logs
tail -f RunningLog/launchd_stderr.log
tail -f RunningLog/launchd_stdout.log
```

### **"Database or ETL Errors"**
```bash
# Recreate database
source VNTrading_env/bin/activate
python core/database.py

# Test ETL manually
./run_etl.sh

# Check specific error logs
tail -f logs/fetcher.log
```

### **"Python Not Found"**
```bash
# Install Python 3.12+ from https://www.python.org/downloads/
# Or use Homebrew:
brew install python@3.12
```

---

## 🔧 **Maintenance & Monitoring**

### **Daily Monitoring**
```bash
# Check recent runs
ls -la RunningLog/etl_*.xlsx

# View latest log
tail -f RunningLog/cron_etl.log

# Check LaunchAgent status
launchctl list | grep vntrading
```

### **Manual Execution**
```bash
# Test run (doesn't interfere with automation)
./run_etl.sh

# Check database status
source VNTrading_env/bin/activate
python -c "
import sqlite3
conn = sqlite3.connect('data/stock_data.db')
cursor = conn.cursor()
cursor.execute('SELECT COUNT(*) FROM stock_prices')
print(f'Records in database: {cursor.fetchone()[0]}')
conn.close()
"
```

---

## 💡 **Important Tips**

### **✅ Do This:**
- Clone to `/Users/username/VNTrading_DataFetcher`
- Use the setup script (`./setup_new_computer.sh`)
- Run `python3 -m venv VNTrading_env --upgrade-deps` to fix paths
- Test Vietnamese packages after setup
- Monitor logs regularly for data quality

### **❌ Avoid This:**
- Cloning to Desktop directory
- Running `rm -rf VNTrading_env` (destroys offline packages)
- Using `pip install` to reinstall Vietnamese packages (they're not on PyPI)
- Ignoring the location requirements
- Running multiple manual executions simultaneously

---

## 📞 **Getting Help**

**Before asking for help:**
1. ✅ Check you're in correct location: `/Users/username/VNTrading_DataFetcher`
2. ✅ Verify Vietnamese packages: `python -c "import vnstock_ta, vnai, vnii"`
3. ✅ Review logs: `tail -f RunningLog/cron_etl.log`
4. ✅ Test manually: `./run_etl.sh`
5. ✅ Check LaunchAgent: `launchctl list | grep vntrading`

**Common Solutions:**
- **Path issues** → Run `python3 -m venv VNTrading_env --upgrade-deps`
- **Missing VN packages** → Re-clone repository
- **Permission errors** → Run `chmod +x *.sh`
- **LaunchAgent issues** → Move out of Desktop directory
- **Data issues** → Check internet connection and Vietnamese market hours

---

**🇻🇳 Designed for Vietnamese Stock Market | 🖥️ macOS Optimized | 📊 Production Ready | 🤖 AI-Enhanced**
