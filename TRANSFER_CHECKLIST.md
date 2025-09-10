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
python setup_launchd_win.py
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
run_etl.bat

# Check scheduled task
schtasks /query /tn VNTrading_DataFetcher_ETL

# Monitor logs
type RunningLog\cron_etl.log
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

- **Automated Task**:
  - Windows: Task Scheduler runs `run_etl.bat`
  - macOS: LaunchAgent runs `run_etl.sh`
- **Schedule**:
  - Daily at 15:00 (3:00 PM)
  - Weekdays: Price + intraday data  
  - Quarterly (11th of Jan/Apr/Jul/Oct): Company + financial data
  - Weekends: Skipped (unless quarterly)
- **Monitoring**:
  - Logs: Saved in `RunningLog/` folder
  - Status checks: Use platform-specific commands

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
uninstall_task.bat
python setup_launchd_win.py
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
| Enable automation | `python setup_launchd_win.py` |
| Manual run | `run_etl.bat` |
| Check status | `schtasks /query /tn VNTrading_DataFetcher_ETL` |
| View logs | `type RunningLog\cron_etl.log` |
| Stop automation | `uninstall_task.bat` |
| Validate setup | `validate_transfer.bat` |

### macOS Commands

| Task | Command |
|------|---------|
| Setup | `./setup_new_computer.sh` |
| Enable automation | `./setup_launchd.sh` |
| Manual run | `./run_etl.sh` |
| Check status | `launchctl list \| grep vntrading` |
| View logs | `tail -f RunningLog/cron_etl.log` |
| Stop automation | `./uninstall_launchd.sh` |
| Validate setup | `./validate_transfer.sh` |

---

**Total setup time**: ~5 minutes ⏱️  
**Automation**: Fully automated daily data fetching 🤖  
**Maintenance**: Zero maintenance required ✅
