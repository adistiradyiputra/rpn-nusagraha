import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../screens/notifications_screen.dart';

class SimpleNotificationDropdown extends StatefulWidget {
  const SimpleNotificationDropdown({super.key});

  @override
  State<SimpleNotificationDropdown> createState() => _SimpleNotificationDropdownState();
}

class _SimpleNotificationDropdownState extends State<SimpleNotificationDropdown> {
  // Sample notification data for badge count
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Proposal Riset Disetujui',
      'message': 'Proposal "Penelitian AI" telah disetujui oleh reviewer',
      'category': 'NUSARISET',
      'time': '2 jam yang lalu',
      'isRead': false,
      'icon': Icons.check_circle,
      'iconColor': Colors.green,
    },
    {
      'id': '2',
      'title': 'Cuti Ditolak',
      'message': 'Permohonan cuti tanggal 15-20 Januari ditolak',
      'category': 'NUSAHUMA',
      'time': '1 hari yang lalu',
      'isRead': false,
      'icon': Icons.cancel,
      'iconColor': Colors.red,
    },
    {
      'id': '3',
      'title': 'Surat Masuk Baru',
      'message': 'Ada 3 surat masuk yang perlu ditindaklanjuti',
      'category': 'NUSAREKA',
      'time': '2 hari yang lalu',
      'isRead': true,
      'icon': Icons.mail,
      'iconColor': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: AppSizes.iconSm,
                ),
              ),
              // Unread count badge
              if (_getUnreadCount() > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_getUnreadCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  int _getUnreadCount() {
    return _notifications.where((n) => !n['isRead']).length;
  }
}
