import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Feature card for meditation, workouts, or activities
/// Features:
/// - Rounded corners with colored background
/// - Duration badge
/// - Category label
/// - Play button
class FeatureCard extends StatelessWidget {
  final String title;
  final String duration;
  final String? category;
  final Color backgroundColor;
  final bool isDark;
  final VoidCallback? onTap;
  final IconData? icon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.duration,
    this.category,
    required this.backgroundColor,
    this.isDark = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.backgroundWhite : AppTheme.textPrimary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? Colors.white.withOpacity(0.2)
                              : AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (category != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          category!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark 
                                ? AppTheme.backgroundWhite.withOpacity(0.7)
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.accentTeal,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.play_arrow,
                color: AppTheme.backgroundWhite,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact feature card for grid layouts
class CompactFeatureCard extends StatelessWidget {
  final String title;
  final String duration;
  final Color backgroundColor;
  final bool isDark;
  final VoidCallback? onTap;

  const CompactFeatureCard({
    super.key,
    required this.title,
    required this.duration,
    required this.backgroundColor,
    this.isDark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.backgroundWhite : AppTheme.textPrimary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? Colors.white.withOpacity(0.2)
                        : AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppTheme.backgroundWhite,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
