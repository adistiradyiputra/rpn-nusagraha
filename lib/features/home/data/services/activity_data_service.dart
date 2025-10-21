import '../../../../core/services/api_service.dart';
import '../../domain/models/activity_response.dart';

class ActivityDataService {
  static Future<Map<String, dynamic>> getActivitiesByUser({
    required String userId,
    int page = 1,
    int limit = 10,
    String search = '',
    String sortBy = 'created_real',
    String sortOrder = 'DESC',
  }) async {
    try {
      // Build query parameters
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'search': search,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };

      // Remove empty search parameter
      if (search.isEmpty) {
        queryParams.remove('search');
      }

      // Build URL with query parameters
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      
      final url = '/API/Aktivitas/getAktivitasByIdKar/$userId?$queryString';

      final response = await ApiService.get(url);

      if (response['status'] == 200) {
        final responseData = response['data'];
        final List<dynamic> itemsData = responseData['items'] ?? [];
        
        // Convert to ActivityResponse objects
        final List<ActivityResponse> activities = itemsData
            .map((item) => ActivityResponse.fromJson(item))
            .toList();

        // Extract pagination info from the correct structure
        final pagination = responseData['pagination'] ?? {};
        final total = pagination['total_records'] ?? responseData['total'] ?? activities.length;
        final totalPages = pagination['total_pages'] ?? responseData['total_pages'] ?? responseData['totalPages'] ?? (total / limit).ceil();
        final currentPage = pagination['current_page'] ?? page;
        final hasNextPage = pagination['has_next_page'] ?? (currentPage < totalPages);
        final hasPreviousPage = pagination['has_previous_page'] ?? (currentPage > 1);
        
        return {
          'success': true,
          'message': response['message'] ?? 'Data aktivitas berhasil diambil',
          'data': {
            'items': activities,
            'total': total,
            'page': currentPage,
            'limit': limit,
            'totalPages': totalPages,
            'hasNextPage': hasNextPage,
            'hasPreviousPage': hasPreviousPage,
            'pagination': pagination, // Include full pagination object
          },
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Gagal mengambil data aktivitas',
          'data': {
            'items': <ActivityResponse>[],
            'total': 0,
            'page': page,
            'limit': limit,
            'totalPages': 0,
          },
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'data': {
          'items': <ActivityResponse>[],
          'total': 0,
          'page': page,
          'limit': limit,
          'totalPages': 0,
        },
      };
    }
  }

  static Future<Map<String, dynamic>> searchActivities({
    required String userId,
    required String searchQuery,
    int page = 1,
    int limit = 10,
    String sortBy = 'created_real',
    String sortOrder = 'DESC',
  }) async {
    return getActivitiesByUser(
      userId: userId,
      page: page,
      limit: limit,
      search: searchQuery,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

}
