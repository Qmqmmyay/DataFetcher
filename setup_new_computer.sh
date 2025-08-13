#!/bin/bash

# Complete setup scri    exit 1
fi

PYTHON_VERSION=$(python3 --version)
echo "✅ Found Python: $PYTHON_VERSION"

# Extract Python version (e.g., "3.12" from "Python 3.12.3")
CURRENT_PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "🔍 Python version: $CURRENT_PYTHON_VERSION"

# Check if virtual environment exists with offline packages
if [ -d "VNTrading_env" ]; then
    echo "🎯 Found existing virtual environment with offline Vietnamese packages"
    
    # Check if Python versions match
    if [ -f "VNTrading_env/pyvenv.cfg" ]; then
        VENV_PYTHON_VERSION=$(grep "version = " VNTrading_env/pyvenv.cfg | sed 's/version = //' | cut -d'.' -f1,2)
        echo "📋 Virtual env was created with Python: $VENV_PYTHON_VERSION"
        echo "📋 Current system has Python: $CURRENT_PYTHON_VERSION"
        
        if [ "$VENV_PYTHON_VERSION" != "$CURRENT_PYTHON_VERSION" ]; then
            echo "⚠️  WARNING: Python version mismatch!"
            echo "   Virtual env: Python $VENV_PYTHON_VERSION"
            echo "   Current system: Python $CURRENT_PYTHON_VERSION"
            echo "   Vietnamese packages may not work due to binary incompatibility"
            echo ""
            read -p "Continue with version mismatch? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "❌ Setup cancelled. Consider using a system with Python $VENV_PYTHON_VERSION"
                echo "   Or re-clone the repository to get a fresh environment"
                exit 1
            fi
        fi
    fi
    
    echo "🔧 Updating environment paths instead of recreating (to preserve offline packages)..."rading DataFetcher on a new computer
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

# Check if virtual environment exists with offline packages
if [ -d "VNTrading_env" ]; then
    echo "🎯 Found existing virtual environment with offline Vietnamese packages"
    echo "� Updating environment paths instead of recreating (to preserve offline packages)..."
    
    # Update the virtual environment to work with current system
    echo "🔧 Updating virtual environment paths for new system..."
    python3 -m venv VNTrading_env --upgrade-deps
    echo "✅ Virtual environment updated and paths fixed"
else
    echo "📦 Creating new virtual environment (no existing environment found)..."
    python3 -m venv VNTrading_env
    echo "⚠️  Note: Created fresh environment - offline Vietnamese packages not available"
fi

# Activate virtual environment
source VNTrading_env/bin/activate
echo "✅ Virtual environment activated"

# Check if Vietnamese packages are available (indicating offline packages preserved)
echo "🔍 Checking for Vietnamese trading packages..."
if python -c "import vnstock_ta, vnai, vnii" 2>/dev/null; then
    echo "🇻🇳 ✅ Offline Vietnamese packages found and working!"
    echo "   • vnstock_ta, vnai, vnii are available"
    echo "   • Skipping package installation (offline packages preserved)"
    VN_PACKAGES_AVAILABLE=true
else
    echo "⚠️  Offline Vietnamese packages not found"
    echo "📚 Installing basic packages from requirements.txt..."
    VN_PACKAGES_AVAILABLE=false
    
    # Upgrade pip
    echo "⬆️  Upgrading pip..."
    pip install --upgrade pip > /dev/null 2>&1
    
    # Install required packages
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt > /dev/null 2>&1
        echo "✅ Installed packages from requirements.txt"
        echo "⚠️  Note: Only basic packages installed - Vietnamese trading packages not available"
    else
        pip install vnstock pandas openpyxl beautifulsoup4 requests > /dev/null 2>&1
        echo "✅ Installed default packages"
    fi
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

# Display Vietnamese package status
if [ "$VN_PACKAGES_AVAILABLE" = true ]; then
    echo "🇻🇳 Vietnamese Trading Packages Status: ✅ AVAILABLE"
    echo "   • Offline packages preserved: vnstock_ta, vnai, vnii, vnstock_data, etc."
    echo "   • Full Vietnamese market analysis capabilities enabled"
else
    echo "🇻🇳 Vietnamese Trading Packages Status: ⚠️  LIMITED"
    echo "   • Only basic vnstock available from PyPI"
    echo "   • Advanced Vietnamese packages (vnstock_ta, vnai, vnii) not available"
    echo "   • Consider cloning fresh repository to get offline packages"
fi

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
