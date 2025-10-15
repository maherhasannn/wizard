# Tab 4: Networking/Profile Implementation Plan

## Overview
Implement a comprehensive networking tab with profile creation, multiple discovery methods (swipe cards, map view, filters), search functionality, and user profiles.

## Main Features

### 1. Onboarding/Questionnaire Flow
**Purpose:** First-time setup for networking features

#### Screens:
- **Welcome Screen**: "Would you like to reach new friends?" with two options
- **Personal Info**: Name, Birthday, Gender inputs
- **Public Profile**: Country, City, Instagram, Interests, visibility toggle
- **Photo Upload**: Add/remove profile photo

### 2. Discovery Methods Screen
**Purpose:** Choose how to find friends

#### Three Options:
- **Swipe Cards** - Tinder-style card interface
- **Show on Map** - Location-based discovery
- **By Filters** - Criteria-based search

### 3. Swipe Cards Interface
**Features:**
- Card stack with user profiles
- Swipe gestures (left = pass, right = connect)
- Profile preview with photo, name, age, location, bio
- Like/pass buttons as fallback
- "It's a match!" animation when mutual

### 4. Map View
**Features:**
- Custom map-like UI with grid background
- Profile pins scattered across map
- Tap pin to see profile preview
- "Search on a map" bar at top
- Zoom/pan gestures (simplified)

### 5. Filter Search
**Features:**
- List of filter criteria
- Age range slider
- Location radius
- Interests checkboxes
- Gender preference
- Apply filters to see results

### 6. Search & Results
**Features:**
- Search bar with history
- Keyboard integration
- "Found People" results list
- Profile picture thumbnails
- Names and usernames
- Empty state: "Unfortunately nothing found"

### 7. Profile Screen
**Features:**
- Large circular profile photo
- Name, age, location display
- Bio text area
- Instagram/social link button
- Back button navigation
- Clean, minimal design

## Implementation Approach

### Data Structure

```dart
class NetworkUser {
  final String id;
  final String name;
  final int age;
  final String city;
  final String country;
  final String bio;
  final String instagram;
  final List<String> interests;
  final String photoUrl; // placeholder
  final double latitude;  // mock coordinates
  final double longitude;
  final String gender;
}
```

### Mock Data
- Create 20-30 sample users
- Diverse names, ages (20-35), locations
- Realistic bios and interests
- Use placeholder profile images or initials

### Simplified Implementations

#### Swipe Cards
- Use `Dismissible` widget for swipe gestures
- Stack of 3-5 visible cards
- Simple left/right swipe detection
- No actual matching logic (just UI animation)

#### Map View
- Custom painted grid/map background
- Positioned profile avatars using mock lat/lng
- Simple pan gesture detector
- No real map integration

#### Filters
- Basic UI with sliders and checkboxes
- Filter mock data on client side
- No backend/API calls

#### Profile Photos
- Use colored circles with initials as placeholders
- Or generate random gradient backgrounds
- User can "upload" but it's just UI state

### Navigation Flow

```
Tab 4 Main Screen
  ├─ First Time: Onboarding Flow (4 screens)
  │   └─ After completion → Discovery Methods
  ├─ Discovery Methods Selection
  │   ├─ Swipe Cards → Card Stack Screen
  │   ├─ Map View → Map Screen with pins
  │   └─ Filters → Filter Screen → Results
  ├─ Search Bar (always accessible)
  │   └─ Search Results → Profile View
  └─ Profile View (from any method)
      └─ Back to previous screen
```

## Files to Create

### Models
- `lib/models/network_user.dart` - User data model

### Data
- `lib/data/network_users_data.dart` - Mock user data (20-30 users)

### Screens
- `lib/tabs/networking_tab.dart` - Main tab container
- `lib/screens/networking_onboarding_screen.dart` - Questionnaire flow
- `lib/screens/discovery_methods_screen.dart` - Choose discovery method
- `lib/screens/swipe_cards_screen.dart` - Card swiping interface
- `lib/screens/map_view_screen.dart` - Map with user pins
- `lib/screens/filter_search_screen.dart` - Filter criteria
- `lib/screens/search_screen.dart` - Search functionality
- `lib/screens/user_profile_screen.dart` - Detailed profile view

### Widgets
- `lib/widgets/profile_card.dart` - Swipeable card widget
- `lib/widgets/map_user_pin.dart` - Map pin widget
- `lib/widgets/filter_option.dart` - Filter UI components
- `lib/widgets/user_search_tile.dart` - Search result item
- `lib/widgets/onboarding_step.dart` - Reusable onboarding screen

### State Management
- Local state with StatefulWidget
- Share user profile data via constructor params
- Store onboarding completion in bool flag

## Styling & Design

### Colors
- Background: `#1B0A33` (dark purple)
- Accent: `#6A1B9A` (purple)
- Text: `#F0E6D8` (light beige)
- Cards: Layered with subtle gradients
- Borders: Subtle glows and shadows

### Typography
- Continue using `GoogleFonts.dmSans`
- Profile names: 24px, bold
- Bio text: 16px, regular
- Metadata: 14px, light

### Animations
- Card swipe with rotation
- Smooth transitions between screens
- Pulse animation on map pins
- Slide-in for profile details
- Fade transitions for modals

### Icons & Images
- Use Material Icons for most elements
- Profile placeholders: Colored circles with initials
- Map pins: Custom painted circles with photos
- Social icons: Instagram, etc.

## Implementation Priority

1. Create user model and mock data
2. Build main networking tab container
3. Implement onboarding flow (4 screens)
4. Create discovery methods selection screen
5. Build swipe cards interface
6. Implement map view with pins
7. Create filter search screen
8. Add search functionality
9. Build user profile screen
10. Connect all navigation flows
11. Polish animations and transitions

## Key Features for Demo

### Must Have
- ✅ Onboarding questionnaire with profile creation
- ✅ Three discovery method options
- ✅ Swipe cards with gesture support
- ✅ Map view with user pins
- ✅ Search with results
- ✅ Detailed profile view
- ✅ Smooth navigation throughout

### Nice to Have (if time permits)
- Match animation
- Filter results updating live
- Search history persistence
- Profile editing
- Like/favorites list

## Files to Modify
- `lib/main_app_screen.dart` - Update Tab 4 from placeholder to NetworkingTab

## Technical Notes

### Mock Data Strategy
- Generate realistic names using common first/last names
- Use major cities for locations (Barcelona, Madrid, Paris, London, etc.)
- Create varied interests (meditation, music, art, travel, etc.)
- Bios should be 1-2 sentences, personality-focused

### Performance
- Limit visible cards to 5 at a time
- Lazy load map pins if needed
- Cache profile images (even if placeholders)
- Smooth 60fps animations

### User Experience
- Clear back navigation on all screens
- Loading states (even if instant)
- Empty states with helpful messages
- Confirmation for important actions
- Visual feedback for all interactions

## Success Criteria
1. User can complete onboarding flow smoothly
2. All three discovery methods are functional and beautiful
3. Swipe cards work with smooth animations
4. Map view displays users and allows interaction
5. Search returns filtered results
6. Profile screen shows complete user information
7. Navigation flows logically throughout
8. UI matches the provided mockups in style and feel
9. No crashes or major visual bugs
10. Demo-ready quality that impresses viewers
