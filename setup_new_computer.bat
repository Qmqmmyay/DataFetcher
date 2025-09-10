@echo off
echo Setting up VNTrading DataFetcher for Windows...

:: Create virtual environment
python -m venv VNTrading_env

:: Activate virtual environment
call VNTrading_env\Scripts\activate.bat

:: Install requirements
pip install -r requirements.txt

:: Create and setup Vietnamese packages
mkdir vietnamese_packages
cd vietnamese_packages

:: Clone Vietnamese packages
git clone https://github.com/Qmqmmyay/vnstock_data.git
git clone https://github.com/Qmqmmyay/vnstock_pipeline.git
git clone https://github.com/Qmqmmyay/vnstock_ta.git
git clone https://github.com/Qmqmmyay/vnii.git

:: Install packages in development mode
cd vnstock_data && pip install -e . && cd ..
cd vnstock_pipeline && pip install -e . && cd ..
cd vnstock_ta && pip install -e . && cd ..
cd vnii && pip install -e . && cd ..

cd ..

:: Verify installation
python -c "import vnstock_data, vnstock_pipeline, vnstock_ta, vnii; print('✅ All packages installed successfully!')"

echo Setup completed successfully!
