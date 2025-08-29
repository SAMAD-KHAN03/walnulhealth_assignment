# Habit Tracker Application

A modern, cross-platform habit tracking application built with Flutter to help users build and maintain positive daily habits with visual progress tracking and streak monitoring.

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code with Flutter extensions
- For iOS development: Xcode (macOS only)
- For Android development: Android SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd habit-tracker-flutter
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For development (debug mode)
   flutter run

   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d web
   flutter run -d windows
   flutter run -d macos
   ```

4. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release

   # iOS
   flutter build ios --release

   # Web
   flutter build web --release

   # Windows
   flutter build windows --release
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34
- Ensure Android SDK and build tools are installed

#### iOS
- Minimum deployment target: iOS 11.0
- Requires Xcode 14.0+
- Valid Apple Developer account for device testing

## 🏗️ Architecture Overview

### Project Structure
```
lib/
├── main.dart                   # App entry point
├── models/
│   ├── habit.dart              # Habit data model
│   ├── habit_progress.dart     # Progress tracking model
│   ├── habitui.dart            # UI-specific habit model
│   ├── user.dart               # User data model
│   └── user_profile.dart       # User profile model
├── ui/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── dashboard/
│   │   └── dashboard.dart      # Main habit list view
│   ├── habitdetails/
│   │   └── habit_details_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── progressscreen/
│       ├── progress_screen.dart     # Monthly progress view
│       ├── calendar_view.dart       # Calendar visualization
│       ├── calendar_grid.dart       # Calendar grid layout
│       ├── month_selector.dart      # Month navigation
│       ├── habit_streak_section.dart # Streak display
│       └── task_completion_checker.dart
├── widgets/
│   ├── habit_detail_screen_widgets/
│   ├── build_habit_card.dart        # Individual habit display
│   ├── frequency_selector.dart      # Habit frequency picker
│   ├── habit_bottom_sheet.dart      # Add/Edit habit modal
│   └── build_bottom_navigation.dart # Navigation bar
├── providers/
│   ├── auth_service_specific_providers/
│   │   ├── auth_service_repo_provider.dart
│   │   └── dio_provider.dart
│   ├── habit_details_specific_provider/
│   │   └── week_days_provider.dart
│   ├── local_storage_specific_providers/
│   │   ├── local_progress_storage_class_provider.dart
│   │   └── local_storage_habits_list_provider.dart
│   ├── progress_screen_specific_providers/
│   │   └── selected_date_provider.dart
│   ├── texteditingcontroller_provider/
│   │   └── text_editing_controllers_provider.dart
│   ├── all_habit_list_provider.dart
│   ├── complete_list_provider.dart
│   ├── habit_service_repo_provider.dart
│   └── profile_provider.dart
└── services/
    ├── profile/
    │   └── fetchprofile.dart
    ├── auth_service.dart           # Authentication logic
    ├── habit_service.dart          # Habit business logic
    ├── local_store.dart            # Local data persistence
    ├── local_progress_store.dart   # Progress data storage
    ├── token_storage.dart          # Auth token management
    └── completed_habit_list_provider.dart
```

### Flutter Architecture Pattern: Provider + Service Layer

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   UI Screens    │───▶│    Providers     │───▶│    Services     │
│   (Widgets)     │    │ (State Manager)  │    │ (Business Logic)│
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ▲                        │                       │
         │                        ▼                       │
         │               ┌──────────────────┐              │
         │               │     Models       │              │
         │               │  (Data Classes)  │              │
         │               └──────────────────┘              │
         │                                                 ▼
         │                                    ┌─────────────────┐
         └────────────────────────────────────│ SharedPreferences│
                      UI Updates              │ (Local Storage) │
                                             └─────────────────┘
```

### Key Components

**Provider Architecture**: Modular state management with specialized providers
- `all_habit_list_provider.dart`: Manages complete habit collection
- `complete_list_provider.dart`: Handles completed habits state
- `selected_date_provider.dart`: Progress screen date navigation
- `local_storage_habits_list_provider.dart`: Local habit data persistence
- `local_progress_storage_class_provider.dart`: Progress tracking storage

