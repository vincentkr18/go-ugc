import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Floating pill-shaped bottom navigation bar
/// Features:
/// - Dark charcoal background
/// - Outline icons with circular active indicators
/// - Smooth animations on selection
/// - Icon-only navigation
class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: AppTheme.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(AppTheme.bottomNavPillRadius),
        boxShadow: AppTheme.bottomNavShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          
          return Expanded(
            child: _NavBarItem(
              icon: item.icon,
              isSelected: isSelected,
              onTap: () => onTap(index),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.defaultDuration,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.defaultCurve),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.defaultCurve),
    );
    
    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: AppTheme.minTouchTarget,
          minHeight: AppTheme.minTouchTarget,
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: AppTheme.defaultDuration,
              curve: AppTheme.defaultCurve,
              width: AppTheme.bottomNavActiveIndicatorSize,
              height: AppTheme.bottomNavActiveIndicatorSize,
              decoration: BoxDecoration(
                color: widget.isSelected 
                    ? AppTheme.backgroundWhite 
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: AppTheme.bottomNavIconSize,
                color: widget.isSelected 
                    ? AppTheme.primaryDark 
                    : AppTheme.backgroundWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.label,
  });
}
