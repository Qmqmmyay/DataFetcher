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
    
    # Path to the batch script
    etl_script = base_dir / "run_etl.bat"
    
    # Create logs directory
    log_dir = base_dir / "RunningLog"
    log_dir.mkdir(exist_ok=True)
    print(f"✅ Created logs directory: {log_dir}")
    
    # Ensure the batch script exists
    if not etl_script.exists():
        print(f"❌ Error: ETL script not found at {etl_script}")
        sys.exit(1)
        
    print("🚀 Setting up VNTrading ETL Windows Task...")
    print(f"📁 Project directory: {base_dir}")
    print(f"📜 ETL script: {etl_script}")
    
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
      <Command>"{etl_script}"</Command>
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
        
        # Run the task immediately for testing (equivalent to RunAtLoad)
        print("🔄 Running immediate test...")
        subprocess.run(["schtasks", "/run", "/tn", task_name], check=True)
        print("✅ Task triggered for immediate test run")
        
        # Verify task exists and show status
        verify_result = subprocess.run(
            ["schtasks", "/query", "/tn", task_name],
            capture_output=True, text=True, check=True
        )
        print("✅ Task is now active")
        
        print("\n🎉 Setup complete!")
        print("\n📋 Task Configuration:")
        print(f"   • Name: {task_name}")
        print("   • Schedule: Daily at 15:00 (3:00 PM)")
        print(f"   • Script: {etl_script}")
        print(f"   • Logs: {log_dir}")
        print("\n🔧 Management commands:")
        print(f"   • Check status: schtasks /query /tn {task_name}")
        print(f"   • Run manually: schtasks /run /tn {task_name}")
        print(f"   • Delete task: schtasks /delete /tn {task_name} /f")
        print("\n⚠️  Note: The ETL will run immediately once and then daily at 15:00")
        print("   If current time is before 15:00, it will be blocked by the time check in run_etl.bat")
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Error creating scheduled task: {e}")
        print(f"Error output: {e.stderr if hasattr(e, 'stderr') else 'No error output'}")
        sys.exit(1)
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
