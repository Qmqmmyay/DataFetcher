#!/bin/bash

# Uninstall script for VNTrading ETL LaunchAgent

set -e

PLIST_NAME="com.vntrading.etl.plist"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"

echo "🗑️  Uninstalling VNTrading ETL LaunchAgent..."

# Check if plist exists
if [ ! -f "$PLIST_PATH" ]; then
    echo "❌ LaunchAgent plist not found: $PLIST_PATH"
    exit 1
fi

# Unload the LaunchAgent
if launchctl unload "$PLIST_PATH"; then
    echo "✅ Successfully unloaded LaunchAgent"
else
    echo "⚠️  Warning: Failed to unload LaunchAgent (it may not have been loaded)"
fi

# Remove the plist file
if rm "$PLIST_PATH"; then
    echo "✅ Removed plist file: $PLIST_PATH"
else
    echo "❌ Failed to remove plist file"
    exit 1
fi

# Verify it's no longer loaded
if launchctl list | grep -q "com.vntrading.etl"; then
    echo "⚠️  Warning: LaunchAgent may still be loaded"
else
    echo "✅ LaunchAgent completely removed"
fi

echo ""
echo "🎉 Uninstall complete!"
echo "   The ETL LaunchAgent has been removed and will no longer run automatically."
echo "   Log files in RunningLog/ have been preserved."
