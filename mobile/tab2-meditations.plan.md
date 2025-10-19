# Tab 2: Meditations Implementation Plan

## Overview
Implement a comprehensive Meditations tab with audio list, full-screen player, sleep timer, and silence mode features.

## Main Components

### 1. Meditations List Screen
**File:** `lib/tabs/meditations_tab.dart`

#### Features:
- Header with "Meditations" title, bell icon, profile icon
- Category filter tabs: "Audios", "Music", "Sleep"
- Secondary filter tabs: "All audio", "Albums", "Music", "Live"
- Scrollable list of meditation tracks
- Each track item includes:
  - Circular play icon (purple)
  - Track title and subtitle
  - Artist name (@monocorde, @thewizard, etc.)
  - Duration (2:00, 3:00, etc.)
  - Three-dot menu icon
- Track counter: "25 audios"
- Mini player bar at bottom (when playing)
- Tap track to open full player
- Tap menu icon for options popup

### 2. Full-Screen Music Player
**File:** `lib/screens/meditation_player_screen.dart`

#### Features:
- Background image (storm/lightning - use placeholder)
- Back button in header
- Heart and download icons in header
- Track information:
  - Large title display
  - Artist name with @ prefix
- Progress bar with:
  - Current time (00:12)
  - Total duration (05:10)
  - Draggable slider
- Playback controls (center):
  - Shuffle button (left)
  - Rewind 15 seconds
  - Large play/pause button (purple circle)
  - Forward 15 seconds
  - Repeat button (right)
- Bottom action icons:
  - Heart (favorite)
  - Download
  - Share
  - Moon (sleep timer)

### 3. Track Options Menu
**File:** `lib/widgets/meditation_track_menu.dart`

#### Features:
- Modal bottom sheet or popup
- Track title with "premium" tag (optional)
- Options list:
  - Add to favorites (heart icon)
  - Download (download icon)
  - Share (share icon)
- Cancel button at bottom

### 4. Sleep Timer Modal
**File:** `lib/widgets/sleep_timer_modal.dart`

#### Features:
- Modal popup overlay
- "Sleep Timer" title
- Circular time selector (wheel picker)
- Time options: 5, 10, 15, 20, 25, 30, 45, 60 minutes
- Selected time displayed in center (large number)
- "Launch Timer" button
- Visual indicator when timer is active (moon icon highlighted)

### 5. Silence Mode
**File:** `lib/screens/silence_mode_screen.dart`

#### Two Screens:

**Screen A: Time Selection**
- "Silence" title
- Subtitle: "Choose time for your silence session"
- Scrollable time list (07:00 - 13:00 in 1-hour increments)
- Selected time highlighted in purple
- "Let's start" button at bottom

**Screen B: Active Session**
- Abstract metallic icon/animation (placeholder)
- Instructions: "Close your eyes and keep calm in silence"
- Countdown timer display (06:00, 05:59, etc.)
- Play/pause button
- Back button to exit session

### 6. Statistics/Achievements (Optional for Tab 2)
**File:** `lib/screens/meditation_stats_screen.dart`

#### Features:
- "My achievements" screen with:
  - Daily meditation count (54 meditations)
  - Total time spent (53 minutes)
  - "See more" button
- Calendar view:
  - Monthly calendar grid
  - Highlighted days with meditation activity
  - Streak counter
- History list:
  - Date-grouped meditation sessions
  - "See all meditations" button

## Data Structure

### Meditation Track Model
```dart
class MeditationTrack {
  final String id;
  final String title;
  final String artist;
  final String duration; // "2:00" format
  final String category; // "audio", "music", "sleep"
  final String imageUrl; // placeholder path
  final String audioUrl; // placeholder or null
  final bool isPremium;
  final bool isFavorite;
  final bool isDownloaded;
}
```

### Sample Data
- Create 25 sample meditation tracks
- Mix of different categories
- Various durations (2:00 - 10:00)
- Different artist names
- No premium restrictions (as per requirement)

## State Management

### Player State
- Current track
- Playing/paused status
- Current playback position
- Shuffle enabled
- Repeat mode (off/one/all)
- Sleep timer (active/inactive, remaining time)

### List State
- Selected category filter
- Selected secondary filter
- Favorite tracks
- Downloaded tracks
- Playback history

## Technical Implementation

### Audio Playback
- Use placeholder audio or just UI simulation for now
- Mock playback progress with timer
- Implement all UI controls (they'll trigger state changes)

### Animations
- Progress bar sliding animation
- Play/pause button transitions
- Mini player slide up/down
- Modal popup animations
- Timer countdown animation

### Navigation
- From list → full player (Hero animation optional)
- Back button returns to list with mini player visible
- Sleep timer modal overlays player
- Silence mode is separate screen stack

## Styling

### Colors
- Background: `#1B0A33`
- Accent: `#6A1B9A`
- Text: `#F0E6D8`
- Highlighted items: Purple overlay
- Progress bars: Purple with gray background

### Typography
- Continue using `GoogleFonts.dmSans`
- Track titles: 16px, weight 500
- Artist names: 14px, weight 300, opacity 0.8
- Large player title: 24px, weight 600

### Icons
- Use Material Icons for most elements
- Custom painted icons for unique elements (silence mode icon)
- Consistent sizing: 24px for main icons, 20px for secondary

## Implementation Order

1. Create meditation data model and sample data
2. Build meditations list screen with tabs
3. Implement track list items with menu
4. Create full-screen player UI
5. Add mini player bar component
6. Implement sleep timer modal
7. Build silence mode screens
8. Add navigation between screens
9. Implement state management for playback
10. Add statistics/achievements (optional)

## Files to Create

### New Files
- `lib/tabs/meditations_tab.dart` - Main tab content
- `lib/screens/meditation_player_screen.dart` - Full player
- `lib/screens/silence_mode_screen.dart` - Silence sessions
- `lib/screens/meditation_stats_screen.dart` - Stats/achievements
- `lib/widgets/meditation_track_menu.dart` - Options popup
- `lib/widgets/sleep_timer_modal.dart` - Sleep timer
- `lib/widgets/mini_player_bar.dart` - Bottom player bar
- `lib/models/meditation_track.dart` - Data model
- `lib/data/meditation_data.dart` - Sample data

### Files to Modify
- `lib/main_app_screen.dart` - Update Tab 2 from placeholder to MeditationsTab

## Notes
- No subscription/paywall functionality needed
- Use placeholder images for backgrounds
- Mock audio playback for now (UI only)
- All tracks are accessible (no premium locks)
- Focus on UI/UX implementation and state management
