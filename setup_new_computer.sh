#!/bin/bash

# Complete setup script for VNTrading DataFetcher on a new computer
# Run this script after copying the project to ~/VNTrading_DataFetcher/

set -e

echo "🚀 Setting up VNTrading DataFetcher on new computer..."
echo "=============================================="

# Get the current directory (should be ~/VNTrading_DataFetcher)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Project directory: $PROJECT_DIR"

# Check if we're in the home directory (recommended location)
if [[ "$PROJECT_DIR" != "$HOME/VNTrading_DataFetcher" ]]; then
    echo "⚠️  Warning: Project is not in recommended location!"
    echo "   Current: $PROJECT_DIR"
    echo "   Recommended: $HOME/VNTrading_DataFetcher"
    echo "   LaunchAgents work best when project is in home directory."
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please move project to $HOME/VNTrading_DataFetcher and run again:"
        echo "  mv \"$PROJECT_DIR\" \"$HOME/VNTrading_DataFetcher\""
        exit 1
    fi
fi

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8+ first."
    echo "   Visit: https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$(python3 --version)
echo "✅ Found Python: $PYTHON_VERSION"

# Remove old virtual environment if it exists
if [ -d "VNTrading_env" ]; then
    echo "🗑️  Removing old virtual environment..."
    rm -rf VNTrading_env
fi

# Create new virtual environment
echo "📦 Creating new virtual environment..."
python3 -m venv VNTrading_env

# Activate virtual environment
source VNTrading_env/bin/activate
echo "✅ Virtual environment created and activated"

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip > /dev/null 2>&1

# Install required packages
echo "📚 Installing Python packages..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt > /dev/null 2>&1
    echo "✅ Installed packages from requirements.txt"
else
    pip install vnstock pandas openpyxl beautifulsoup4 requests > /dev/null 2>&1
    echo "✅ Installed default packages"
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p RunningLog
mkdir -p logs  
mkdir -p data
echo "✅ Directories created"

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x *.sh
echo "✅ Scripts made executable"

# Remove quarantine attributes (macOS security)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🔓 Removing macOS quarantine attributes..."
    xattr -c *.sh 2>/dev/null || true
    echo "✅ Quarantine attributes removed"
fi

# Test the Python environment
echo "🧪 Testing Python environment..."
if VNTrading_env/bin/python -c "import vnstock, pandas, openpyxl; print('All packages imported successfully')" > /dev/null 2>&1; then
    echo "✅ Python environment test passed"
else
    echo "❌ Python environment test failed"
    echo "Try running: pip install -r requirements.txt"
    exit 1
fi

# Test database creation
echo "🗄️  Testing database setup..."
if VNTrading_env/bin/python core/database.py > /dev/null 2>&1; then
    echo "✅ Database setup test passed"
else
    echo "❌ Database setup test failed"
    exit 1
fi

# Test a quick ETL run (will be blocked by time check, but tests imports)
echo "🧪 Testing ETL script..."
if timeout 30 ./run_etl.sh > /tmp/etl_test.log 2>&1; then
    echo "✅ ETL script test passed"
else
    # Check if it was blocked by time (expected behavior)
    if grep -q "Blocked.*before 15:00" /tmp/etl_test.log; then
        echo "✅ ETL script test passed (blocked by time check as expected)"
    else
        echo "⚠️  ETL script test result:"
        tail -3 /tmp/etl_test.log
    fi
fi

# Check file sizes to make sure transfer was complete
echo "📊 Checking project integrity..."
echo "   Database: $(ls -lh data/trading_system.db 2>/dev/null | awk '{print $5}' || echo 'not found')"
echo "   Python files: $(find . -name "*.py" | wc -l | tr -d ' ') files"
echo "   Shell scripts: $(find . -name "*.sh" | wc -l | tr -d ' ') files"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Test manual ETL run: ./run_etl.sh"  
echo "   2. Set up automated scheduling: ./setup_launchd.sh"
echo "   3. Monitor logs: tail -f RunningLog/cron_etl.log"
echo ""
echo "💡 Useful commands:"
echo "   • Manual ETL: ./run_etl.sh"
echo "   • Setup automation: ./setup_launchd.sh" 
echo "   • Check status: launchctl list | grep vntrading"
echo "   • View logs: tail -f RunningLog/cron_etl.log"
echo "   • Stop automation: ./uninstall_launchd.sh"
echo ""
echo "✅ Project is ready to use on this computer!"
echo "🕒 Run './setup_launchd.sh' to enable daily execution at 15:00 (3:00 PM)"
