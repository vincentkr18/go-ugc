import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  String _selectedFilter = 'All';
  String? _selectedTemplate;

  final List<String> _filters = [
    'All',
    'Popular',
    'Characters',
    'Celebrities',
    'Avatars',
    'Custom',
  ];

  final List<Map<String, String>> _templates = [
    {'id': '1', 'name': 'Character A', 'category': 'Characters'},
    {'id': '2', 'name': 'Character B', 'category': 'Characters'},
    {'id': '3', 'name': 'Celebrity 1', 'category': 'Celebrities'},
    {'id': '4', 'name': 'Avatar 1', 'category': 'Avatars'},
    {'id': '5', 'name': 'Character C', 'category': 'Characters'},
    {'id': '6', 'name': 'Celebrity 2', 'category': 'Celebrities'},
    {'id': '7', 'name': 'Avatar 2', 'category': 'Avatars'},
    {'id': '8', 'name': 'Custom A', 'category': 'Custom'},
    {'id': '9', 'name': 'Character D', 'category': 'Characters'},
    {'id': '10', 'name': 'Celebrity 3', 'category': 'Celebrities'},
  ];

  List<Map<String, String>> get _filteredTemplates {
    if (_selectedFilter == 'All') {
      return _templates;
    }
    return _templates
        .where((template) => template['category'] == _selectedFilter)
        .toList();
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
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter badges
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
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: AppTheme.cardNeutral,
                    selectedColor: AppTheme.accentPrimary,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.accentPrimary
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
              style: GoogleFonts.figtree(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Template grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppTheme.sidePadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingMd,
                mainAxisSpacing: AppTheme.spacingMd,
                childAspectRatio: 0.85,
              ),
              itemCount: _filteredTemplates.length,
              itemBuilder: (context, index) {
                final template = _filteredTemplates[index];
                final isSelected = template['id'] == _selectedTemplate;
                return _buildTemplateCard(template, isSelected);
              },
            ),
          ),

          // Select button
          if (_selectedTemplate != null)
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
                    Navigator.of(context).pop(_selectedTemplate);
                  },
                  child: Text(
                    'Select Template',
                    style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, String> template, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTemplate = template['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardNeutral,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentPrimary
                : AppTheme.borderLight,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppTheme.accentPrimary,
                size: 40,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              template['name']!,
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
              ),
              child: Text(
                template['category']!,
                style: GoogleFonts.figtree(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.accentPrimary,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.accentPrimary,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
