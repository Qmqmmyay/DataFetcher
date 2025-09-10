@echo off
setlocal enabledelayedexpansion

echo 🔍 Validating VNTrading DataFetcher transfer...

rem Check if we're in the right location
set "EXPECTED_PATH=%USERPROFILE%\VNTrading_DataFetcher"
if not "%CD%"=="%EXPECTED_PATH%" (
    echo ❌ Wrong location! Should be in %EXPECTED_PATH%
    echo    Current: %CD%
    exit /b 1
)

rem Check essential files
echo 📋 Checking required files...
set REQUIRED_FILES=^
    setup_new_computer.bat^
    setup_launchd_win.py^
    run_etl.bat^
    requirements.txt^
    core\database.py^
    config\symbols.py^
    scripts\main_etl_runner.py

for %%f in (%REQUIRED_FILES%) do (
    if exist "%%f" (
        echo ✅ %%f
    ) else (
        echo ❌ Missing: %%f
        exit /b 1
    )
)

rem Check directories
echo 📁 Checking required directories...
set REQUIRED_DIRS=^
    core^
    config^
    scripts^
    utils^
    data

for %%d in (%REQUIRED_DIRS%) do (
    if exist "%%d\" (
        echo ✅ %%d\
    ) else (
        echo ❌ Missing: %%d\
        exit /b 1
    )
)

rem Check Python availability
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python not found! Install from https://www.python.org/downloads/
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('python --version') do echo ✅ Python available: %%i
)

echo.
echo 🎉 Transfer validation successful!
echo 📝 Next steps:
echo    1. Run: setup_new_computer.bat
echo    2. Run: setup_launchd_win.py
echo    3. Test: run_etl.bat

endlocal
