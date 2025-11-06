# Tooth Tycoon - Project Context

## Project Overview
Tooth Tycoon is a Flutter mobile application designed to help parents track their children's tooth loss milestones and teach financial literacy through a gamified experience. The app allows parents to document each lost tooth, reward their children with virtual currency, and provide educational features around investing and savings.

**Version:** 1.0.0+1
**SDK:** Dart >=3.0.0 <4.0.0 (upgraded from 2.7.0)
**Platform:** iOS & Android
**Backend:** AWS EC2 (http://ec2-3-141-107-40.us-east-2.compute.amazonaws.com/api)
**Package Name (Android):** za.co.digitalcowboy.toothtycoon
**Bundle ID (iOS):** za.co.digitalcowboy.toothtycoon

## Core Features

### 1. Child Management
- Add multiple children with photo, name, and age
- Track teeth pulled for each child
- View tooth-pulling history with photos
- Badge system for milestones

### 2. Tooth Tracking
- Interactive video-based tooth selection interface
- Photo capture of lost tooth
- Educational information about each tooth type (First Molar, Second Molar, Lateral Incisor, Central Incisor, Cuspid)
- Question and answer validation process after tooth pull

### 3. Financial Features
- Currency system with multi-currency support
- Set budget per tooth
- Investment feature - simulate compound interest over time
- Cash out feature - withdraw accumulated funds
- Track total earnings per child

### 4. Gamification & Engagement
- Badge rewards for milestones
- Congratulations screens with animations
- Share milestone achievements
- Video animations for tooth pulling experience
- Progress tracking

### 5. Authentication
- Email/password signup and login
- Social login (Facebook, Apple Sign In)
- Password reset functionality
- Firebase Authentication integration

## Project Structure

```
lib/
├── main.dart                    # App entry point, route configuration
├── constants/
│   ├── colors.dart             # App color palette
│   └── constants.dart          # App-wide constants (routes, keys, teeth info)
├── models/
│   ├── postdataModel/          # Request models
│   │   ├── addChildPostDataModel.dart
│   │   ├── loginPostDataModel.dart
│   │   ├── signupPostDataModel.dart
│   │   └── socialLoginPostData.dart
│   └── responseModel/          # Response models
│       ├── cashOutResponse.dart
│       ├── childListResponse.dart
│       ├── currencyResponse.dart
│       ├── investResponse.dart
│       ├── loginResponseModel.dart
│       ├── pullHistoryResponse.dart
│       ├── pullToothResponse.dart
│       ├── signupResponseModel.dart
│       └── submitQuestionResponse.dart
├── screens/                    # UI screens (20 screens)
│   ├── splashScreen.dart
│   ├── welcomeScreen.dart
│   ├── homeScreen.dart
│   ├── viewChildren.dart
│   ├── childDetail.dart
│   ├── captureImageScreen.dart
│   ├── pullToothScreen.dart
│   ├── questionAnsScreen.dart
│   ├── congratulationsScreen.dart
│   ├── congratulationsAfterToothPullScreen.dart
│   ├── receiveBadgeScreen.dart
│   ├── investScreen.dart
│   ├── cashOutScreen.dart
│   ├── historyScreen.dart
│   ├── badgesScreen.dart
│   ├── summaryScreen.dart
│   ├── analysingScreen.dart
│   ├── shareImageScreen.dart
│   ├── tellYourFriendScreen.dart
│   └── deviceNotSupportedScreen.dart
├── bottomsheet/                # Modal bottom sheets
│   ├── addChildBottomSheet.dart
│   ├── loginBottomSheet.dart
│   ├── signupBottomSheet.dart
│   ├── resetPasswordBottomSheet.dart
│   └── setBudgetBottomSheet.dart
├── services/
│   ├── apiService.dart         # All API calls
│   └── navigation_service.dart # Navigation management
├── helper/
│   └── prefrenceHelper.dart    # SharedPreferences wrapper
├── utils/
│   ├── utils.dart              # General utilities
│   ├── commonResponse.dart     # API response parsing
│   ├── lager.dart              # Logging utilities
│   ├── dateTimeUtils.dart      # Date/time formatting
│   ├── encryptUtils.dart       # Encryption utilities
│   └── textUtils.dart          # Text manipulation
└── widgets/
    ├── customWebView.dart      # WebView wrapper
    └── videoPlayerWidget.dart  # Video player component
```

## Key Technical Components

### Navigation Routes
All routes are defined in [main.dart](lib/main.dart) and use named routes:
- `/SPLASH` - Splash screen with app initialization
- `/WELCOME` - Welcome/onboarding screen
- `/HOME` - Main dashboard
- `/VIEW_CHILD` - List of children
- `/CHILD_DETAIL` - Individual child profile and history
- `/CAPTURE_IMAGE` - Camera interface for tooth photos
- `/PULL_TOOTH` - Interactive tooth selection with video
- `/QUESTION_AND_ANSWER` - Validation questions
- `/CONGRATULATION_SCREEN` - Success screen
- `/RECEIVE_BADGE_SCREEN` - Badge earned display
- `/INVEST_SCREEN` - Investment interface
- `/CASH_OUT_SCREEN` - Withdrawal interface
- `/SHARE_SCREEN` - Share milestone
- `/ANALYSING_SCREEN` - Processing screen
- `/TELL_YOUR_FRIEND_SCREEN` - Referral screen
- `/DEVICE_NOT_SUPPORTED_SCREEN` - Compatibility warning

### Data Models

#### Child Data
```dart
class ChildData {
  int id;
  int userId;
  String name;
  int age;
  String img;
  int teethCount;
}
```

#### Pull History
```dart
class TeethList {
  int id;
  String childId;
  String teethNumber;
  String picture;
  String pullDate;
}

class Badges {
  int id;
  String name;
  String description;
  String img;
}
```

### API Service ([apiService.dart](lib/services/apiService.dart:14))
Base URL: `http://ec2-3-141-107-40.us-east-2.compute.amazonaws.com/api`

**Authentication Endpoints:**
- `POST /api/login` - Email/password login
- `POST /api/register` - User registration
- `POST /api/Social` - Social login (Facebook/Apple)
- `POST /api/forgot` - Forgot password
- `POST /api/reset` - Reset password

**Child Management:**
- `POST /api/child` - Get child list
- `POST /api/child/add` - Add new child (multipart/form-data)
- `POST /api/child/pull_history` - Get tooth pull history for child

**Tooth Management:**
- `POST /api/child/teeth/pull` - Record tooth pull (multipart/form-data)

**Financial Operations:**
- `POST /api/SetBudget` - Set budget per tooth
- `POST /api/child/invest` - Create investment
- `POST /api/child/cashout` - Cash out funds
- `GET /api/currency/get` - Get available currencies

**Other:**
- `POST /api/SubmitQuestions` - Submit answers after tooth pull
- `POST /api/MillStone` - Share milestone

### State Management
- Uses `shared_preferences` for persistent storage
- [PreferenceHelper](lib/helper/prefrenceHelper.dart) class wraps SharedPreferences
- Stored data includes:
  - Login status
  - Access token (Bearer token)
  - User ID
  - Email
  - Currency ID and amount

### Tooth Types & Education
Five tooth types are defined in [constants.dart](lib/constants/constants.dart:51-68):

1. **First Molar** - "When you were a baby, this tooth was one of your last to cut through..."
2. **Second Molar** - "This tooth is the furthest back in your mouth. It helps to grind your food..."
3. **Lateral Incisor** - "This tooth is just on the side of your front teeth. You use it to cut and shear..."
4. **Central Incisor** - "This tooth is right in the front of your mouth and we see it in your pretty smile..."
5. **Cuspid** - "This tooth is also known as your canine tooth. Can you see it is pointier..."

## Key Dependencies

### UI & UX
- `flutter` - Core framework
- `cupertino_icons: ^1.0.8` - iOS-style icons (upgraded)
- `bot_toast: ^4.1.3` - Toast notifications (upgraded)
- `page_view_indicators: ^2.0.0` - Page indicators (upgraded)
- `percent_indicator: ^4.2.3` - Progress indicators (upgraded)
- `auto_size_text: ^3.0.0` - Responsive text sizing (upgraded)
- `draggable_scrollbar: ^0.1.0` - Custom scrollbars (upgraded)

### Media & Animation
- `video_player: ^2.9.2` - Video playback (upgraded)
- `camera: ^0.11.0+2` - Camera integration (upgraded)
- `image_picker: ^1.1.2` - Photo selection (upgraded)
- `image_sequence_animator: ^2.0.0` - Frame-by-frame animations (upgraded)
- `share_plus: ^10.1.3` - Social sharing (migrated from esys_flutter_share)

### Backend & Storage
- `http: ^1.2.2` - HTTP client (upgraded)
- `http_parser: ^4.0.2` - HTTP parsing utilities (upgraded)
- `shared_preferences: ^2.3.5` - Local storage (upgraded)
- `path_provider: ^2.1.5` - File system access (upgraded)
- `device_info_plus: ^11.2.0` - Device information (migrated from device_info)

### Authentication
- `firebase_auth: ^5.3.4` - Firebase authentication (upgraded)
- `firebase_core: ^3.10.0` - Firebase core (upgraded)
- `sign_in_with_apple: ^6.1.3` - Apple Sign In (migrated from apple_sign_in)
- `flutter_facebook_auth: ^6.0.4` - Facebook login (migrated from flutter_facebook_login)

### Utilities
- `intl: ^0.19.0` - Internationalization (upgraded)
- `encrypt: ^5.0.3` - Encryption utilities (upgraded)
- `synchronized: ^3.3.0+3` - Synchronization primitives (upgraded)
- `webview_flutter: ^4.10.0` - WebView component (upgraded)

### Monetization
- **REMOVED**: Google AdMob has been completely removed from the project

## App Initialization

### Flutter App ([main.dart](lib/main.dart))
1. **Widgets Binding** - Ensures Flutter is initialized
2. **System UI** - Sets portrait orientation and light status bar
3. **BotToast** - Initializes toast notification system
4. **Navigation Service** - Sets up global navigation key

### Android App ([android/app/src/main/kotlin/za/co/digitalcowboy/toothtycoon/MyApplication.kt](android/app/src/main/kotlin/za/co/digitalcowboy/toothtycoon/MyApplication.kt))
1. **Facebook SDK Initialization** - `FacebookSdk.sdkInitialize(applicationContext)`
2. **Facebook App Events** - `AppEventsLogger.activateApp(this)`

## Color Scheme ([constants/colors.dart](lib/constants/colors.dart))
- Primary color: Custom purple/blue theme
- Uses `AppColors.COLOR_PRIMARY` throughout the app

## Assets Structure
```
assets/
├── icons/          # App icons and UI elements
├── videos/         # Tooth pulling animations
│   └── toothSelectionVideo/
├── images/         # Static images
│   └── congratulationsAnimationImages/  # Animation frames
└── fonts/          # Custom fonts (Avenir, OpenSans)
```

## User Flow

1. **Splash Screen** → Check login status
2. **Welcome/Login** → Authenticate user
3. **Home Screen** → Three main actions:
   - Set Budget (per tooth amount)
   - Add Child
   - View Children
4. **Child Detail** → View history, badges, pull tooth
5. **Pull Tooth Flow:**
   - Capture tooth photo
   - Select tooth type (video interface)
   - Answer questions
   - See congratulations
   - Receive badge (if milestone)
6. **Financial Actions:**
   - Invest (compound interest simulation)
   - Cash Out (withdraw funds)

## Development Notes

### API Authentication
All authenticated endpoints require a Bearer token in the Authorization header. Token is stored via [PreferenceHelper](lib/helper/prefrenceHelper.dart) and retrieved from SharedPreferences.

### Image Handling
- Child photos and tooth photos are uploaded as multipart/form-data
- Uses `http.MultipartRequest` and `http.MultipartFile.fromPath()`

### Video Implementation
- Uses `VideoPlayerController` for mouth/tooth animations
- Video files located in `assets/videos/`
- Custom video player widget in [widgets/videoPlayerWidget.dart](lib/widgets/videoPlayerWidget.dart)

### Error Handling
- Common response parsing in [utils/commonResponse.dart](lib/utils/commonResponse.dart)
- API exceptions are caught and logged
- Status codes: 200 (OK), 201 (Created), 401 (Unauthorized)

### Encryption
- [encryptUtils.dart](lib/utils/encryptUtils.dart) provides encryption functionality using the `encrypt` package (v4.0.3)

## Recent Major Updates (November 2024)

### Package Name Migration
- **Android Package**: Changed from `orainfotech.mobi.tooth_tycoon` to `za.co.digitalcowboy.toothtycoon`
- **iOS Bundle ID**: Changed to `za.co.digitalcowboy.toothtycoon`
- All configuration files updated (AndroidManifest.xml, google-services.json, Info.plist, etc.)
- MainActivity moved to new package structure

### Android Build System Upgrades
- **Gradle**: Upgraded from 6.4.1 to 8.9
- **Android Gradle Plugin**: Upgraded from 4.0.1 to 8.7.3
- **Kotlin**: Upgraded from 1.3.50 to 1.9.10
- **Google Services**: Upgraded from 3.0.0 to 4.4.0
- **Build Configuration**:
  - compileSdk: 35
  - targetSdk: 35
  - minSdk: 23 (required by Firebase Auth)
  - Java/Kotlin compatibility: Version 17
- Migrated to declarative plugin syntax in settings.gradle
- Replaced jcenter() with mavenCentral()
- Removed deprecated Android v1 embedding

### Google Ads Removal
- Completely removed all Google AdMob implementation
- Deleted `add_helper.dart` file
- Removed all InterstitialAd and BannerAd code from:
  - addChildBottomSheet.dart
  - setBudgetBottomSheet.dart
  - analysingScreen.dart
  - viewChildren.dart
  - welcomeScreen.dart
- Removed AdMob metadata from AndroidManifest.xml and Info.plist

### Camera Functionality Fix
- Removed all simulator/emulator detection code from captureImageScreen.dart
- Removed `_isSimulator` flag and related methods
- Camera now works on all physical devices

### Facebook Authentication Configuration
- **Android**:
  - App ID: 1159577366145971
  - Client Token: 53d347f96a14aef9b0353d3a79d0d6f5
  - Created MyApplication.kt to initialize Facebook SDK
  - Added Facebook SDK dependency: `com.facebook.android:facebook-login:16.0.0`
  - Configured FacebookActivity and CustomTabActivity in AndroidManifest.xml
  - strings.xml properly configured with facebook_app_id and fb_login_protocol_scheme

- **iOS**:
  - App ID: 1159577366145971
  - Client Token: 53d347f96a14aef9b0353d3a79d0d6f5
  - CFBundleURLSchemes: fb1159577366145971
  - Info.plist properly configured

### Release Signing Configuration
- Created release keystore: `tooth-tycoon-release-key.jks`
- Key alias: `toothtycoon`
- Keystore passwords configured in `key.properties`
- Certificate valid for 10,000 days
- **Release Key Hash (for Facebook)**: `MOmYX15FUQjiG/lThsrXqjc9+xA=`
- build.gradle configured for release signing with minifyEnabled

### App Bundle Created
- Successfully built release AAB: `app-release.aab` (71 MB)
- Properly signed with release certificate
- Ready for Google Play Internal Testing upload

## Known Issues & Technical Debt

1. **Hard-coded URLs** - Base URL is hard-coded in [apiService.dart](lib/services/apiService.dart:14)
2. **No Error Recovery** - Limited error handling and user feedback
3. **Apple Sign In Bug** - Login flow in loginBottomSheet.dart bypasses backend authentication (navigates directly to home)
4. **Symbol Stripping Warning** - Release builds show warning about native library debug symbol stripping (doesn't prevent build)

## Future Considerations

1. **State Management** - Consider Provider, Riverpod, or Bloc for better state management
2. **API Configuration** - Move base URLs to environment variables
3. **Testing** - Add unit tests and widget tests
4. **Accessibility** - Improve screen reader support and accessibility features
5. **Localization** - Support multiple languages using the intl package more extensively
6. **Analytics** - Add comprehensive analytics tracking (Firebase Analytics recommended)
7. **Offline Support** - Cache data for offline access
8. **Fix Apple Sign In** - Login flow should call backend API instead of navigating directly

## Important Configuration Files

### Android
- **Package Name**: za.co.digitalcowboy.toothtycoon
- **Main Activity**: [android/app/src/main/kotlin/za/co/digitalcowboy/toothtycoon/MainActivity.kt](android/app/src/main/kotlin/za/co/digitalcowboy/toothtycoon/MainActivity.kt)
- **Application Class**: [android/app/src/main/kotlin/za/co/digitalcowboy/toothtycoon/MyApplication.kt](android/app/src/main/kotlin/za/co/digitalcowboy/toothtycoon/MyApplication.kt)
- **Manifest**: [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml)
- **Gradle Config**: [android/app/build.gradle](android/app/build.gradle)
- **Google Services**: [android/app/google-services.json](android/app/google-services.json)
- **Strings**: [android/app/src/main/res/values/strings.xml](android/app/src/main/res/values/strings.xml)
- **Keystore**: android/tooth-tycoon-release-key.jks (not in git)
- **Key Properties**: android/key.properties (not in git)

### iOS
- **Bundle ID**: za.co.digitalcowboy.toothtycoon
- **Info.plist**: [ios/Runner/Info.plist](ios/Runner/Info.plist)
- **Xcode Project**: [ios/Runner.xcodeproj/project.pbxproj](ios/Runner.xcodeproj/project.pbxproj)
- **Google Services**: [ios/GoogleService-Info.plist](ios/GoogleService-Info.plist)

### Firebase Setup
- Firebase is used **only** for Facebook Login authentication
- Not used for: Database, Storage, Push Notifications, Analytics
- Required files:
  - Android: google-services.json
  - iOS: GoogleService-Info.plist

### Facebook Developer Console Setup
- **App ID**: 1159577366145971
- **Android Package Name**: za.co.digitalcowboy.toothtycoon
- **Android Class Name**: za.co.digitalcowboy.toothtycoon.MainActivity
- **Android Key Hashes**:
  - Debug: `6Brw87eQ9X11F8uLPwCPpoLQFhc=`
  - Release: `MOmYX15FUQjiG/lThsrXqjc9+xA=`
- **iOS Bundle ID**: za.co.digitalcowboy.toothtycoon

## Git Status
- Current branch: `feature_android`
- Main branch: `master`
- Recent work: Android build fixes, Facebook authentication setup, release signing, AAB generation

## Getting Started for Development

### Prerequisites
1. Flutter SDK 3.x+ installed
2. Dart SDK 3.0.0+
3. Android Studio with SDK 35
4. Xcode (for iOS development)
5. Java 17+ (for Android builds)

### Setup Steps
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Ensure Firebase configuration files are in place:
   - `android/app/google-services.json`
   - `ios/GoogleService-Info.plist`
4. For Android development:
   - Ensure SDK 35 is installed
   - Gradle 8.9 will be downloaded automatically
5. For iOS development:
   - Run `pod install` in ios/ directory
6. Run on device/emulator: `flutter run`

### Building for Release

#### Android APK (for testing)
```bash
flutter build apk --release
```

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS (requires Mac)
```bash
flutter build ios --release
```

### Signing Keys
- **IMPORTANT**: Never commit `key.properties` or `.jks` files to git
- Backup keystore file securely
- Keystore password: (stored in key.properties)
- If keystore is lost, you cannot update the app on Play Store

## Contact & API Access
The backend API is hosted on AWS EC2. For API access, authentication tokens, or database schema information, contact the backend team.
