import '../models/notification_model.dart';

class NotificationService {
  static final Map<String, Map<String, List<Map<String, dynamic>>>> _notifications = {
    'NUSARISET': {
      'Expert System': [
        {
          'id': '1',
          'title': 'Sistem Pakar Baru',
          'message': 'Expert system untuk diagnosa medis telah diupdate',
          'time': '1 jam yang lalu',
          'isRead': false,
        },
        {
          'id': '2',
          'title': 'Rule Engine Updated',
          'message': 'Aturan baru telah ditambahkan ke sistem',
          'time': '3 jam yang lalu',
          'isRead': true,
        },
        {
          'id': '3',
          'title': 'Knowledge Base Expanded',
          'message': 'Database pengetahuan telah diperluas dengan 50 aturan baru',
          'time': '5 jam yang lalu',
          'isRead': false,
        },
        {
          'id': '4',
          'title': 'Inference Engine Optimized',
          'message': 'Mesin inferensi telah dioptimalkan untuk performa lebih baik',
          'time': '1 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '5',
          'title': 'Expert Consultation Available',
          'message': 'Konsultasi dengan pakar AI tersedia untuk proyek baru',
          'time': '2 hari yang lalu',
          'isRead': false,
        },
        {
          'id': '6',
          'title': 'System Training Completed',
          'message': 'Pelatihan sistem pakar untuk tim riset telah selesai',
          'time': '3 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '7',
          'title': 'New Diagnostic Module',
          'message': 'Modul diagnosa untuk penyakit kardiovaskular telah ditambahkan',
          'time': '4 hari yang lalu',
          'isRead': false,
        },
        {
          'id': '8',
          'title': 'Performance Report',
          'message': 'Laporan performa sistem pakar bulan Januari tersedia',
          'time': '1 minggu yang lalu',
          'isRead': true,
        },
      ],
      'E-Proposal': [
        {
          'id': '9',
          'title': 'Proposal Disetujui',
          'message': 'Proposal "Penelitian AI" telah disetujui',
          'time': '2 jam yang lalu',
          'isRead': false,
        },
        {
          'id': '10',
          'title': 'Review Selesai',
          'message': 'Review proposal "Machine Learning" selesai',
          'time': '1 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '11',
          'title': 'Proposal Revisi',
          'message': 'Proposal "Deep Learning" memerlukan revisi pada bab metodologi',
          'time': '2 hari yang lalu',
          'isRead': false,
        },
        {
          'id': '12',
          'title': 'Budget Approved',
          'message': 'Anggaran untuk proposal "Computer Vision" telah disetujui',
          'time': '3 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '13',
          'title': 'Timeline Updated',
          'message': 'Jadwal penelitian untuk proposal "NLP" telah diperbarui',
          'time': '4 hari yang lalu',
          'isRead': false,
        },
        {
          'id': '14',
          'title': 'Collaboration Request',
          'message': 'Permintaan kolaborasi dari universitas partner untuk proposal AI',
          'time': '5 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '15',
          'title': 'Proposal Deadline',
          'message': 'Deadline pengumpulan proposal riset tinggal 3 hari',
          'time': '1 minggu yang lalu',
          'isRead': false,
        },
        {
          'id': '16',
          'title': 'Template Updated',
          'message': 'Template proposal riset telah diperbarui dengan format terbaru',
          'time': '1 minggu yang lalu',
          'isRead': true,
        },
      ],
      'E-Monev': [
        {
          'id': '17',
          'title': 'Monitoring Bulanan',
          'message': 'Laporan monitoring bulan Januari tersedia',
          'time': '4 jam yang lalu',
          'isRead': false,
        },
        {
          'id': '18',
          'title': 'Progress Report',
          'message': 'Laporan kemajuan proyek AI untuk bulan Januari telah diselesaikan',
          'time': '1 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '19',
          'title': 'Milestone Achieved',
          'message': 'Milestone pertama proyek Machine Learning telah tercapai',
          'time': '2 hari yang lalu',
          'isRead': false,
        },
        {
          'id': '20',
          'title': 'Budget Utilization',
          'message': 'Utilisasi anggaran proyek Computer Vision mencapai 75%',
          'time': '3 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '21',
          'title': 'Risk Assessment',
          'message': 'Penilaian risiko proyek NLP menunjukkan level rendah',
          'time': '4 hari yang lalu',
          'isRead': false,
        },
        {
          'id': '22',
          'title': 'Team Performance',
          'message': 'Evaluasi kinerja tim riset untuk kuartal Q1 telah selesai',
          'time': '5 hari yang lalu',
          'isRead': true,
        },
        {
          'id': '23',
          'title': 'Quality Assurance',
          'message': 'Audit kualitas output penelitian bulan Januari telah dilakukan',
          'time': '1 minggu yang lalu',
          'isRead': false,
        },
        {
          'id': '24',
          'title': 'Stakeholder Meeting',
          'message': 'Rapat dengan stakeholder untuk review progress proyek AI',
          'time': '1 minggu yang lalu',
          'isRead': true,
        },
      ],
    },
    'NUSAHUMA': {
      'SPPD': [
        {
          'id': '25',
          'title': 'SPPD Disetujui',
          'message': 'Surat Perjalanan Dinas ke Jakarta disetujui',
          'time': '1 jam yang lalu',
          'isRead': false,
        },
      ],
      'Cuti': [
        {
          'id': '26',
          'title': 'Cuti Ditolak',
          'message': 'Permohonan cuti tanggal 15-20 Januari ditolak',
          'time': '1 hari yang lalu',
          'isRead': false,
        },
      ],
      'Presensi': [
        {
          'id': '27',
          'title': 'Absensi Terlambat',
          'message': 'Anda terlambat 15 menit hari ini',
          'time': '2 jam yang lalu',
          'isRead': true,
        },
      ],
    },
    'NUSAREKA': {
      'Surat Masuk': [
        {
          'id': '28',
          'title': 'Surat Masuk Baru',
          'message': 'Ada 3 surat masuk yang perlu ditindaklanjuti',
          'time': '2 hari yang lalu',
          'isRead': true,
        },
      ],
      'Disposisi': [
        {
          'id': '29',
          'title': 'Disposisi Baru',
          'message': 'Surat perlu didisposisikan ke bagian terkait',
          'time': '3 jam yang lalu',
          'isRead': false,
        },
      ],
    },
    'NUSAPROC': {
      'PR & PPAB': [
        {
          'id': '30',
          'title': 'PR Disetujui',
          'message': 'Purchase Request #PR-2024-001 telah disetujui',
          'time': '3 hari yang lalu',
          'isRead': true,
        },
      ],
      'HPS': [
        {
          'id': '31',
          'title': 'HPS Selesai',
          'message': 'Harga Perkiraan Sendiri untuk proyek ABC selesai',
          'time': '1 hari yang lalu',
          'isRead': false,
        },
      ],
    },
    'NUSAFINA': {
      'SPP': [
        {
          'id': '32',
          'title': 'SPP Siap Dibayar',
          'message': 'Surat Permintaan Pembayaran #SPP-2024-005 siap diproses',
          'time': '1 minggu yang lalu',
          'isRead': true,
        },
      ],
      'Voucher': [
        {
          'id': '33',
          'title': 'Voucher Baru',
          'message': 'Voucher makan siang untuk bulan Januari tersedia',
          'time': '2 hari yang lalu',
          'isRead': false,
        },
      ],
    },
  };

