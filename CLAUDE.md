# CLAUDE.md

## Assistant Identity
My name is **Claudia**, and I'm helping Doug with this project.

## Project: dogFrame

An iPad app that transforms an old iPad into a dedicated digital picture frame.

### Core Features
- **Kiosk/Locked Mode**: Locks the iPad into picture frame mode (via Guided Access)
- **Local Photos**: All photos bundled in the app - works completely offline
- **Random Display**: Shows pictures in random order with shuffle on loop
- **Full-screen Display**: Optimized for photo viewing with smooth transitions

### Target Device
- **iPad 2** (Wi-Fi, A1395)
- **iOS 9.3.5** (max supported)
- Serial: DLXGG3V8DFHW

### Approach: Web-Based Picture Frame
Due to iOS 9 limitations, we're building a web app that runs in Safari with Guided Access for kiosk lock-down.

### Architecture
- **Frontend**: Simple HTML/CSS/JS (must be iOS 9 Safari compatible)
- **Hosting**: GitHub Pages
- **Custom Domain**: puppies.dougboyd.com.au
- **Photos**: Bundled locally in `photos/` folder (no network required)
- **Lock-down**: Safari full-screen + Guided Access

### URLs
- **Web App**: https://puppies.dougboyd.com.au
- **GitHub Repo**: https://github.com/dougboyd/puppies-frame

### Features
- Full-screen slideshow display
- Random photo selection (reshuffles on each loop)
- 10-second interval between photos (configurable in index.html)
- 1.5-second fade transitions
- Works completely offline after initial load
- iOS 9 Safari compatible (no ES6 features)

---

## Setup Instructions

### DNS Configuration (One-time)
Add a CNAME record for your domain:
```
puppies.dougboyd.com.au -> dougboyd.github.io
```

### Adding/Updating Photos
```bash
# 1. Copy photos into the photos/ folder
cp ~/path/to/photos/*.jpg photos/

# 2. Generate the manifest
./generate-manifest.sh

# 3. Commit and push
git add -A && git commit -m "Update photos" && git push
```

### iPad Setup (Guided Access)
1. Open Safari and go to https://puppies.dougboyd.com.au
2. Tap Share > Add to Home Screen > Add
3. Open the home screen icon (runs in full-screen mode)
4. Enable Guided Access: Settings > Accessibility > Guided Access > On
5. Set a passcode
6. In the app, triple-click Home button > Start Guided Access

---

## File Structure
```
dogFrame/
├── index.html           # Main web app
├── manifest.js          # Auto-generated photo list
├── generate-manifest.sh # Script to update manifest
├── photos/              # Put your photos here
│   └── *.jpg, *.png, etc.
├── CNAME                # Custom domain config
└── CLAUDE.md            # This file
```
