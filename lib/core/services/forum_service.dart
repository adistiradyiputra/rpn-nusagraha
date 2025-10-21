import 'package:flutter/foundation.dart';
import 'api_service.dart';

class ForumService {
  /// Mendapatkan link forum berdasarkan ID Kar
  /// 
  /// Parameter:
  /// - idKar: ID Karyawan dari user yang login
  /// 
  /// Returns:
  /// - String: Link forum yang didapat dari API
  static Future<String> getForumLink(String idKar) async {
    try {
      if (kDebugMode) {
        print('ForumService: Requesting forum link for idKar: $idKar');
      }
      
      final response = await ApiService.get('/API/Aktivitas/getLinkForum/$idKar');
      
      if (kDebugMode) {
        print('ForumService: Response: $response');
      }
      
      // Cek response status
      if (response['status'] == 200) {
        final linkForum = response['link_forum'];
        
        if (linkForum != null && linkForum.toString().isNotEmpty) {
          if (kDebugMode) {
            print('ForumService: Link forum found: $linkForum');
          }
          return linkForum.toString();
        } else {
          throw Exception('Link forum tidak ditemukan dalam response');
        }
      } else {
        final message = response['message'] ?? 'Gagal mendapatkan link forum';
        throw Exception(message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('ForumService: Error: $e');
      }
      rethrow;
    }
  }
}

