import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/user_auth_details_card.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _userName {
    final user = AuthService().currentUser;
    return user?.userMetadata?['full_name'] ?? user?.email?.split('@').first ?? 'Creator';
  }

  String get _userEmail {
    final user = AuthService().currentUser;
    return user?.email ?? 'No email';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.backgroundMainDark : AppTheme.backgroundMain,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.sidePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppTheme.spacingLg),
                  
                  // Header
                  Text(
                    'Profile',
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXl),
                  
                  // Profile Avatar & Info
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: AppTheme.avatarSizeLarge,
                          height: AppTheme.avatarSizeLarge,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.black87],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          _userName,
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXl),
                  
                  // User Auth Details Card (KEEP API CALL)
                  const UserAuthDetailsCard(),
                  
                  const SizedBox(height: AppTheme.spacingLg),
                  
                  // Plan & Upgrade
                  _buildUpgradeCard(context),
                  
                  const SizedBox(height: AppTheme.spacingLg),
                  
                  // Dark Theme Toggle
                  _buildThemeToggle(context),
                  
                  const SizedBox(height: AppTheme.spacingLg),
                  
                  // Account Actions
                  _buildActionButton(
                    context,
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    onTap: () async {
                      await AuthService().signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  
                  const SizedBox(height: AppTheme.spacingSm),
                  
                  _buildActionButton(
                    context,
                    icon: Icons.delete_outline_rounded,
                    label: 'Close Account',
                    isDestructive: true,
                    onTap: () => _showCloseAccountDialog(context),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildThemeToggle(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final currentThemeColors = isDarkMode 
        ? (AppTheme.textPrimaryDark, AppTheme.cardNeutralDark, AppTheme.borderLightDark)
        : (AppTheme.textPrimary, AppTheme.cardNeutral, AppTheme.borderLight);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: currentThemeColors.$2,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: currentThemeColors.$3),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Icon(
            isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: currentThemeColors.$1,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: currentThemeColors.$1,
                  ),
                ),
                Text(
                  isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }
  
  Widget _buildUpgradeCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUpgradeDialog(context),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free Plan',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Upgrade to Pro for unlimited videos',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? AppTheme.cardNeutralDark : AppTheme.cardNeutral;
    final borderColor = isDarkMode ? AppTheme.borderLightDark : AppTheme.borderLight;
    final textColor = isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimary;
    final secondaryColor = isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondary;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: isDestructive ? AppTheme.statusError.withOpacity(0.3) : borderColor,
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppTheme.statusError : textColor,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? AppTheme.statusError : textColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        title: Text(
          'Upgrade to Pro',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get unlimited video generation and premium features',
              style: GoogleFonts.manrope(fontSize: 14),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            _buildFeatureItem('Unlimited videos'),
            _buildFeatureItem('Priority processing'),
            _buildFeatureItem('Advanced models'),
            _buildFeatureItem('No watermarks'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later', style: GoogleFonts.manrope()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Upgrade feature coming soon!', style: GoogleFonts.manrope()),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Upgrade Now', style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppTheme.statusComplete, size: 20),
          const SizedBox(width: AppTheme.spacingSm),
          Text(text, style: GoogleFonts.manrope(fontSize: 14)),
        ],
      ),
    );
  }

  void _showCloseAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        title: Text(
          'Close Account?',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.statusError,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your videos and data will be permanently deleted.',
          style: GoogleFonts.manrope(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.manrope()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account closure is not available yet', style: GoogleFonts.manrope()),
                  backgroundColor: AppTheme.statusError,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.statusError),
            child: Text('Close Account', style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
