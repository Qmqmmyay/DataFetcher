# VNTrading DataFetcher - Setup Guide

## ⚠️ CRITICAL WARNINGS

### 🚨 INCLUDED VIRTUAL ENVIRONMENT
**This repository includes a complete virtual environment (`VNTrading_env/`) with ALL Python packages pre-installed.**

**Why?** This project uses **unreleased/offline Vietnamese trading libraries** that are NOT available on PyPI:
- `vnstock` (3.2.6) - Vietnamese stock data
- `vnstock_ta` (0.1.1) - Technical analysis for VN market
- `vnstock_data` (2.0.7) - VN market data APIs
- `vnstock_ezchart` (0.0.2) - VN market charts
- `vnstock_pipeline` (2.0) - VN data pipelines
- `vnai` (2.0.4) - Vietnamese AI trading tools
- `vnii` (0.0.7) - VN investment intelligence

**⚠️ These packages CANNOT be installed via `pip install` elsewhere!**

### 🖥️ SYSTEM REQUIREMENTS
- **macOS ONLY** - LaunchAgent automation requires macOS `launchd`
- **NOT for Desktop directory** - Must be in `/Users/username/` or `/Users/username/Documents/`
- Python 3.12 (pre-configured in included virtual environment)

### 📁 LOCATION REQUIREMENTS
```bash
# ✅ CORRECT locations:
/Users/yourusername/VNTrading_DataFetcher/
/Users/yourusername/Documents/VNTrading_DataFetcher/

# ❌ AVOID Desktop (launchd compatibility issues):
/Users/yourusername/Desktop/VNTrading_DataFetcher/
```

## 🚀 Setup on New Computer

## 🚀 Setup on New Computer

### Option 1: Use Included Virtual Environment (RECOMMENDED)

**Since this repository includes a complete virtual environment with offline packages:**

1. **Clone to correct location:**
   ```bash
   cd /Users/yourusername/
   git clone https://github.com/Qmqmmyay/DataFetcher.git VNTrading_DataFetcher
   cd VNTrading_DataFetcher
   ```

2. **Activate included environment:**
   ```bash
   source VNTrading_env/bin/activate
   ```

3. **Test the offline packages:**
   ```bash
   python -c "import vnstock, vnstock_ta, vnai, vnii; print('All VN packages loaded successfully!')"
   ```

4. **Setup automation (macOS only):**
   ```bash
   ./setup_launchd.sh
   ```

### Option 2: Fresh Setup (NOT RECOMMENDED)

⚠️ **Warning: You will lose access to offline VN packages!**

### Option 2: Fresh Setup (NOT RECOMMENDED)

⚠️ **Warning: You will lose access to offline VN packages!**

Only use this if you don't need the Vietnamese trading packages:

```bash
./setup_new_computer.sh
```

## 🔍 Verifying Your Setup

### Check Virtual Environment:
```bash
source VNTrading_env/bin/activate
pip list | grep -E "^(vnstock|vnai|vnii)"
```

Expected output:
```
vnai                    2.0.4
vnii                    0.0.7
vnstock                 3.2.6
vnstock_data            2.0.7
vnstock_ezchart         0.0.2
vnstock_pipeline        2.0
vnstock_ta              0.1.1
```

### Test ETL Process:
```bash
./run_etl.sh
```

## 📋 What's Included in This Repository

## 📋 What's Included in This Repository

### ✅ Complete Package:
- **All Python source code** - ETL scripts, data processing
- **Complete Virtual Environment** - 24,000+ files with all dependencies
- **Offline VN Trading Packages** - Not available elsewhere
- **Database schema** - SQLite setup
- **Configuration files** - Market symbols, constants
- **Shell scripts** - Automation and setup tools
- **macOS LaunchAgent** - Automated daily execution

### 🔐 Offline Dependencies Included:
- `vnstock` ecosystem (7 packages)
- `pandas`, `numpy`, `openpyxl` 
- `beautifulsoup4`, `requests`
- `jupyter`, `ipython`
- And 100+ other dependencies

### ❌ NOT Included (Platform-Specific):
- Python interpreter (use system Python 3.12)
- macOS system permissions
- LaunchAgent registration (done by setup script)

## 🔧 Post-Setup & Usage

### Daily Automated Execution (macOS only):
```bash
# Setup once:
./setup_launchd.sh

# Monitor logs:
tail -f RunningLog/cron_etl.log
```

### Manual Execution:
```bash
source VNTrading_env/bin/activate
./run_etl.sh
```

### Verify Automation:
```bash
# Check if LaunchAgent is loaded:
launchctl list | grep vntrading

# View recent runs:
ls -la RunningLog/
```

## 📊 Project Structure

```
VNTrading_DataFetcher/
├── 🚀 setup_new_computer.sh      # Fresh setup (loses VN packages)
├── 📚 requirements.txt           # Basic package list
├── 🔄 run_etl.sh                # ETL execution script
├── ⏰ setup_launchd.sh           # macOS automation setup
├── 🐍 VNTrading_env/             # COMPLETE virtual environment (578MB)
│   ├── bin/                      # Python executables
│   ├── lib/python3.12/site-packages/  # ALL packages (24,000+ files)
│   │   ├── vnstock/              # 🇻🇳 VN stock data
│   │   ├── vnstock_ta/           # 🇻🇳 VN technical analysis
│   │   ├── vnai/                 # 🇻🇳 VN AI trading
│   │   └── vnii/                 # 🇻🇳 VN investment intelligence
│   └── README.md                 # Virtual env documentation
├── 💾 core/                      # Data processing engine
├── ⚙️ config/                    # Configuration files
├── 📜 scripts/                   # Main ETL scripts
├── 🛠️ utils/                     # Utility functions
├── 🗄️ data/                      # SQLite database storage
└── 📊 RunningLog/               # Execution logs and outputs
```

## 🆘 Troubleshooting

### "VN Package Import Errors"
```bash
# Ensure you're using the included environment:
source VNTrading_env/bin/activate
python -c "import vnstock; print('VN packages available!')"
```

### "Permission Denied on Scripts"
```bash
chmod +x *.sh
```

### "LaunchAgent Not Working"
```bash
# macOS only - check location:
pwd  # Should NOT be in Desktop
./cleanup_old_launchd.sh
./setup_launchd.sh
```

### "Python Version Mismatch"
```bash
# Use the included Python:
VNTrading_env/bin/python --version  # Should be 3.12.x
```

## 🔒 Important Notes

1. **Repository Size**: ~578MB due to included virtual environment
2. **First Clone**: Takes longer due to 24,000+ files
3. **VN Packages**: Cannot be installed elsewhere - unique to this repo
4. **macOS Only**: LaunchAgent automation requires macOS `launchd`
5. **Location Matters**: Avoid Desktop directory for automation compatibility

## 📞 Support

**Before asking for help:**
1. Check `RunningLog/cron_etl.log` for errors
2. Verify you're using included virtual environment
3. Confirm macOS and correct directory location
4. Test VN package imports manually

**Common Issues:**
- ❌ Used `./setup_new_computer.sh` → Lost offline packages
- ❌ Cloned to Desktop → LaunchAgent issues  
- ❌ Used system Python → Missing VN packages
- ❌ Wrong activation → `source VNTrading_env/bin/activate`
