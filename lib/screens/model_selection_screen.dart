import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'ugc_creation_screen.dart';

class ModelType {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String? assetImage;

  ModelType({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.assetImage,
  });
}

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  // No selection state needed

  final List<ModelType> _models = [
    ModelType(
      id: 'lip_sync',
      name: 'Lip Sync',
      description: 'Sync audio to character',
      icon: Icons.record_voice_over_rounded,
      color: const Color(0xFFFF6B6B),
      assetImage: 'assets/images/eve-jyg_kpdbp6M-unsplash.jpg',
    ),
    ModelType(
      id: 'sora2',
      name: 'Sora 2',
      description: 'Text-to-video generation',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF4DABF7),
      assetImage: 'assets/images/codioful-formerly-gradienta-T0oLW4bwkRU-unsplash.jpg',
    ),
    ModelType(
      id: 'kling',
      name: 'Kling',
      description: 'Product video creation',
      icon: Icons.animation_rounded,
      color: const Color(0xFF51CF66),
      assetImage: 'assets/images/dirk-lach-W1RV39u5K5M-unsplash.jpg',
    ),
    ModelType(
      id: 'veo3',
      name: 'Veo 3',
      description: 'Advanced video synthesis',
      icon: Icons.video_camera_back_rounded,
      color: const Color(0xFFFFA726),
      assetImage: 'assets/images/mimo-FeNrGgQ1Tu8-unsplash.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Model',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.sidePadding),
                children: [
                  Text(
                    'Choose Your Model',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Select the AI model that best fits your creative needs',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  ..._models.asMap().entries.map((entry) {
                    final index = entry.key;
                    final model = entry.value;
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
                      child: _buildModelCard(model),
                    );
                  }),
                ],
              ),
            ),
            
            // No continue button, direct navigation
          ],
        ),
      ),
    );
  }

  Widget _buildModelCard(ModelType model) {
    return GestureDetector(
      onTap: () => _navigateToCreation(model.id),
      child: AnimatedContainer(
        duration: AppTheme.microDuration,
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // No border on selection
          boxShadow: AppTheme.cardShadow,
          image: model.assetImage != null
              ? DecorationImage(
                  image: AssetImage(model.assetImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.85),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      model.description,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // No checkmark
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCreation(String modelId) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UgcCreationScreen(modelId: modelId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: AppTheme.defaultDuration,
      ),
    );
  }
}
