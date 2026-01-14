import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import 'template_selection_screen.dart';
import 'audio_selection_screen.dart';
import '../services/video_generation_service.dart';
import '../models/video_generation_job.dart';
import '../config/api_config.dart' as api;

class UgcCreationScreen extends StatefulWidget {
  final String modelId;

  const UgcCreationScreen({super.key, required this.modelId});

  @override
  State<UgcCreationScreen> createState() => _UgcCreationScreenState();
}

class _UgcCreationScreenState extends State<UgcCreationScreen> {
  final TextEditingController _promptController = TextEditingController();
  final VideoGenerationService _videoService = VideoGenerationService();
  bool _isGenerating = false;
  double _progress = 0.0;
  Timer? _progressTimer;
  String? _selectedTemplate;
  String? _selectedAudio;
  File? _selectedAudioFile;
  File? _selectedProductImage;
  VideoGenerationJob? _currentJob;
  String? _errorMessage;

  @override
  void dispose() {
    _promptController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  String get _modelName {
    switch (widget.modelId) {
      case 'lip_sync':
        return 'Lip Sync';
      case 'sora2':
        return 'Sora 2';
      case 'kling':
        return 'Kling';
      case 'veo3':
        return 'Veo 3';
      default:
        return 'Model';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _isGenerating ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          _modelName,
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: _isGenerating ? _buildGeneratingView() : _buildInputView(),
      ),
    );
  }

