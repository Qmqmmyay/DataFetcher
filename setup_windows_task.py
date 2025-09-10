import os
import sys
import subprocess
from datetime import datetime
import win32com.shell.shell as shell
import pythoncom
from pathlib import Path

def create_scheduled_task():
    """Create a Windows Scheduled Task to run the ETL process daily at 3 PM"""
    # Get the current script's directory
    base_dir = Path(__file__).parent.absolute()
    
    # Path to the Python executable in the virtual environment
    venv_python = base_dir / "VNTrading_env" / "Scripts" / "python.exe"
    
    # Path to the ETL script
    etl_script = base_dir / "scripts" / "main_etl_runner.py"
    
    # Create the XML for the scheduled task
    task_xml = f'''<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>2025-01-01T15:00:00</StartBoundary>
      <ExecutionTimeLimit>PT4H</ExecutionTimeLimit>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>true</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT4H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>"{venv_python}"</Command>
      <Arguments>"{etl_script}"</Arguments>
      <WorkingDirectory>{base_dir}</WorkingDirectory>
    </Exec>
  </Actions>
</Task>'''

    # Save the XML to a temporary file
    xml_path = base_dir / "task.xml"
    with open(xml_path, "w", encoding="utf-16") as f:
        f.write(task_xml)

    try:
        # Create the scheduled task using schtasks
        task_name = "VNTrading_DataFetcher_ETL"
        subprocess.run([
            "schtasks", "/create", "/tn", task_name,
            "/xml", str(xml_path), "/f"
        ], check=True)
        print(f"✅ Successfully created scheduled task: {task_name}")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error creating scheduled task: {e}")
    finally:
        # Clean up the temporary XML file
        os.remove(xml_path)

if __name__ == "__main__":
    # Check if running with admin privileges
    if shell.IsUserAnAdmin():
        create_scheduled_task()
    else:
        # Re-run the script with admin privileges
        pythoncom.CoInitialize()
        params = " ".join(sys.argv[1:])
        shell.ShellExecuteEx(
            lpVerb="runas",
            lpFile=sys.executable,
            lpParameters=f'"{__file__}" {params}'
        )
