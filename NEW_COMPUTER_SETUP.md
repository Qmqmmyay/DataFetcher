# 🚀 VNTrading DataFetcher - New Computer Setup Guide

## 📋 Quick Setup (3 Steps)

### Step 1: Copy the Project
Copy the entire `VNTrading_DataFetcher` folder to the new computer's **home directory**:
```
~/VNTrading_DataFetcher/
```

**Important**: The project must be in the home directory (`~`) for LaunchAgents to work properly!

### Step 2: Run Setup Script
```bash
cd ~/VNTrading_DataFetcher
./setup_new_computer.sh
```

### Step 3: Enable Automation
```bash
./setup_launchd.sh
```

## ✅ What the Setup Does

The `setup_new_computer.sh` script will:
1. ✅ Check Python 3.8+ is installed
2. 🗑️ Remove old virtual environment (computer-specific paths)
3. 📦 Create new virtual environment with correct paths
4. 📚 Install all required Python packages
5. 🧪 Test the installation
6. 📁 Create necessary directories
7. 🔧 Make all scripts executable
8. 🗄️ Test database creation

## 📊 After Setup

### Test Manual ETL Run:
```bash
cd ~/VNTrading_DataFetcher
./run_etl.sh
```

### View Logs:
```bash
tail -f ~/VNTrading_DataFetcher/RunningLog/cron_etl.log
```

### Check LaunchAgent Status:
```bash
launchctl list | grep vntrading
```

## 🔧 Automation Schedule

Once set up, the system will:
- **Run daily at 15:00 (3:00 PM)** automatically
- **Weekdays**: Fetch price + intraday data
- **Quarterly (11th of Jan/Apr/Jul/Oct)**: Also fetch company + finance data  
- **Weekends**: Skip execution (unless quarterly date)

## 🗂️ Project Structure After Setup

```
~/VNTrading_DataFetcher/
├── setup_new_computer.sh    # 🚀 Main setup script
├── setup_launchd.sh         # ⏰ Schedule automation
├── run_etl.sh              # 🔄 ETL execution script
├── VNTrading_env/          # 🐍 Virtual environment (recreated)
├── RunningLog/            # 📊 Logs and outputs
├── data/                   # 🗄️ Database storage
└── [other project files...]
```

## 🆘 Troubleshooting

### "Python not found" Error:
Install Python 3.8+ from https://www.python.org/downloads/

### "Permission denied" Error:
```bash
chmod +x *.sh
./setup_new_computer.sh
```

### "LaunchAgent not working" Error:
```bash
# Make sure project is in home directory (not Desktop!)
mv /path/to/VNTrading_DataFetcher ~/VNTrading_DataFetcher
cd ~/VNTrading_DataFetcher
./setup_launchd.sh
```

### Package Installation Issues:
```bash
cd ~/VNTrading_DataFetcher
source VNTrading_env/bin/activate
pip install -r requirements.txt
```

## 🎯 Success Indicators

✅ **Setup Successful** when you see:
- Virtual environment created
- All packages installed
- Database test passes
- ETL script test passes

✅ **LaunchAgent Working** when:
- `launchctl list | grep vntrading` shows status 0
- Logs appear in `RunningLog/cron_etl.log`
- No errors in `RunningLog/launchd_stderr.log`

## 📞 Quick Commands Reference

```bash
# Setup on new computer
cd ~/VNTrading_DataFetcher
./setup_new_computer.sh
./setup_launchd.sh

# Monitor
tail -f RunningLog/cron_etl.log
launchctl list | grep vntrading

# Manual test
./run_etl.sh

# Stop automation
./uninstall_launchd.sh
```

---

**That's it!** Your automated Vietnamese stock data fetcher will be running daily at 3:00 PM! 🎉
