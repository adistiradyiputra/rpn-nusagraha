import 'research_activity.dart';

class ActivityResponse {
  final String id;
  final String kategori;
  final String keterangan;
  final String kota;
  final String luarnegri;
  final String created;
  final String tglMulai;
  final String tglSelesai;
  final String createdBy;
  final String? lastupdated;
  final String? lastupdatedBy;
  final String isDeleted;
  final String idKar;
  final String createdReal;
  final String statusAktivitas;
  final bool isEdited; // Track if activity has been edited (manual tracking)

  ActivityResponse({
    required this.id,
    required this.kategori,
    required this.keterangan,
    required this.kota,
    required this.luarnegri,
    required this.created,
    required this.tglMulai,
    required this.tglSelesai,
    required this.createdBy,
    this.lastupdated,
    this.lastupdatedBy,
    required this.isDeleted,
    required this.idKar,
    required this.createdReal,
    required this.statusAktivitas,
    this.isEdited = false,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      id: json['id']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      kota: json['kota']?.toString() ?? '',
      luarnegri: json['luarnegri']?.toString() ?? '0',
      created: json['created']?.toString() ?? '',
      tglMulai: json['tgl_mulai']?.toString() ?? '',
      tglSelesai: json['tgl_selesai']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      lastupdated: json['lastupdated']?.toString(),
      lastupdatedBy: json['lastupdated_by']?.toString(),
      isDeleted: json['is_deleted']?.toString() ?? '0',
      idKar: json['id_kar']?.toString() ?? '',
      createdReal: json['created_real']?.toString() ?? '',
      statusAktivitas: json['status_aktivitas']?.toString() ?? '',
      isEdited: json['lastupdated'] != null && json['lastupdated_by'] != null, // Check if both are not null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori': kategori,
      'keterangan': keterangan,
      'kota': kota,
      'luarnegri': luarnegri,
      'created': created,
      'tgl_mulai': tglMulai,
      'tgl_selesai': tglSelesai,
      'created_by': createdBy,
      'lastupdated': lastupdated,
      'lastupdated_by': lastupdatedBy,
      'is_deleted': isDeleted,
      'id_kar': idKar,
      'created_real': createdReal,
      'status_aktivitas': statusAktivitas,
    };
  }

  // Convert to ResearchActivity for compatibility with existing table
  ResearchActivity toResearchActivity() {
    return ResearchActivity(
      id: id,
      title: keterangan,
      category: kategori,
      status: statusAktivitas,
      location: kota,
      locationType: luarnegri == '1' ? 'Luar Negeri' : 'Dalam Negeri',
      startDate: _parseDateTime(tglMulai),
      endDate: _parseDateTime(tglSelesai),
      description: keterangan,
      created: created,
      lastUpdated: lastupdated != null ? _parseDateTime(lastupdated!) : null,
      isEdited: isEdited, // Already calculated from lastupdated and lastupdated_by
    );
  }

  DateTime _parseDateTime(String dateTimeString) {
    try {
      // Parse format: "2025-09-29 14:41:45"
      final parts = dateTimeString.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('-');
        final timeParts = parts[1].split(':');
        
        if (dateParts.length == 3 && timeParts.length == 3) {
          return DateTime(
            int.parse(dateParts[0]), // year
            int.parse(dateParts[1]), // month
            int.parse(dateParts[2]), // day
            int.parse(timeParts[0]), // hour
            int.parse(timeParts[1]), // minute
            int.parse(timeParts[2]), // second
          );
        }
      }
      
      // Fallback to current date if parsing fails
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }
}

