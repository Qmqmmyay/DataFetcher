@echo off
setlocal enabledelayedexpansion

rem Set paths
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR:~0,-1%"
set "VENV_DIR=%PROJECT_DIR%\VNTrading_env"
set "LOG_DIR=%PROJECT_DIR%\RunningLog"
set "PYTHON_CMD=%VENV_DIR%\Scripts\python.exe"

rem Create log directory if it doesn't exist
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

rem Set log files
set "CRON_ETL_LOG=%LOG_DIR%\cron_etl.log"
set "CRON_PING_LOG=%LOG_DIR%\cron_ping.log"

rem Check DNS
echo 🔍 Checking DNS resolve at %date% %time% >> "%CRON_ETL_LOG%"
for /l %%i in (1,1,5) do (
    nslookup api.vndirect.com >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ DNS is ready at %date% %time% >> "%CRON_ETL_LOG%"
        goto :dns_ready
    )
    echo ⏳ DNS not ready yet. Try %%i, sleeping 5s... >> "%CRON_ETL_LOG%"
    timeout /t 5 /nobreak >nul
)
:dns_ready

rem Set file paths with current date
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set "DONE_FILE=%LOG_DIR%\etl_%%c-%%a-%%b.done"
)
for /f "tokens=1-4 delims=/:. " %%a in ('time /t') do (
    set "EXCEL_FILE=%LOG_DIR%\etl_%date:~10,4%-%date:~4,2%-%date:~7,2%_%%a-%%b.xlsx"
)

rem Create empty Excel file
"%PYTHON_CMD%" -c "from openpyxl import Workbook; wb = Workbook(); wb.save(r'%EXCEL_FILE%')" >> "%CRON_ETL_LOG%" 2>&1
echo 📊 Created empty Excel file: %EXCEL_FILE% >> "%CRON_ETL_LOG%"

rem Check if already run today
if exist "%DONE_FILE%" (
    echo ✅ Already successfully ran today on %date% >> "%CRON_PING_LOG%"
    exit /b 0
)

rem Check if current time is >= 15:00
for /f "tokens=1,2 delims=:." %%a in ('time /t') do (
    set hour=%%a
    if !hour! lss 15 (
        echo ⛔ Blocked: Current time is before 15:00. Aborting at %date% %time% >> "%CRON_ETL_LOG%"
        exit /b 0
    )
)

echo 📅 Task triggered at %date% %time% >> "%CRON_PING_LOG%"
cd /d "%PROJECT_DIR%"

echo 📌 PATH=%PATH% >> "%CRON_ETL_LOG%"
"%PYTHON_CMD%" -c "import sys; print('🐍 Using python=' + sys.executable)" >> "%CRON_ETL_LOG%"

echo ====== ETL started at %date% %time% ====== >> "%CRON_ETL_LOG%"
"%PYTHON_CMD%" -m scripts.main_etl_runner >> "%CRON_ETL_LOG%" 2>&1
if !errorlevel! equ 0 (
    echo ====== ETL ended successfully at %date% %time% ====== >> "%CRON_ETL_LOG%"
    type nul > "%DONE_FILE%"
) else (
    echo ❌ ETL failed at %date% %time% >> "%CRON_ETL_LOG%"
)

echo. >> "%CRON_ETL_LOG%"
echo 📅 Task finished at %date% %time% >> "%CRON_PING_LOG%"

endlocal
