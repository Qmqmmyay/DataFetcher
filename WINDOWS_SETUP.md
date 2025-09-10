# 🪟 VNTrading DataFetcher - Complete Windows Setup Guide

> **Automated Vietnamese Stock Market Data Collection & Analysis System**

## 🚨 **CRITICAL: Read This First**

This repository includes Vietnamese trading packages that need to be installed from GitHub:

- 📊 **vnstock_data** (2.0.7) - VN market data pipelines
- 📈 **vnstock_pipeline** (2.0) - VN data processing workflows
- 📉 **vnstock_ta** (0.1.1) - Technical analysis for VN market
- 🤖 **vnii** (0.0.7) - VN investment intelligence

---

## 📊 **Project Overview**

| Component | Description |
|-----------|-------------|
| 🐍 **Virtual Environment** | Python environment with all required packages |
| 📁 **Source Code & Config** | Core ETL logic, configuration, utilities |
| 📄 **Documentation** | Setup guides, documentation, scripts |
| 📊 **Logs/Data** | Runtime logs and database files |
| 🔄 **Task Scheduler** | Windows automated execution (3:00 PM daily) |

## 🖥️ **System Requirements**

| Requirement | Details |
|-------------|---------|
| **Operating System** | Windows 10/11 |
| **Python Version** | **3.12+ REQUIRED** (for package compatibility) |
| **Git** | Required for cloning repositories |
| **Required Location** | `C:\Users\username\VNTrading_DataFetcher` |
| **❌ Avoid** | Desktop directory (permissions issues) |
| **Disk Space** | ~800MB free space |
| **Internet** | Required for Vietnamese stock market APIs |
| **Schedule** | Daily execution at 15:00 (3:00 PM) |

---

## ⚡ **Quick Setup (3 Steps - Recommended)**

### **Step 1: Install Prerequisites**
```powershell
# 1. Download and install Python 3.12+ from python.org
#    ✅ Make sure to check "Add Python to PATH" during installation

# 2. Download and install Git from git-scm.com

# 3. Install required Windows components
pip install pywin32 wheel setuptools
```

### **Step 2: Clone Repository**
   ```cmd
   cd %USERPROFILE%
   git clone https://github.com/Qmqmmyay/DataFetcher.git VNTrading_DataFetcher
   cd VNTrading_DataFetcher
   ```

3. **Run Setup:**
   ```cmd
   setup_new_computer.bat
   ```

4. **Setup Automation:**
   ```cmd
   python setup_windows_task.py
   ```
   This will create a scheduled task to run daily at 3:00 PM.

---

## 🔧 **Manual Setup Options**

1. **Create Virtual Environment:**
   ```cmd
   python -m venv VNTrading_env
   VNTrading_env\Scripts\activate
   ```

2. **Install Requirements:**
   ```cmd
   pip install -r requirements.txt
   ```

3. **Install Vietnamese Packages:**
   ```cmd
   mkdir vietnamese_packages
   cd vietnamese_packages
   
   git clone https://github.com/Qmqmmyay/vnstock_data.git
   git clone https://github.com/Qmqmmyay/vnstock_pipeline.git
   git clone https://github.com/Qmqmmyay/vnstock_ta.git
   git clone https://github.com/Qmqmmyay/vnii.git
   
   cd vnstock_data && pip install -e . && cd ..
   cd vnstock_pipeline && pip install -e . && cd ..
   cd vnstock_ta && pip install -e . && cd ..
   cd vnii && pip install -e . && cd ..
   ```

4. **Create Windows Task:**
   - Run `python setup_windows_task.py` with administrator privileges
   - Or manually create a task in Task Scheduler to run:
     ```cmd
     VNTrading_env\Scripts\python.exe scripts\main_etl_runner.py
     ```

---

## 🔍 **Verification & Maintenance**

### **Verify Installation**
```powershell
# Activate virtual environment
.\VNTrading_env\Scripts\activate

# Test package imports
python -c "import vnstock_data, vnstock_pipeline, vnstock_ta, vnii; print('✅ All packages working!')"
```

### **Check Task Scheduler**
1. Open Task Scheduler (Win + R, type `taskschd.msc`)
2. Look for task named "VNTrading_DataFetcher_ETL"
3. Verify trigger time (3:00 PM daily)
4. Check last run result and next run time

### **Update Packages**
```powershell
cd vietnamese_packages
cd vnstock_data && git pull && cd ..
cd vnstock_pipeline && git pull && cd ..
cd vnstock_ta && git pull && cd ..
cd vnii && git pull && cd ..
```

---

## ❗ **Troubleshooting**

### **Common Issues & Solutions**

| Issue | Solution |
|-------|----------|
| **🔒 Permission Denied** | • Run Command Prompt/PowerShell as Administrator<br>• Check folder permissions<br>• Verify Task Scheduler is running as correct user |
| **❌ Python Not Found** | • Check if Python is in PATH<br>• Verify with `python --version`<br>• Reinstall Python with "Add to PATH" option |
| **📛 Import Errors** | • Activate virtual environment first<br>• Check package installation: `pip list`<br>• Verify all packages are in site-packages |
| **⏰ Task Not Running** | • Check Task Scheduler logs<br>• Verify computer is not sleeping at 3 PM<br>• Ensure network connectivity |
| **🔄 Git Clone Failed** | • Check internet connection<br>• Verify GitHub access<br>• Try HTTPS instead of SSH |

### **Log File Locations**
```
%USERPROFILE%\VNTrading_DataFetcher\logs\fetcher.log    # Main log file
%USERPROFILE%\VNTrading_DataFetcher\logs\etl_log_*.log  # Daily ETL logs
```

### **Reset Installation**
```powershell
# Remove virtual environment
rmdir /s /q VNTrading_env

# Remove Vietnamese packages
rmdir /s /q vietnamese_packages

# Remove Task Scheduler entry
schtasks /delete /tn "VNTrading_DataFetcher_ETL" /f

# Start fresh with setup_new_computer.bat
```

### **Need More Help?**
- Check the GitHub repository issues
- Review the detailed logs
- Contact repository maintainers
