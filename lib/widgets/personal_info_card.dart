import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Personal info card with icon rows
/// Features:
/// - White background with elevation
/// - Rounded corners
/// - Icon + text rows without dividers
/// - Spacing-based separation
class PersonalInfoCard extends StatelessWidget {
  final List<InfoRow> infoRows;
  final VoidCallback? onEditPressed;

  const PersonalInfoCard({
    super.key,
    required this.infoRows,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal info',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (onEditPressed != null)
                GestureDetector(
                  onTap: onEditPressed,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentTeal,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingMd),
          
          // Info rows
          ...List.generate(infoRows.length, (index) {
            final infoRow = infoRows[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < infoRows.length - 1 
                    ? AppTheme.spacingMd 
                    : 0,
              ),
              child: _InfoRowWidget(infoRow: infoRow),
            );
          }),
        ],
      ),
    );
  }
}

class _InfoRowWidget extends StatelessWidget {
  final InfoRow infoRow;

  const _InfoRowWidget({required this.infoRow});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            infoRow.icon,
            size: 20,
            color: AppTheme.iconGray,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                infoRow.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                infoRow.value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoRow {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}
