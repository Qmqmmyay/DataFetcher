# 🇻🇳 VNTrading DataFetcher

> **Automated Vietnamese Stock Market Data Collection & Analysis System**

A comprehensive ETL (Extract, Transform, Load) system designed specifically for Vietnamese stock market data collection using specialized Vietnamese trading libraries that are not available on standard package repositories.

## 🚨 **Special Repository Notice**

This repository is **unique** because it includes a complete Python virtual environment (578MB) containing **offline Vietnamese trading packages** that cannot be installed via `pip` elsewhere:

- 📊 **vnstock** (3.2.6) - Vietnamese stock data APIs
- 📈 **vnstock_ta** (0.1.1) - Technical analysis for VN market  
- 📉 **vnstock_data** (2.0.7) - VN market data pipelines
- 📋 **vnstock_ezchart** (0.0.2) - VN market visualization
- 🔄 **vnstock_pipeline** (2.0) - VN data processing workflows
- 🤖 **vnai** (2.0.4) - Vietnamese AI trading tools
- 🧠 **vnii** (0.0.7) - VN investment intelligence

## 📊 **Project Size & Composition**

| Component | Size | Percentage | Description |
|-----------|------|------------|-------------|
| 🐍 **Virtual Environment** | 578MB | 76% | Complete Python environment with offline VN packages |
| 📁 **Git Repository** | 182MB | 24% | Version control and file storage |
| 💻 **Source Code** | 196KB | <1% | Core ETL logic, configuration, utilities |
| 📄 **Documentation** | 48KB | <1% | Setup guides, documentation, scripts |
| 📊 **Logs/Data** | 180KB | <1% | Runtime logs and database files |
| **TOTAL** | **760MB** | **100%** | Complete project |

## 🎯 **Features**

- ✅ **Automated Daily Data Collection** - Runs daily at 3:00 PM using macOS LaunchAgent
- 📊 **SQLite Database Storage** - Structured data storage with proper schema
- 📈 **Vietnamese Market Focus** - Specialized for VN stock exchanges (HOSE, HNX, UPCOM)
- 🔄 **ETL Pipeline** - Extract, Transform, Load with error handling
- 📋 **Excel Export** - Daily reports in Excel format
- 🖥️ **macOS Integration** - Native LaunchAgent scheduling
- 🛠️ **Offline Packages** - No dependency on external package repositories

## 🖥️ **System Requirements**

- **macOS** (required for LaunchAgent automation)
- **Python 3.12** (included in virtual environment)
- **Location**: Must be in `/Users/username/` (NOT Desktop)
- **Disk Space**: ~800MB free space
- **Internet**: Required for Vietnamese stock market APIs

## ⚡ **Quick Start**

```bash
# 1. Clone repository
cd /Users/yourusername/
git clone https://github.com/Qmqmmyay/DataFetcher.git VNTrading_DataFetcher
cd VNTrading_DataFetcher

# 2. Fix virtual environment paths for new system
python3 -m venv VNTrading_env --upgrade-deps
source VNTrading_env/bin/activate

# 3. Test Vietnamese packages
python -c "import vnstock, vnstock_ta, vnai, vnii; print('✅ All VN packages loaded!')"

# 4. Setup automation (macOS only)
./setup_launchd.sh

# 5. Manual test run
./run_etl.sh
```

## 📁 **Project Structure**

```
VNTrading_DataFetcher/                 # 760MB total
├── 🐍 VNTrading_env/                  # 578MB - Complete Python environment
│   ├── bin/                          #   Python executables and scripts
│   ├── lib/python3.12/site-packages/ #   All Python packages (24,000+ files)
│   │   ├── 🇻🇳 vnstock/              #   Vietnamese stock data library
│   │   ├── 🇻🇳 vnstock_ta/           #   VN technical analysis tools
│   │   ├── 🇻🇳 vnai/                 #   VN AI trading algorithms
│   │   └── 🇻🇳 vnii/                 #   VN investment intelligence
│   └── README.md                     #   Virtual environment docs
├── 💾 core/                          # Core data processing
│   ├── data_loader.py               #   Data extraction logic
│   ├── database.py                  #   SQLite database management
│   └── __init__.py
├── ⚙️ config/                        # Configuration management
│   ├── const.py                     #   System constants
│   ├── symbols.py                   #   Stock symbols and market data
│   └── __init__.py
├── 📜 scripts/                       # Main ETL execution
│   ├── main_etl_runner.py           #   Primary ETL orchestrator
│   └── __init__.py
├── 🛠️ utils/                         # Utility functions
│   ├── data_utils.py                #   Data processing helpers
│   └── __init__.py
├── 🗄️ data/                          # Database storage
├── 📊 logs/                          # Application logs
├── 📈 RunningLog/                    # Execution logs and Excel outputs
├── 🚀 setup_new_computer.sh          # Fresh installation script
├── ⏰ setup_launchd.sh               # macOS automation setup
├── 🔄 run_etl.sh                     # ETL execution script
├── 🧹 cleanup_old_launchd.sh         # LaunchAgent cleanup
├── 📚 README.md                      # This file
├── 📋 README_SETUP.md                # Detailed setup instructions
├── 📋 requirements.txt               # Python dependencies list
└── 📄 *.md files                     # Additional documentation
```

