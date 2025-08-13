#!/bin/bash

# Cleanup script for old VNTrading LaunchAgents

echo "🧹 Cleaning up old VNTrading LaunchAgents..."

# List of old LaunchAgent labels to remove
OLD_AGENTS=(
    "com.vntrading.etl.20h55"
    "com.vntrading.etl.runatload"
)

for agent in "${OLD_AGENTS[@]}"; do
    echo "🗑️  Removing: $agent"
    
    # Unload the agent
    launchctl unload ~/Library/LaunchAgents/${agent}.plist 2>/dev/null || echo "   (not loaded)"
    
    # Remove the plist file
    if [ -f ~/Library/LaunchAgents/${agent}.plist ]; then
        rm ~/Library/LaunchAgents/${agent}.plist
        echo "   ✅ Removed plist file"
    else
        echo "   ❌ Plist file not found"
    fi
done

# Remove backup files
if [ -f ~/Library/LaunchAgents/com.vntrading.etl.plist.save ]; then
    rm ~/Library/LaunchAgents/com.vntrading.etl.plist.save
    echo "🗑️  Removed backup file"
fi

echo ""
echo "✅ Cleanup complete!"
echo "📋 Remaining LaunchAgents:"
launchctl list | grep vntrading || echo "   (none found)"
