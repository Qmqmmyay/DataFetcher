# 🇻🇳 VNTrading DataFetcher

> **Automated Vietnamese Stock Market Data Collection & Analysis System**

An advanced ETL (Extract, Transform, Load) system specifically designed for Vietnamese stock market data collection. This project includes **rare offline Vietnamese trading packages** (578MB) that cannot be installed from standard repositories, making it a unique and valuable resource for Vietnamese market analysis.

## 🚨 **What Makes This Project Special**

This repository is **unique** because it contains:

- 📦 **578MB Virtual Environment** with offline Vietnamese trading packages
- 🇻🇳 **Specialized VN Market Libraries** not available on PyPI
- 🤖 **Automated Daily Data Collection** using macOS LaunchAgent
- 📊 **SQLite Database** with comprehensive Vietnamese market schema
- 📋 **Excel Reports** generated automatically
- 🔄 **Production-Ready ETL Pipeline** with error handling

### 🇻🇳 **Included Vietnamese Trading Packages**

- 📊 **vnstock** (3.2.6) - Vietnamese stock data APIs
- 📈 **vnstock_ta** (0.1.1) - Technical analysis for VN market  
- 📉 **vnstock_data** (2.0.7) - VN market data pipelines
- 📋 **vnstock_ezchart** (0.0.2) - VN market visualization
- 🔄 **vnstock_pipeline** (2.0) - VN data processing workflows
- 🤖 **vnai** (2.0.4) - Vietnamese AI trading tools
- 🧠 **vnii** (0.0.7) - VN investment intelligence

**⚠️ These packages cannot be installed anywhere else!**

## 🎯 **Key Features**

- ✅ **Automated Daily Collection** - Runs at 3:00 PM using macOS LaunchAgent
- 📊 **Vietnamese Market Focus** - HOSE, HNX, UPCOM exchanges
- 🗄️ **SQLite Database Storage** - 6 tables with proper schema
- 📋 **Excel Report Generation** - Daily automated reports
- 🖥️ **macOS Integration** - Native LaunchAgent scheduling
- 🛠️ **Offline Package Support** - No external dependencies
- 🔄 **Error Handling** - Comprehensive logging and recovery
- 📈 **Technical Analysis** - Built-in VN market indicators

## 📊 **Project Composition**

| Component | Size | Purpose |
|-----------|------|---------|
| 🐍 **Virtual Environment** | 578MB | Vietnamese trading packages |
| 💻 **Source Code** | 196KB | ETL logic and utilities |
| 📄 **Documentation** | 48KB | Setup guides and documentation |
| 📊 **Data & Logs** | 180KB | Database and execution logs |
| **Total Project** | **~800MB** | Complete trading system |

## 🚀 **Quick Start**

### **Step 1: Clone Repository**
```bash
# Clone to your home directory (NOT Desktop!)
cd /Users/$(whoami)/
git clone https://github.com/Qmqmmyay/DataFetcher.git VNTrading_DataFetcher
cd VNTrading_DataFetcher
```

### **Step 2: Run Setup Script**
```bash
# This preserves Vietnamese packages and configures paths
./setup_new_computer.sh
```

### **Step 3: Enable Automation**
```bash
# Set up daily execution at 3:00 PM
./setup_launchd.sh
```

### **Step 4: Test Everything**
```bash
# Manual test run
./run_etl.sh
```

## 📞 **Command Reference**

### **Essential Commands**
```bash
# Setup and run
./setup_new_computer.sh     # Initial setup (preserves VN packages)
./setup_launchd.sh         # Enable daily automation
./run_etl.sh              # Manual ETL execution

# Monitoring
launchctl list | grep vntrading        # Check automation status
tail -f RunningLog/cron_etl.log       # View real-time logs

# Control
./uninstall_launchd.sh     # Stop automation
./validate_transfer.sh     # Validate setup
./cleanup_old_launchd.sh   # Clean old processes
```

### **Troubleshooting**
```bash
# Fix permissions (if needed)
chmod +x *.sh

# Test Vietnamese packages
source VNTrading_env/bin/activate
python -c "import vnstock; print('✅ VN packages working')"

# Check database
sqlite3 data/trading_system.db ".tables"
```

## 📁 **Project Structure**

```
VNTrading_DataFetcher/
├── 🚀 setup_new_computer.sh          # Main setup script
├── ⏰ setup_launchd.sh               # Automation setup
├── 🔄 run_etl.sh                     # ETL execution
├── 📂 config/                        # Configuration files
├── 📂 core/                          # ETL engine
├── 📂 scripts/                       # Main execution scripts
├── 📂 utils/                         # Utility functions
├── 📂 data/                          # Database and schemas
├── 📂 logs/                          # Application logs
├── 📂 RunningLog/                    # Daily reports and logs
└── 📂 VNTrading_env/                 # Vietnamese packages (578MB)
```

## 🖥️ **System Requirements**

- **Operating System:** macOS (required for LaunchAgent)
- **Python Version:** 3.12+ (included in virtual environment)
- **Location:** `/Users/username/` (NOT Desktop directory)
- **Disk Space:** ~800MB free space
- **Internet:** Required for Vietnamese market APIs
- **Schedule:** Daily execution at 15:00 (3:00 PM)

## 📚 **Documentation**

For detailed information, see these comprehensive guides:

- 📋 **[Complete Setup Guide](SETUP_GUIDE.md)** - Detailed installation, troubleshooting, and best practices
- 📊 **[Database Documentation](data/Database_Description.md)** - Complete database schema with Vietnamese market tables
- ✅ **[Transfer Checklist](TRANSFER_CHECKLIST.md)** - Moving this project to a new computer

## 🔄 **How It Works**

1. **Daily Trigger**: macOS LaunchAgent activates at 3:00 PM
2. **Data Collection**: Fetches Vietnamese stock data using vnstock APIs
3. **Data Processing**: Transforms raw data with Vietnamese market rules
4. **Database Storage**: Updates SQLite database with 6 specialized tables
5. **Report Generation**: Creates Excel reports in `RunningLog/`
6. **Logging**: Comprehensive execution logs for monitoring

## ⚠️ **Important Notes**

- 🖥️ **macOS Only** - Uses macOS LaunchAgent for automation
- 📁 **Location Critical** - Must be in home directory, NOT Desktop
- 🔄 **Virtual Environment** - Never recreate from scratch (loses offline packages)
- 🌐 **Internet Required** - Needs connection for Vietnamese market APIs
- 📦 **Unique Packages** - Contains Vietnamese libraries not available elsewhere

## 🤝 **Contributing**

Contributions are welcome, but please:

1. **Preserve Virtual Environment** - Do not modify `VNTrading_env/`
2. **Test Vietnamese Functionality** - Ensure VN market features work
3. **Maintain macOS Compatibility** - Test LaunchAgent automation
4. **Update Documentation** - Keep guides current with changes

## 📞 **Support**

For issues and troubleshooting:

1. 📋 Check the **[Complete Setup Guide](SETUP_GUIDE.md)** for detailed instructions
2. 📊 Review `RunningLog/cron_etl.log` for execution logs
3. 🔍 Verify Vietnamese package imports work correctly
4. 🖥️ Confirm macOS LaunchAgent status

## 📄 **License**

This project includes specialized Vietnamese trading packages. Please respect the licensing terms of all included packages.

---

**🇻🇳 Built for Vietnamese Stock Market | 🖥️ Optimized for macOS | 📊 Production Ready**
