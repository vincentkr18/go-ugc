import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_bottom_nav_bar.dart';
import 'goals_screen.dart';
import 'wellness_screen.dart';
import 'resources_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

/// Main navigation scaffold with floating bottom navigation bar
/// Manages navigation between core app sections
class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    GoalsScreen(),
    WellnessScreen(),
    ResourcesScreen(),
    DashboardScreen(),
    ProfileScreen(),
  ];
  
  final List<BottomNavItem> _navItems = const [
    BottomNavItem(
      icon: Icons.track_changes,
      label: 'Goals',
    ),
    BottomNavItem(
      icon: Icons.self_improvement,
      label: 'Wellness',
    ),
    BottomNavItem(
      icon: Icons.folder_outlined,
      label: 'Resources',
    ),
    BottomNavItem(
      icon: Icons.explore_outlined,
      label: 'Explore',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      body: Stack(
        children: [
          // Screen content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          
          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBottomNavBar(
              currentIndex: _currentIndex,
              items: _navItems,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
