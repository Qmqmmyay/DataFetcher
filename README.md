# VNTrading DataFetcher

An advanced ETL (Extract, Transform, Load) system specifically designed for Vietnamese stock market data collection, featuring:

- 📦 **578MB Vietnamese Trading Environment** with offline packages
- 🇻🇳 **Specialized VN Market Libraries** not available on PyPI
- 🤖 **Cross-Platform Automated Collection** (Windows & macOS)  
- 📊 **SQLite Database** with comprehensive Vietnamese market schema
- 📈 **Full Market Coverage**: HOSE, HNX, UPCOM exchanges

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

## 📁 **Key Components**

```
VNTrading_DataFetcher/
├── 🚀 setup_new_computer.sh/bat     # Initial setup
├── ⏰ setup_launchd.sh/win.py       # Automation setup
├── 🔄 run_etl.sh/bat               # ETL execution
├── � data/                        # SQLite database
├── 📂 RunningLog/                  # Reports and logs
└── 📂 VNTrading_env/              # Vietnamese packages
```

👉 See [Database_Description.md](data/Database_Description.md) for schema details.

## 🖥️ **System Requirements**

- **Operating System:** Windows or macOS
- **Python Version:** 3.12+ (included in virtual environment)
- **Location:**
  - macOS: `/Users/username/` (NOT Desktop directory)
  - Windows: `C:\Users\username\` (NOT Desktop)
- **Disk Space:** ~800MB free space
- **Internet:** Required for Vietnamese market APIs
- **Schedule:** Daily execution at 15:00 (3:00 PM)
- **Permissions:** Admin rights for task scheduling setup

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

- 🖥️ **Cross-Platform Support** - Works on both Windows and macOS
- 📁 **Location Critical** - Must be in home directory, NOT Desktop
- 🔄 **Virtual Environment** - Never recreate from scratch (loses offline packages)
- 🌐 **Internet Required** - Needs connection for Vietnamese market APIs
- 📦 **Unique Packages** - Contains Vietnamese libraries not available elsewhere
- 🔒 **Admin Rights** - Required for setting up automated tasks

## 🤝 **Contributing**

Contributions are welcome, but please:

1. **Preserve Virtual Environment** - Do not modify `VNTrading_env/`
2. **Test Vietnamese Functionality** - Ensure VN market features work
3. **Cross-Platform Testing** - Verify both Windows and macOS functionality
4. **Update Documentation** - Keep guides current with changes
5. **Maintain Naming Convention** - Keep `.sh` and `.bat`/`.py` pairs consistent

## ⚡ **Quick Start**

1. Clone repository to home directory (NOT Desktop):
   ```bash
   git clone <repository-url>
   cd VNTrading_DataFetcher
   ```

2. Run initial setup:
   ```bash
   ./setup_new_computer.sh    # macOS
   setup_new_computer.bat     # Windows
   ```

3. Set up automation:
   ```bash
   ./setup_launchd.sh         # macOS
   python setup_launchd_win.py # Windows
   ```

4. Verify setup:
   ```bash
   source VNTrading_env/bin/activate
   python -c "import vnstock; print('✅ VN packages working')"
   ```

5. Check logs in `RunningLog/` directory

## 📞 **Support**

For issues and troubleshooting:

1. 📋 Check the **[Complete Setup Guide](SETUP_GUIDE.md)** for detailed instructions
2. 📊 Review `RunningLog/cron_etl.log` for execution logs
3. 🔍 Verify Vietnamese package imports work correctly
4. 🖥️ Check automation status:
   - Windows: Task Scheduler status
   - macOS: LaunchAgent status
5. 🔒 Verify admin privileges for task scheduling

## 📄 **License**

This project includes specialized Vietnamese trading packages. Please respect the licensing terms of all included packages.

---

**🇻🇳 Built for Vietnamese Stock Market | 🖥️ Windows & macOS Support | 📊 Production Ready**
