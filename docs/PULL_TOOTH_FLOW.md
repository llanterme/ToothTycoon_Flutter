# Tooth Tycoon - Pull Tooth Flow Documentation

## 📱 Simulator Support

### What Was Added
The `captureImageScreen.dart` now includes simulator detection and dummy image support for testing without a physical device camera.

### How It Works

**1. Simulator Detection ([captureImageScreen.dart:52-70](lib/screens/captureImageScreen.dart#L52-L70))**
```dart
Future<void> _checkSimulator() async {
  if (Platform.isIOS) {
    // iOS Simulator detection
    _isSimulator = !Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')
        ? defaultTargetPlatform == TargetPlatform.iOS
        : true;
  } else if (Platform.isAndroid) {
    // Android Emulator detection
    _isSimulator = await _isAndroidEmulator();
  }
  print('Running on simulator: $_isSimulator');
}
```

**2. Camera Preview Placeholder ([captureImageScreen.dart:123-140](lib/screens/captureImageScreen.dart#L123-L140))**
- On simulator: Shows a grey placeholder with camera icon and "Simulator Mode" text
- On device: Shows actual camera preview

**3. Dummy Image Creation ([captureImageScreen.dart:334-353](lib/screens/captureImageScreen.dart#L334-L353))**
```dart
Future<String?> _createDummyImage() async {
  final String filePath = '$dirPath/dummy_${timestamp()}.txt';
  final File dummyFile = File(filePath);
  await dummyFile.writeAsString('Dummy tooth image - Simulator Mode');
  return filePath;
}
```

**4. Conditional Camera Initialization ([captureImageScreen.dart:244-268](lib/screens/captureImageScreen.dart#L244-L268))**
- Skips camera initialization on simulator
- Falls back to simulator mode if no cameras detected

### Testing on Simulator
1. Run app on iOS Simulator or Android Emulator
2. Navigate to Pull Tooth screen
3. Select a tooth
4. You'll see "Simulator Mode Camera Preview" instead of camera
5. Click capture button - creates dummy file instead of taking photo
6. Flow continues normally with the dummy file

---

## 🦷 Pull Tooth Flow - Complete Journey

### Overview
The Pull Tooth feature allows parents to track when their child loses a tooth, capture photos, and manage tooth fairy rewards. Here's the complete flow:

---

### Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         START: Home Screen                           │
│                    (User selects child profile)                      │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 1: Child Detail Screen (Summary Tab)                          │
│  ─────────────────────────────────────────────────────────────      │
│  • Shows child's profile photo, name, age                            │
│  • Displays wallet balance ($0.00 initial)                           │
│  • Shows "Collect a Tooth" button                                    │
│  • Shows teeth count (e.g., "0/20 teeth")                            │
│                                                                       │
│  User Action: Click "Collect a Tooth" button                         │
│  Route: KEY_ROUTE_PULL_TOOTH                                         │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 2: Pull Tooth Screen (pullToothScreen.dart)                   │
│  ─────────────────────────────────────────────────────────────      │
│  • Title: "Select a Tooth to Pull"                                   │
│  • Shows animated mouth image with clickable teeth regions           │
│  • 20 clickable invisible regions overlay the mouth image            │
│    - Top row: 10 teeth (t1-t10)                                      │
│    - Bottom row: 10 teeth (b1-b10)                                   │
│                                                                       │
│  Initial Animation:                                                  │
│  1. Plays mouth_open_video.mp4                                       │
│  2. Auto-plays first molar selection (t9.mp4)                        │
│  3. Shows tooth name: "First Molar"                                  │
│  4. After 500ms, area becomes clickable                              │
│                                                                       │
│  User Action: Tap on any tooth region                                │
│  ─────────────────────────────────────────────────────────────      │
│  What Happens When Tooth Tapped:                                     │
│  1. _isClickable check (prevents double-tap)                         │
│  2. Sets _isClickable = false                                        │
│  3. Stores selected tooth number in CommonResponse.selectedTooth     │
│  4. Plays tooth selection video (e.g., t5.mp4 for tooth #5)          │
│  5. Video listener triggers when playback completes:                 │
│     - Sets _isVideoVisible = false                                   │
│     - Updates _toothName (e.g., "Central Incisor")                   │
│     - Updates _teethDescription (educational text)                   │
│     - Waits 500ms, sets _isClickable = true                          │
│  6. "Pull Tooth" button becomes enabled                              │
│                                                                       │
│  User sees:                                                          │
│  • Tooth name: "Central Incisor" / "First Molar" / etc.              │
│  • Description: Educational text about the tooth                     │
│  • Enabled "Pull Tooth" button at bottom                             │
│                                                                       │
│  User Action: Click "Pull Tooth" button                              │
│  Route: KEY_ROUTE_CAPTURE_IMAGE with teethNumber parameter           │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 3: Capture Image Screen (captureImageScreen.dart)             │
│  ─────────────────────────────────────────────────────────────      │
│  Purpose: Take photo of the pulled tooth                             │
│                                                                       │
│  On Device:                                                          │
│  • Initializes camera (front camera by default)                      │
│  • Shows live camera preview                                         │
│  • Camera controls:                                                  │
│    - Flip camera button (front/back toggle)                          │
│    - Capture button (white circle at bottom)                         │
│                                                                       │
│  On Simulator:                                                       │
│  • Shows "Simulator Mode Camera Preview" placeholder                 │
│  • Camera icon with grey background                                  │
│  • Capture button still functional                                   │
│                                                                       │
│  User Action: Click capture button                                   │
│  ─────────────────────────────────────────────────────────────      │
│  What Happens:                                                       │
│  1. Device: Calls controller.takePicture()                           │
│     Simulator: Calls _createDummyImage()                             │
│  2. Saves image to app documents directory                           │
│  3. Sets imagePath state variable                                    │
│  4. Shows captured image preview                                     │
│  5. "Use Photo" button appears                                       │
│                                                                       │
│  User Action: Click "Use Photo" button                               │
│  ─────────────────────────────────────────────────────────────      │
│  API Call: pullToothApiCall()                                        │
│  • Endpoint: POST /api/pull-tooth                                    │
│  • Payload:                                                          │
│    - childId: Selected child's ID                                    │
│    - teethNumber: Selected tooth number (1-20)                       │
│    - img: Base64 encoded image                                       │
│    - date: Current date (YYYY-MM-DD)                                 │
│    - authToken: Bearer token                                         │
│                                                                       │
│  Response Expected:                                                  │
│  {                                                                   │
│    "status": 1,                                                      │
│    "message": "Tooth pulled successfully",                           │
│    "data": {                                                         │
│      "id": 123,                                                      │
│      "amount": 5.00,      // Tooth fairy reward                      │
│      "teeth_number": "5",                                            │
│      "pull_date": "2025-11-03"                                       │
│    }                                                                 │
│  }                                                                   │
│                                                                       │
│  Route: KEY_ROUTE_ANALYSING_SCREEN                                   │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 4: Analysing Screen (analysingScreen.dart)                    │
│  ─────────────────────────────────────────────────────────────      │
│  Purpose: Show loading animation while processing                    │
│                                                                       │
│  Display:                                                            │
│  • Animated loading indicator                                        │
│  • "Analysing tooth..." text                                         │
│  • Duration: ~2-3 seconds                                            │
│                                                                       │
│  Automatically navigates to congratulations screen                   │
│  Route: KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL                      │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 5: Congratulations Screen (congratulationsToothPull.dart)     │
│  ─────────────────────────────────────────────────────────────      │
│  Purpose: Celebrate successful tooth pull and show reward            │
│                                                                       │
│  Display:                                                            │
│  • Celebration animation / confetti                                  │
│  • "Congratulations!" message                                        │
│  • Tooth fairy reward amount (e.g., "$5.00")                         │
│  • Pulled tooth image                                                │
│  • "Done" button                                                     │
│                                                                       │
│  Data Updated:                                                       │
│  • Child's pulled teeth count: 0 → 1                                 │
│  • Child's wallet balance: $0.00 → $5.00                             │
│  • CommonResponse.pullHistoryData updated                            │
│                                                                       │
│  User Action: Click "Done"                                           │
│  Route: Returns to Child Detail Screen (Summary Tab)                 │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 6: Back to Child Detail Screen (Summary Tab)                  │
│  ─────────────────────────────────────────────────────────────      │
│  Updated Display:                                                    │
│  • Teeth count: "1/20 teeth"                                         │
│  • Wallet balance: "$5.00"                                           │
│  • Can pull another tooth or:                                        │
│    - View History tab (see pulled teeth)                             │
│    - Cash out (if balance > 0)                                       │
│    - Keep mouth healthy (brush teeth game)                           │
│                                                                       │
│                          END OF FLOW                                 │
└─────────────────────────────────────────────────────────────────────┘
```

---

### Key Components Explained

#### 1. **Tooth Selection Logic**
- **Location**: pullToothScreen.dart, lines 242-684
- **20 Invisible Clickable Regions**: Positioned over mouth image
  - Each tooth has its own InkWell widget
  - `flex` values determine size/spacing
  - margin values create proper positioning

Example (Tooth #5 - Central Incisor):
```dart
Widget _t5Widget() {
  return Expanded(
    flex: 13,
    child: InkWell(
      onTap: () {
        if (_isClickable) {
          _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t5.mp4';
          _isClickable = false;
          CommonResponse.selectedTooth = '5';
          _initController(Constants.TEETH_CENTRAL_INCISOR,
              Constants.DESCRIPTION_CENTRAL_INCISOR);
        }
      },
      child: Container(height: 45, margin: EdgeInsets.only(bottom: 20)),
    ),
  );
}
```

#### 2. **Video Animation System**
- **Initial Video**: mouth_open_video.mp4 (mouth opening)
- **Selection Videos**: t1.mp4 through b10.mp4 (20 teeth)
- **Flow**:
  1. Video starts playing → `_isVideoVisible = true`
  2. Video controller listener detects playback
  3. When video ends → `_isVideoVisible = false`
  4. Sets tooth name and description
  5. After 500ms → `_isClickable = true`

#### 3. **Camera/Image Capture**
- **Device Mode**:
  - Uses CameraController
  - Supports front/back camera
  - Captures actual photo with takePicture()

- **Simulator Mode** (NEW):
  - Detects simulator automatically
  - Shows placeholder UI
  - Creates dummy text file
  - API still receives "image" (base64 of dummy file)

#### 4. **Data Flow**
```
CommonResponse (Global State)
├─ selectedTooth: String (1-20)
├─ childData: ChildData
│  ├─ id: int
│  ├─ name: String
│  ├─ TeethCount: int
│  └─ ...
└─ pullHistoryData: PullHistoryData
   ├─ amount: double
   └─ pulledTeeth: List<PulledTooth>
```

#### 5. **API Integration**
**Endpoint**: `POST /api/pull-tooth`

**Request**:
```json
{
  "child_id": 1,
  "teeth_number": "5",
  "img": "base64EncodedImageString...",
  "date": "2025-11-03"
}
```

**Response**:
```json
{
  "status": 1,
  "message": "Tooth pulled successfully",
  "data": {
    "id": 123,
    "amount": 5.00,
    "teeth_number": "5",
    "pull_date": "2025-11-03"
  }
}
```

---

### Constants Reference

**Tooth Names**:
- `TEETH_SECOND_MOLAR`: "Second Molar" (teeth 1, 10, 11, 20)
- `TEETH_FIRST_MOLAR`: "First Molar" (teeth 2, 9, 12, 19)
- `TEETH_CUSPID`: "Cuspid" (teeth 3, 8, 13, 18)
- `TEETH_LATERAL_INCISOR`: "Lateral Incisor" (teeth 4, 7, 14, 17)
- `TEETH_CENTRAL_INCISOR`: "Central Incisor" (teeth 5, 6, 15, 16)

**Routes**:
- `KEY_ROUTE_PULL_TOOTH`: "PULL_TOOTH"
- `KEY_ROUTE_CAPTURE_IMAGE`: "CAPTURE_IMAGE"
- `KEY_ROUTE_ANALYSING_SCREEN`: "ANALYSING_SCREEN"
- `KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL`: "CONGRATULATIONS_ON_TOOTH_PULL"

---

### Testing Checklist

✅ **On Physical Device**:
- [ ] Navigate to child detail
- [ ] Click "Collect a Tooth"
- [ ] Video plays on screen load
- [ ] Tap different teeth - each plays its video
- [ ] Tooth name and description appear
- [ ] "Pull Tooth" button enabled after selection
- [ ] Camera initializes on capture screen
- [ ] Can flip between front/back camera
- [ ] Take photo successfully
- [ ] Photo preview shows
- [ ] Upload succeeds with API
- [ ] Congratulations screen appears
- [ ] Wallet balance updated
- [ ] Teeth count incremented

✅ **On Simulator** (NEW):
- [ ] "Simulator Mode Camera Preview" displays
- [ ] Capture button creates dummy file
- [ ] Flow continues normally
- [ ] Console shows: "Running on simulator: true"
- [ ] Console shows: "Created dummy image at: [path]"

---

### Common Issues & Solutions

**Issue**: Teeth not clickable
- **Cause**: Video still playing or _isClickable = false
- **Solution**: Wait for video to finish (500ms)

**Issue**: Camera crash on simulator
- **Cause**: Trying to initialize real camera
- **Solution**: Now handled automatically with simulator detection

**Issue**: "Bundle identifier missing" (iOS)
- **Cause**: Missing PRODUCT_BUNDLE_IDENTIFIER
- **Solution**: Already fixed in ios/Runner.xcodeproj

**Issue**: Video shows then freezes
- **Cause**: VideoPlayerController not initialized
- **Solution**: Already fixed with nullable controller

---

### File Structure

```
lib/
├── screens/
│   ├── pullToothScreen.dart         # Tooth selection
│   ├── captureImageScreen.dart      # Camera/photo capture
│   ├── analysingScreen.dart         # Loading animation
│   └── congratulationsToothPull.dart # Success celebration
├── models/
│   └── responseModel/
│       └── pullToothResponse.dart   # API response model
├── services/
│   └── apiService.dart              # pullToothApiCall()
└── utils/
    └── commonResponse.dart          # Global state management
```

---

### Summary

The Pull Tooth flow is a **6-step journey**:
1. **Child Detail** → Click "Collect a Tooth"
2. **Pull Tooth** → Select tooth from animated mouth
3. **Capture Image** → Take photo (or use dummy on simulator)
4. **Analysing** → Loading screen
5. **Congratulations** → Show reward
6. **Back to Detail** → Updated stats

**Now fully simulator-compatible** for easy testing without a physical device! 🎉
