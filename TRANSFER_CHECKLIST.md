# 📦 VNTrading DataFetcher - Transfer Checklist

## 🎯 For the Person Receiving This Project

### ✅ Prerequisites (New Computer)

#### For All Systems:
- [ ] Python 3.12+ installed ([Download here](https://www.python.org/downloads/))
- [ ] Git installed ([Download here](https://git-scm.com/downloads))
- [ ] Internet connection

#### Additional for Windows:
- [ ] "Add Python to PATH" checked during installation
- [ ] PowerShell or Command Prompt access
- [ ] Administrator privileges

#### Additional for macOS:
- [ ] Terminal access
- [ ] Command Line Tools (`xcode-select --install`)

### 📂 Transfer Steps

#### Windows Users:

1. Copy Project to User Directory
```powershell
# Copy VNTrading_DataFetcher folder to:
C:\Users\YourUsername\VNTrading_DataFetcher
```

**⚠️ Important**: Must be in User directory, not Desktop!

2. Run Setup
   - Right-click on `setup_new_computer.bat`
   - Select "Run as administrator"

3. Enable Daily Automation
```powershell
python setup_windows_task.py
```

#### macOS Users:

1. Copy Project to Home Directory
```bash
# Copy VNTrading_DataFetcher folder to:
~/VNTrading_DataFetcher/
```

**⚠️ Important**: Must be in home directory (`~`), not Desktop!

2. Run Setup
```bash
cd ~/VNTrading_DataFetcher
./setup_new_computer.sh
```

3. Enable Daily Automation
```bash
./setup_launchd.sh
```

### 🧪 Test Everything Works

#### Windows Testing:
```powershell
# Test manual run
python scripts/main_etl_runner.py

# Check scheduled task
schtasks /query /tn "VNTrading Data Fetcher"

# Monitor logs
Get-Content -Path logs\fetcher.log -Wait
```

#### macOS Testing:
```bash
# Test manual run
./run_etl.sh

# Check automation status
launchctl list | grep vntrading

# Monitor logs
tail -f RunningLog/cron_etl.log
```

## 🕒 What Happens After Setup

- **Daily at 15:00 (3:00 PM)**: Automatically fetches Vietnamese stock data
- **Weekdays**: Price + intraday data  
- **Quarterly**: Company + financial data
- **Weekends**: Skipped (unless quarterly)
- **Logs**: Saved in `RunningLog/` folder

## 🆘 Troubleshooting

### Common Issues (All Systems):
- Make sure Python 3.12+ is installed from https://www.python.org/downloads/
- Verify project is in correct directory location
- Check logs for specific error messages

### Windows-Specific:
```powershell
# Python PATH issues:
# Open System Properties > Advanced > Environment Variables
# Add Python and pip to PATH

# Permission issues:
# Run PowerShell as Administrator:
Set-ExecutionPolicy RemoteSigned
.\setup_new_computer.bat

# Task Scheduler issues:
schtasks /delete /tn "VNTrading Data Fetcher" /f
python setup_windows_task.py
```

### macOS-Specific:
```bash
# Permission issues:
chmod +x *.sh
./setup_new_computer.sh

# LaunchAgent issues:
# Ensure project is in home directory:
mv /path/to/project ~/VNTrading_DataFetcher
cd ~/VNTrading_DataFetcher
./setup_launchd.sh
```

## 📞 Quick Reference

### Windows Commands

| Task | Command |
|------|---------|
| Setup | Right-click `setup_new_computer.bat` > Run as administrator |
| Enable automation | `python setup_windows_task.py` |
| Manual run | `python scripts/main_etl_runner.py` |
| Check status | `schtasks /query /tn "VNTrading Data Fetcher"` |
| View logs | `type logs\fetcher.log` |
| Stop automation | `schtasks /delete /tn "VNTrading Data Fetcher" /f` |

### macOS Commands

| Task | Command |
|------|---------|
| Setup | `./setup_new_computer.sh` |
| Enable automation | `./setup_launchd.sh` |
| Manual run | `./run_etl.sh` |
| Check status | `launchctl list \| grep vntrading` |
| View logs | `tail -f RunningLog/cron_etl.log` |
| Stop automation | `./uninstall_launchd.sh` |

---

**Total setup time**: ~5 minutes ⏱️  
**Automation**: Fully automated daily data fetching 🤖  
**Maintenance**: Zero maintenance required ✅
