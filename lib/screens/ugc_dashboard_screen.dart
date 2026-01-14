import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/template_service.dart';
import '../models/video_template.dart';
import 'profile_screen.dart';
import 'model_selection_screen.dart';
import 'video_detail_screen.dart';

// Mock video model
class VideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? videoUrl; // Cloudinary video URL
  final VideoStatus status;
  final int? progress; // 0-100 for in-progress videos
  final DateTime createdAt;

  VideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.videoUrl,
    required this.status,
    this.progress,
    required this.createdAt,
  });
}

enum VideoStatus { generating, complete, error }

class UgcDashboardScreen extends StatefulWidget {
  const UgcDashboardScreen({super.key});

  @override
  State<UgcDashboardScreen> createState() => _UgcDashboardScreenState();
}

class _UgcDashboardScreenState extends State<UgcDashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TemplateService _templateService = TemplateService();
  List<VideoTemplate> _randomTemplates = [];
  bool _isLoadingTemplates = false;
  
  // Mock video data - will be populated with random templates
  List<VideoItem> _videos = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppTheme.slowDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
    _loadRandomTemplates();
  }

  Future<void> _loadRandomTemplates() async {
    setState(() => _isLoadingTemplates = true);
    
    try {
      final templates = await _templateService.fetchTemplatePage(limit: 50);
      
      // Shuffle and take 3 random templates
      templates.shuffle();
      final randomTemplates = templates.take(3).toList();
      
      // Convert templates to VideoItems
      final videos = randomTemplates.asMap().entries.map((entry) {
        final index = entry.key;
        final template = entry.value;
        return VideoItem(
          id: template.id.toString(),
          title: template.title,
          thumbnailUrl: template.thumbnailUrl,
          videoUrl: template.previewUrl,
          status: VideoStatus.complete,
          createdAt: DateTime.now().subtract(Duration(days: index + 1)),
        );
      }).toList();
      
      setState(() {
        _randomTemplates = randomTemplates;
        _videos = videos;
        _isLoadingTemplates = false;
      });
    } catch (e) {
      setState(() => _isLoadingTemplates = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load templates: $e',
              style: GoogleFonts.figtree(),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.statusError,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String get _userName {
    final user = AuthService().currentUser;
    return user?.userMetadata?['full_name'] ?? user?.email?.split('@').first ?? 'Creator';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      body: _selectedIndex == 0 ? _buildDashboard() : const ProfileScreen(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSidebar,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppTheme.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: AppTheme.microDuration,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accentPrimary : AppTheme.textSecondary,
              size: AppTheme.bottomNavIconSize,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.accentPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.sidePadding),
                child: RichText(
                  text: TextSpan(
                    text: 'Welcome back, ',
                    style: GoogleFonts.ebGaramond(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      TextSpan(
                        text: _userName,
                        style: GoogleFonts.ebGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Create Video Button with Illustration
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sidePadding),
                child: Column(
                  children: [
                    // Illustration
                    Image.asset(
                      'assets/images/illustration.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    // Create Button
                    _buildCreateVideoButton(),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingXl)),
            
            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sidePadding),
                child: Text(
                  'Your Videos',
                  style: GoogleFonts.figtree(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingMd)),
            
            // Videos Grid/List
            _videos.isEmpty ? _buildEmptyState() : _buildVideosList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateVideoButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      onTapUp: (_) => setState(() {}),
      onTapCancel: () => setState(() {}),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ModelSelectionScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 0.3);
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            transitionDuration: AppTheme.defaultDuration,
          ),
        );
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: AppTheme.microDuration,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.accentPrimary, AppTheme.accentHover],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 28),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Create New UGC Video',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideosList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sidePadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: _buildVideoCard(_videos[index]),
            );
          },
          childCount: _videos.length,
        ),
      ),
    );
  }

  Widget _buildVideoCard(VideoItem video) {
    return GestureDetector(
      onTap: () {
        if (video.status == VideoStatus.complete) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  VideoDetailScreen(video: video),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                    child: child,
                  ),
                );
              },
              transitionDuration: AppTheme.defaultDuration,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.cardNeutral,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.cardRadius),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.cardYellow,
                        child: const Icon(Icons.video_library_outlined, size: 48),
                      ),
                    ),
                  ),
                  
                  // Status overlay
                  if (video.status == VideoStatus.generating)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                value: video.progress! / 100,
                                strokeWidth: 4,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            Text(
                              '${video.progress}%',
                              style: GoogleFonts.figtree(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // Play icon for complete videos
                  if (video.status == VideoStatus.complete)
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.spacingMd),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Video info
            Padding(
              padding: const EdgeInsets.all(AppTheme.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Row(
                    children: [
                      _buildStatusBadge(video.status),
                      const SizedBox(width: AppTheme.spacingSm),
                      Text(
                        _formatDate(video.createdAt),
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(VideoStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case VideoStatus.generating:
        color = AppTheme.statusProcessing;
        label = 'Processing';
        icon = Icons.sync_rounded;
        break;
      case VideoStatus.complete:
        color = AppTheme.statusComplete;
        label = 'Ready';
        icon = Icons.check_circle_rounded;
        break;
      case VideoStatus.error:
        color = AppTheme.statusError;
        label = 'Failed';
        icon = Icons.error_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spacingXl),
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: AppTheme.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No videos yet',
              style: GoogleFonts.ebGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Tap the button above to create\nyour first UGC video',
              textAlign: TextAlign.center,
              style: GoogleFonts.figtree(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
