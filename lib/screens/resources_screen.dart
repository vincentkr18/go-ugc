import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/resource_card.dart';

/// Resources & Files Screen
/// Displays workout plans, meal plans, documents, and file management
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: const CustomAppBar(
        showBackButton: false,
        showMenuButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingMd),
          
          // Page Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Files & Resources',
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
                      Icons.cloud_upload_outlined,
                      color: AppTheme.primaryDark,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          // Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.cardShadow,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: AppTheme.backgroundWhite,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'In Progress'),
                  Tab(text: 'Completed'),
                  Tab(text: 'All Files'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInProgressTab(),
                _buildCompletedTab(),
                _buildAllFilesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResourceCard(
            title: 'PartWay',
            subtitle: '6 Mins Remaining',
            icon: Icons.flag_outlined,
            iconColor: const Color(0xFF9B8FFF),
            progress: 0.63,
            onTap: () {},
          ),
          ResourceCard(
            title: 'MotionMA4',
            subtitle: '5 Mins Remaining',
            icon: Icons.play_circle_outline,
            iconColor: const Color(0xFF8FD5C8),
            progress: 0.40,
            onTap: () {},
          ),
          ResourceCard(
            title: 'Tutorial Mp4',
            subtitle: '2 Mins Remaining',
            icon: Icons.school_outlined,
            iconColor: const Color(0xFFFFB84D),
            progress: 0.92,
            onTap: () {},
          ),
          ResourceCard(
            title: 'Appling',
            subtitle: '1 Min Remaining',
            icon: Icons.apple,
            iconColor: const Color(0xFFFF9B9B),
            progress: 0.85,
            onTap: () {},
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          // Recent Uploaded Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Uploaded',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingMd),
          
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                RecentItemCard(
                  title: 'Style Guide Fig',
                  date: '9 Sep 2025',
                  icon: Icons.palette_outlined,
                  iconBackground: const Color(0xFFFFF5E6),
                  showFavorite: true,
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                RecentItemCard(
                  title: 'ED Graphic',
                  date: '9 Sep 2025',
                  icon: Icons.image_outlined,
                  iconBackground: const Color(0xFFE8F4FF),
                  showFavorite: true,
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                RecentItemCard(
                  title: 'Workout Plan',
                  date: '8 Sep 2025',
                  icon: Icons.fitness_center,
                  iconBackground: AppTheme.accentMintPastel,
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                RecentItemCard(
                  title: 'Meal Plan',
                  date: '7 Sep 2025',
                  icon: Icons.restaurant_menu,
                  iconBackground: const Color(0xFFFFE8E8),
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }
  
  Widget _buildCompletedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Column(
        children: [
          ResourceCard(
            title: 'Week 1 Workout',
            subtitle: 'Completed on Aug 30',
            icon: Icons.check_circle_outline,
            iconColor: AppTheme.accentTeal,
            statusText: 'Done',
            onTap: () {},
          ),
          ResourceCard(
            title: 'Nutrition Guide',
            subtitle: 'Completed on Aug 28',
            icon: Icons.check_circle_outline,
            iconColor: AppTheme.accentTeal,
            statusText: 'Done',
            onTap: () {},
          ),
          ResourceCard(
            title: 'Cardio Session',
            subtitle: 'Completed on Aug 25',
            icon: Icons.check_circle_outline,
            iconColor: AppTheme.accentTeal,
            statusText: 'Done',
            onTap: () {},
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
  
  Widget _buildAllFilesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout Plans
          Text(
            'Workout Plans',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          ResourceCard(
            title: 'Full Body Strength',
            subtitle: '12 exercises • 45 mins',
            icon: Icons.fitness_center,
            iconColor: const Color(0xFF9B8FFF),
            onTap: () {},
          ),
          ResourceCard(
            title: 'HIIT Cardio Blast',
            subtitle: '8 exercises • 30 mins',
            icon: Icons.speed,
            iconColor: const Color(0xFFFF9B9B),
            onTap: () {},
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          // Meal Plans
          Text(
            'Nutrition & Meal Plans',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          ResourceCard(
            title: 'Weekly Meal Prep',
            subtitle: '7 days • 2,000 cal/day',
            icon: Icons.restaurant_menu,
            iconColor: const Color(0xFFFFB84D),
            onTap: () {},
          ),
          ResourceCard(
            title: 'Protein Recipes',
            subtitle: '20 recipes',
            icon: Icons.local_dining,
            iconColor: AppTheme.accentTeal,
            onTap: () {},
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
