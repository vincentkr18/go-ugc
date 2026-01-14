/// Model for video template tag
class TemplateTag {
  final int id;
  final String name;

  TemplateTag({
    required this.id,
    required this.name,
  });

  factory TemplateTag.fromJson(Map<String, dynamic> json) {
    return TemplateTag(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Model for video template
class VideoTemplate {
  final int id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String previewUrl;
  final List<TemplateTag> tags;

  VideoTemplate({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.previewUrl,
    required this.tags,
  });

  factory VideoTemplate.fromJson(Map<String, dynamic> json) {
    return VideoTemplate(
      id: json['id'] as int,
      title: json['title'] as String,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      previewUrl: json['preview_url'] as String,
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => TemplateTag.fromJson(tag as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'preview_url': previewUrl,
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
  }

  /// Get comma-separated tag names
  String get tagNames => tags.map((tag) => tag.name).join(', ');

  /// Check if template has a specific tag
  bool hasTag(String tagName) {
    return tags.any((tag) => tag.name.toLowerCase() == tagName.toLowerCase());
  }
}

/// Model for paginated video templates response
class VideoTemplatesResponse {
  final int page;
  final int limit;
  final int total;
  final List<VideoTemplate> items;

  VideoTemplatesResponse({
    required this.page,
    required this.limit,
    required this.total,
    required this.items,
  });

  factory VideoTemplatesResponse.fromJson(Map<String, dynamic> json) {
    return VideoTemplatesResponse(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => VideoTemplate.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  /// Check if there are more pages
  bool get hasNextPage => page * limit < total;

  /// Get total number of pages
  int get totalPages => (total / limit).ceil();
}
