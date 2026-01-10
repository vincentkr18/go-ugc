import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Profile avatar with edit button
/// Features:
/// - Circular avatar with white border ring
/// - Edit icon overlapping bottom-right
/// - Smooth scale animation
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final IconData? placeholderIcon;
  final VoidCallback? onEditPressed;
  final bool showEditButton;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.person,
    this.onEditPressed,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Avatar
        Container(
          width: AppTheme.profileAvatarSize,
          height: AppTheme.profileAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.backgroundWhite,
              width: AppTheme.profileAvatarBorderWidth,
            ),
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: ClipOval(
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _PlaceholderAvatar(icon: placeholderIcon!);
                    },
                  )
                : _PlaceholderAvatar(icon: placeholderIcon!),
          ),
        ),
        
        // Edit button
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Container(
                width: AppTheme.profileEditIconSize,
                height: AppTheme.profileEditIconSize,
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.backgroundWhite,
                    width: 2,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: AppTheme.backgroundWhite,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  final IconData icon;

  const _PlaceholderAvatar({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.accentMintLight,
      child: Icon(
        icon,
        size: 50,
        color: AppTheme.accentTeal,
      ),
    );
  }
}
