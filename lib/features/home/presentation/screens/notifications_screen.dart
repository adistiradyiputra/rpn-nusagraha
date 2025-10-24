import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_filter.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  bool _showFilter = false;
  Set<String> _selectedModules = {};
  Set<String> _selectedMonths = {};
  Set<String> _selectedStatus = {};
  DateTime _lastUpdateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientBlue,
                AppColors.navyBlue,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifikasi',
          style: AppTextStyles.h3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Notifications Content
          NotificationService.getTotalNotificationCount() == 0
              ? _buildEmptyState()
              : _buildNotificationsList(),

          // Filter Overlay
          if (_showFilter)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: NotificationFilter(
                        selectedModules: _selectedModules,
                        selectedMonths: _selectedMonths,
                        selectedStatus: _selectedStatus,
                        onFilterChanged: _onFilterChanged,
                        onApplyFilter: _onApplyFilter,
                        onCloseFilter: _onCloseFilter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onFilterChanged(String value, String type) {
    setState(() {
      switch (type) {
        case 'notifikasi':
          if (_selectedStatus.contains(value)) {
            _selectedStatus.remove(value);
          } else {
            _selectedStatus.add(value);
          }
          break;
        case 'month':
          if (_selectedMonths.contains(value)) {
            _selectedMonths.remove(value);
          } else {
            _selectedMonths.add(value);
          }
          break;
        case 'module':
          if (_selectedModules.contains(value)) {
            _selectedModules.remove(value);
          } else {
            _selectedModules.add(value);
          }
          break;
      }
    });
  }

  void _onApplyFilter() {
    setState(() {
      _showFilter = false;
    });
  }

  void _onCloseFilter() {
    setState(() {
      _showFilter = false;
    });
  }


  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 60,
                color: Colors.blue.shade300,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Notifications yet',
              style: AppTextStyles.h2.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your notifications will appear here\nonce you\'ve received them.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    // Use _lastUpdateTime to ensure rebuild when notifications are updated
    final _ = _lastUpdateTime;
    
    final filteredNotifications = NotificationService.getFilteredNotifications(
      selectedModules: _selectedModules,
      selectedMonths: _selectedMonths,
      selectedStatus: _selectedStatus,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredNotifications.length + 1, // +1 for date separator
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildDateSeparator('September 2025');
        }
        
        final notification = filteredNotifications[index - 1];
        return NotificationCard(
          notification: notification.toMap(),
          onTap: () => _handleNotificationTap(notification),
        );
      },
    );
  }

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        date,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read and force rebuild
    setState(() {
      NotificationService.markAsRead(notification.id);
      // Force rebuild by updating a dummy state variable
      _lastUpdateTime = DateTime.now();
    });
    
    // Navigate to relevant screen based on category
    _navigateToNotification(notification);
  }

  void _navigateToNotification(NotificationModel notification) {
    // Navigate based on category
    // Implementation depends on your navigation structure
  }
}