## 🔄 **How It Works**

1. **📅 Scheduled Execution**: macOS LaunchAgent triggers at 15:00 daily
2. **🔍 Environment Check**: Verifies network connectivity and DNS resolution
3. **📊 Data Collection**: Fetches Vietnamese stock market data using vnstock APIs
4. **🔄 Data Processing**: Cleans, transforms, and validates market data
5. **💾 Database Storage**: Stores processed data in SQLite database
6. **📋 Excel Export**: Generates daily Excel report with timestamp
7. **📝 Logging**: Records execution details and any errors
8. **✅ Completion Marker**: Creates daily completion file to prevent re-runs

## 🛡️ **Why Include Virtual Environment?**

**Traditional Approach Problems:**
- Vietnamese trading packages are **not available on PyPI**
- Packages may be **unreleased/beta versions**
- **Complex dependencies** between VN-specific libraries
- **Installation failures** on different systems

**Our Solution:**
- ✅ **Guaranteed compatibility** - Tested, working environment
- ✅ **Offline capability** - No external dependency resolution
- ✅ **Version consistency** - Exact same packages everywhere
- ✅ **Quick setup** - Clone and run, no complex installation

## 📈 **Data Sources**

- **Vietnamese Stock Exchanges**: HOSE, HNX, UPCOM
- **Market Data**: Real-time and historical prices
- **Technical Indicators**: Moving averages, RSI, MACD
- **Financial Data**: Company fundamentals, financial statements
- **Market Intelligence**: AI-driven insights and analysis

## 🔧 **Maintenance**

### Daily Monitoring
```bash
# Check recent runs
ls -la RunningLog/

# View latest log
tail -f RunningLog/cron_etl.log

# Check LaunchAgent status
launchctl list | grep vntrading
```

### Troubleshooting
```bash
# Manual test run
source VNTrading_env/bin/activate
./run_etl.sh

# Reset automation
./cleanup_old_launchd.sh
./setup_launchd.sh
```

## 📝 **Documentation**

- 📋 **[Setup Guide](README_SETUP.md)** - Detailed installation instructions
- 🔧 **[New Computer Setup](NEW_COMPUTER_SETUP.md)** - Migration guide
- ✅ **[Transfer Checklist](TRANSFER_CHECKLIST.md)** - Deployment checklist
- 📊 **[Virtual Environment Info](VNTrading_env/README.md)** - Package details

## ⚠️ **Important Warnings**

- 🖥️ **macOS Only** - LaunchAgent requires macOS `launchd`
- 📁 **Location Sensitive** - Must NOT be in Desktop directory
- 🔄 **Virtual Environment** - Do NOT recreate from scratch (loses offline packages)
- 🌐 **Network Required** - Needs internet for Vietnamese market APIs
- 💾 **Disk Space** - Requires ~800MB free space

## 🤝 **Contributing**

Due to the specialized nature of offline Vietnamese packages, contributions should:

1. **Preserve Virtual Environment** - Do not modify `VNTrading_env/`
2. **Test with VN Packages** - Ensure Vietnamese market functionality
3. **macOS Compatibility** - Test LaunchAgent automation
4. **Documentation** - Update README for any changes

## 📄 **License**

This project includes proprietary Vietnamese trading packages. Please respect the licensing terms of included packages.

## 📞 **Support**

For issues:
1. 📋 Check [Setup Guide](README_SETUP.md)
2. 📊 Review `RunningLog/cron_etl.log`
3. 🔍 Verify Vietnamese package imports
4. 🖥️ Confirm macOS LaunchAgent status

---

**🇻🇳 Designed for Vietnamese Stock Market | 🖥️ Optimized for macOS | 📊 Production Ready**
