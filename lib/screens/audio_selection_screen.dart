import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AudioSelectionScreen extends StatefulWidget {
  const AudioSelectionScreen({super.key});

  @override
  State<AudioSelectionScreen> createState() => _AudioSelectionScreenState();
}

class _AudioSelectionScreenState extends State<AudioSelectionScreen> {
  String? _selectedOption;
  bool _isRecording = false;
  int _recordingDuration = 0;

  void _handleUpload() async {
    // In a real app, this would open file picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Audio file selected',
          style: GoogleFonts.figtree(),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.statusComplete,
      ),
    );
    // Simulate file selection
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).pop('uploaded_audio.mp3');
    }
  }

  void _handleRecord() {
    setState(() {
      _isRecording = !_isRecording;
      _recordingDuration = 0;
    });

    if (_isRecording) {
      // Simulate recording timer
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (_isRecording && mounted) {
          setState(() => _recordingDuration++);
          return true;
        }
        return false;
      });
    }
  }

  void _stopAndSave() {
    setState(() => _isRecording = false);
    Navigator.of(context).pop('recorded_audio.mp3');
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _isRecording ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Audio',
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: _selectedOption == null
            ? _buildSelectionView()
            : _selectedOption == 'record'
                ? _buildRecordingView()
                : _buildUploadingView(),
      ),
    );
  }

  Widget _buildSelectionView() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Audio Source',
            style: GoogleFonts.ebGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Select how you want to add audio to your video',
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),

          // Upload option
          _buildOptionCard(
            title: 'Upload Audio File',
            subtitle: 'Choose an audio file from your device',
            icon: Icons.upload_file_rounded,
            iconColor: AppTheme.accentPrimary,
            onTap: () {
              setState(() => _selectedOption = 'upload');
              _handleUpload();
            },
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Record option
          _buildOptionCard(
            title: 'Record Voice',
            subtitle: 'Record your voice using the microphone',
            icon: Icons.mic_rounded,
            iconColor: AppTheme.statusInProgress,
            onTap: () {
              setState(() => _selectedOption = 'record');
            },
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Text to speech option (optional)
          _buildOptionCard(
            title: 'Text to Speech',
            subtitle: 'Convert written text to speech audio',
            icon: Icons.text_fields_rounded,
            iconColor: AppTheme.statusComplete,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Text to Speech feature coming soon',
                    style: GoogleFonts.figtree(),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.cardRadiusSmall),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    subtitle,
                    style: GoogleFonts.figtree(
                      fontSize: 13,
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
    );
  }

  Widget _buildRecordingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.sidePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recording animation
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? AppTheme.statusInProgress.withOpacity(0.1)
                    : AppTheme.accentPrimary.withOpacity(0.1),
                border: Border.all(
                  color: _isRecording
                      ? AppTheme.statusInProgress
                      : AppTheme.accentPrimary,
                  width: 4,
                ),
              ),
              child: Center(
                child: Icon(
                  _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  size: 80,
                  color: _isRecording
                      ? AppTheme.statusInProgress
                      : AppTheme.accentPrimary,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Timer
            Text(
              _formatDuration(_recordingDuration),
              style: GoogleFonts.figtree(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: AppTheme.spacingSm),

            Text(
              _isRecording ? 'Recording...' : 'Ready to record',
              style: GoogleFonts.figtree(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl * 2),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRecording)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _selectedOption = null);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: Text(
                        'Back',
                        style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                if (!_isRecording) const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRecording ? _stopAndSave : _handleRecord,
                    icon: Icon(_isRecording ? Icons.check_rounded : Icons.fiber_manual_record_rounded),
                    label: Text(
                      _isRecording ? 'Save' : 'Start',
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording
                          ? AppTheme.statusComplete
                          : AppTheme.accentPrimary,
                    ),
                  ),
                ),
              ],
            ),

            if (_isRecording) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppTheme.cardPadding),
                decoration: BoxDecoration(
                  color: AppTheme.cardYellow,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.accentPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        'Speak clearly into the microphone',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
