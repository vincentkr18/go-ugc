# Design System Quick Reference

## 🎨 Color Palette

### Primary Colors
```
Dark Charcoal:     #1A1A1A  ███████  (Buttons, Nav Bar)
Near Black:        #111111  ███████  (Text Primary)
```

### Accent Colors
```
Mint Green:        #8FD5C8  ███████  (Charts, Highlights)
Teal:              #6EC5B8  ███████  (Active States)
Mint Light:        #B8E6DD  ███████  (Backgrounds)
Mint Pastel:       #D4F1E9  ███████  (Analytics Cards)
```

### Background Colors
```
White:             #FFFFFF  ███████  (Cards, Surfaces)
Off-White:         #F8F9FA  ███████  (Screen Background)
Light Gray:        #F5F5F5  ███████  (Inactive Elements)
```

### Text Colors
```
Primary:           #111111  ███████  (Headings, Body)
Secondary:         #666666  ███████  (Subtitles)
Muted:             #999999  ███████  (Labels, Hints)
```

---

## 📏 Spacing Scale

```
XS:    4dp   ▌
SM:    8dp   ▌▌
MD:   16dp   ▌▌▌▌
LG:   24dp   ▌▌▌▌▌▌
XL:   32dp   ▌▌▌▌▌▌▌▌
```

---

## 🔠 Typography Scale

### Display (Poppins - Bold)
```
Large:   32px / Bold    → Page Titles
Medium:  28px / Bold    → Section Headers
Small:   24px / Semibold → Subsections
```

### Headlines (Inter - Semibold)
```
Large:   20px / Semibold → Card Headers
Medium:  18px / Semibold → Subheaders
```

### Body (Inter - Regular)
```
Large:   16px / Regular  → Primary Text
Medium:  14px / Regular  → Secondary Text
Small:   12px / Regular  → Captions
```

---

## 📐 Component Dimensions

### Bottom Navigation
```
Height:            60dp
Pill Radius:       30dp (fully rounded)
Icon Size:         24dp
Active Indicator:  48dp circle
```

### App Bar
```
Height:            56dp
Icon Container:    40dp circle
Icon Size:         20dp
```

### Cards
```
Border Radius:     18-20dp
Padding:           16dp
Elevation:         2dp soft shadow
```

### Filter Chips
```
Height:            36dp
Border Radius:     18dp (pill)
Padding:           18dp horizontal
```

### Touch Targets
```
Minimum:           44×44dp
Recommended:       48×48dp
```

---

## 🎭 Component States

### Filter Chips
```
Active:
  Background: #1A1A1A (Dark)
  Text:       #FFFFFF (White)

Inactive:
  Background: #E8E8E8 (Light Gray)
  Text:       #333333 (Dark Gray)
```

### Bottom Nav Icons
```
Active:
  Container:  #FFFFFF circle
  Icon:       #1A1A1A

Inactive:
  Container:  Transparent
  Icon:       #FFFFFF
```

### Buttons
```
Primary:
  Background: #1A1A1A
  Text:       #FFFFFF
  Radius:     12dp
  Height:     50dp

FAB (Add Button):
  Background: #FFFFFF
  Icon:       #1A1A1A
  Radius:     22dp (circle)
  Size:       44dp
```

---

## 🎬 Animation Timings

```
Micro (Button Press):     150ms
Default (Transitions):    300ms
Chart Animation:          800ms

Curve: easeInOut for all
```

---

## 🧩 Component Usage

### Analytics Card
```dart
AnalyticsCard(
  title: 'Steps',
  value: '12,845',
  subtitle: 'Total Steps',
  icon: Icons.directions_walk,
  chartData: [...],
  selectedPeriod: 'Weekly',
)
```

### Filter Chips
```dart
FilterChipList(
  categories: ['All', 'Steps', 'Calories'],
  selectedCategory: 'All',
  onCategorySelected: (cat) => setState(...),
)
```

### Profile Avatar
```dart
ProfileAvatar(
  placeholderIcon: Icons.person,
  showEditButton: true,
  onEditPressed: () => editProfile(),
)
```

### Personal Info Card
```dart
PersonalInfoCard(
  infoRows: [
    InfoRow(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'user@example.com',
    ),
  ],
  onEditPressed: () => edit(),
)
```

---

## 🎯 Design Principles

1. **Spacing**: Use consistent spacing (MD for most cases)
2. **Contrast**: Maintain 4.5:1 minimum for text
3. **Touch Targets**: Never below 44×44dp
4. **Animation**: Smooth, purposeful, <300ms
5. **Hierarchy**: Size, weight, color for importance
6. **Simplicity**: Remove unnecessary elements
7. **Consistency**: Reuse components and patterns

---

## ✅ Accessibility Checklist

- [ ] All interactive elements ≥ 44×44dp
- [ ] Text contrast ratio ≥ 4.5:1
- [ ] Clear visual focus indicators
- [ ] Meaningful icon labels
- [ ] Sufficient spacing between elements
- [ ] Large, readable fonts (≥ 14px body)
- [ ] Color not sole differentiator

---

## 🚀 Quick Start

```dart
// 1. Import theme
import 'package:your_app/theme/app_theme.dart';

// 2. Apply to MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme(context),
  home: MainNavigationScaffold(),
)

// 3. Use design tokens
Container(
  padding: EdgeInsets.all(AppTheme.spacingMd),
  decoration: BoxDecoration(
    color: AppTheme.backgroundWhite,
    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
  ),
)
```
