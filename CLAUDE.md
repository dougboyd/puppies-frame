# CLAUDE.md

## Assistant Identity
My name is **Claudia**, and I'm helping Doug with this project.

## Project: dogFrame

An iPad app that transforms an old iPad into a dedicated digital picture frame.

### Core Features
- **Kiosk/Locked Mode**: Locks the iPad into picture frame mode (via Guided Access)
- **Azure Blob Storage**: Fetches photos remotely - add/remove photos anytime
- **Random Display**: Shows pictures in random order with shuffle on loop
- **Full-screen Display**: Optimized for photo viewing with smooth transitions

### Target Device
- **iPad 2** (Wi-Fi, A1395)
- **iOS 9.3.5** (max supported)
- Serial: DLXGG3V8DFHW

### Approach: Web-Based Picture Frame
Due to iOS 9 limitations, we're building a web app that runs in Safari with Guided Access for kiosk lock-down.

### Architecture
- **Frontend**: Simple HTML/CSS/JS (iOS 9 Safari compatible)
- **Hosting**: GitHub Pages
- **Photo Storage**: Azure Blob Storage (remote, manageable)
- **Lock-down**: Safari full-screen + Guided Access

### Azure Resources
- **Storage Account**: `puppiesframe`
- **Container**: `photos` (public read + list access)
- **CORS**: Enabled for all origins

### URLs
- **Web App**: https://dougboyd.github.io/puppies-frame
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

## Managing Photos

### Upload photos
```bash
# Single photo
az storage blob upload \
  --account-name puppiesframe \
  --container-name photos \
  --file /path/to/photo.jpg \
  --name photo.jpg

# Entire folder
az storage blob upload-batch \
  --account-name puppiesframe \
  --destination photos \
  --source /path/to/folder \
  --pattern "*.jpg"
```

### List photos
```bash
az storage blob list \
  --account-name puppiesframe \
  --container-name photos \
  --query "[].name" -o tsv
```

### Delete a photo
```bash
az storage blob delete \
  --account-name puppiesframe \
  --container-name photos \
  --name photo.jpg
```

### Delete all photos
```bash
az storage blob delete-batch \
  --account-name puppiesframe \
  --source photos
```

---

## iPad Setup (Guided Access)
1. Connect iPad to WiFi
2. Open Safari → go to https://dougboyd.github.io/puppies-frame
3. Tap **Share** → **Add to Home Screen** → **Add**
4. Open the home screen icon (runs in full-screen mode)
5. Enable Guided Access: Settings → Accessibility → Guided Access → On
6. Set a passcode
7. In the app, triple-click Home button → Start Guided Access
