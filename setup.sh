#!/bin/bash
# dogFrame setup script for MacBook Air
# Run this once to set up the server and Cloudflare Tunnel

set -e

INSTALL_DIR="$HOME/dogframe"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== dogFrame Setup ==="
echo ""

# 1. Copy project to install directory
echo "1. Installing to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR/photos"
mkdir -p "$INSTALL_DIR/logs"
cp "$SCRIPT_DIR/server.py" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/index.html" "$INSTALL_DIR/"
echo "   Done."

# 2. Update plist with correct username and install
echo ""
echo "2. Installing launchd service..."
PLIST_NAME="com.dougboyd.dogframe"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"

# Update paths in plist to match actual home directory
sed "s|/Users/doug/dogframe|$INSTALL_DIR|g" "$PLIST_SRC" > "$PLIST_DEST"

# Unload if already loaded
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"
echo "   Server installed and started on port 8080."

# 3. Cloudflare Tunnel setup
echo ""
echo "3. Setting up Cloudflare Tunnel..."

if ! command -v cloudflared &> /dev/null; then
    echo "   ERROR: cloudflared not found. Install with: brew install cloudflare/cloudflare/cloudflared"
    exit 1
fi

# Check if tunnel already exists
if cloudflared tunnel list 2>/dev/null | grep -q "dogframe"; then
    echo "   Tunnel 'dogframe' already exists."
else
    echo "   Creating tunnel 'dogframe'..."
    cloudflared tunnel create dogframe
fi

# Get tunnel ID
TUNNEL_ID=$(cloudflared tunnel list 2>/dev/null | grep "dogframe" | awk '{print $1}')

if [ -z "$TUNNEL_ID" ]; then
    echo "   ERROR: Could not get tunnel ID. You may need to run: cloudflared tunnel login"
    exit 1
fi

echo "   Tunnel ID: $TUNNEL_ID"

# Create tunnel config
CLOUDFLARED_DIR="$HOME/.cloudflared"
mkdir -p "$CLOUDFLARED_DIR"

cat > "$CLOUDFLARED_DIR/config-dogframe.yml" << EOF
tunnel: $TUNNEL_ID
credentials-file: $CLOUDFLARED_DIR/$TUNNEL_ID.json

ingress:
  - hostname: ashandrosie.dougboyd.com.au
    service: http://localhost:8080
  - service: http_status:404
EOF

echo "   Tunnel config written to $CLOUDFLARED_DIR/config-dogframe.yml"

# 4. Create DNS route
echo ""
echo "4. Creating DNS route..."
cloudflared tunnel route dns dogframe ashandrosie.dougboyd.com.au 2>/dev/null || echo "   DNS route may already exist (this is fine)."

# 5. Install cloudflared as a service
echo ""
echo "5. Installing Cloudflare Tunnel service..."

# Create a launchd plist for cloudflared
CFTUNNEL_PLIST="$HOME/Library/LaunchAgents/com.dougboyd.dogframe-tunnel.plist"
cat > "$CFTUNNEL_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dougboyd.dogframe-tunnel</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which cloudflared)</string>
        <string>tunnel</string>
        <string>--config</string>
        <string>$CLOUDFLARED_DIR/config-dogframe.yml</string>
        <string>run</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/logs/tunnel.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/tunnel.error.log</string>
</dict>
</plist>
EOF

launchctl unload "$CFTUNNEL_PLIST" 2>/dev/null || true
launchctl load "$CFTUNNEL_PLIST"
echo "   Cloudflare Tunnel service started."

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Your picture frame is now running at:"
echo "  https://ashandrosie.dougboyd.com.au"
echo ""
echo "To add photos, copy them to: $INSTALL_DIR/photos/"
echo "The slideshow picks up new photos automatically."
echo ""
echo "To check status:"
echo "  curl http://localhost:8080/api/photos"
echo ""
echo "Logs:"
echo "  $INSTALL_DIR/logs/server.log"
echo "  $INSTALL_DIR/logs/tunnel.log"
