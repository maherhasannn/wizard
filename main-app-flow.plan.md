# Main App Flow Implementation

## Overview
Replace the current Plan Ready screen navigation with a new 4-tab main app screen that users access after completing the power selection flow.

## Updated Flow
After "Continue" button on Plan Ready screen → Navigate to Main App Screen with 4 tabs

## Main App Screen Structure

### Tab 1: Home/Dashboard (Primary Content)
Based on the images provided, this tab includes:

#### Welcome Section
- "Welcome back Gabriella!" greeting with wave emoji
- User profile picture in top-right

#### Message of the Day Flow
- "Unlock your message of the day" card with date
- "Swipe to unlock" interactive button
- Loading screens showing progress (34%, 99%)
- Card flip animation (tarot card back → front)
- "Message of the day" screen with:
  - Tarot card display ("The Sun" card)
  - Short message: "You will meet your destiny very soon and unexpectedly"
  - Full message screen with detailed text
  - "Whispers of the Thunder" button

#### Video Section
- "Video" header with "See all >" link
- Video thumbnails with titles and timestamps
- Video playback screen with controls

#### Opportunities Section
- "Get a new opportunities" subscription banner
- Pricing information ($9.99/month)

#### Affirmation of the Day
- Interactive affirmation card with video content
- "Take a new one" / "See again" buttons
- Feeling feedback section with emoji ratings

#### Live Streams
- "Answering your questions directly in the app" stream
- Live viewer count and chat
- "Join healing room" / "Join livestream" buttons

### Tab 2-4: Placeholder
- Will be implemented based on additional images provided

## Implementation Files

### New Files to Create
- `lib/main_app_screen.dart` - Main 4-tab screen container
- `lib/tabs/home_tab.dart` - Tab 1: Home/Dashboard content
- `lib/widgets/message_of_day_flow.dart` - Message unlocking flow
- `lib/widgets/video_section.dart` - Video content section
- `lib/widgets/live_stream_widget.dart` - Live stream components
- `lib/widgets/affirmation_card.dart` - Affirmation of the day widget

### Files to Modify
- `lib/plan_ready_screen.dart` - Update Continue button to navigate to main app screen

## Technical Details

### Tab Navigation
- Use `BottomNavigationBar` with 4 tabs
- `PageView` or `IndexedStack` for tab content switching
- Tab 1: Home icon (highlighted by default)
- Tab 2: Star icon
- Tab 3: Calendar icon  
- Tab 4: Profile icon

### Message of Day Flow
- Triggered by "Swipe to unlock" interaction
- Loading animation with percentage display
- Card flip animation using `AnimatedBuilder` and rotation transforms
- Tarot card assets (placeholder or custom painted)

### State Management
- Use `StatefulWidget` for main app screen
- Local state for current tab selection
- Pass user selections from power flow to personalize content

### Styling
- Consistent purple theme: `#1B0A33` background, `#6A1B9A` accents
- Light text: `#F0E6D8`
- Starry background using existing `SharedBackground`
- Card-based layouts with rounded corners

### User Personalization
- Use "Gabriella" as hardcoded name for now
- Incorporate selected power focus areas into personalized content
- Dynamic date display for "message of the day"

## Implementation Priority
1. Create main app screen with 4-tab structure
2. Implement Tab 1 (Home/Dashboard) with all sections
3. Add message of the day flow with animations
4. Wire navigation from Plan Ready screen
5. Prepare for Tab 2-4 implementation (waiting for additional images)
