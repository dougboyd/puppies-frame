# CLAUDE.md

## Assistant Identity
My name is **Claudia**, and I'm helping Doug with this project.

## Project: dogFrame

An iPad picture frame app for Doug's daughter's puppies, Ash & Rosie.

### Core Features
- **Kiosk/Locked Mode**: Locks the iPad into picture frame mode (via Guided Access)
- **Local Photo Serving**: Photos served from a MacBook Air via Cloudflare Tunnel
- **Random Display**: Shows pictures in random order with shuffle on loop
- **Full-screen Display**: Optimized for photo viewing with smooth transitions
- **Remote Management**: Add/remove photos by dropping files on the MacBook Air

### Target Device
- **iPad 2** (Wi-Fi, A1395)
- **iOS 9.3.5** (max supported)
- Serial: DLXGG3V8DFHW

### Architecture
- **Server**: Python 3 web server on MacBook Air (macOS 14.8.3)
- **Tunnel**: Cloudflare Tunnel → `ashandrosie.dougboyd.com.au`
- **Frontend**: Simple HTML/CSS/JS (iOS 9 Safari compatible)
- **Photos**: Local directory on MacBook Air (`~/dogframe/photos/`)
- **Lock-down**: Safari full-screen + Guided Access

### URLs
- **Web App**: https://ashandrosie.dougboyd.com.au
- **GitHub Repo**: https://github.com/dougboyd/puppies-frame

### Features
- Full-screen slideshow display
- Random photo selection (reshuffles on each loop)
- 10-second interval between photos (configurable in index.html)
- 1.5-second fade transitions
- Tap to retry on error
- Auto-detects new photos (no restart needed)
- iOS 9 Safari compatible (no ES6 features)

---

## MacBook Air Setup (One-time)

### Prerequisites
- macOS 14+ with Python 3
- `cloudflared` installed (`brew install cloudflare/cloudflare/cloudflared`)
- Cloudflare account with `dougboyd.com.au` domain
- `cloudflared tunnel login` completed

### Install
```bash
# Clone the repo
git clone https://github.com/dougboyd/puppies-frame.git
cd puppies-frame

# Run setup (installs server + Cloudflare Tunnel as launchd services)
./setup.sh
```

This will:
1. Install the web server to `~/dogframe/`
2. Create and configure a Cloudflare Tunnel
3. Set up both services to auto-start on boot

### Managing Photos
```bash
# Add photos - just copy to the photos directory
cp ~/path/to/photos/*.jpg ~/dogframe/photos/

# Remove a photo
rm ~/dogframe/photos/photo.jpg

# List photos
ls ~/dogframe/photos/
```
No restart needed - the server picks up changes automatically.

### Service Management
```bash
# Check server status
curl http://localhost:8080/api/photos

# View logs
tail -f ~/dogframe/logs/server.log
tail -f ~/dogframe/logs/tunnel.log

# Restart server
launchctl unload ~/Library/LaunchAgents/com.dougboyd.dogframe.plist
launchctl load ~/Library/LaunchAgents/com.dougboyd.dogframe.plist

# Restart tunnel
launchctl unload ~/Library/LaunchAgents/com.dougboyd.dogframe-tunnel.plist
launchctl load ~/Library/LaunchAgents/com.dougboyd.dogframe-tunnel.plist
```

---

## iPad Setup (Guided Access)
1. Connect iPad to WiFi
2. Open Safari → go to https://ashandrosie.dougboyd.com.au
3. Tap **Share** → **Add to Home Screen** → **Add**
4. Open the home screen icon (runs in full-screen mode)
5. Enable Guided Access: Settings → Accessibility → Guided Access → On
6. Set a passcode
7. In the app, triple-click Home button → Start Guided Access

---

## File Structure
```
dogFrame/
├── index.html                    # Web app (served to iPad)
├── server.py                     # Python web server
├── setup.sh                      # One-time setup script
├── com.dougboyd.dogframe.plist   # launchd service config
├── .gitignore
└── CLAUDE.md
```

Installed to `~/dogframe/` on the MacBook Air:
```
~/dogframe/
├── index.html
├── server.py
├── photos/          # Drop photos here
└── logs/
    ├── server.log
    └── tunnel.log
```
