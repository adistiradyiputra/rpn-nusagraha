import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isRead'] ? Colors.grey.shade200 : Colors.blue.shade100,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildMessage(),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Module name with icon on the left
        Row(
          children: [
            _buildModuleIcon(),
            const SizedBox(width: 8),
            _buildModuleName(),
          ],
        ),
        // Sub-module name on the right
        _buildSubModuleName(),
      ],
    );
  }

  Widget _buildModuleIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: _getModuleColor(notification['moduleName']).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Image.asset(
          _getModuleIconPath(notification['moduleName']),
          width: 14,
          height: 14,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildModuleName() {
    return Text(
      notification['moduleName'],
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubModuleName() {
    return Text(
      notification['subModuleName'],
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      notification['title'],
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      notification['message'],
      style: AppTextStyles.bodyMedium.copyWith(
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          notification['time'],
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Color _getModuleColor(String moduleName) {
    switch (moduleName) {
      case 'NUSARISET':
        return Colors.blue;
      case 'NUSAHUMA':
        return Colors.green;
      case 'NUSAREKA':
        return Colors.orange;
      case 'NUSAPROC':
        return Colors.purple;
      case 'NUSAFINA':
        return Colors.red;
      default:
        return Colors.blue.shade600;
    }
  }

  String _getModuleIconPath(String moduleName) {
    switch (moduleName) {
      case 'NUSARISET':
        return 'assets/images/icon-nusariset.png';
      case 'NUSAHUMA':
        return 'assets/images/icon-nusahuma.png';
      case 'NUSAREKA':
        return 'assets/images/icon-nusareka.png';
      case 'NUSAPROC':
        return 'assets/images/icon-nusaproc.png';
      case 'NUSAFINA':
        return 'assets/images/icon-nusafina.png';
      default:
        return 'assets/images/icon-nusariset.png';
    }
  }
}
