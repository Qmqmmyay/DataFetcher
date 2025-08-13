# 🚀 VNTrading DataFetcher - Complete Setup Guide

## 🚨 **CRITICAL: Read This First**

This repository includes a **578MB virtual environment** with **offline Vietnamese trading packages** that are NOT available on PyPI:
- 🇻🇳 **vnstock_ta** - Vietnamese technical analysis
- 🇻🇳 **vnai** - Vietnamese AI trading tools  
- 🇻🇳 **vnii** - Vietnamese investment intelligence
- 🇻🇳 **vnstock_data** - Vietnamese market data pipelines
- 🇻🇳 **vnstock_ezchart** - Vietnamese market charts
- 🇻🇳 **vnstock_pipeline** - Vietnamese data workflows

**⚠️ These packages cannot be installed anywhere else!**

---

## 🖥️ **System Requirements**

| Requirement | Details |
|-------------|---------|
| **Operating System** | macOS only (LaunchAgent automation) |
| **Python Version** | 3.12+ (included in virtual environment) |
| **Location** | `/Users/username/VNTrading_DataFetcher` |
| **❌ Avoid** | Desktop directory (causes LaunchAgent issues) |
| **Disk Space** | ~800MB free space |
| **Internet** | Required for Vietnamese stock market APIs |

---

## ⚡ **Quick Setup (Recommended)**

### **Step 1: Clone Repository**
```bash
# Clone to your home directory (NOT Desktop!)
cd /Users/yourusername/
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

### **Step 3: Setup Automation**
```bash
# Enable daily automated execution at 3:00 PM
./setup_launchd.sh
```

### **Step 4: Test Everything**
```bash
# Test manual run
./run_etl.sh

# Check Vietnamese packages
source VNTrading_env/bin/activate
python -c "import vnstock_ta, vnai, vnii; print('🇻🇳 All VN packages working!')"
```

---

## 🔧 **Manual Setup (Alternative)**

If you prefer manual control:

### **Option A: Preserve Offline Packages (Recommended)**
```bash
# Update virtual environment paths while keeping packages
python3 -m venv VNTrading_env --upgrade-deps
source VNTrading_env/bin/activate

# Verify Vietnamese packages are preserved
python -c "import vnstock_ta, vnai, vnii; print('✅ Offline packages preserved!')"
```

### **Option B: Fresh Installation (Loses Vietnamese Packages)**
```bash
# ⚠️ WARNING: This destroys offline Vietnamese packages!
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
# Test ETL pipeline
./run_etl.sh

# Check automation status
launchctl list | grep vntrading

# Monitor logs
tail -f RunningLog/cron_etl.log
```

---

## 📊 **Project Structure Overview**

```
VNTrading_DataFetcher/                    # 760MB total
├── 🐍 VNTrading_env/                     # 578MB - Complete Python environment
│   └── lib/python3.12/site-packages/    # 24,000+ files including VN packages
├── 🔧 setup_new_computer.sh             # Smart setup script (preserves VN packages)
├── ⏰ setup_launchd.sh                  # macOS automation setup
├── 🔄 run_etl.sh                        # Manual ETL execution
├── 💾 core/                             # Data processing engine
├── ⚙️ config/                           # Stock symbols and constants
├── 📜 scripts/                          # Main ETL orchestration
├── 🛠️ utils/                            # Helper functions
├── 🗄️ data/                             # SQLite database
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

### **Monitor Automation**
```bash
# Check if automation is active
launchctl list | grep vntrading

# View recent execution logs
ls -la RunningLog/

# Watch live execution
tail -f RunningLog/cron_etl.log
```

### **Disable Automation**
```bash
./uninstall_launchd.sh
```

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
```

### **"Database or ETL Errors"**
```bash
# Recreate database
source VNTrading_env/bin/activate
python core/database.py

# Test ETL manually
./run_etl.sh
```

---

## 💡 **Important Tips**

### **✅ Do This:**
- Clone to `/Users/username/VNTrading_DataFetcher`
- Use the setup script (`./setup_new_computer.sh`)
- Run `python3 -m venv VNTrading_env --upgrade-deps` to fix paths
- Test Vietnamese packages after setup

### **❌ Avoid This:**
- Cloning to Desktop directory
- Running `rm -rf VNTrading_env` (destroys offline packages)
- Using `pip install` to reinstall Vietnamese packages (they're not on PyPI)
- Ignoring the location requirements

---

## 📈 **What Happens During Execution**

1. **15:00 Daily Trigger** - macOS LaunchAgent starts the process
2. **Network Check** - Verifies internet connectivity and DNS
3. **Market Data Collection** - Fetches Vietnamese stock market data
4. **Data Processing** - Cleans and validates market information
5. **Database Storage** - Saves processed data to SQLite
6. **Excel Export** - Generates timestamped report
7. **Logging** - Records execution details and any errors

---

## 🇻🇳 **Vietnamese Market Coverage**

- **Stock Exchanges**: HOSE, HNX, UPCOM
- **Data Types**: Real-time prices, historical data, technical indicators
- **Analysis Tools**: AI-driven insights, investment intelligence
- **Export Formats**: Excel reports with Vietnamese market specifics

---

## 📞 **Getting Help**

**Before asking for help:**
1. ✅ Check you're in correct location (not Desktop)
2. ✅ Verify Vietnamese packages: `python -c "import vnstock_ta, vnai, vnii"`
3. ✅ Review logs: `tail -f RunningLog/cron_etl.log`
4. ✅ Test manually: `./run_etl.sh`

**Common Solutions:**
- **Path issues** → Run `python3 -m venv VNTrading_env --upgrade-deps`
- **Missing VN packages** → Re-clone repository
- **Permission errors** → Run `chmod +x *.sh`
- **LaunchAgent issues** → Move out of Desktop directory

---

**🇻🇳 Designed for Vietnamese Stock Market | 🖥️ macOS Optimized | 📊 Production Ready**
