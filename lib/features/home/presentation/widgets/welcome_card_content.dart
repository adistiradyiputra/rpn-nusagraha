import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'simple_notification_dropdown.dart';

class WelcomeCardContent extends StatelessWidget {
  const WelcomeCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Only show user data if user is authenticated and has user data
        if (!authProvider.isAuthenticated || authProvider.user == null) {
          return Row(
            children: [
              // Default Avatar
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.sm),
                child: Container(
                  width: 65,
                  height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/images/ava.jpg',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                ),
              ),
              
              SizedBox(width: AppSizes.md),
              
              // Default User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      'User',
                      style: AppTextStyles.bodyExtraLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notification Dropdown
              const SimpleNotificationDropdown(),
            ],
          );
        }

        return Row(
          children: [
            // Avatar
            Padding(
              padding: const EdgeInsets.only(left: AppSizes.sm),
              child: Container(
                width: 65,
                height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: authProvider.user!.foto != null
                    ? Image.network(
                        authProvider.user!.foto!,
                        width: 65,
                        height: 65,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/ava.jpg',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/ava.jpg',
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
              ),
              ),
            ),
            
            SizedBox(width: AppSizes.md),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: AppSizes.xs),
                  Text(
                    authProvider.user!.fullName,
                    style: AppTextStyles.bodyExtraLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authProvider.user!.jabStruk ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Notification Dropdown
            const SimpleNotificationDropdown(),
          ],
        );
      },
    );
  }
}
