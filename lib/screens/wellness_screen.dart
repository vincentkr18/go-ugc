import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/feature_card.dart';

/// Wellness & Meditation Screen
/// Features meditation sessions, breathing exercises, and relaxation content
class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingMd),
            
            // Greeting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello, Paul 👋',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.backgroundWhite,
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: AppTheme.textMuted,
                      size: 22,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Featured Sessions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: CompactFeatureCard(
                      title: 'Emotional\nBalance',
                      duration: '15 min',
                      backgroundColor: AppTheme.primaryDark,
                      isDark: true,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CompactFeatureCard(
                      title: 'Calm\nRelaxation',
                      duration: '12 min',
                      backgroundColor: AppTheme.backgroundWhite,
                      isDark: false,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Special for you',
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
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            // Special Sessions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Column(
                children: [
                  FeatureCard(
                    title: 'Morning Gratitude',
                    duration: '5 min',
                    category: 'Morning',
                    backgroundColor: AppTheme.accentMintPastel,
                    isDark: false,
                    icon: Icons.play_arrow,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  FeatureCard(
                    title: 'Serenity Before Sleep',
                    duration: '10 min',
                    category: 'Evening',
                    backgroundColor: AppTheme.backgroundWhite,
                    isDark: false,
                    icon: Icons.play_arrow,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  FeatureCard(
                    title: 'Mindful Breathing',
                    duration: '8 min',
                    category: 'Anytime',
                    backgroundColor: const Color(0xFFFFF5E6),
                    isDark: false,
                    icon: Icons.air,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  FeatureCard(
                    title: 'Body Scan Relaxation',
                    duration: '15 min',
                    category: 'Evening',
                    backgroundColor: const Color(0xFFE8F4FF),
                    isDark: false,
                    icon: Icons.self_improvement,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Text(
                'Browse by category',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            // Category Pills
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                children: [
                  _buildCategoryPill('Sleep', Icons.bedtime_outlined, const Color(0xFF9B8FFF)),
                  const SizedBox(width: 12),
                  _buildCategoryPill('Stress', Icons.spa_outlined, const Color(0xFFFF9B9B)),
                  const SizedBox(width: 12),
                  _buildCategoryPill('Focus', Icons.center_focus_strong, const Color(0xFF8FD5C8)),
                  const SizedBox(width: 12),
                  _buildCategoryPill('Anxiety', Icons.healing_outlined, const Color(0xFFFFD58F)),
                ],
              ),
            ),
            
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryPill(String label, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
