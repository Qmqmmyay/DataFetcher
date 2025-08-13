# 📦 VNTrading DataFetcher - Transfer Checklist

## 🎯 For the Person Receiving This Project

### ✅ Prerequisites (New Computer)
- [ ] macOS or Linux computer
- [ ] Python 3.8+ installed ([Download here](https://www.python.org/downloads/))
- [ ] Internet connection
- [ ] Terminal/Command line access

### 📂 Transfer Steps

#### 1. Copy Project to Home Directory
```bash
# Copy the entire VNTrading_DataFetcher folder to:
~/VNTrading_DataFetcher/
```

**⚠️ Important**: Must be in home directory (`~`), not Desktop!

#### 2. Run Setup (One Command)
```bash
cd ~/VNTrading_DataFetcher
./setup_new_computer.sh
```

#### 3. Enable Daily Automation
```bash
./setup_launchd.sh
```

### 🧪 Test Everything Works
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

## 🆘 If Something Goes Wrong

### Python Issues:
```bash
# Install Python 3.8+
https://www.python.org/downloads/

# Re-run setup
./setup_new_computer.sh
```

### Permission Issues:
```bash
chmod +x *.sh
./setup_new_computer.sh
```

### LaunchAgent Issues:
```bash
# Make sure in home directory
mv /path/to/project ~/VNTrading_DataFetcher
cd ~/VNTrading_DataFetcher
./setup_launchd.sh
```

## 📞 Quick Reference

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
