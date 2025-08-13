#!/bin/bash
set -e
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
VENV_DIR="$PROJECT_DIR/VNTrading_env"
LOG_DIR="$PROJECT_DIR/RunningLog"
mkdir -p "$LOG_DIR"

CRON_ETL_LOG="$LOG_DIR/cron_etl.log"
CRON_PING_LOG="$LOG_DIR/cron_ping.log"

# ✅ Wait for DNS
echo "🔍 Checking DNS resolve at $(date)" >> "$CRON_ETL_LOG"
for i in {1..5}; do
    if nslookup api.vndirect.com > /dev/null 2>&1; then
        echo "✅ DNS is ready at $(date)" >> "$CRON_ETL_LOG"
        break
    fi
    echo "⏳ DNS not ready yet. Try $i, sleeping 5s..." >> "$CRON_ETL_LOG"
    sleep 5
done

DONE_FILE="$LOG_DIR/etl_$(date '+%Y-%m-%d').done"
EXCEL_FILE="$LOG_DIR/etl_$(date '+%Y-%m-%d_%H-%M').xlsx"
"$VENV_DIR/bin/python" -c "
from openpyxl import Workbook
wb = Workbook()
wb.save(\"$EXCEL_FILE\")
" >> "$CRON_ETL_LOG" 2>&1
echo "📊 Created empty Excel file: $EXCEL_FILE" >> "$CRON_ETL_LOG"

if [ -f "$DONE_FILE" ]; then
    echo "✅ Already successfully ran today on $(date '+%Y-%m-%d')" >> "$CRON_PING_LOG"
    exit 0
fi

# ✅ Check if current time is >= 15:00
current_hour=$(date +%H)
current_min=$(date +%M)

if [ "$current_hour" -lt 15 ]; then
    echo "⛔ Blocked: Current time is before 15:00. Aborting at $(date)" >> "$CRON_ETL_LOG"
    exit 0
fi

echo "📅 Launchd triggered at $(date)" >> "$CRON_PING_LOG"
cd "$PROJECT_DIR" || exit

echo "📌 PATH=$PATH" >> "$CRON_ETL_LOG"
echo "🐍 Using python=$($VENV_DIR/bin/python -c 'import sys; print(sys.executable)')" >> "$CRON_ETL_LOG"

echo "====== ETL started at $(date '+%Y-%m-%d %H:%M:%S') ======" >> "$CRON_ETL_LOG"
if "$VENV_DIR/bin/python" -m scripts.main_etl_runner >> "$CRON_ETL_LOG" 2>&1; then
    echo "====== ETL ended successfully at $(date '+%Y-%m-%d %H:%M:%S') ======" >> "$CRON_ETL_LOG"
    touch "$DONE_FILE"
else
    echo "❌ ETL failed at $(date '+%Y-%m-%d %H:%M:%S')" >> "$CRON_ETL_LOG"
fi
echo "" >> "$CRON_ETL_LOG"
echo "📅 Launchd finished at $(date)" >> "$CRON_PING_LOG"
