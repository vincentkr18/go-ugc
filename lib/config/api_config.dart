/// API Configuration for Video Generation Services
class ApiConfig {
  // Base URL for all API endpoints
  static const String baseUrl = 'https://fastapi-supabase-pi.vercel.app';
  
  // API Endpoints
  static const String sora2Endpoint = '/api/v1/sora-2';
  static const String klingEndpoint = '/api/v1/kling';
  static const String veo3Endpoint = '/api/v1/veo-3';
  static const String lipSyncEndpoint = '/api/v1/lip-sync';
  static const String templatesEndpoint = '/templates/videos';
  
  // Full URLs
  static String get sora2Url => '$baseUrl$sora2Endpoint';
  static String get klingUrl => '$baseUrl$klingEndpoint';
  static String get veo3Url => '$baseUrl$veo3Endpoint';
  static String get lipSyncUrl => '$baseUrl$lipSyncEndpoint';
  static String get templatesUrl => '$baseUrl$templatesEndpoint';
  
  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(minutes: 2);
}

/// Aspect ratio enum values
enum AspectRatio {
  portrait_9_16('9:16'),
  landscape_16_9('16:9'),
  square_1_1('1:1');
  
  final String value;
  const AspectRatio(this.value);
  
  @override
  String toString() => value;
}
