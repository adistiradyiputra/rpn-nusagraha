import 'api_service.dart';
import '../constants/api_constants.dart';

class ActivityService {
  static Future<Map<String, dynamic>> postActivity({
    required String idKar,
    required List<String> kategori,
    required String keterangan,
    required String statusAktivitas,
    required String kota,
    required int luarNegri,
    required String created,
    required String tglMulai,
    required String tglSelesai,
  }) async {
    try {
      final body = {
        'id_kar': idKar,
        'kategori': kategori,
        'keterangan': keterangan,
        'status_aktivitas': statusAktivitas,
        'kota': kota,
        'luarnegri': luarNegri,
        'created': created,
        'tgl_mulai': tglMulai,
        'tgl_selesai': tglSelesai,
      };

      final response = await ApiService.post(ApiConstants.postAktivitasEndpoint, body);
      
      if (response['status'] == 200) {
        return {
          'success': true,
          'message': response['message'] ?? 'Aktivitas berhasil disimpan',
          'data': response['data'],
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Gagal menyimpan aktivitas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateActivity({
    required String id,
    required String idKar,
    required List<String> kategori,
    required String keterangan,
    required String statusAktivitas,
    required String kota,
    required int luarNegri,
    required String created,
    required String tglMulai,
    required String tglSelesai,
  }) async {
    try {
      final body = {
        'id': id,
        'id_kar': idKar,
        'kategori': kategori,
        'keterangan': keterangan,
        'status_aktivitas': statusAktivitas,
        'kota': kota,
        'luarnegri': luarNegri,
        'created': created,
        'tgl_mulai': tglMulai,
        'tgl_selesai': tglSelesai,
      };

      final response = await ApiService.put(ApiConstants.updateAktivitasEndpoint, body);
      
      if (response['status'] == 200) {
        return {
          'success': true,
          'message': response['message'] ?? 'Aktivitas berhasil diupdate',
          'data': response['data'],
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Gagal mengupdate aktivitas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}