  Widget _buildInputView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Your Video',
            style: GoogleFonts.ebGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Provide details for your ${_modelName} video',
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),
          
          if (widget.modelId == 'lip_sync') _buildLipSyncFlow(),
          if (widget.modelId == 'sora2' || widget.modelId == 'kling' || widget.modelId == 'veo3')
            _buildTextToVideoFlow(),
        ],
      ),
    );
  }

  Widget _buildLipSyncFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template selection
        Text(
          'Choose Template',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        
        // Navigate to template selection screen
        InkWell(
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TemplateSelectionScreen(),
              ),
            );
            if (result != null) {
              setState(() => _selectedTemplate = result);
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.cardPadding),
            decoration: BoxDecoration(
              color: AppTheme.cardNeutral,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(
                color: _selectedTemplate != null
                    ? AppTheme.accentPrimary
                    : AppTheme.borderLight,
                width: 2,
              ),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
                  ),
                  child: Icon(
                    Icons.grid_view_rounded,
                    color: AppTheme.accentPrimary,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedTemplate != null
                            ? 'Template Selected'
                            : 'Select Template',
                        style: GoogleFonts.figtree(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        _selectedTemplate != null
                            ? 'Template ID: $_selectedTemplate'
                            : 'Browse 100+ templates',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXl),
        
        // Audio upload - navigate to audio selection screen
        InkWell(
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AudioSelectionScreen(),
              ),
            );
            if (result != null) {
              setState(() {
                _selectedAudio = result;
                // Convert string path to File object
                if (result is String && result.isNotEmpty) {
                  _selectedAudioFile = File(result);
                }
              });
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.cardPadding),
            decoration: BoxDecoration(
              color: AppTheme.cardNeutral,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(
                color: _selectedAudio != null
                    ? AppTheme.accentPrimary
                    : AppTheme.borderLight,
                width: 2,
              ),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
                  ),
                  child: Icon(
                    Icons.audio_file_rounded,
                    color: AppTheme.accentPrimary,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedAudio != null
                            ? 'Audio Selected'
                            : 'Upload Audio or Record Voice',
                        style: GoogleFonts.figtree(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        _selectedAudio != null
                            ? _selectedAudio!
                            : 'Upload file or record voice',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXl * 2),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_selectedTemplate != null && _selectedAudio != null)
                ? _startGeneration
                : null,
            child: Text(
              'Generate Video',
              style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextToVideoFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prompt input
        Text(
          'Video Prompt',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextField(
          controller: _promptController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe your video...\nExample: A product showcase of wireless headphones with smooth camera movements',
            hintStyle: GoogleFonts.figtree(
              fontSize: 14,
              color: AppTheme.textSecondary.withOpacity(0.6),
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXl),
        
        // Product image upload
        InkWell(
          onTap: () async {
            try {
              // Use file picker to select image
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );

              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                if (file.path != null) {
                  setState(() {
                    _selectedProductImage = File(file.path!);
                  });
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Image selected: ${file.name}',
                          style: GoogleFonts.figtree(),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.statusComplete,
                      ),
                    );
                  }
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error selecting image: $e',
                      style: GoogleFonts.figtree(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppTheme.statusError,
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.cardPadding),
            decoration: BoxDecoration(
              color: AppTheme.cardNeutral,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: AppTheme.borderLight, width: 2),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
                  ),
                  child: Icon(
                    Icons.image_rounded,
                    color: AppTheme.accentPrimary,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedProductImage != null
                            ? 'Image Selected'
                            : 'Upload Product Image',
                        style: GoogleFonts.figtree(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        _selectedProductImage != null
                            ? _selectedProductImage!.path.split('/').last
                            : 'Select product or scene image',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingMd),
        
        // Info tip
        Container(
          padding: const EdgeInsets.all(AppTheme.cardPadding),
          decoration: BoxDecoration(
            color: AppTheme.cardYellow,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppTheme.accentPrimary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  'Tip: Be specific about camera angles, lighting, and movement for best results',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXl * 2),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _promptController.text.isEmpty ? null : _startGeneration,
            child: Text(
              'Generate Video',
              style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.sidePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 8,
                      backgroundColor: AppTheme.borderLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.accentPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: GoogleFonts.figtree(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            Text(
              'Generating Your Video',
              style: GoogleFonts.ebGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingSm),
            
            Text(
              'This may take a few moments...',
              style: GoogleFonts.figtree(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            Text(
              'Estimated time: ${_getEstimatedTime()}',
              style: GoogleFonts.figtree(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEstimatedTime() {
    final remaining = ((1.0 - _progress) * 60).toInt();
    return '${remaining}s remaining';
  }

  void _startGeneration() async {
    setState(() {
      _isGenerating = true;
      _progress = 0.0;
      _errorMessage = null;
    });
    
    try {
      VideoGenerationJob job;
      
      // Call appropriate API based on model
      if (widget.modelId == 'lip_sync') {
        // Lip sync requires template and audio
        if (_selectedTemplate == null || _selectedAudioFile == null) {
          throw Exception('Template and audio are required for Lip Sync');
        }
        
        final templateId = int.tryParse(_selectedTemplate!) ?? 1;
        job = await _videoService.generateLipSyncWithAudio(
          aspectRatio: api.AspectRatio.portrait_9_16,
          videoTemplateId: templateId,
          audioFile: _selectedAudioFile!,
        );
      } else if (widget.modelId == 'sora2') {
        job = await _videoService.generateSora2Video(
          aspectRatio: api.AspectRatio.portrait_9_16,
          prompt: _promptController.text,
          productImage: _selectedProductImage,
        );
      } else if (widget.modelId == 'kling') {
        job = await _videoService.generateKlingVideo(
          aspectRatio: api.AspectRatio.portrait_9_16,
          prompt: _promptController.text,
          productImage: _selectedProductImage,
        );
      } else if (widget.modelId == 'veo3') {
        job = await _videoService.generateVeo3Video(
          aspectRatio: api.AspectRatio.portrait_9_16,
          prompt: _promptController.text,
          productImage: _selectedProductImage,
        );
      } else {
        throw Exception('Unknown model: ${widget.modelId}');
      }
      
      setState(() {
        _currentJob = job;
      });
      
      // Simulate progress animation
      _startProgressAnimation();
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _errorMessage = e.toString();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.figtree(),
            ),
            backgroundColor: AppTheme.statusError,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  
  void _startProgressAnimation() {
    // Animate progress to completion
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          timer.cancel();
          _showCompletionDialog();
        }
      });
    });
  }

  void _showCompletionDialog() {
    final jobId = _currentJob?.jobId ?? 'unknown';
    final videoUrl = _currentJob?.videoGeneratedPath;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.statusComplete.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppTheme.statusComplete,
                size: 64,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'Video Ready!',
              style: GoogleFonts.ebGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Your video has been generated successfully',
              textAlign: TextAlign.center,
              style: GoogleFonts.figtree(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            if (videoUrl != null) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.cardNeutral,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
                ),
                child: Text(
                  'Job ID: $jobId',
                  style: GoogleFonts.figtree(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (videoUrl != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Could open video player or share video
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Video URL: $videoUrl',
                        style: GoogleFonts.figtree(),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  'View Video',
                  style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          const SizedBox(height: AppTheme.spacingSm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close creation screen
                Navigator.of(context).pop(); // Close model selection
              },
              child: Text(
                'Back to Dashboard',
                style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
