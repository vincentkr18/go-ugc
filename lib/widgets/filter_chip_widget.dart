import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Filter chip for category selection
/// Features:
/// - Pill-shaped design
/// - Active/inactive states with smooth transitions
/// - Dark background when active, light when inactive
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.defaultDuration,
        curve: AppTheme.defaultCurve,
        height: AppTheme.chipHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.chipPaddingHorizontal,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryDark 
              : AppTheme.chipInactiveBg,
          borderRadius: BorderRadius.circular(AppTheme.chipRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected 
                  ? AppTheme.backgroundWhite 
                  : AppTheme.chipInactiveText,
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrollable list of filter chips
class FilterChipList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FilterChipList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTheme.chipHeight + 16,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return FilterChipWidget(
            label: category,
            isSelected: category == selectedCategory,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}
