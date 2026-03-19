# TuneBox

An Apple Music-inspired local music player for iPhone. Plays audio files stored in the app's Documents directory.

## Features

- Apple Music-style UI (Songs, Albums, Artists)
- Full-screen Now Playing with animated artwork
- Persistent mini player
- Background audio playback
- Lock screen / Control Center controls
- Supports: MP3, M4A, AAC, AIFF, WAV, FLAC

## Adding Music

1. Open the **Files** app on your iPhone
2. Navigate to **On My iPhone → TuneBox**
3. Copy/move your audio files into this folder
4. In TuneBox, pull down to refresh the library

You can also share audio files from other apps directly to TuneBox using the share sheet.

## Building

### Requirements

- Xcode 15+
- iOS 16+ deployment target
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) installed

### Steps

```bash
# Install XcodeGen (if not already installed)
brew install xcodegen

# Generate the Xcode project
xcodegen generate

# Open in Xcode
open TuneBox.xcodeproj
```

Then build and run on a simulator or physical device.
