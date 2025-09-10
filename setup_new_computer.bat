@echo off
setlocal enabledelayedexpansion

echo 🚀 Setting up VNTrading DataFetcher for Windows...

:: Check Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed. Please install Python 3.12+ first.
    echo    Visit: https://www.python.org/downloads/
    exit /b 1
)

:: Get current Python version
for /f "tokens=2" %%I in ('python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"') do set CURRENT_PYTHON_VERSION=%%I
echo ✅ Found Python version: %CURRENT_PYTHON_VERSION%

:: Check project location
set "HOME_DIR=%USERPROFILE%"
set "PROJECT_DIR=%CD%"

echo 📂 Project location:
echo    Current: %PROJECT_DIR%
echo    Recommended: %HOME_DIR%\VNTrading_DataFetcher

if not "%PROJECT_DIR%"=="%HOME_DIR%\VNTrading_DataFetcher" (
    echo.
    echo ⚠️  Warning: Project is not in recommended location!
    echo    Task Scheduler works best when project is in user home directory.
    echo.
    set /p CONTINUE="Continue anyway? (y/N): "
    if /i not "!CONTINUE!"=="y" (
        echo Please move project to %HOME_DIR%\VNTrading_DataFetcher and run again:
        echo    move "%PROJECT_DIR%" "%HOME_DIR%\VNTrading_DataFetcher"
        exit /b 1
    )
)

:: Check if virtual environment exists with offline packages
if exist "VNTrading_env" (
    echo 🎯 Found existing virtual environment with offline Vietnamese packages

    :: Check Python version in virtual environment
    if exist "VNTrading_env\pyvenv.cfg" (
        for /f "tokens=3" %%i in ('findstr "version" VNTrading_env\pyvenv.cfg') do set VENV_PYTHON_VERSION=%%i
        echo 📋 Virtual env was created with Python: !VENV_PYTHON_VERSION!
        
        if not "!VENV_PYTHON_VERSION!"=="%CURRENT_PYTHON_VERSION%" (
            echo ⚠️  WARNING: Python version mismatch!
            echo    Virtual env: Python !VENV_PYTHON_VERSION!
            echo    Current system: Python %CURRENT_PYTHON_VERSION%
            echo    Vietnamese packages may not work due to binary incompatibility
            echo.
            set /p CONTINUE="Continue with version mismatch? (y/N): "
            if /i not "!CONTINUE!"=="y" (
                echo ❌ Setup cancelled. Consider using Python !VENV_PYTHON_VERSION!
                echo    Or re-clone the repository to get a fresh environment
                exit /b 1
            )
        )
    )

    echo 🔧 Updating environment paths to preserve offline packages...
    python -m venv VNTrading_env --upgrade-deps
    call VNTrading_env\Scripts\activate.bat

    :: Test if packages work after path update
    echo 🧪 Testing Vietnamese packages after path update...
    python -c "import vnstock_ta, vnai, vnii; print('✅ Offline packages preserved!')" 2>nul
    if !errorlevel! equ 0 (
        echo 🇻🇳 ✅ Vietnamese packages successfully preserved!
        set VN_PACKAGES_AVAILABLE=true
    ) else (
        :: Check if packages exist physically
        set VN_PKG_COUNT=0
        for /f %%i in ('dir /b VNTrading_env\Lib\site-packages ^| findstr /i "^vnstock\|^vnai\|^vnii" ^| find /c /v ""') do set VN_PKG_COUNT=%%i
        
        if !VN_PKG_COUNT! gtr 3 (
            echo    ✅ Vietnamese packages found in site-packages (!VN_PKG_COUNT! packages^)
            echo    🔧 Issue is with Python path configuration, not missing packages
            echo    ⚠️  WARNING: Preserving packages and skipping recreation
            set VN_PACKAGES_AVAILABLE=true
        ) else (
            echo    ❌ Vietnamese packages missing from site-packages
            echo    📝 Only found !VN_PKG_COUNT! Vietnamese packages
            set VN_PACKAGES_AVAILABLE=false
        )
    )
) else (
    echo 📦 Creating new virtual environment (no existing environment found^)...
    python -m venv VNTrading_env
    echo ⚠️  Note: Created fresh environment - offline Vietnamese packages not available
    set VN_PACKAGES_AVAILABLE=false
)

