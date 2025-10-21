import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class ServiceItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  ServiceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

class ServiceSection extends StatefulWidget {
  final String title;
  final dynamic icon; // Can be IconData or String (for asset path)
  final String description;
  final List<ServiceItem>? services;
  final VoidCallback? onTap;

  const ServiceSection({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    this.services,
    this.onTap,
  });

  @override
  State<ServiceSection> createState() => _ServiceSectionState();
}

class _ServiceSectionState extends State<ServiceSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color.fromARGB(255, 255, 255, 255), // White smoke color
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        children: [
          // Header
          ListTile(
            leading: Container(
              width: 28,
              height: 28,
              child: widget.icon is String
                  ? Image.asset(
                      widget.icon,
                      width: AppSizes.iconSm,
                      height: AppSizes.iconSm,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      widget.icon,
                      color: AppColors.primaryBlue,
                      size: AppSizes.iconSm,
                    ),
            ),
            title: Text(
              widget.title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              widget.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            trailing: widget.services != null
                ? Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconSm,
                  )
                : Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconSm,
                  ),
            onTap: widget.services != null
                ? () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  }
                : widget.onTap,
          ),
          
          // Expandable Services
          if (widget.services != null && _isExpanded)
            Column(
              children: widget.services!.map((service) {
                return ListTile(
                  dense: true,
                  leading: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                    ),
                    child: Icon(
                      service.icon,
                      color: AppColors.textSecondary,
                      size: AppSizes.iconSm,
                    ),
                  ),
                  title: Text(
                    service.title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    service.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconSm,
                  ),
                  onTap: service.onTap,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
