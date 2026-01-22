# CLAUDE.md

## Assistant Identity
My name is **Claudia**, and I'm helping Doug with this project.

## Project: dogFrame

An iPad app that transforms an old iPad into a dedicated digital picture frame.

### Core Features
- **Kiosk/Locked Mode**: Locks the iPad into picture frame mode (via Guided Access)
- **Azure Blob Storage**: Fetches photos from Azure container
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
- **Cloud Storage**: Azure Blob Storage
- **Lock-down**: Safari full-screen + Guided Access

### Azure Resources
- **Storage Account**: `puppiesframe`
- **Container**: `photos` (public read + list access)
- **CORS**: Enabled for all origins

### URLs
- **Web App**: https://puppies.dougboyd.com.au
- **Photo Storage**: https://puppiesframe.blob.core.windows.net/photos/
- **GitHub Repo**: https://github.com/dougboyd/puppies-frame

### Features
- Full-screen slideshow display
- Random photo selection (reshuffles on each loop)
- 10-second interval between photos (configurable in index.html)
- 1.5-second fade transitions
- Tap to retry on error
- iOS 9 Safari compatible (no ES6 features)

---

## Setup Instructions

### DNS Configuration (One-time)
Add a CNAME record for your domain:
```
puppies.dougboyd.com.au -> dougboyd.github.io
```

### Uploading Photos
```bash
# Upload a single photo
az storage blob upload \
  --account-name puppiesframe \
  --container-name photos \
  --file /path/to/photo.jpg \
  --name photo.jpg

# Upload all photos from a folder
az storage blob upload-batch \
  --account-name puppiesframe \
  --destination photos \
  --source /path/to/photos/folder \
  --pattern "*.jpg"
```

### iPad Setup (Guided Access)
1. Open Safari and go to https://puppies.dougboyd.com.au
2. Tap Share > Add to Home Screen > Add
3. Open the home screen icon (runs in full-screen mode)
4. Enable Guided Access: Settings > Accessibility > Guided Access > On
5. Set a passcode
6. In the app, triple-click Home button > Start Guided Access