  static List<NotificationModel> getAllNotifications() {
    List<NotificationModel> allNotifications = [];
    _notifications.forEach((moduleName, moduleData) {
      moduleData.forEach((subModuleName, notifications) {
        notifications.forEach((notification) {
          allNotifications.add(NotificationModel.fromMap({
            ...notification,
            'moduleName': moduleName,
            'subModuleName': subModuleName,
          }));
        });
      });
    });
    return allNotifications;
  }

  static List<NotificationModel> getFilteredNotifications({
    required Set<String> selectedModules,
    required Set<String> selectedMonths,
    required Set<String> selectedStatus,
  }) {
    List<NotificationModel> allNotifications = getAllNotifications();
    
    return allNotifications.where((notification) {
      // Module filter
      if (selectedModules.isNotEmpty && !selectedModules.contains(notification.moduleName)) {
        return false;
      }
      
      // Status filter (unread only)
      if (selectedStatus.contains('unread') && notification.isRead) {
        return false;
      }
      
      // Month filter (simplified - you can enhance this based on actual date)
      if (selectedMonths.isNotEmpty) {
        // For now, just return true - you can implement actual month filtering
        return true;
      }
      
      return true;
    }).toList();
  }

  static void markAsRead(String notificationId) {
    _notifications.forEach((moduleName, moduleData) {
      moduleData.forEach((subModuleName, notifications) {
        for (var notification in notifications) {
          if (notification['id'] == notificationId) {
            notification['isRead'] = true;
            return;
          }
        }
      });
    });
  }

  static int getTotalNotificationCount() {
    int count = 0;
    _notifications.values.forEach((moduleData) {
      moduleData.values.forEach((notifications) {
        count += notifications.length;
      });
    });
    return count;
  }
}
