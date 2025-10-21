import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../models/approval_history_models.dart';

class ApprovalAuthoritiesWidget extends StatelessWidget {
  final List<ApprovalAuthority> authorities;

  const ApprovalAuthoritiesWidget({
    super.key,
    required this.authorities,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAuthoritiesList(authorities);
  }

  Widget _buildAuthorityItem(ApprovalAuthority authority) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        children: [
          // Role label with fixed width for consistent alignment
          SizedBox(
            width: 140,
            child: Text(
              authority.role,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Name and icon with proper spacing
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  authority.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSizes.xs),
                if (authority.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  )
                else if (authority.isRejected)
                  const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 16,
                  )
                else
                  const Icon(
                    Icons.hourglass_empty,
                    color: Colors.orange,
                    size: 16,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthoritiesList(List<ApprovalAuthority> authorities) {
    // Group authorities by role
    Map<String, List<ApprovalAuthority>> groupedAuthorities = {};
    
    for (ApprovalAuthority authority in authorities) {
      if (!groupedAuthorities.containsKey(authority.role)) {
        groupedAuthorities[authority.role] = [];
      }
      groupedAuthorities[authority.role]!.add(authority);
    }
    
    return Column(
      children: groupedAuthorities.entries.map((entry) {
        String role = entry.key;
        List<ApprovalAuthority> roleAuthorities = entry.value;
        
        // Special handling for "Paraf" role - group multiple paraf under one label
        if (role == 'Paraf' && roleAuthorities.length > 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role label on the left with fixed width
                SizedBox(
                  width: 140,
                  child: Text(
                    role,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                // Multiple names on the right with proper alignment
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: roleAuthorities.map((authority) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              authority.name,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                            if (authority.isCompleted)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              )
                            else if (authority.isRejected)
                              const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 16,
                              )
                            else
                              const Icon(
                                Icons.hourglass_empty,
                                color: Colors.orange,
                                size: 16,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Regular single authority display
          return _buildAuthorityItem(roleAuthorities.first);
        }
      }).toList(),
    );
  }
}
