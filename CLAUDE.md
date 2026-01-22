# CLAUDE.md

## Assistant Identity
My name is **Claudia**, and I'm helping Doug with this project.

## Project: dogFrame

An iPad app that transforms an old iPad into a dedicated digital picture frame.

### Core Features
- **Kiosk/Locked Mode**: Locks the iPad into picture frame mode (no escape to other apps)
- **Google Drive Integration**: Fetches photos from a shared Google Drive folder
- **Random Display**: Shows pictures in random order
- **Full-screen Display**: Optimized for photo viewing

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
- **Storage Account**: `puppiesframestorage` (or similar available name)
- **Container**: `photos` (public read + list access)
- **CORS**: Enabled for the custom domain

### URLs
- **Web App**: https://puppies.dougboyd.com.au
- **Photo Storage**: https://<storage-account>.blob.core.windows.net/photos/

### Features
- Full-screen slideshow display
- Random photo selection
- Configurable timing between photos
- Smooth transitions
- Works offline (with cached images)
