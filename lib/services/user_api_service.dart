import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for fetching user authentication details from the FastAPI backend
class UserApiService {
  static final UserApiService _instance = UserApiService._internal();
  factory UserApiService() => _instance;
  UserApiService._internal();

  final String _baseUrl = 'https://fastapi-supabase-pi.vercel.app';
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch user authentication details
  /// Returns a map containing user details or throws an exception on error
  Future<Map<String, dynamic>> getUserAuthDetails() async {
    try {
      // Get the current session token
      final session = _supabase.auth.currentSession;
      
      if (session == null) {
        throw Exception('No active session. Please log in.');
      }

      final token = session.accessToken;
      
      debugPrint('Fetching user auth details from API...');
      
      // Make the API call
      final response = await http.get(
        Uri.parse('$_baseUrl/users/me/auth'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Parse and return the response
        final data = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('Successfully fetched user auth details');
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        final errorBody = response.body.isNotEmpty 
            ? response.body 
            : 'Unknown error';
        throw Exception('Failed to fetch user details: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      debugPrint('Error fetching user auth details: $e');
      rethrow;
    }
  }
}