**Service Layer**: Business logic and data operations
- `habit_service.dart`: Core habit CRUD operations and validation
- `auth_service.dart`: User authentication and session management
- `local_store.dart`: SharedPreferences operations for habit data
- `local_progress_store.dart`: Progress tracking and completion data
- `token_storage.dart`: Secure authentication token management

**UI Layer**: Screen-specific components and reusable widgets
- `dashboard.dart`: Main habit overview and interaction hub
- `progress_screen.dart`: Monthly progress visualization with calendar
- `habit_details_screen.dart`: Individual habit management and editing
- `calendar_view.dart`: Interactive calendar for progress tracking
- `habit_streak_section.dart`: Streak visualization and statistics

## 🧠 State Management Reasoning

### Current Implementation: Provider Pattern + SharedPreferences

**Why Provider + SharedPreferences:**
- **Flutter Native**: Built-in state management solution
- **Cross-platform**: Works on all Flutter platforms
- **Reactive**: Automatic UI updates when data changes
- **Simple**: Easy to understand and maintain
- **Offline-first**: No network dependency required

**State Architecture:**
```dart
class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;
  
  // State getters
  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  
  // Business methods
  Future<void> addHabit(Habit habit) async { ... }
  Future<void> toggleCompletion(String habitId) async { ... }
  Future<void> loadHabits() async { ... }
}
```

**Data Storage Structure:**
```dart
class Habit {
  final String id;
  final String title;
  final String description;
  final HabitFrequency frequency;
  final DateTime createdAt;
  final Map<String, bool> completions; // Date -> completed
  final int currentStreak;
  final int bestStreak;
}
```

**Benefits:**
- Immediate data persistence across app restarts
- No network latency or connectivity issues
- Built-in Flutter integration
- Automatic JSON serialization
- Cross-platform compatibility

**Limitations:**
- Limited storage capacity (~1MB recommended)
- No cross-device synchronization
- Performance degrades with large datasets
- No backup/restore capabilities
- Single-user limitation

## 🐛 Known Issues & Planned Improvements

### Current Issues

#### 1. Progress Screen Default State Bug
**Issue**: Progress section doesn't initialize to current month and year by default
- **Location**: `progress_screen.dart` - `initState()` method
- **Impact**: Users see empty or previous month data on first load
- **Root Cause**: Date initialization happens after widget build
- **Reproduction**: 
  1. Open app
  2. Navigate to Progress tab
  3. Screen shows incorrect month/year
- **Workaround**: Manual refresh or month navigation
- **Status**: High priority fix needed

#### 2. Inefficient Storage Strategy
**Issue**: All habit data stored in SharedPreferences regardless of current relevance
- **Location**: `storage_service.dart` - `saveHabits()` method
- **Impact**: 
  - SharedPreferences size bloat (approaching 1MB limit)
  - Slow app startup with 100+ habits
  - Unnecessary memory usage
  - Poor performance on older devices
- **Current Behavior**: All habits + all historical completion data stored locally
- **Proposed Solution**: Hybrid storage approach
  - **Local**: Only today's habits + recent 7 days completion data
  - **Backend**: Historical data and inactive habits
- **Status**: Architecture redesign required

### Planned Improvements

#### Immediate Fixes (Next Release v1.0.1)
- [ ] **Fix progress screen initialization**
  ```dart
  // Current problematic code:
  @override
  void initState() {
    super.initState();
    // selectedDate initialized too late
  }
  
  // Proposed fix:
  DateTime selectedDate = DateTime.now();
  ```

- [ ] **Add error handling for storage operations**
- [ ] **Implement loading states for all async operations**
- [ ] **Fix memory leaks in provider disposal**

#### Short-term (v1.1.0 - Next Month)
- [ ] **Storage Optimization**
  - Implement data archiving for old completions
  - Add storage size monitoring
  - Create data cleanup utilities
  - Implement lazy loading for habit history

- [ ] **Performance Improvements**
  - Add `ListView.builder` with proper itemExtent
  - Implement habit search and filtering
  - Optimize provider rebuild cycles
  - Add image caching for habit icons

