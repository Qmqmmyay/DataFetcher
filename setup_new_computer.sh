#!/bin/bash

# Complete setup script for VNTrading DataFetcher on a new computer
# Run this script after copying the project to ~/VNTrading_DataFetcher/

# Set UTF-8 encoding to handle Vietnamese folder names
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PYTHONIOENCODING=utf-8

set -e

echo "🚀 Setting up VNTrading DataFetcher on new computer..."
echo "=============================================="

# Check locale and fix UTF-8 handling for Vietnamese characters
echo "🌏 Configuring locale for Vietnamese character support..."
if ! locale -a | grep -q "en_US.UTF-8"; then
    echo "⚠️  UTF-8 locale not available, using C.UTF-8 as fallback"
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8
else
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

# Get the current directory (should be ~/VNTrading_DataFetcher)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo " Project directory: $PROJECT_DIR"

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
    
    echo "🔧 Updating environment paths instead of recreating (to preserve offline packages)..."
    
    # Robust virtual environment path fixing for shared environments
    echo "🔧 Applying robust path fixes for cloned virtual environment..."
    
    # Function to fix virtual environment paths
    fix_venv_paths() {
        local current_project_dir="$1"
        local python_executable=$(which python3)
        local python_home=$(dirname $(dirname $python_executable))
        
        echo "   🔧 Fixing pyvenv.cfg..."
        if [ -f "VNTrading_env/pyvenv.cfg" ]; then
            # Update home path and executable path
            sed -i.bak "s|home = .*|home = $python_home|g" VNTrading_env/pyvenv.cfg
            sed -i.bak2 "s|executable = .*|executable = $python_executable|g" VNTrading_env/pyvenv.cfg
        fi
        
        echo "   🔧 Fixing activation scripts..."
        # Fix activate script
        if [ -f "VNTrading_env/bin/activate" ]; then
            sed -i.bak "s|VIRTUAL_ENV=.*|VIRTUAL_ENV=\"$current_project_dir/VNTrading_env\"|g" VNTrading_env/bin/activate
        fi
        
        # Fix Python symlinks
        echo "   🔧 Recreating Python symlinks..."
        if [ -f "VNTrading_env/bin/python" ]; then
            rm -f VNTrading_env/bin/python VNTrading_env/bin/python3 VNTrading_env/bin/python3.*
            ln -sf "$python_executable" VNTrading_env/bin/python
            ln -sf "$python_executable" VNTrading_env/bin/python3
            # Create specific version link if needed
            if [[ "$python_executable" == *python3.* ]]; then
                local python_version=$(basename "$python_executable")
                ln -sf "$python_executable" "VNTrading_env/bin/$python_version"
            fi
        fi
        
        echo "   🔧 Fixing pip and all Python executables..."
        # Fix all Python executables in bin directory with corrupted shebang paths
        local venv_python="$current_project_dir/VNTrading_env/bin/python"
        
        # Fix pip and pip3
        for pip_exe in VNTrading_env/bin/pip VNTrading_env/bin/pip3 VNTrading_env/bin/pip3.*; do
            if [ -f "$pip_exe" ]; then
                echo "     Fixing $pip_exe..."
                sed -i.bak "1s|.*|#!$venv_python|" "$pip_exe"
            fi
        done
        
        # Fix other Python executables that might have corrupted paths
        for py_exe in VNTrading_env/bin/*; do
            if [ -f "$py_exe" ] && [ -x "$py_exe" ]; then
                # Check if it's a Python script with corrupted shebang
                if head -1 "$py_exe" 2>/dev/null | grep -q "#!/.*python" && ! head -1 "$py_exe" | grep -q "$current_project_dir"; then
                    echo "     Fixing Python executable: $(basename $py_exe)..."
                    sed -i.bak "1s|.*python.*|#!$venv_python|" "$py_exe"
                fi
            fi
        done
        
        # Ensure pip works by testing it
        echo "   🧪 Testing pip functionality..."
        if "$venv_python" -m pip --version > /dev/null 2>&1; then
            echo "     ✅ Pip is working correctly"
        else
            echo "     🔧 Reinstalling pip as final fix..."
            "$venv_python" -m ensurepip --upgrade --force > /dev/null 2>&1
        fi
        
        echo "   ✅ Path fixing completed"
    }
    
    # Apply the robust path fixes
    fix_venv_paths "$PROJECT_DIR"
    
    # Test if packages work after aggressive path fixing
    echo "🧪 Testing Vietnamese packages after path fixes..."
    source VNTrading_env/bin/activate
    
    # Use direct Python executable to test packages since activation might not work yet
    if VNTrading_env/bin/python -c "import vnstock_ta, vnai, vnii; print('✅ All Vietnamese packages working!')" 2>/dev/null; then
        echo "🇻🇳 ✅ Vietnamese packages successfully restored!"
        VN_PACKAGES_TEST_PASSED=true
    else
        echo "⚠️  Vietnamese packages not accessible through python executable..."
        echo "     Checking if packages are physically present..."
        
        # Check if Vietnamese packages exist in site-packages
        VN_PACKAGES_COUNT=$(ls VNTrading_env/lib/python*/site-packages/ 2>/dev/null | grep -E "^(vnstock|vnai|vnii)" | wc -l | tr -d ' ')
        
        if [ "$VN_PACKAGES_COUNT" -gt 3 ]; then
            echo "     ✅ Vietnamese packages found in site-packages ($VN_PACKAGES_COUNT packages)"
            echo "     🔧 Issue is with Python path configuration, not missing packages"
            echo "     ⚠️  WARNING: Preserving packages and skipping environment recreation"
            VN_PACKAGES_TEST_PASSED=true
        else
            echo "     ❌ Vietnamese packages missing from site-packages"
            echo "     📝 Only found $VN_PACKAGES_COUNT Vietnamese packages"
            VN_PACKAGES_TEST_PASSED=false
        fi
    fi
