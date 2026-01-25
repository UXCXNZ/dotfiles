# Global Browser MCP Setup

This directory contains a global Browser MCP (Model Context Protocol) setup that enables AI assistants to interact with web browsers for debugging, testing, and development.

## 🤖 What is Browser MCP?

Browser MCP allows AI assistants (like Cursor's AI or Claude) to:
- 📸 Take screenshots of web pages
- 📋 Monitor console logs and errors in real-time
- 🌐 Track network requests and responses
- 🔍 Inspect DOM elements
- 📊 Run performance, SEO, and accessibility audits
- 🐛 Help debug web applications interactively

## 🏗️ Architecture Overview

Browser MCP consists of **two separate components**:

### 1. Server (Node.js) - What This Script Manages
- **Location**: Runs on your machine (usually port 3025)
- **Purpose**: Handles communication between AI assistant and browser
- **Managed by**: The `install-global-browser-mcp.sh` script in this folder
- **Lifecycle**: Start once, use with multiple projects

```bash
# The server that this script manages:
npx @agentdeskai/browser-tools-server@latest
```

### 2. Browser Extension - Separate Installation
- **Location**: Installed in your browser (Brave, Chrome, etc.)
- **Purpose**: Provides actual browser functionality (screenshots, DOM access, etc.)
- **Installation**: Download from [Browser MCP Releases](https://github.com/AgentDeskAI/browser-tools-mcp/releases)
- **Connection**: Automatically connects to server when DevTools are open

## 🎯 What This Script Does

The `install-global-browser-mcp.sh` script creates a global `browser-mcp` command with these functions:

| Command | Purpose |
|---------|---------|
| `browser-mcp start` | Starts the Node.js server (main function) |
| `browser-mcp stop` | Stops the server |
| `browser-mcp status` | Shows server status (running/stopped, port, PID) |
| `browser-mcp restart` | Restarts the server |
| `browser-mcp logs` | Shows recent server logs |
| `browser-mcp brave` | Opens Brave browser with DevTools (convenience) |

## 🚀 Installation

### 1. Install the Global Command

```bash
# From your dotfiles directory
cd ~/dotfiles
./scripts/browser-mcp/install-global-browser-mcp.sh
```

This will:
- Create `~/.local/bin/browser-mcp` command
- Add `~/.local/bin` to your PATH
- Set up process management with PID tracking

### 2. Install Browser Extension (Separate)

1. Download the extension from [Browser MCP Releases](https://github.com/AgentDeskAI/browser-tools-mcp/releases)
2. Extract the zip file
3. Open Brave → Extensions → "Load unpacked"
4. Select the extracted folder
5. Ensure the extension is enabled

### 3. Configure Your AI Assistant

Add Browser MCP to your AI assistant's MCP configuration:

**Cursor**: `~/.cursor/mcp.json`
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["@agentdeskai/browser-tools-mcp@latest"]
    }
  }
}
```

**Claude Desktop**: `~/Library/Application Support/Claude/claude_desktop_config.json`
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["@agentdeskai/browser-tools-mcp@latest"]
    }
  }
}
```

## 📖 Usage Examples

### Basic Workflow

```bash
# 1. Start the Browser MCP server (once)
browser-mcp start
# ✅ Server running on port 3025

# 2. Start any web project
cd ~/Code/my-react-app
npm run dev
# ✅ App running on localhost:3000

# 3. Open browser (optional - can open manually)
browser-mcp brave

# 4. Navigate to your app and open DevTools (F12)
# ✅ Look for "BrowserToolsMCP" tab
# ✅ Should show "Connected" status

# 5. Ask your AI assistant to help
# "Take a screenshot of this page"
# "Check for any JavaScript errors"
# "What network requests is this page making?"
```

### Working Across Multiple Projects

```bash
# Server runs once, works with any project
browser-mcp start

# Switch between projects freely
cd ~/Code/project-a && npm run dev
cd ~/Code/project-b && pnpm dev  
cd ~/Code/project-c && yarn dev

# Same browser extension connects to all
```

### Server Management

```bash
# Check if server is running
browser-mcp status

# View recent logs if something's wrong
browser-mcp logs

# Restart if needed
browser-mcp restart

# Stop when done (optional - can leave running)
browser-mcp stop
```

## �� AI Assistant Commands

Once everything is connected, you can ask your AI assistant:

### Screenshots & Visual Debugging
```
"Take a screenshot of this page"
"Show me what the login form looks like"
"Capture the current state of the dashboard"
```

### Console & Error Monitoring
```
"Check for any JavaScript errors"
"Show me the console logs"
"Are there any warnings in the console?"
```

### Network Analysis
```
"What network requests is this page making?"
"Are there any failed API calls?"
"Show me the response from the /api/users endpoint"
```

### Performance & Auditing
```
"Run a performance audit on this page"
"Check the SEO of this website"
"Analyze accessibility issues"
"Run a best practices audit"
```

## 🐛 Troubleshooting

### Server Won't Start
```bash
# Check what's using the port
lsof -i :3025

# Try restarting
browser-mcp restart

# Check logs for errors
browser-mcp logs
```

### Extension Not Connecting
1. **Ensure server is running**: `browser-mcp status`
2. **Open DevTools**: Press F12 in your browser
3. **Check for "BrowserToolsMCP" tab**: Should appear in DevTools
4. **Navigate to a real webpage**: Extension only connects on actual pages (not chrome:// pages)
5. **Restart browser**: Sometimes needed after extension installation

### AI Assistant Can't Connect
1. **Check MCP configuration**: Ensure browser-tools is in your MCP config
2. **Restart AI assistant**: After changing MCP config
3. **Verify server is running**: `browser-mcp status`

## 📁 File Structure

```
~/dotfiles/scripts/browser-mcp/
├── README.md                        # This documentation
├── install-global-browser-mcp.sh    # Installation script
└── [future: browser-mcp-uninstall.sh]
```

After installation:
```
~/.local/bin/browser-mcp             # Global command
~/.browser-mcp.pid                   # Server process ID
~/.browser-mcp.log                   # Server logs
```

## 🌍 Why Global Setup?

- **Use with any project**: React, Next.js, Vue, vanilla HTML, etc.
- **One server for everything**: No need to start/stop per project
- **Consistent workflow**: Same commands across all development
- **Clean project repos**: No Browser MCP scripts in individual projects
- **Team friendly**: Each developer sets up once, works everywhere

## 🔗 Resources

- [Browser MCP GitHub](https://github.com/AgentDeskAI/browser-tools-mcp)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [Browser MCP Releases](https://github.com/AgentDeskAI/browser-tools-mcp/releases)

## 📋 Version Management

### MCP Configuration Versions

The examples above use `@latest` to always get the newest version:
```json
"args": ["@agentdeskai/browser-tools-mcp@latest"]
```

**Alternative approaches:**

```json
// Always use latest (recommended for development)
"args": ["@agentdeskai/browser-tools-mcp@latest"]

// Pin to specific version (recommended for production/teams)
"args": ["@agentdeskai/browser-tools-mcp@1.2.0"]

// Use without version specifier (uses npm default)
"args": ["@agentdeskai/browser-tools-mcp"]
```

### Updating Browser MCP

```bash
# Update the MCP package
npm update -g @agentdeskai/browser-tools-mcp

# Or force reinstall latest
npm install -g @agentdeskai/browser-tools-mcp@latest

# Restart your AI assistant after updating
# Restart the Browser MCP server
browser-mcp restart
```

### Checking Current Version

```bash
# Check installed version
npx @agentdeskai/browser-tools-mcp@latest --version

# Check server logs for version info
browser-mcp logs | grep -i version
```
