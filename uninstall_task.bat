@echo off
setlocal enabledelayedexpansion

echo 🗑️  Uninstalling VNTrading ETL Scheduled Task...

set TASK_NAME=VNTrading_DataFetcher_ETL

rem Check if task exists
schtasks /query /tn %TASK_NAME% >nul 2>&1
if errorlevel 1 (
    echo ❌ Scheduled Task not found: %TASK_NAME%
    exit /b 1
)

rem Delete the task
schtasks /delete /tn %TASK_NAME% /f
if errorlevel 1 (
    echo ❌ Failed to remove Scheduled Task
    exit /b 1
) else (
    echo ✅ Successfully removed Scheduled Task
)

rem Verify it's no longer present
schtasks /query /tn %TASK_NAME% >nul 2>&1
if errorlevel 1 (
    echo ✅ Task completely removed
) else (
    echo ⚠️  Warning: Task may still be present
)

echo.
echo 🎉 Uninstall complete!
echo    The ETL Task has been removed and will no longer run automatically.
echo    Log files in RunningLog\ have been preserved.

endlocal