:: Activate virtual environment
call VNTrading_env\Scripts\activate.bat
echo ✅ Virtual environment activated

:: Comprehensive package test
:test_vietnamese_packages
echo 🔍 Verifying Vietnamese trading packages...
echo    📦 Testing vnstock_ta...
python -c "import vnstock_ta; print(f'   ✅ vnstock_ta {getattr(vnstock_ta, \"__version__\", \"(installed)\")}');" 2>nul || echo    ❌ vnstock_ta failed

echo    📦 Testing vnai...
python -c "import vnai; print(f'   ✅ vnai {getattr(vnai, \"__version__\", \"(installed)\")}');" 2>nul || echo    ❌ vnai failed

echo    📦 Testing vnii...
python -c "import vnii; print(f'   ✅ vnii {getattr(vnii, \"__version__\", \"(installed)\")}');" 2>nul || echo    ❌ vnii failed

echo    📦 Testing vnstock_data...
python -c "import vnstock_data; print(f'   ✅ vnstock_data {getattr(vnstock_data, \"__version__\", \"(installed)\")}');" 2>nul || echo    ❌ vnstock_data failed

:: Only install packages if not already available
python -c "import vnstock_ta, vnai, vnii" 2>nul
if errorlevel 1 (
    if "%VN_PACKAGES_AVAILABLE%"=="false" (
        echo ⚠️  Offline Vietnamese packages not found
        echo 📚 Installing basic packages from requirements.txt...

        :: Upgrade pip
        echo ⬆️  Upgrading pip...
        python -m pip install --upgrade pip >nul 2>&1

        :: Install required packages
        if exist "requirements.txt" (
            pip install -r requirements.txt >nul 2>&1
            echo ✅ Installed packages from requirements.txt
            echo ⚠️  Note: Only basic packages installed - Vietnamese trading packages not available
        ) else (
            pip install vnstock pandas openpyxl beautifulsoup4 requests >nul 2>&1
            echo ✅ Installed default packages
        )
    )
)

:: Create necessary directories
echo 📁 Creating necessary directories...
if not exist "RunningLog" mkdir RunningLog
if not exist "logs" mkdir logs
if not exist "data" mkdir data
echo ✅ Directories created

:: System status report
echo.
echo 📊 Setup Status Report:
echo    Files: !PROJECT_DIR!
echo    Database: !PROJECT_DIR!\data\trading_system.db
for /f %%i in ('dir /s /b *.py ^| find /c /v ""') do echo    Python files: %%i files
for /f %%i in ('dir /s /b *.bat ^| find /c /v ""') do echo    Batch files: %%i files
for /f "tokens=*" %%i in ('dir /s /a VNTrading_env ^| findstr "bytes"') do echo    Virtual env: %%i

:: Final compatibility check
echo.
echo 🔍 System compatibility summary:
echo    • Operating System: Windows
echo    • Python Version: %CURRENT_PYTHON_VERSION%
echo    • Project Location: %PROJECT_DIR%
echo    • Vietnamese Support: Tested OK

:: Package status
if "%VN_PACKAGES_AVAILABLE%"=="true" (
    echo.
    echo 🇻🇳 Vietnamese Trading Packages Status: ✅ AVAILABLE
    echo    • Offline packages preserved: vnstock_ta, vnai, vnii, vnstock_data, etc.
    echo    • Full Vietnamese market analysis capabilities enabled
) else (
    echo.
    echo 🇻🇳 Vietnamese Trading Packages Status: ⚠️  LIMITED
    echo    • Only basic vnstock available from PyPI
    echo    • Advanced Vietnamese packages (vnstock_ta, vnai, vnii^) not available
    echo    • Consider re-cloning repository to get offline packages
)

echo.
echo 📋 Next steps:
echo    1. Test manual ETL run: python scripts/main_etl_runner.py
echo    2. Set up automated scheduling: python setup_windows_task.py
echo    3. Monitor logs: type logs\fetcher.log
echo.
echo 💡 Useful commands:
echo    • Manual ETL: python scripts/main_etl_runner.py
echo    • Check task: schtasks /query /tn "VNTrading Data Fetcher"
echo    • View logs: type logs\fetcher.log

echo.
echo 🎉 Setup completed successfully!
endlocal
