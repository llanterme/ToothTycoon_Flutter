# Tooth Tycoon - Project Context

## Project Overview
Tooth Tycoon is a Flutter mobile application designed to help parents track their children's tooth loss milestones and teach financial literacy through a gamified experience. The app allows parents to document each lost tooth, reward their children with virtual currency, and provide educational features around investing and savings.

**Version:** 1.0.1+8
**SDK:** Dart 2.7.0 - 3.0.0
**Platform:** iOS & Android
**Backend:** AWS EC2 (http://ec2-3-141-107-40.us-east-2.compute.amazonaws.com/api)

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
│   ├── prefrenceHelper.dart    # SharedPreferences wrapper
│   └── add_helper.dart         # Additional helpers
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
- `cupertino_icons: ^0.1.3` - iOS-style icons
- `bot_toast: 3.0.4` - Toast notifications
- `page_view_indicators: 1.3.1` - Page indicators
- `percent_indicator: 2.1.7+4` - Progress indicators
- `auto_size_text: 2.1.0` - Responsive text sizing
- `draggable_scrollbar: ^0.0.4` - Custom scrollbars

### Media & Animation
- `video_player: 1.0.1` - Video playback
- `camera: 0.5.8+7` - Camera integration
- `image_picker: 0.6.7+11` - Photo selection
- `image_sequence_animator: ^1.0.10` - Frame-by-frame animations
- `esys_flutter_share: ^1.0.2` - Social sharing

### Backend & Storage
- `http: 0.12.2` - HTTP client
- `http_parser: 3.1.3` - HTTP parsing utilities
- `shared_preferences: 0.5.12+4` - Local storage
- `path_provider: 1.6.21` - File system access
- `device_info: 0.4.2+4` - Device information

### Authentication
- `firebase_auth: 0.20.1` - Firebase authentication
- `firebase_core: 0.7.0` - Firebase core
- `apple_sign_in: 0.1.0` - Apple Sign In
- `flutter_facebook_login: ^3.0.0` - Facebook login

### Utilities
- `intl: 0.16.1` - Internationalization
- `encrypt: 4.0.3` - Encryption utilities
- `synchronized: 2.1.0+1` - Synchronization primitives
- `webview_flutter: 0.3.23` - WebView component

### Monetization
- `google_mobile_ads: ^0.13.1` - Google AdMob integration (initialized in [main.dart](lib/main.dart:31-38))

## App Initialization ([main.dart](lib/main.dart))

1. **Widgets Binding** - Ensures Flutter is initialized
2. **AdMob Initialization** - Sets up mobile ads with child-directed treatment configuration
3. **System UI** - Sets portrait orientation and light status bar
4. **BotToast** - Initializes toast notification system
5. **Navigation Service** - Sets up global navigation key

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

## Known Issues & Technical Debt

1. **Outdated Dependencies** - Many packages are using old versions (Flutter SDK 2.7.0, deprecated packages)
2. **Null Safety** - Project uses pre-null-safety Dart version
3. **Hard-coded URLs** - Base URL is hard-coded in [apiService.dart](lib/services/apiService.dart:14)
4. **No Error Recovery** - Limited error handling and user feedback
5. **Mixed Auth Methods** - Multiple authentication providers without unified flow

## Future Considerations

1. **Migration to Null Safety** - Update to Dart 3.x with null safety
2. **Dependency Updates** - Many packages need updating
3. **State Management** - Consider Provider, Riverpod, or Bloc for better state management
4. **API Configuration** - Move base URLs to environment variables
5. **Testing** - Add unit tests and widget tests
6. **Accessibility** - Improve screen reader support and accessibility features
7. **Localization** - Support multiple languages using the intl package more extensively
8. **Analytics** - Add comprehensive analytics tracking
9. **Offline Support** - Cache data for offline access

## Git Status
- Current branch: `master`
- Main branch: `master`
- Latest commit: "changes" (b6c083a)
- Recent work focused on bug fixes

## Getting Started for Development

1. Ensure Flutter SDK 2.7.0+ is installed
2. Run `flutter pub get` to install dependencies
3. Configure Firebase project (google-services.json for Android, GoogleService-Info.plist for iOS)
4. Configure Facebook App ID for social login
5. Run on device/emulator: `flutter run`

## Contact & API Access
The backend API is hosted on AWS EC2. For API access, authentication tokens, or database schema information, contact the backend team.
