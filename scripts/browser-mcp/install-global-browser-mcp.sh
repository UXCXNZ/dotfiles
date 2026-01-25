#!/bin/bash

# Global Browser MCP Installation Script
# This script installs a global 'browser-mcp' command for use across all projects

set -e

echo "🚀 Installing Global Browser MCP..."

# Create the global script directory if it doesn't exist
SCRIPT_DIR="$HOME/.local/bin"
mkdir -p "$SCRIPT_DIR"

# Create the main browser-mcp script
cat > "$SCRIPT_DIR/browser-mcp" << 'INNER_EOF'
#!/bin/bash

# Global Browser MCP Manager
# Usage: browser-mcp [start|stop|status|restart|brave|help]

PID_FILE="$HOME/.browser-mcp.pid"
LOG_FILE="$HOME/.browser-mcp.log"
DEFAULT_PORT=3025

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Global Browser MCP Manager"
    echo ""
    echo "Usage: browser-mcp [command]"
    echo ""
    echo "Commands:"
    echo "  start     Start Browser MCP server"
    echo "  stop      Stop Browser MCP server"
    echo "  status    Check server status"
    echo "  restart   Restart Browser MCP server"
    echo "  brave     Open Brave with DevTools ready"
    echo "  logs      Show recent server logs"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  browser-mcp start         # Start the server"
    echo "  browser-mcp brave         # Open Brave browser"
    echo "  browser-mcp status        # Check if running"
}

is_server_running() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        else
            rm -f "$PID_FILE"
            return 1
        fi
    fi
    return 1
}

get_server_port() {
    if [ -f "$LOG_FILE" ]; then
        grep -o "Server running on port [0-9]*" "$LOG_FILE" | tail -1 | grep -o "[0-9]*" || echo "$DEFAULT_PORT"
    else
        echo "$DEFAULT_PORT"
    fi
}

start_server() {
    if is_server_running; then
        local port=$(get_server_port)
        echo -e "${YELLOW}Browser MCP server is already running on port $port${NC}"
        echo -e "PID: $(cat "$PID_FILE")"
        return 0
    fi

    echo -e "${BLUE}Starting Browser MCP server...${NC}"
    
    # Start the server in background and capture PID
    nohup npx @agentdeskai/browser-tools-server@latest > "$LOG_FILE" 2>&1 &
    local server_pid=$!
    
    echo "$server_pid" > "$PID_FILE"
    
    # Wait a moment for server to start
    sleep 3
    
    if is_server_running; then
        local port=$(get_server_port)
        echo -e "${GREEN}✅ Browser MCP server started successfully${NC}"
        echo -e "Port: $port"
        echo -e "PID: $server_pid"
        echo -e "Logs: $LOG_FILE"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo -e "1. Open your web application in Brave browser"
        echo -e "2. Press F12 to open DevTools"
        echo -e "3. Look for 'BrowserToolsMCP' tab"
        echo -e "4. Verify 'Connected' status"
    else
        echo -e "${RED}❌ Failed to start Browser MCP server${NC}"
        echo -e "Check logs: $LOG_FILE"
        return 1
    fi
}

stop_server() {
    if ! is_server_running; then
        echo -e "${YELLOW}Browser MCP server is not running${NC}"
        return 0
    fi

    local pid=$(cat "$PID_FILE")
    echo -e "${BLUE}Stopping Browser MCP server (PID: $pid)...${NC}"
    
    kill "$pid" 2>/dev/null || true
    rm -f "$PID_FILE"
    
    # Wait for process to stop
    sleep 2
    
    if ! ps -p "$pid" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Browser MCP server stopped${NC}"
    else
        echo -e "${YELLOW}Force killing server...${NC}"
        kill -9 "$pid" 2>/dev/null || true
        echo -e "${GREEN}✅ Browser MCP server force stopped${NC}"
    fi
}

show_status() {
    if is_server_running; then
        local pid=$(cat "$PID_FILE")
        local port=$(get_server_port)
        echo -e "${GREEN}✅ Browser MCP server is running${NC}"
        echo -e "PID: $pid"
        echo -e "Port: $port"
        echo -e "URL: http://localhost:$port"
        echo -e "Logs: $LOG_FILE"
    else
        echo -e "${RED}❌ Browser MCP server is not running${NC}"
    fi
}

restart_server() {
    echo -e "${BLUE}Restarting Browser MCP server...${NC}"
    stop_server
    sleep 1
    start_server
}

open_brave() {
    if command -v brave > /dev/null 2>&1; then
        echo -e "${BLUE}Opening Brave browser with DevTools...${NC}"
        brave --auto-open-devtools-for-tabs &
    elif [ -f "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" ]; then
        echo -e "${BLUE}Opening Brave browser with DevTools...${NC}"
        "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" --auto-open-devtools-for-tabs &
    else
        echo -e "${YELLOW}Brave browser not found. Please open Brave manually and press F12 for DevTools.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Brave browser opened${NC}"
    echo -e "Navigate to your application and check the 'BrowserToolsMCP' tab in DevTools"
}

show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo -e "${BLUE}Recent Browser MCP server logs:${NC}"
        echo "----------------------------------------"
        tail -n 20 "$LOG_FILE"
    else
        echo -e "${YELLOW}No log file found${NC}"
    fi
}

# Main command handling
case "${1:-help}" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    status)
        show_status
        ;;
    restart)
        restart_server
        ;;
    brave)
        open_brave
        ;;
    logs)
        show_logs
        ;;
    help|--help|-h)
        print_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        print_usage
        exit 1
        ;;
esac
INNER_EOF

# Make the script executable
chmod +x "$SCRIPT_DIR/browser-mcp"

# Check if the script directory is in PATH
if [[ ":$PATH:" != *":$SCRIPT_DIR:"* ]]; then
    echo ""
    echo "📝 Adding $SCRIPT_DIR to your PATH..."
    
    # Add to appropriate shell config file
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    else
        SHELL_CONFIG="$HOME/.zshrc"
    fi
    
    # Add PATH export if not already present
    if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$SHELL_CONFIG" 2>/dev/null; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Global Browser MCP" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_CONFIG"
        
        echo "✅ Added $SCRIPT_DIR to PATH in $SHELL_CONFIG"
        echo ""
        echo "🔄 Reload your shell or run: source $SHELL_CONFIG"
    else
        echo "✅ PATH already includes $SCRIPT_DIR"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Global Browser MCP installed successfully!${NC}"
echo ""
echo "📖 Usage:"
echo "  browser-mcp start     # Start the server"
echo "  browser-mcp brave     # Open Brave with DevTools"
echo "  browser-mcp status    # Check server status"
echo "  browser-mcp stop      # Stop the server"
echo "  browser-mcp help      # Show all commands"
echo ""
echo "🚀 Quick start:"
echo "  1. browser-mcp start"
echo "  2. browser-mcp brave"
echo "  3. Navigate to your app and check DevTools 'BrowserToolsMCP' tab"
echo ""

# Test the installation
if command -v browser-mcp > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Installation verified - 'browser-mcp' command is available${NC}"
else
    echo -e "${YELLOW}⚠️  You may need to reload your shell: source $SHELL_CONFIG${NC}"
fi
