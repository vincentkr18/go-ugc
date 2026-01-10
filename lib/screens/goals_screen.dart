import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/analytics_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Steps', 'Weight Loss', 'Calories'];
  
  String _selectedPeriod = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: const CustomAppBar(
        showBackButton: false,
        showMenuButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingMd),
            
            // Page Title with Plus Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monitor Your Goals',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: AppTheme.primaryDark,
                        size: 24,
                      ),
                      onPressed: () {
                        // Add new goal
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Filter Chips
            FilterChipList(
              categories: _filters,
              selectedCategory: _selectedFilter,
              onCategorySelected: (category) {
                setState(() {
                  _selectedFilter = category;
                });
              },
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Analytics Card - Steps
            AnalyticsCard(
              title: 'Steps',
              value: '12,845',
              subtitle: 'Total Steps',
              icon: Icons.directions_walk,
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              chartData: const [
                ChartDataPoint(label: 'Mon', value: 8500),
                ChartDataPoint(label: 'Tue', value: 10200),
                ChartDataPoint(label: 'Wed', value: 9800),
                ChartDataPoint(label: 'Thu', value: 11500),
                ChartDataPoint(label: 'Fri', value: 12845),
                ChartDataPoint(label: 'Sat', value: 7200),
                ChartDataPoint(label: 'Sun', value: 6500),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Analytics Card - Calories
            if (_selectedFilter == 'All' || _selectedFilter == 'Calories')
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
                child: AnalyticsCard(
                  title: 'Calories',
                  value: '2,340',
                  subtitle: 'Burned Today',
                  icon: Icons.local_fire_department,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  chartData: const [
                    ChartDataPoint(label: 'Mon', value: 2100),
                    ChartDataPoint(label: 'Tue', value: 2450),
                    ChartDataPoint(label: 'Wed', value: 2200),
                    ChartDataPoint(label: 'Thu', value: 2600),
                    ChartDataPoint(label: 'Fri', value: 2340),
                    ChartDataPoint(label: 'Sat', value: 1900),
                    ChartDataPoint(label: 'Sun', value: 1800),
                  ],
                ),
              ),
            
            // Analytics Card - Weight
            if (_selectedFilter == 'All' || _selectedFilter == 'Weight Loss')
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
                child: AnalyticsCard(
                  title: 'Weight',
                  value: '72.5 kg',
                  subtitle: 'Current Weight',
                  icon: Icons.monitor_weight_outlined,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  chartData: const [
                    ChartDataPoint(label: 'Week 1', value: 75.0),
                    ChartDataPoint(label: 'Week 2', value: 74.5),
                    ChartDataPoint(label: 'Week 3', value: 73.8),
                    ChartDataPoint(label: 'Week 4', value: 73.2),
                    ChartDataPoint(label: 'Week 5', value: 72.5),
                  ],
                ),
              ),
            
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}
