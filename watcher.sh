#!/bin/bash

# Auto Gen Assets Background Watcher
# Copy this file to your project root and run: chmod +x watcher.sh && ./watcher.sh start

PID_FILE=".watcher.pid"
LOG_FILE="watcher.log"

case "$1" in
    start)
        if [ -f "$PID_FILE" ]; then
            echo "Watcher already running (PID: $(cat $PID_FILE))"
        else
            echo "Starting watcher in background..."
            nohup dart run auto_gen_assets --watch > "$LOG_FILE" 2>&1 &
            echo $! > "$PID_FILE"
            echo "✅ Watcher started (PID: $!)"
            echo "📋 Logs: tail -f $LOG_FILE"
            echo "🛑 Stop: $0 stop"
        fi
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            echo "Stopping watcher (PID: $PID)..."
            kill $PID 2>/dev/null
            rm -f "$PID_FILE"
            echo "✅ Watcher stopped"
        else
            echo "Watcher not running"
        fi
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    status)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if ps -p $PID > /dev/null; then
                echo "✅ Watcher is running (PID: $PID)"
            else
                echo "❌ Watcher crashed"
                rm -f "$PID_FILE"
            fi
        else
            echo "❌ Watcher not running"
        fi
        ;;
    logs)
        if [ -f "$LOG_FILE" ]; then
            tail -f "$LOG_FILE"
        else
            echo "No log file found. Start watcher first: $0 start"
        fi
        ;;
    *)
        echo "Auto Gen Assets Background Watcher"
        echo ""
        echo "Usage: $0 {start|stop|restart|status|logs}"
        echo ""
        echo "Commands:"
        echo "  start   - Start watcher in background"
        echo "  stop    - Stop watcher"
        echo "  restart - Restart watcher"
        echo "  status  - Check watcher status"
        echo "  logs    - Show watcher logs"
        echo ""
        echo "Examples:"
        echo "  $0 start    # Start watcher in background"
        echo "  $0 status   # Check if running"
        echo "  $0 logs     # View logs"
        echo "  $0 stop     # Stop watcher"
        echo ""
        echo "Workflow:"
        echo "  1. $0 start    # Start watcher"
        echo "  2. Add/remove assets in assets/ folder"
        echo "  3. Watcher auto-updates lib/generated/assets.dart"
        echo "  4. $0 stop     # Stop when done"
        ;;
esac 