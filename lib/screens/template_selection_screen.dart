import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import '../services/template_service.dart';
import '../models/video_template.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  final TemplateService _templateService = TemplateService();
  List<VideoTemplate> _allTemplates = [];
  List<VideoTemplate> _filteredTemplates = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'All';
  int? _selectedTemplateId;
  int? _hoveredTemplateId;
  int? _longPressedTemplateId;
  final TextEditingController _searchController = TextEditingController();

  // Extract unique tags from templates for filters
  List<String> get _filters {
    if (_allTemplates.isEmpty) return ['All'];
    
    final tagSet = <String>{'All'};
    for (final template in _allTemplates) {
      for (final tag in template.tags) {
        tagSet.add(tag.name);
      }
    }
    return tagSet.toList()..sort();
  }

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final templates = await _templateService.fetchAllTemplates();
      setState(() {
        _allTemplates = templates;
        _filteredTemplates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTemplates = _allTemplates.where((template) {
        // Apply tag filter
        if (_selectedFilter != 'All' && !template.hasTag(_selectedFilter)) {
          return false;
        }
        
        // Apply search filter
        if (_searchController.text.isNotEmpty) {
          return template.title.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
        }
        
        return true;
      }).toList();
    });
  }

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
          'Select Template',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadTemplates,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _buildTemplatesView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.sidePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppTheme.statusError,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'Failed to Load Templates',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton(
              onPressed: _loadTemplates,
              child: Text(
                'Retry',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppTheme.sidePadding),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              hintText: 'Search templates...',
              hintStyle: GoogleFonts.manrope(
                fontSize: 14,
                color: AppTheme.textSecondary.withOpacity(0.6),
              ),
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Filter badges
        if (_filters.length > 1)
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.sidePadding),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                        _applyFilters();
                      });
                    },
                    backgroundColor: AppTheme.cardNeutral,
                    selectedColor: Colors.black,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? Colors.black
                          : AppTheme.borderLight,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                  ),
                );
              },
            ),
          ),

        // Template count
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.sidePadding,
            vertical: AppTheme.spacingSm,
          ),
          child: Text(
            '${_filteredTemplates.length} templates available',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ),

        // Template grid
        Expanded(
          child: _filteredTemplates.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.all(AppTheme.sidePadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTheme.spacingMd,
                    mainAxisSpacing: AppTheme.spacingMd,
                    childAspectRatio: 0.55, // Taller cards for 9:16 videos
                  ),
                  itemCount: _filteredTemplates.length,
                  itemBuilder: (context, index) {
                    final template = _filteredTemplates[index];
                    final isSelected = template.id == _selectedTemplateId;
                    return _buildTemplateCard(template, isSelected);
                  },
                ),
        ),

        // Select button
        if (_selectedTemplateId != null)
          Container(
            padding: const EdgeInsets.all(AppTheme.sidePadding),
            decoration: BoxDecoration(
              color: AppTheme.backgroundMain,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedTemplateId.toString());
                },
                child: Text(
                  'Select Template',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'No Templates Found',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(VideoTemplate template, bool isSelected) {
    final isHovered = template.id == _hoveredTemplateId;
    final isLongPressed = template.id == _longPressedTemplateId;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredTemplateId = template.id),
      onExit: (_) => setState(() => _hoveredTemplateId = null),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTemplateId = template.id);
        },
        onLongPressStart: (_) {
          // For mobile: show video preview modal on long press
          setState(() => _longPressedTemplateId = template.id);
          _showVideoPreviewModal(template);
        },
        onLongPressEnd: (_) {
          // Clean up when long press ends
          setState(() => _longPressedTemplateId = null);
        },
        child: AnimatedScale(
          scale: isLongPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail or Video Preview
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(
                    color: isSelected
                        ? Colors.black
                        : AppTheme.borderLight,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : AppTheme.cardShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Always show thumbnail as base layer
                      CachedNetworkImage(
                        imageUrl: template.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.black.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black.withOpacity(0.1),
                          child: Icon(
                            Icons.video_library_rounded,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                      
                      // Show video on top when hovered and ready
                      if (isHovered)
                        _VideoPreview(videoUrl: template.previewUrl),
                      
                      // Selection indicator overlay
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingSm),
            
            // Title below thumbnail
            Text(
              template.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingXs),
            
            // Tags
            if (template.tags.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: template.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag.name,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
          ),
      ),
    );
  }

  void _showVideoPreviewModal(VideoTemplate template) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _VideoPreviewModal(
        template: template,
        onDismiss: () {
          Navigator.of(context).pop();
          setState(() => _longPressedTemplateId = null);
        },
      ),
    );
  }
}

/// Full-screen video preview modal for long-press
class _VideoPreviewModal extends StatefulWidget {
  final VideoTemplate template;
  final VoidCallback onDismiss;

  const _VideoPreviewModal({
    required this.template,
    required this.onDismiss,
  });

  @override
  State<_VideoPreviewModal> createState() => _VideoPreviewModalState();
}

class _VideoPreviewModalState extends State<_VideoPreviewModal> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.template.previewUrl),
      );

      await _controller.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
        _controller.setLooping(true);
        _controller.setVolume(0.3); // Low volume for preview
        _controller.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Template title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.template.title,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            
            // Video preview
            Container(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 700,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _hasError
                      ? Container(
                          color: AppTheme.cardNeutral,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 48,
                                color: AppTheme.statusError,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load preview',
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : !_isInitialized
                          ? Container(
                              color: AppTheme.cardNeutral,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller.value.size.width,
                                height: _controller.value.size.height,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Instructions
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.touch_app_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap anywhere to close',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Video preview widget that plays on hover
class _VideoPreview extends StatefulWidget {
  final String videoUrl;

  const _VideoPreview({required this.videoUrl});

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      
      await _controller.initialize();
      
      if (mounted) {
        setState(() => _isInitialized = true);
        _controller.setLooping(true);
        _controller.setVolume(0); // Mute preview
        _controller.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const SizedBox.shrink(); // Don't show anything if error
    }

    if (!_isInitialized) {
      return const SizedBox.shrink(); // Don't show anything while loading
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
