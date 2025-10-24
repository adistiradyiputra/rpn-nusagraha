import '../models/notification_model.dart';

class NotificationService {
  // Data notifikasi kosong - akan diisi dari API
  static final Map<String, Map<String, List<Map<String, dynamic>>>> _notifications = {};

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