- [ ] **Enhanced UX**
  - Add pull-to-refresh on habit list
  - Implement haptic feedback
  - Add dark theme support
  - Improve accessibility (screen readers, etc.)

#### Medium-term (v2.0.0 - Next Quarter)
- [ ] **Backend Integration**
  - **Technology Stack**: Firebase/Supabase + REST API
  - **Authentication**: Firebase Auth or custom JWT
  - **Database**: Cloud Firestore or PostgreSQL
  - **Storage Strategy**: 
    ```
    Local (SharedPreferences):
    ├── Today's active habits
    ├── Last 7 days completion data
    ├── User preferences
    └── Cached offline data
    
    Backend (Cloud):
    ├── Complete habit history
    ├── User profile data
    ├── Cross-device sync data
    └── Analytics and insights
    ```

- [ ] **Advanced Features**
  - Custom habit categories with colors
  - Flexible habit frequencies (every 3 days, weekdays only, etc.)
  - Progress photos for visual habits
  - Habit templates and sharing

#### Long-term (v3.0.0 - Future)
- [ ] **Cross-platform Enhancements**
  - Wear OS companion app
  - Desktop widgets (Windows/macOS)
  - Web dashboard with advanced analytics

- [ ] **AI-Powered Features**
  - Habit recommendation engine
  - Optimal timing suggestions
  - Progress prediction and insights
  - Personalized motivation messages

- [ ] **Social Features**
  - Habit sharing with friends
  - Community challenges
  - Progress competitions
  - Achievement badges system

### Performance Benchmarks & Targets

**Current Performance:**
- App startup: ~2-3 seconds (with 50+ habits)
- Habit toggle response: ~200-500ms
- Progress screen load: ~1-2 seconds

**Target Performance (Post-optimization):**
- App startup: <1 second
- Habit toggle response: <100ms
- Progress screen load: <500ms

## 🛠️ Development Guidelines

### Flutter Best Practices
- Use `const` constructors wherever possible
- Implement proper `dispose()` methods for controllers
- Follow Flutter naming conventions
- Use `ListView.builder` for long lists
- Implement proper error handling with try-catch

### Code Style
```dart
// Use dartfmt for consistent formatting
flutter format .

// Analyze code for issues
flutter analyze

// Run tests
flutter test
```

### Testing Strategy
- **Unit Tests**: Models, services, and utility functions
- **Widget Tests**: Individual widget behavior
- **Integration Tests**: Complete user workflows
- **Golden Tests**: UI consistency across platforms

### State Management Guidelines
```dart
// Good: Minimal rebuilds
Consumer<HabitProvider>(
  builder: (context, habitProvider, child) {
    return Text(habitProvider.todayHabitsCount.toString());
  },
)

// Avoid: Unnecessary rebuilds
Consumer<HabitProvider>(
  builder: (context, habitProvider, child) {
    return Column(
      children: habitProvider.allHabits.map((habit) => 
        HabitCard(habit: habit)
      ).toList(),
    );
  },
)
```

## 🔧 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5              # State management
  shared_preferences: ^2.2.2    # Local storage
  uuid: ^4.0.0                  # Unique ID generation
  intl: ^0.18.1                 # Date formatting

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0         # Linting rules
  mockito: ^5.4.2               # Testing mocks
```

### Planned Dependencies
```yaml
provider: ^6.1.5+1
  flutter_riverpod: ^2.6.1
  dio: ^5.9.0
  shared_preferences: ^2.5.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  dotted_border: ^3.1.0
  intl: ^0.20.2
  connectivity_plus: ^6.1.5
```

## 📱 Platform Considerations

### Android Specific
- **Minimum SDK**: API 21 (covers 98%+ of devices)
- **Permissions**: None required for basic functionality
- **Adaptive Icons**: Implemented for Android 8.0+
- **Background Processing**: WorkManager for habit reminders

### iOS Specific  
- **Deployment Target**: iOS 11.0
- **App Store Guidelines**: Compliant with review guidelines
- **Background App Refresh**: Supported for data sync
- **Widget Extension**: Planned for iOS home screen
---

*Last updated: August 30, 2025*  
*Version: 1.0.0*  
*Flutter SDK: 3.19.0 • Dart: 3.3.0*
