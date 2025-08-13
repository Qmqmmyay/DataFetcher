# VNTrading DataFetcher - New Computer Setup

## 🚀 Quick Setup on New Computer

### Prerequisites
- macOS or Linux
- Python 3.8+ installed
- Internet connection

### One-Command Setup
```bash
./setup_new_computer.sh
```

This script will:
1. ✅ Check Python installation
2. 🗑️ Remove old virtual environment
3. 📦 Create new virtual environment  
4. 📚 Install all required packages
5. 📁 Create necessary directories
6. 🧪 Test the installation
7. 🔧 Make all scripts executable

### Manual Setup (Alternative)

If you prefer manual setup:

1. **Create virtual environment:**
   ```bash
   python3 -m venv VNTrading_env
   source VNTrading_env/bin/activate
   ```

2. **Install packages:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Test installation:**
   ```bash
   python core/database.py
   ./run_etl.sh
   ```

4. **Setup automation:**
   ```bash
   ./setup_launchd.sh
   ```

## 📋 What Gets Transferred

### ✅ Works Automatically:
- All Python source code
- Database schema
- Configuration files
- Shell scripts

### ❌ Needs Reconfiguration:
- Virtual environment (computer-specific paths)
- LaunchAgent (needs new absolute paths)
- Python packages (need reinstallation)

## 🔧 Post-Setup

After running `setup_new_computer.sh`:

1. **Test ETL manually:**
   ```bash
   ./run_etl.sh
   ```

2. **Setup automated daily runs:**
   ```bash
   ./setup_launchd.sh
   ```

3. **Monitor logs:**
   ```bash
   tail -f RunningLog/cron_etl.log
   ```

## 📊 Project Structure

```
DataFetcher/
├── setup_new_computer.sh    # 🚀 Main setup script
├── requirements.txt         # 📚 Python dependencies
├── run_etl.sh              # 🔄 ETL execution script
├── setup_launchd.sh        # ⏰ Schedule automation
├── VNTrading_env/          # 🐍 Virtual environment (recreated)
├── core/                   # 💾 Core data processing
├── config/                 # ⚙️ Configuration files
├── scripts/                # 📜 Main ETL scripts
├── utils/                  # 🛠️ Utility functions
├── data/                   # 🗄️ Database storage
└── RunningLog/            # 📊 Logs and outputs
```

## 🆘 Troubleshooting

### Python Import Errors
```bash
# Reinstall packages
source VNTrading_env/bin/activate
pip install -r requirements.txt
```

### Permission Errors
```bash
# Fix script permissions
chmod +x *.sh
```

### LaunchAgent Issues
```bash
# Clean up and reinstall
./cleanup_old_launchd.sh
./setup_launchd.sh
```

### Database Issues
```bash
# Recreate database
python core/database.py
```

## 📞 Support

If you encounter issues:
1. Check `RunningLog/cron_etl.log` for ETL errors
2. Run `./setup_new_computer.sh` again
3. Ensure Python 3.8+ is installed
4. Check internet connection for vnstock API
