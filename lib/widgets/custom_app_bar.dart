import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom app bar with circular icon backgrounds
/// Features:
/// - White background
/// - Back arrow and menu icon in circular containers
/// - Subtle ripple feedback
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;
  final bool showBackButton;
  final bool showMenuButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.onMenuPressed,
    this.showBackButton = true,
    this.showMenuButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppTheme.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBackButton)
              _CircularIconButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            else
              const SizedBox(width: AppTheme.appBarIconContainerSize),
            
            if (title != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              const Spacer(),
            
            if (showMenuButton)
              _CircularIconButton(
                icon: Icons.menu,
                onPressed: onMenuPressed,
              )
            else
              const SizedBox(width: AppTheme.appBarIconContainerSize),
          ],
        ),
      ),
    );
  }
}

class _CircularIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircularIconButton({
    required this.icon,
    this.onPressed,
  });

  @override
  State<_CircularIconButton> createState() => _CircularIconButtonState();
}

class _CircularIconButtonState extends State<_CircularIconButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.microDuration,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: AppTheme.appBarIconContainerSize,
          height: AppTheme.appBarIconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: AppTheme.appBarIconSize,
            color: AppTheme.primaryDark,
          ),
        ),
      ),
    );
  }
}
