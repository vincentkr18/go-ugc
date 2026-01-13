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

  ModelType({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  String? _selectedModelId;

  final List<ModelType> _models = [
    ModelType(
      id: 'lip_sync',
      name: 'Lip Sync',
      description: 'Sync character lips to audio track',
      icon: Icons.record_voice_over_rounded,
      color: const Color(0xFFFF6B6B),
    ),
    ModelType(
      id: 'sora2',
      name: 'Sora 2',
      description: 'AI-powered video generation from text',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF4DABF7),
    ),
    ModelType(
      id: 'kling',
      name: 'Kling',
      description: 'Advanced character animation',
      icon: Icons.animation_rounded,
      color: const Color(0xFF51CF66),
    ),
    ModelType(
      id: 'veo3',
      name: 'Veo 3',
      description: 'Realistic product demonstrations',
      icon: Icons.video_camera_back_rounded,
      color: const Color(0xFFFFA726),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Model',
          style: GoogleFonts.figtree(
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
                    style: GoogleFonts.ebGaramond(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Select the AI model that best fits your creative needs',
                    style: GoogleFonts.figtree(
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
            
            // Continue button
            if (_selectedModelId != null)
              Container(
                padding: const EdgeInsets.all(AppTheme.sidePadding),
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
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToCreation,
                      child: Text(
                        'Continue',
                        style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelCard(ModelType model) {
    final isSelected = _selectedModelId == model.id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedModelId = model.id),
      child: AnimatedContainer(
        duration: AppTheme.microDuration,
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cardHighlight : AppTheme.cardNeutral,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: isSelected ? AppTheme.accentPrimary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? AppTheme.elevatedShadow : AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: model.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
              ),
              child: Icon(
                model.icon,
                color: model.color,
                size: 32,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: GoogleFonts.figtree(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.description,
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreation() {
    if (_selectedModelId == null) return;
    
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UgcCreationScreen(modelId: _selectedModelId!),
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
