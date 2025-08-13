#!/bin/bash

# Setup script for VNTrading ETL LaunchAgent
# This script creates and loads a LaunchAgent to run ETL daily at 15:00

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
ETL_SCRIPT="$PROJECT_DIR/run_etl.sh"
PLIST_NAME="com.vntrading.etl.plist"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"
LOG_DIR="$PROJECT_DIR/RunningLog"

echo "🚀 Setting up VNTrading ETL LaunchAgent..."
echo "📁 Project directory: $PROJECT_DIR"
echo "📜 ETL script: $ETL_SCRIPT"
echo "📋 Plist file: $PLIST_PATH"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$HOME/Library/LaunchAgents"
echo "✅ Created LaunchAgents directory"

# Create logs directory
mkdir -p "$LOG_DIR"
echo "✅ Created logs directory: $LOG_DIR"

# Make sure ETL script is executable
chmod +x "$ETL_SCRIPT"
echo "✅ Made ETL script executable"

# Create the plist file
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.vntrading.etl</string>

    <key>ProgramArguments</key>
    <array>
        <string>$ETL_SCRIPT</string>
    </array>

    <!-- Run daily at 15:00 (3:00 PM) -->
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>15</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <!-- Run immediately when loaded (for testing) -->
    <key>RunAtLoad</key>
    <true/>

    <!-- Keep alive if it exits -->
    <key>KeepAlive</key>
    <false/>

    <!-- Standard output and error logs -->
    <key>StandardOutPath</key>
    <string>$LOG_DIR/launchd_stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/launchd_stderr.log</string>

    <!-- Environment variables -->
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
</dict>
</plist>
EOF

echo "✅ Created plist file: $PLIST_PATH"

# Unload any existing version (ignore errors)
launchctl unload "$PLIST_PATH" 2>/dev/null || true
echo "🔄 Unloaded any existing LaunchAgent"

# Load the new LaunchAgent
if launchctl load "$PLIST_PATH"; then
    echo "✅ Successfully loaded LaunchAgent"
else
    echo "❌ Failed to load LaunchAgent"
    exit 1
fi

# Check if it's loaded
if launchctl list | grep -q "com.vntrading.etl"; then
    echo "✅ LaunchAgent is now active"
else
    echo "⚠️  LaunchAgent may not be properly loaded"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 LaunchAgent Configuration:"
echo "   • Name: com.vntrading.etl"
echo "   • Schedule: Daily at 15:00 (3:00 PM)"
echo "   • Script: $ETL_SCRIPT"
echo "   • Logs: $LOG_DIR/"
echo ""
echo "🔧 Management commands:"
echo "   • Check status: launchctl list | grep vntrading"
echo "   • View logs: tail -f $LOG_DIR/launchd_stdout.log"
echo "   • Unload: launchctl unload $PLIST_PATH"
echo "   • Reload: launchctl unload $PLIST_PATH && launchctl load $PLIST_PATH"
echo ""
echo "⚠️  Note: The ETL will run immediately once (RunAtLoad=true) and then daily at 15:00"
echo "   If current time is before 15:00, it will be blocked by the time check in run_etl.sh"
