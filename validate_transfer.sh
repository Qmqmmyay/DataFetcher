#!/bin/bash

# Quick validation script to check if project was transferred correctly

echo "🔍 Validating VNTrading DataFetcher transfer..."

# Check if we're in the right location
if [[ "$PWD" != "$HOME/VNTrading_DataFetcher" ]]; then
    echo "❌ Wrong location! Should be in $HOME/VNTrading_DataFetcher"
    echo "   Current: $PWD"
    exit 1
fi

# Check essential files
REQUIRED_FILES=(
    "setup_new_computer.sh"
    "setup_launchd.sh" 
    "run_etl.sh"
    "requirements.txt"
    "core/database.py"
    "config/symbols.py"
    "scripts/main_etl_runner.py"
)

echo "📋 Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

# Check directories
REQUIRED_DIRS=(
    "core"
    "config" 
    "scripts"
    "utils"
    "data"
)

echo "📁 Checking required directories..."
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/"
    else
        echo "❌ Missing: $dir/"
        exit 1
    fi
done

# Check Python availability
if command -v python3 &> /dev/null; then
    echo "✅ Python 3 available: $(python3 --version)"
else
    echo "❌ Python 3 not found! Install from https://www.python.org/downloads/"
    exit 1
fi

echo ""
echo "🎉 Transfer validation successful!"
echo "📝 Next steps:"
echo "   1. Run: ./setup_new_computer.sh"
echo "   2. Run: ./setup_launchd.sh"
echo "   3. Test: ./run_etl.sh"
