import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/video_generation_job.dart';

/// Service for handling video generation API calls
class VideoGenerationService {
  /// Generate video using Sora 2 API
  Future<VideoGenerationJob> generateSora2Video({
    required AspectRatio aspectRatio,
    required String prompt,
    String? characterDescription,
    String? environmentDescription,
    String? gestures,
    String? dialogue,
    String? voiceTone,
    File? productImage,
  }) async {
    return await _generateVideo(
      endpoint: ApiConfig.sora2Url,
      aspectRatio: aspectRatio,
      prompt: prompt,
      characterDescription: characterDescription,
      environmentDescription: environmentDescription,
      gestures: gestures,
      dialogue: dialogue,
      voiceTone: voiceTone,
      productImage: productImage,
    );
  }

  /// Generate video using Kling API
  Future<VideoGenerationJob> generateKlingVideo({
    required AspectRatio aspectRatio,
    required String prompt,
    String? characterDescription,
    String? environmentDescription,
    String? gestures,
    String? dialogue,
    String? voiceTone,
    File? productImage,
  }) async {
    return await _generateVideo(
      endpoint: ApiConfig.klingUrl,
      aspectRatio: aspectRatio,
      prompt: prompt,
      characterDescription: characterDescription,
      environmentDescription: environmentDescription,
      gestures: gestures,
      dialogue: dialogue,
      voiceTone: voiceTone,
      productImage: productImage,
    );
  }

  /// Generate video using Veo 3 API
  Future<VideoGenerationJob> generateVeo3Video({
    required AspectRatio aspectRatio,
    required String prompt,
    String? characterDescription,
    String? environmentDescription,
    String? gestures,
    String? dialogue,
    String? voiceTone,
    File? productImage,
  }) async {
    return await _generateVideo(
      endpoint: ApiConfig.veo3Url,
      aspectRatio: aspectRatio,
      prompt: prompt,
      characterDescription: characterDescription,
      environmentDescription: environmentDescription,
      gestures: gestures,
      dialogue: dialogue,
      voiceTone: voiceTone,
      productImage: productImage,
    );
  }

  /// Generate lip sync video using audio file
  Future<VideoGenerationJob> generateLipSyncWithAudio({
    required AspectRatio aspectRatio,
    required int videoTemplateId,
    required File audioFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.lipSyncUrl));

      // Add required fields
      request.fields['aspect_ratio'] = aspectRatio.value;
      request.fields['video_template_id'] = videoTemplateId.toString();

      // Add audio file
      request.files.add(
        await http.MultipartFile.fromPath(
          'audio_file',
          audioFile.path,
        ),
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return VideoGenerationJob.fromJson(jsonData);
      } else {
        throw Exception('Failed to generate lip sync video: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating lip sync video: $e');
    }
  }

  /// Generate lip sync video using text-to-speech
  Future<VideoGenerationJob> generateLipSyncWithTTS({
    required AspectRatio aspectRatio,
    required int videoTemplateId,
    required String textInput,
    required String voiceId,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.lipSyncUrl));

      // Add required fields
      request.fields['aspect_ratio'] = aspectRatio.value;
      request.fields['video_template_id'] = videoTemplateId.toString();
      request.fields['text_input'] = textInput;
      request.fields['voice_id'] = voiceId;

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return VideoGenerationJob.fromJson(jsonData);
      } else {
        throw Exception('Failed to generate lip sync video: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating lip sync video: $e');
    }
  }

  /// Private method to handle common video generation logic
  Future<VideoGenerationJob> _generateVideo({
    required String endpoint,
    required AspectRatio aspectRatio,
    required String prompt,
    String? characterDescription,
    String? environmentDescription,
    String? gestures,
    String? dialogue,
    String? voiceTone,
    File? productImage,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add required fields
      request.fields['aspect_ratio'] = aspectRatio.value;
      request.fields['prompt'] = prompt;

      // Add optional fields
      if (characterDescription != null && characterDescription.isNotEmpty) {
        request.fields['character_description'] = characterDescription;
      }
      if (environmentDescription != null && environmentDescription.isNotEmpty) {
        request.fields['environment_description'] = environmentDescription;
      }
      if (gestures != null && gestures.isNotEmpty) {
        request.fields['gestures'] = gestures;
      }
      if (dialogue != null && dialogue.isNotEmpty) {
        request.fields['dialogue'] = dialogue;
      }
      if (voiceTone != null && voiceTone.isNotEmpty) {
        request.fields['voice_tone'] = voiceTone;
      }

      // Add product image if provided
      if (productImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'product_image',
            productImage.path,
          ),
        );
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return VideoGenerationJob.fromJson(jsonData);
      } else {
        throw Exception('Failed to generate video: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating video: $e');
    }
  }

  /// Poll job status (for future implementation)
  Future<VideoGenerationJob> getJobStatus(String jobId) async {
    // This would be implemented when you have a status endpoint
    throw UnimplementedError('Job status polling not yet implemented');
  }
}
