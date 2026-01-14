import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/video_template.dart';

/// Service for fetching video templates
class TemplateService {
  /// Fetch video templates with optional filters
  Future<VideoTemplatesResponse> fetchTemplates({
    int page = 1,
    int limit = 20,
    String? search,
    List<String>? tags,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (tags != null && tags.isNotEmpty) {
        queryParams['tags'] = tags.join(',');
      }

      // Build URI with query parameters
      final uri = Uri.parse(ApiConfig.templatesUrl).replace(
        queryParameters: queryParams,
      );

      // Make GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return VideoTemplatesResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to fetch templates: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching templates: $e');
    }
  }

  /// Fetch a single page of templates (simplified)
  Future<List<VideoTemplate>> fetchTemplatePage({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await fetchTemplates(page: page, limit: limit);
    return response.items;
  }

  /// Search templates by title
  Future<List<VideoTemplate>> searchTemplates(String query) async {
    final response = await fetchTemplates(search: query);
    return response.items;
  }

  /// Filter templates by tags
  Future<List<VideoTemplate>> filterByTags(List<String> tags) async {
    final response = await fetchTemplates(tags: tags);
    return response.items;
  }

  /// Fetch all templates (loads all pages)
  Future<List<VideoTemplate>> fetchAllTemplates() async {
    final allTemplates = <VideoTemplate>[];
    int currentPage = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await fetchTemplates(page: currentPage, limit: 100);
      allTemplates.addAll(response.items);
      
      hasMore = response.hasNextPage;
      currentPage++;
      
      // Safety limit to prevent infinite loops
      if (currentPage > 100) break;
    }

    return allTemplates;
  }
}
