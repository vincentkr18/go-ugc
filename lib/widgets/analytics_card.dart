import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Analytics card with bar chart visualization
/// Features:
/// - Soft mint/pastel green background
/// - Large rounded corners
/// - Header with icon badge and dropdown
/// - Animated bar chart with tooltip
class AnalyticsCard extends StatefulWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<ChartDataPoint> chartData;
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String)? onPeriodChanged;

  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.chartData,
    this.selectedPeriod = 'Weekly',
    this.periodOptions = const ['Daily', 'Weekly', 'Monthly'],
    this.onPeriodChanged,
  });

  @override
  State<AnalyticsCard> createState() => _AnalyticsCardState();
}

class _AnalyticsCardState extends State<AnalyticsCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? _selectedBarIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.chartAnimationDuration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.accentMintPastel,
        borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accentMint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: AppTheme.backgroundWhite,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Period dropdown
              GestureDetector(
                onTap: () => _showPeriodSelector(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accentMint, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.selectedPeriod,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Chart
          SizedBox(
            height: 150,
            child: _BarChart(
              data: widget.chartData,
              animation: _controller,
              selectedIndex: _selectedBarIndex,
              onBarTap: (index) {
                setState(() {
                  _selectedBarIndex = _selectedBarIndex == index ? null : index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPeriodSelector(BuildContext context) {
    if (widget.onPeriodChanged == null) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ...widget.periodOptions.map((period) => ListTile(
                title: Text(
                  period,
                  style: TextStyle(
                    fontWeight: period == widget.selectedPeriod 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                    color: period == widget.selectedPeriod 
                        ? AppTheme.accentTeal 
                        : AppTheme.textPrimary,
                  ),
                ),
                trailing: period == widget.selectedPeriod
                    ? const Icon(Icons.check, color: AppTheme.accentTeal)
                    : null,
                onTap: () {
                  widget.onPeriodChanged!(period);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final Animation<double> animation;
  final int? selectedIndex;
  final Function(int) onBarTap;

  const _BarChart({
    required this.data,
    required this.animation,
    required this.selectedIndex,
    required this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(data.length, (index) {
            final dataPoint = data[index];
            final isSelected = index == selectedIndex;
            final heightPercent = (dataPoint.value / maxValue) * animation.value;
            
            return Expanded(
              child: GestureDetector(
                onTap: () => onBarTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Tooltip
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentTeal,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            dataPoint.value.toInt().toString(),
                            style: const TextStyle(
                              color: AppTheme.backgroundWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      
                      // Bar
                      Container(
                        width: double.infinity,
                        height: 100 * heightPercent,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppTheme.accentTeal 
                              : AppTheme.accentMint.withOpacity(0.5),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Label
                      Text(
                        dataPoint.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected 
                              ? AppTheme.textPrimary 
                              : AppTheme.textMuted,
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class ChartDataPoint {
  final String label;
  final double value;

  const ChartDataPoint({
    required this.label,
    required this.value,
  });
}
