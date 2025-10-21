import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationService {
  static const String _cacheKey = 'location_data_cache';
  static const String _cacheTimestampKey = 'location_data_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);
  
  static Future<Map<String, List<String>>> getKotaDanNegara() async {
    try {
      // Check cache first
      final cachedData = await _getCachedData();
      if (cachedData != null) {
        return cachedData;
      }
      
      // If no cache or cache expired, fetch from API
      final response = await ApiService.get('/API/Aktivitas/getKotaDanNegara');
      
      if (response['status'] == 200) {
        final responseData = response['data'];
        
        // Extract names from the objects in list_kota
        final List<dynamic> kotaData = responseData['list_kota'] ?? [];
        final List<String> kotaNames = kotaData
            .map((kota) => kota['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
            
        // Extract names from the objects in list_negara  
        final List<dynamic> negaraData = responseData['list_negara'] ?? [];
        final List<String> negaraNames = negaraData
            .map((negara) => negara['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        
        final result = {
          'kota': kotaNames,
          'negara': negaraNames,
        };
        
        // Cache the result
        await _cacheData(result);
        
        return result;
      } else {
        throw Exception('API Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // If API fails, try to return cached data even if expired
      final cachedData = await _getCachedData(ignoreExpiry: true);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch location data: $e');
    }
  }
  
  static Future<Map<String, List<String>>?> _getCachedData({bool ignoreExpiry = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      final timestamp = prefs.getInt(_cacheTimestampKey);
      
      if (cachedJson == null || timestamp == null) {
        return null;
      }
      
      if (!ignoreExpiry) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        if (now.difference(cacheTime) > _cacheValidDuration) {
          return null; // Cache expired
        }
      }
      
      final Map<String, dynamic> cachedMap = json.decode(cachedJson);
      return {
        'kota': List<String>.from(cachedMap['kota'] ?? []),
        'negara': List<String>.from(cachedMap['negara'] ?? []),
      };
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> _cacheData(Map<String, List<String>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, json.encode(data));
      await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Cache failure is not critical
    }
  }
  
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);
    } catch (e) {
      // Cache clear failure is not critical
    }
  }
}