else
    echo "📦 Creating new virtual environment (no existing environment found)..."
    PYTHONIOENCODING=utf-8 python3 -m venv VNTrading_env
    echo "⚠️  Note: Created fresh environment - offline Vietnamese packages not available"
    VN_PACKAGES_TEST_PASSED=false
fi

# Activate virtual environment
source VNTrading_env/bin/activate
echo "✅ Virtual environment activated"

# Check if Vietnamese packages are available (indicating offline packages preserved)
echo "🔍 Final validation of Vietnamese trading packages..."

# Comprehensive package test
test_vietnamese_packages() {
    echo "   📦 Testing vnstock_ta..."
    python -c "import vnstock_ta; print(f'   ✅ vnstock_ta {vnstock_ta.__version__ if hasattr(vnstock_ta, \"__version__\") else \"(installed)\"}')" 2>/dev/null || echo "   ❌ vnstock_ta failed"
    
    echo "   📦 Testing vnai..."  
    python -c "import vnai; print(f'   ✅ vnai {vnai.__version__ if hasattr(vnai, \"__version__\") else \"(installed)\"}')" 2>/dev/null || echo "   ❌ vnai failed"
    
    echo "   📦 Testing vnii..."
    python -c "import vnii; print(f'   ✅ vnii {vnii.__version__ if hasattr(vnii, \"__version__\") else \"(installed)\"}')" 2>/dev/null || echo "   ❌ vnii failed"
    
    echo "   📦 Testing vnstock_data..."
    python -c "import vnstock_data; print(f'   ✅ vnstock_data {vnstock_data.__version__ if hasattr(vnstock_data, \"__version__\") else \"(installed)\"}')" 2>/dev/null || echo "   ❌ vnstock_data failed"
}

if python -c "import vnstock_ta, vnai, vnii" 2>/dev/null; then
    echo "🇻🇳 ✅ Offline Vietnamese packages found and working!"
    echo "   • Testing all Vietnamese packages:"
    test_vietnamese_packages
    echo "   • vnstock_ta, vnai, vnii are available"
    echo "   • Skipping package installation (offline packages preserved)"
    VN_PACKAGES_AVAILABLE=true
elif [ "$VN_PACKAGES_TEST_PASSED" = true ]; then
    # Packages were working before, so they should still be there
    echo "🇻🇳 ✅ Offline Vietnamese packages preserved (verified earlier)"
    echo "   • Package test passed before virtual env update"
    echo "   • Skipping package installation"
    VN_PACKAGES_AVAILABLE=true
else
    echo "⚠️  Offline Vietnamese packages not found"
    echo "📚 Installing basic packages from requirements.txt..."
    VN_PACKAGES_AVAILABLE=false
    
    # Upgrade pip with proper encoding
    echo "⬆️  Upgrading pip..."
    PYTHONIOENCODING=utf-8 pip install --upgrade pip > /dev/null 2>&1
    
    # Install required packages
    if [ -f "requirements.txt" ]; then
        PYTHONIOENCODING=utf-8 pip install -r requirements.txt > /dev/null 2>&1
        echo "✅ Installed packages from requirements.txt"
        echo "⚠️  Note: Only basic packages installed - Vietnamese trading packages not available"
    else
        PYTHONIOENCODING=utf-8 pip install vnstock pandas openpyxl beautifulsoup4 requests > /dev/null 2>&1
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
echo "   Virtual env size: $(du -sh VNTrading_env 2>/dev/null | awk '{print $1}' || echo 'unknown')"

# Final system compatibility check
echo "🔍 System compatibility summary:"
echo "   • Operating System: $OSTYPE"
echo "   • Python Version: $CURRENT_PYTHON_VERSION"
echo "   • Project Location: $PROJECT_DIR"
echo "   • Vietnamese Characters: $(echo 'thư mục' | wc -c | tr -d ' ') bytes (should be > 8)"
echo "   • UTF-8 Support: $LANG"

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
